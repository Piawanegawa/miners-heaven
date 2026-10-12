# Retrospective: <change-name>

> Written: <YYYY-MM-DD> (after verify passed)
> Commit range: `<base-sha>..<head-sha>`
> Worktree: <path or "merged to main">

---

## 0. Evidence

> Quantitative front matter — refer to these figures in Wins / Misses bullets
> instead of repeating `[evidence: ...]` in every line. For a retrospective
> written well after the cycle, this section should still be reconstructible
> from `git log`, `tasks.md`, and commit messages.

- **Commit range**: `<base-sha>..<head-sha>` (<n> commits)
- **Diff size**: <+X / -Y lines across N files>
- **Tasks done**: <x>/<y> (in PowerShell 7, `(Select-String -Path tasks.md -Pattern '^\s*- \[x\]').Count` → x; the pattern allows indented subtasks)
- **Active hours**: <estimate>
- **Subagent dispatches**: <count or "n/a">
- **New external dependencies**: <list, with license + version, or "none">
- **Bugs encountered post-merge**: <count, one-line each, or "none">
- **OpenSpec validate state at archive**: <pass / fail / not-run>
- **Test coverage signal**: <e.g. jacoco %, pytest count, vitest count, or "n/a">

Commit chain (chronological order):

```
<base-sha> <one-line summary>
...
<head-sha> <archive commit one-line>
```

---

## 1. Wins

- [evidence: <commit/file/test>] <description>

## 2. Misses

- 🔴 [blocking | evidence: ...] <description>
- 🟡 [painful  | evidence: ...] <description>
- 📌 [nit      | evidence: ...] <description>

## 3. Plan deviations

| Plan task | What changed | Why |
|-----------|--------------|-----|
| 1.2       | ...          | ... |

## 4. Skill / workflow compliance

| Skill                                            | Used |
|--------------------------------------------------|------|
| superpowers:brainstorming                        |      |
| superpowers:writing-plans                        |      |
| superpowers:using-git-worktrees                  |      |
| superpowers:subagent-driven-development          |      |
| (transitive) superpowers:test-driven-development |      |
| (transitive) superpowers:requesting-code-review  |      |
| superpowers:finishing-a-development-branch       |      |

> **Default expectation**: every skill is marked ✓. Each skill is part of the
> schema's workflow, so skipping one is exceptional. For any ✗, explain the
> reason and prevention plan in the `### Deliberately Skipped Skills` subsection.

### Deliberately Skipped Skills

> Skipping a skill is an escape hatch, not the normal path. Every ✗ must answer
> the following three questions. An empty subsection (all green) is expected.

- **`<skill name>`**
  - **What was skipped**: <specify whether the whole skill or one sub-step was skipped>
  - **Why this cycle**: <the concrete cycle condition; avoid vague reasons such as "not needed", "too small", "no time", "blocked by an external dependency", or "the skill output looked wrong"; name the actual trigger, such as a commit, log line, or observed behavior>
  - **How to prevent recurrence**: <choose one and say how it applies next cycle under the same conditions>
    - `schema graph fix` — identify the exact section of schema.yaml to change
    - `skill description tightening` — identify the skill front matter or instruction to change
    - `CLAUDE.md trigger` — specify the routing rule to add to the adopter fragment
    - `scope-judgment rule` — explain how to interpret the cycle's scope
    - `one-off — schema boundary case, no prevention possible` — explain why this is a boundary case; do not use this as a vague exception

> **Relationship to §6 Promote candidates**: if multiple cycles skip the same
> skill for similar reasons and give the same `How to prevent` answer, promote
> that pattern to §6 and use it to motivate a schema or skill PR; do not let it
> become normal practice.

## 5. Surprises

- <assumption that turned out wrong>

## 6. Promote candidates → long-term learning

Use a `- [ ]` checklist for each candidate:

- Title: severity emoji (🔴/🟡/📌) plus a one-sentence lesson
- `→ **Promote to** <destination>`(memory / CLAUDE.md / schema / skill / one-off)
- Two body lines (matching the Superpowers feedback memory body schema):
  - `> **Why**: <reason; often a past incident or strong preference>`
  - `> **How to apply**: <when/where this guidance kicks in>`

Unchecked `- [ ]` items have not been promoted yet. Carry them into the next
cycle's retrospective for review, or keep them as observations across cycles.

> **Carry-forward process**: when writing the next cycle's retrospective, use
> PowerShell 7 to search archived retrospectives for unchecked candidates, for
> example:
> `Get-ChildItem 'openspec/changes/archive' -Filter retrospective.md -Recurse | Select-String -Pattern '^\s*- \[ \]' -Context 0,5`
> Decide for each item whether to carry it into this cycle's §6, promote it in
> place, or mark it stale and stop tracking it.

Examples:

- [ ] 🔴 **<short rule>** → **Promote to memory** (type: feedback)
  > **Why**: <past incident or strong preference that motivated this rule>
  > **How to apply**: <which file / cycle phase / decision moment this kicks in>

- [ ] 🟡 **<another candidate>** → **Promote to project CLAUDE.md** (the `<path/to/CLAUDE.md>` section)
  > **Why**: ...
  > **How to apply**: ...

- [ ] 📌 **<third candidate>** → **One-off** (record it without promoting)
  > **Why**: <why it doesn't generalize>
