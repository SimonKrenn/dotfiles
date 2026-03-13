---
name: fff-find-files
description: Use fff MCP tools for fast file and content discovery with constraints-first queries and low-token search loops.
argument-hint: "[what to find]"
allowed-tools: ["fff_find_files", "fff_grep", "fff_multi_grep", "read", "astgrep_find", "astgrep_rule_find", "astgrep_debug_query"]
---

# FFF MCP Search Skill

Use this skill whenever you need to discover files or locate code/content in a repository.

Prefer `fff` MCP tools over generic search tools for speed, ranking quality, and lower token usage.

## Tool Selection

- `fff_find_files`: fuzzy FILE NAME search only
- `fff_grep`: single-pattern content search (best default for code lookup)
- `fff_multi_grep`: OR search across multiple literal patterns in one call
- `read`: inspect exact files after narrowing candidates
- `astgrep_find` / `astgrep_rule_find`: structural code search after file/content narrowing

Do not use file-name search to answer content questions; do not use content grep to discover unknown filenames first.

## Core Workflow

1. Start broad with one short term in `fff_find_files` or one identifier in `fff_grep`.
2. Add constraints (paths/globs/exclusions) before adding more search terms.
3. Read the top candidate files.
4. If code-structure precision is needed, switch to `astgrep` in the narrowed scope.
5. Iterate in small steps; prefer 2-3 focused searches over one overloaded query.

## Query Rules (Critical)

- Keep queries short: usually 1 term, sometimes 2.
- For `fff_grep`, search one identifier per call when possible.
- Treat multi-word `fff_find_files` queries as narrowing waterfall, not OR.
- Use literal patterns in `fff_multi_grep`; do not escape with regex syntax.
- Always add file constraints when you know likely locations (`src/`, `*.lua`, `*.ts`, etc.).
- Exclude noise aggressively (`!node_modules/`, `!dist/`, `!vendor/`, `!*.min.js`).

## Constraints Cheatsheet

Use constraints to reduce result volume before increasing query complexity.

- Directory: `src/` or `lua/plugins/`
- Glob include: `**/*.lua`, `*.{ts,tsx}`, `**/*test*`
- Exclude: `!test/`, `!**/*.snap`, `!dist/`
- Single file scope (grep): `path/to/file.lua`
- Git-state filtering: `git:modified`, `git:staged`, `git:untracked`

Example constraints strings:

- `*.{ts,tsx} !**/*.test.tsx src/`
- `lua/ !lua/vendor/`
- `git:modified *.md`

## Practical Patterns

### 1) Find a file by fuzzy name

Use when path is unknown.

```text
fff_find_files(query="lsp", maxResults=20)
```

Refine with path prefix or glob if noisy:

```text
fff_find_files(query="lua/plugins/ lsp", maxResults=20)
```

### 2) Find references to an identifier

Use one identifier first:

```text
fff_grep(query="*.lua client_supports_method", maxResults=50)
```

Then repeat with second identifier only if needed.

### 3) Handle naming variants in one pass

Use OR search for snake/camel/Pascal variants:

```text
fff_multi_grep(
  constraints="*.{ts,tsx} src/ !**/*.test.tsx",
  patterns=["user_id", "userId", "UserId"],
  maxResults=80
)
```

### 4) Search only changed files

Useful for reviews and incremental updates:

```text
fff_grep(query="git:modified TODO", maxResults=100)
```

## Pagination and Result Strategy

- If the first page is insufficient, continue with `cursor`.
- Increase `maxResults` gradually; do not jump to very large outputs first.
- Stop when confidence is high and move to `read`.

## When to Use ast-grep After fff

After `fff` narrows candidate files, use `astgrep` for exact structural matches:

- function/class declarations
- call sites with specific argument shapes
- language-aware rewrites

Recommended sequence:

1. `fff_grep` to identify likely files
2. `astgrep_find` scoped with `globs`/`path` for structural accuracy

## Anti-Patterns to Avoid

- Overlong natural-language search queries
- Starting with regex-heavy grep when literal identifier works
- Searching entire repo without constraints for known subtrees
- Reading many files before narrowing candidates
- Using one giant OR query when 2 focused calls are clearer

## Fast Decision Tree

- Unknown file name -> `fff_find_files`
- Known symbol/text -> `fff_grep`
- Multiple literal variants -> `fff_multi_grep`
- Need AST-level certainty -> `astgrep_find` after fff narrowing

## Output Expectations

When reporting results to users or parent agents:

- Return best candidate paths first
- Mention the exact query/constraints used
- State what was not found (if applicable)
- Suggest one next narrowing step if results are ambiguous

This keeps search behavior predictable, fast, and token-efficient.
