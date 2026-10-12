# Verification Report

> This file is produced by the `openspec-verify-change` skill after apply to
> check consistency between the implementation and the specs, design, and tasks.
> Fix the corresponding artifact for any failed check, then rerun verification.

**Change**: `<change-name>`
**Verified at**: `YYYY-MM-DD HH:mm`
**Verifier**: `<who / which agent>`

---

## 1. Structural Validation (`openspec validate --all --json`)

- [ ] Every item is `"valid": true`

**Result**:

```text
<Paste a summary of the openspec validate --all output>
```

If any items failed, list their IDs and issues:

| Item | Type | Issues |
|---|---|---|
| — | — | — |

---

## 2. Task Completion (`tasks.md`)

- [ ] Every `- [ ]` has been changed to `- [x]`

**Incomplete tasks** (if any):

| Task | Reason incomplete | Blocks archive? |
|---|---|---|
| — | — | — |

---

## 3. Delta Spec Sync State

For each capability directory under `openspec/changes/<name>/specs/`, compare it
with `openspec/specs/<capability>/spec.md`:

| Capability | Sync status | Notes |
|---|---|---|
| — | ✓ Synced / ✗ Needs sync / N/A | — |

---

## 4. Design / Specs Coherence Spot Check

Spot-check whether decisions in `design.md` are reflected in the Requirements
and Scenarios in `specs/*.md`:

| Item sampled | Design description | Corresponding spec | Gap |
|---|---|---|---|
| — | — | — | — |

**Drift warnings** (non-blocking):

- <List any warnings, or write "None">

---

## 5. Implementation Signal

- [ ] No unstaged files remain in the worktree
- [ ] All related commits have been pushed

**Commit range** (if known): `<from-sha>..<to-sha>`

---

## 6. Front-Door Routing Leak Detector (warning, non-blocking)

Design output should not be placed in `docs/superpowers/specs/`; the brainstorm
artifact's output redirection sends it to `openspec/changes/<name>/brainstorm.md`.

Detection:

```powershell
Get-ChildItem -Path 'docs/superpowers/specs/*.md' -File -ErrorAction SilentlyContinue
```

- [ ] No files exist, or any existing files are legitimate leftovers from before schema installation

**Leak list** (if any):

| File | Has the content been captured in the change? | Suggested action |
|---|---|---|
| — | — | — |

> This does not block archive. For leaks created during a cycle using this
> schema, move the content into `openspec/changes/<name>/brainstorm.md` or
> `design.md`, then delete the original file.

---

## 7. Deferred Manual Dogfood vs Automated Test Equivalence

For each manual dogfood or smoke task marked `[~]` as deferred in plan.md, list
the equivalent automated test coverage. If no equivalent automated test exists,
consider it a **real gap**, not a justified deferral, and record it under
retrospective Misses.

| Deferred dogfood (plan §) | Equivalent automated test | Coverage assessment | Real gap? |
|---|---|---|---|
| Example: §11.3 `compose up + curl /actuator/health` | `LinebcIntegrationApplicationTests` (Testcontainers, 24s) | Spring context boot, Flyway completion, and primary bean injection | ❌ Equivalent coverage exists |
| — | — | — | — |

> **Interpretation rules**:
> - "Equivalent" means the automated test's assertions are a superset of those expected from the manual dogfood check.
> - "Coverage assessment" lists the layers actually exercised (context / DB schema / wiring / HTTP path / etc.).
> - A row marked "Real gap = ✅" does not prevent an Overall Decision of PASS, but it must have a follow-up item in the retrospective.

> **When this section may be left empty**: if plan.md has no rows marked `[~]`,
> this section is not required (empty means PASS). If plan.md contains any `[~]`
> rows, list each one here; otherwise the Overall Decision should be FAIL.

---

## Overall Decision

- [ ] ✅ PASS — may proceed to finishing-a-development-branch and archive
- [ ] ⚠️ PASS WITH WARNINGS — may proceed, with the following caveat: `<explanation>`
- [ ] ❌ FAIL — fix the failing artifact and rerun verification

**Next step**:

<Describe the next action>
