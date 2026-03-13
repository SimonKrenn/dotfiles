import { tool } from "@opencode-ai/plugin";

type AstGrepMatch = {
  file?: string;
  lines?: string;
  text?: string;
  range?: {
    start?: {
      line?: number;
      column?: number;
    };
    end?: {
      line?: number;
      column?: number;
    };
  };
  ruleId?: string;
  severity?: string;
  message?: string;
};

const STRICTNESS_VALUES = [
  "cst",
  "smart",
  "ast",
  "relaxed",
  "signature",
  "template",
] as const;
const DEBUG_FORMAT_VALUES = ["pattern", "ast", "cst", "sexp"] as const;

function decode(bytes?: Uint8Array): string {
  if (!bytes) return "";
  return new TextDecoder().decode(bytes);
}

function formatToolResult(payload: unknown): string {
  return JSON.stringify(payload, null, 2);
}

function runAstGrep(cmdArgs: string[], cwd: string) {
  const proc = Bun.spawnSync({
    cmd: ["ast-grep", ...cmdArgs],
    cwd,
    stdout: "pipe",
    stderr: "pipe",
  });

  return {
    success: proc.exitCode === 0,
    exitCode: proc.exitCode,
    stdout: decode(proc.stdout),
    stderr: decode(proc.stderr),
  };
}

function parseJsonStream(stdout: string): AstGrepMatch[] {
  const lines = String(stdout)
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);

  const parsed: AstGrepMatch[] = [];
  for (const line of lines) {
    try {
      parsed.push(JSON.parse(line) as AstGrepMatch);
    } catch {
      // Ignore malformed lines.
    }
  }
  return parsed;
}

function compactMatch(match: AstGrepMatch) {
  const start = match.range?.start;
  const line = typeof start?.line === "number" ? start.line + 1 : null;
  const column = typeof start?.column === "number" ? start.column + 1 : null;

  return {
    file: match.file ?? "",
    line,
    column,
    snippet: (match.lines ?? match.text ?? "").trim(),
    ruleId: match.ruleId,
    severity: match.severity,
    message: match.message,
  };
}

function uniqueFiles(matches: AstGrepMatch[]): string[] {
  return [
    ...new Set(
      matches.map((m) => m.file).filter((v): v is string => Boolean(v)),
    ),
  ];
}

function withCommonSearchFlags(args: {
  pattern: string;
  language?: string;
  strictness?: (typeof STRICTNESS_VALUES)[number];
  globs?: string[];
  path?: string;
}): string[] {
  const cmd = [
    "run",
    "--pattern",
    args.pattern,
    "--json=stream",
    "--color",
    "never",
  ];

  if (args.language) cmd.push("--lang", args.language);
  if (args.strictness) cmd.push("--strictness", args.strictness);
  for (const glob of args.globs ?? []) cmd.push("--globs", glob);

  cmd.push(args.path ?? ".");
  return cmd;
}

export const find = tool({
  description: "Structural search with ast-grep CLI",
  args: {
    pattern: tool.schema.string().describe("AST pattern to search for"),
    language: tool.schema
      .string()
      .optional()
      .describe("Language, e.g. ts, js, lua, py"),
    strictness: tool.schema
      .enum(STRICTNESS_VALUES)
      .optional()
      .describe("Pattern strictness (default ast-grep behavior)"),
    path: tool.schema
      .string()
      .optional()
      .describe("Path to search, defaults to current directory"),
    globs: tool.schema
      .array(tool.schema.string())
      .optional()
      .describe("Optional include/exclude globs"),
    maxResults: tool.schema
      .number()
      .int()
      .positive()
      .max(500)
      .optional()
      .describe("Max matches returned (default 50)"),
  },
  async execute(args, context) {
    const maxResults = args.maxResults ?? 50;
    const cwd = context.directory || context.worktree;
    const result = runAstGrep(
      withCommonSearchFlags({
        pattern: args.pattern,
        language: args.language,
        strictness: args.strictness,
        globs: args.globs,
        path: args.path,
      }),
      cwd,
    );

    if (!result.success) {
      return formatToolResult({
        ok: false,
        error:
          result.stderr ||
          result.stdout ||
          `ast-grep failed with exit code ${result.exitCode}`,
      });
    }

    const all = parseJsonStream(result.stdout);
    const matches = all.slice(0, maxResults).map(compactMatch);

    return formatToolResult({
      ok: true,
      totalMatches: all.length,
      returnedMatches: matches.length,
      truncated: all.length > maxResults,
      files: uniqueFiles(all),
      matches,
    });
  },
});

