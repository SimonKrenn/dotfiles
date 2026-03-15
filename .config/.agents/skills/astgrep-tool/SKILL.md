---
name: astgrep-tool
description: Use ast-grep tools for structural code search, debug, rule-based scanning, and safe rewrites.
argument-hint: "[what structural pattern to find or rewrite]"
allowed-tools: ["astgrep_find", "astgrep_rewrite", "astgrep_rule_find", "astgrep_debug_query", "read", "fff_find_files", "fff_grep", "fff_multi_grep"]
---

# ast-grep Tool Skill

Use this skill when text search is too noisy and you need syntax-aware, structural matching or rewrites.

This skill is based on the tool behavior implemented in `opencode/tools/astgrep.ts`.

## When To Use Which Tool

- `astgrep_find`: find structural matches for one AST pattern.
- `astgrep_rewrite`: preview or apply a structural replacement (`apply` defaults to `false`).
- `astgrep_rule_find`: run inline YAML rules for richer matching logic.
- `astgrep_debug_query`: inspect how ast-grep parses a pattern before searching/rewrite.

## Preferred Workflow

1. Narrow scope first with `fff_*` if repository is large.
2. Validate pattern shape with `astgrep_debug_query` when uncertain.
3. Run `astgrep_find` to verify match quality and scope.
4. Run `astgrep_rewrite` with `apply=false` (dry run) to preview impact.
5. Only then run `astgrep_rewrite` with `apply=true`.

## Common Arguments (Find/Rewrite)

- `pattern` (required): ast-grep pattern.
- `language` (optional): e.g. `ts`, `js`, `lua`, `py`.
- `strictness` (optional): one of:
  - `cst`
  - `smart`
  - `ast`
  - `relaxed`
  - `signature`
  - `template`
- `path` (optional): search root, defaults to `.`
- `globs` (optional): include/exclude glob filters.
- `maxResults` (optional, max 500):
  - `find` default: `50`
  - `rewrite` preview default: `30`
  - `rule_find` default: `50`

## Tool-Specific Details

### `astgrep_find`

Use for structural discovery.

Returns (JSON):
- `ok`
- `totalMatches`
- `returnedMatches`
- `truncated`
- `files`
- `matches[]` with:
  - `file`
  - `line` (1-based)
  - `column` (1-based)
  - `snippet`
  - optional `ruleId`, `severity`, `message`

### `astgrep_rewrite`

Use for structural replacement.

- Dry run is default (`apply=false`).
- Dry-run result includes:
  - `matchedBefore`
  - `files`
  - `replacement`
  - `preview`
  - `truncated`
- Apply mode (`apply=true`) performs `--update-all` rewrite and returns:
  - `matchedBefore`
  - `changedFiles`
  - `remainingMatches` (post-check; may be `null` if post-check failed)

Safety rule: never start with `apply=true` unless explicitly requested and already validated with `find`/dry-run.

### `astgrep_rule_find`

Use when one pattern is not enough and YAML rule logic is needed.

Arguments:
- `yaml` (required): inline ast-grep rule text.
- `path`, `globs`, `maxResults` like above.

Returns same shape as `find` (`ok`, counts, files, matches).

### `astgrep_debug_query`

Use to debug parser interpretation of the pattern.

Arguments:
- `pattern` (required)
- `language` (required)
- `format` (optional): `pattern` (default), `ast`, `cst`, `sexp`

Returns:
- `ok`
- `format`
- `output` (truncated if very large)

## Strictness Guidance

- Start with default behavior (omit strictness).
- If matches are too broad, try stricter modes (`ast`, `cst`, `signature`).
- If matches are too narrow, try `relaxed` or `template`.
- Re-check with `find` after changing strictness.

## Failure Handling

If `ok: false`:
- Read `error` and fix one variable at a time:
  - wrong `language`
  - malformed `pattern`
  - invalid YAML in `rule_find`
  - overly broad/narrow scope (`path`/`globs`)
- Use `astgrep_debug_query` to inspect pattern parsing before retrying.
- Reduce scope using `path` and `globs` instead of increasing complexity first.

## Practical Patterns

- Unknown location -> narrow with `fff_find_files` / `fff_grep`.
- Known file set -> run `astgrep_find` with `globs` and `path`.
- Unsure pattern semantics -> run `astgrep_debug_query`.
- Refactor -> `find` -> `rewrite` dry run -> `rewrite apply`.

## Anti-Patterns

- Running repo-wide rewrites without a dry run.
- Using text grep when structural precision is required.
- Skipping `language` when pattern depends on language syntax.
- Ignoring `truncated=true` when validating impact.
