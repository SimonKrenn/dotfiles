/**
 * git-ai plugin for OpenCode
 *
 * This plugin integrates git-ai with OpenCode to track AI-generated code.
 * It uses the tool.execute.before and tool.execute.after events to create
 * checkpoints that mark code changes as human or AI-authored.
 *
 * Installation:
 *   - Automatically installed by `git-ai install-hooks`
 *   - Or manually copy to ~/.config/opencode/plugin/git-ai.ts (global)
 *   - Or to .opencode/plugin/git-ai.ts (project-local)
 *
 * Requirements:
 *   - git-ai must be installed (path is injected at install time)
 *
 * @see https://github.com/git-ai-project/git-ai
 * @see https://opencode.ai/docs/plugins/
 */

import type { Plugin } from "@opencode-ai/plugin";
import { existsSync, statSync } from "fs";
import { dirname, isAbsolute, resolve } from "path";

// Absolute path to the git-ai binary, replaced at install time by `git-ai install-hooks`
const GIT_AI_BIN = "__GIT_AI_BINARY_PATH__";

const resolveGitAiBin = () => {
  if (typeof process !== "undefined" && process.env.GIT_AI_BIN) {
    return process.env.GIT_AI_BIN;
  }

  if (GIT_AI_BIN && GIT_AI_BIN !== "__GIT_AI_BINARY_PATH__") {
    return GIT_AI_BIN;
  }

  return "git-ai";
};

const isDebugEnabled =
  typeof process !== "undefined" && process.env.GIT_AI_DEBUG === "1";

const logDebug = (...args: unknown[]) => {
  if (isDebugEnabled) {
    console.error("[git-ai:debug]", ...args);
  }
};

// Tools that modify files and should be monitored
const FILE_EDIT_TOOLS = [
  "edit",
  "write",
  "patch",
  "apply_patch",
  "multiedit",
  "astgrep_rewrite",
];

type PendingEdit = {
  filePaths: string[];
  repoDirs: string[];
  sessionID: string;
  tool: string;
};

const dedupe = (items: string[]) => [...new Set(items.filter(Boolean))];

const parseApplyPatchPaths = (patchText: string): string[] => {
  const paths: string[] = [];

  for (const line of patchText.split("\n")) {
    if (line.startsWith("*** Add File: ")) {
      paths.push(line.slice("*** Add File: ".length).trim());
    }
    if (line.startsWith("*** Update File: ")) {
      paths.push(line.slice("*** Update File: ".length).trim());
    }
    if (line.startsWith("*** Delete File: ")) {
      paths.push(line.slice("*** Delete File: ".length).trim());
    }
    if (line.startsWith("*** Move to: ")) {
      paths.push(line.slice("*** Move to: ".length).trim());
    }
  }

  return dedupe(paths);
};

