<!--
Delta spec template for a change.

This template shows four delta sections; use only those that apply:
- ADDED / MODIFIED / REMOVED / RENAMED
File path: openspec/changes/<change-name>/specs/<capability>/spec.md
(`<capability>` must match the directory name under openspec/specs/.)

Format requirements (validated by OpenSpec):
- A Requirement statement MUST contain `SHALL` or `MUST`.
- Every Requirement MUST have at least one `#### Scenario:`.
- A Scenario MUST use level 4 (`####`); level 3 headings or bullets can fail silently.
-->

## ADDED Requirements

<!-- New behavior. List the Requirements this change adds to the capability. -->

### Requirement: <!-- requirement name -->
<!-- Requirement text — must contain SHALL or MUST -->

#### Scenario: <!-- scenario name -->
- **WHEN** <!-- condition -->
- **THEN** <!-- expected outcome -->

---

## MODIFIED Requirements

<!--
Modify an existing Requirement. **MUST use the exact normalized header from
openspec/specs/<capability>/spec.md** (trimmed, case-sensitive comparison), or
delta application during archive will fail to find the matching Requirement.

**MUST include the full updated content**, not just a diff, because OpenSpec
applies MODIFIED sections by replacing the full text.
-->

### Requirement: <!-- same header as in the existing spec -->
<!-- Full updated Requirement text — include SHALL or MUST -->

#### Scenario: <!-- scenario name (may be new or revised) -->
- **WHEN** <!-- condition -->
- **THEN** <!-- expected outcome -->

---

## REMOVED Requirements

<!--
Remove an existing Requirement. MUST include Reason and Migration details so
reviewers understand why it is removed and how existing dependents should migrate.
-->

### Requirement: <!-- header to remove, exactly matching the existing spec -->

**Reason**: <!-- why it is being removed -->

**Migration**: <!-- how existing callers or dependents should adapt -->

---

## RENAMED Requirements

<!--
Rename a Requirement header. Use the fixed FROM / TO format with fenced headers.
If both the name and content change, list the rename here and also provide the
full updated content under MODIFIED using the **new** header.

Archive applies these sections in order: RENAMED → REMOVED → MODIFIED → ADDED.
-->

- FROM: `### Requirement: <Old Name>`
- TO: `### Requirement: <New Name>`