export const rewrite = tool({
  description: "Structural rewrite with optional apply",
  args: {
    pattern: tool.schema.string().describe("AST pattern to rewrite"),
    replacement: tool.schema.string().describe("Replacement template"),
    language: tool.schema
      .string()
      .optional()
      .describe("Language, e.g. ts, js, lua, py"),
    strictness: tool.schema
      .enum(STRICTNESS_VALUES)
      .optional()
      .describe("Pattern strictness (default ast-grep behavior)"),
    path: tool.schema
      .string()
      .optional()
      .describe("Path to rewrite, defaults to current directory"),
    globs: tool.schema
      .array(tool.schema.string())
      .optional()
      .describe("Optional include/exclude globs"),
    apply: tool.schema
      .boolean()
      .optional()
      .describe("Apply changes when true. Defaults to false (dry run)."),
    maxResults: tool.schema
      .number()
      .int()
      .positive()
      .max(500)
      .optional()
      .describe("Max preview matches returned (default 30)"),
  },
  async execute(args, context) {
    const apply = args.apply ?? false;
    const maxResults = args.maxResults ?? 30;
    const cwd = context.directory || context.worktree;

    const before = runAstGrep(
      withCommonSearchFlags({
        pattern: args.pattern,
        language: args.language,
        strictness: args.strictness,
        globs: args.globs,
        path: args.path,
      }),
      cwd,
    );

    if (!before.success) {
      return formatToolResult({
        ok: false,
        error:
          before.stderr ||
          before.stdout ||
          `ast-grep failed with exit code ${before.exitCode}`,
      });
    }

    const beforeMatches = parseJsonStream(before.stdout);
    const preview = beforeMatches.slice(0, maxResults).map(compactMatch);
    const files = uniqueFiles(beforeMatches);

    if (beforeMatches.length === 0) {
      return formatToolResult({
        ok: true,
        dryRun: !apply,
        matchedBefore: 0,
        changedFiles: [],
        preview: [],
      });
    }

    if (!apply) {
      return formatToolResult({
        ok: true,
        dryRun: true,
        matchedBefore: beforeMatches.length,
        files,
        replacement: args.replacement,
        preview,
        truncated: beforeMatches.length > maxResults,
      });
    }

    const rewriteCmd = [
      "run",
      "--pattern",
      args.pattern,
      "--rewrite",
      args.replacement,
      "--update-all",
      "--color",
      "never",
    ];
    if (args.language) rewriteCmd.push("--lang", args.language);
    if (args.strictness) rewriteCmd.push("--strictness", args.strictness);
    for (const glob of args.globs ?? []) rewriteCmd.push("--globs", glob);
    rewriteCmd.push(args.path ?? ".");

    const rewriteResult = runAstGrep(rewriteCmd, cwd);
    if (!rewriteResult.success) {
      return formatToolResult({
        ok: false,
        error:
          rewriteResult.stderr ||
          rewriteResult.stdout ||
          `ast-grep rewrite failed with exit code ${rewriteResult.exitCode}`,
      });
    }

    const after = runAstGrep(
      withCommonSearchFlags({
        pattern: args.pattern,
        language: args.language,
        strictness: args.strictness,
        globs: args.globs,
        path: args.path,
      }),
      cwd,
    );

    const remainingMatches = after.success
      ? parseJsonStream(after.stdout).length
      : null;

    return formatToolResult({
      ok: true,
      dryRun: false,
      matchedBefore: beforeMatches.length,
      changedFiles: files,
      remainingMatches,
      note:
        remainingMatches === null
          ? "Rewrite applied; post-check failed."
          : "Rewrite applied successfully.",
    });
  },
});

export const rule_find = tool({
  description: "Run inline ast-grep YAML rule search",
  args: {
    yaml: tool.schema.string().describe("Inline ast-grep YAML rule text"),
    path: tool.schema
      .string()
      .optional()
      .describe("Path to scan, defaults to current directory"),
    globs: tool.schema
      .array(tool.schema.string())
      .optional()
      .describe("Optional include/exclude globs"),
    maxResults: tool.schema
      .number()
      .int()
      .positive()
      .max(500)
      .optional()
      .describe("Max matches returned (default 50)"),
  },
  async execute(args, context) {
    const maxResults = args.maxResults ?? 50;
    const cwd = context.directory || context.worktree;
    const cmd = [
      "scan",
      "--inline-rules",
      args.yaml,
      "--json=stream",
      "--color",
      "never",
    ];
    for (const glob of args.globs ?? []) cmd.push("--globs", glob);
    cmd.push(args.path ?? ".");

    const result = runAstGrep(cmd, cwd);
    if (!result.success) {
      return formatToolResult({
        ok: false,
        error:
          result.stderr ||
          result.stdout ||
          `ast-grep scan failed with exit code ${result.exitCode}`,
      });
    }

    const all = parseJsonStream(result.stdout);
    const matches = all.slice(0, maxResults).map(compactMatch);

    return formatToolResult({
      ok: true,
      totalMatches: all.length,
      returnedMatches: matches.length,
      truncated: all.length > maxResults,
      files: uniqueFiles(all),
      matches,
    });
  },
});

export const debug_query = tool({
  description: "Inspect how ast-grep parses a pattern",
  args: {
    pattern: tool.schema.string().describe("Pattern to inspect"),
    language: tool.schema.string().describe("Language for parsing the pattern"),
    format: tool.schema
      .enum(DEBUG_FORMAT_VALUES)
      .optional()
      .describe("Tree format: pattern, ast, cst, sexp (default pattern)"),
  },
  async execute(args, context) {
    const format = args.format ?? "pattern";
    const cwd = context.directory || context.worktree;
    const result = runAstGrep(
      [
        "run",
        "--pattern",
        args.pattern,
        "--lang",
        args.language,
        `--debug-query=${format}`,
        "--color",
        "never",
        ".",
      ],
      cwd,
    );

    if (!result.success) {
      return formatToolResult({
        ok: false,
        error:
          result.stderr ||
          result.stdout ||
          `ast-grep debug failed with exit code ${result.exitCode}`,
      });
    }

    const text = result.stdout || result.stderr;
    return formatToolResult({
      ok: true,
      format,
      output:
        text.length > 12000 ? `${text.slice(0, 12000)}\n...truncated...` : text,
    });
  },
});