export const GitAiPlugin: Plugin = async (ctx) => {
  const { $, directory, worktree } = ctx;
  const gitAiBin = resolveGitAiBin();

  // Check if git-ai is installed
  let gitAiInstalled = false;
  try {
    await $`${gitAiBin} --version`.quiet();
    gitAiInstalled = true;
  } catch {
    // git-ai not installed, plugin will be a no-op
  }

  if (!gitAiInstalled) {
    return {};
  }

  // Track pending edits by callID so we can reference them in the after hook
  const pendingEdits = new Map<string, PendingEdit>();

  const toAbsolutePaths = (filePaths: string[]): string[] =>
    dedupe(
      filePaths.map((filePath) =>
        isAbsolute(filePath) ? filePath : resolve(directory, filePath),
      ),
    );

  const extractToolPaths = (
    tool: string,
    args: Record<string, unknown>,
  ): string[] => {
    if (tool === "astgrep_rewrite" && args.apply !== true) {
      return [];
    }

    const directFilePath =
      typeof args.filePath === "string" ? args.filePath : null;
    if (directFilePath) {
      return [directFilePath];
    }

    if (tool === "astgrep_rewrite" && typeof args.path === "string") {
      return [args.path];
    }

    if (typeof args.patchText === "string") {
      return parseApplyPatchPaths(args.patchText);
    }

    if (typeof args.patch === "string") {
      return parseApplyPatchPaths(args.patch);
    }

    return [];
  };

  const existingDirForPath = (filePath: string): string => {
    let current = filePath;

    if (existsSync(current)) {
      try {
        if (!statSync(current).isDirectory()) {
          current = dirname(current);
        }
      } catch {
        current = dirname(current);
      }
    } else {
      current = dirname(current);
    }

    let previous = "";

    while (current !== previous) {
      if (existsSync(current)) {
        return current;
      }
      previous = current;
      current = dirname(current);
    }

    return directory;
  };

  // Helper to find git repo root from a file path
  const findGitRepo = async (filePath: string): Promise<string | null> => {
    try {
      const dir = existingDirForPath(filePath);
      const result = await $`git -C ${dir} rev-parse --show-toplevel`.quiet();
      const repoRoot = result.stdout.toString().trim();
      return repoRoot || null;
    } catch {
      // Not a git repo or git not available
      return null;
    }
  };

  const buildToolInput = (filePaths: string[], tool: string) => {
    if (filePaths.length === 1) {
      return {
        filePath: filePaths[0],
        tool_name: tool,
      };
    }

    if (filePaths.length > 1) {
      return {
        filePaths,
        tool_name: tool,
      };
    }

    return {
      tool_name: tool,
    };
  };

  const createCheckpoint = async (
    hookEventName: "PreToolUse" | "PostToolUse",
    sessionID: string,
    repoDir: string,
    filePaths: string[],
    tool: string,
  ) => {
    const hookInput = JSON.stringify({
      hook_event_name: hookEventName,
      session_id: sessionID,
      cwd: repoDir,
      tool_input: buildToolInput(filePaths, tool),
    });

    logDebug("checkpoint", hookEventName, tool, repoDir, filePaths.length);
    await $`echo ${hookInput} | ${gitAiBin} checkpoint opencode --hook-input stdin`.quiet();
  };

  return {
    "tool.execute.before": async (input, output) => {
      // Only intercept file editing tools
      if (!FILE_EDIT_TOOLS.includes(input.tool)) {
        return;
      }

      const args = (output.args ?? {}) as Record<string, unknown>;
      const filePaths = toAbsolutePaths(extractToolPaths(input.tool, args));

      const repoCandidates = await Promise.all(
        filePaths.map((filePath) => findGitRepo(filePath)),
      );
      let repoDirs = dedupe(
        repoCandidates.filter((repoDir): repoDir is string => Boolean(repoDir)),
      );

      // Fall back to the current worktree repo for tools with no explicit file paths
      if (repoDirs.length === 0) {
        const fallbackRepo = await findGitRepo(worktree);
        if (fallbackRepo) {
          repoDirs = [fallbackRepo];
        }
      }

      if (repoDirs.length === 0) {
        return;
      }

      pendingEdits.set(input.callID, {
        filePaths,
        repoDirs,
        sessionID: input.sessionID,
        tool: input.tool,
      });

      for (const repoDir of repoDirs) {
        try {
          // Create human checkpoint before AI edit
          // This marks any changes since the last checkpoint as human-authored
          await createCheckpoint(
            "PreToolUse",
            input.sessionID,
            repoDir,
            filePaths,
            input.tool,
          );
        } catch (error) {
          // Log to stderr for debugging, but don't throw - git-ai errors shouldn't break the agent
          console.error(
            "[git-ai] Failed to create human checkpoint:",
            String(error),
          );
        }
      }
    },

    "tool.execute.after": async (input, _output) => {
      // Only intercept file editing tools
      if (!FILE_EDIT_TOOLS.includes(input.tool)) {
        return;
      }

      let editInfo = pendingEdits.get(input.callID);
      pendingEdits.delete(input.callID);

      if (!editInfo) {
        const args = (input.args ?? {}) as Record<string, unknown>;
        const filePaths = toAbsolutePaths(extractToolPaths(input.tool, args));
        const repoCandidates = await Promise.all(
          filePaths.map((filePath) => findGitRepo(filePath)),
        );
        let repoDirs = dedupe(
          repoCandidates.filter((repoDir): repoDir is string => Boolean(repoDir)),
        );

        if (repoDirs.length === 0) {
          const fallbackRepo = await findGitRepo(worktree);
          if (fallbackRepo) {
            repoDirs = [fallbackRepo];
          }
        }

        if (repoDirs.length === 0) {
          return;
        }

        editInfo = {
          filePaths,
          repoDirs,
          sessionID: input.sessionID,
          tool: input.tool,
        };
      }

      const { filePaths, repoDirs, sessionID, tool } = editInfo;

      for (const repoDir of repoDirs) {
        try {
          // Create AI checkpoint after edit
          // This marks the changes made by this tool call as AI-authored
          // Transcript is fetched from OpenCode's local storage by the preset
          await createCheckpoint(
            "PostToolUse",
            sessionID,
            repoDir,
            filePaths,
            tool,
          );
        } catch (error) {
          // Log to stderr for debugging, but don't throw - git-ai errors shouldn't break the agent
          console.error(
            "[git-ai] Failed to create AI checkpoint:",
            String(error),
          );
        }
      }
    },
  };
};
