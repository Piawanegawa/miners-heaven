## Why

<!--
Explain the motivation for this change. What problem does this solve? Why now?

Hard limit: 50–1000 characters (validated by the OpenSpec Zod schema).
- Too short: `Why section must be at least 50 characters` error
- Too long: `Why section should not exceed 1000 characters` error

Suggested structure: current pain point → why address it now → expected benefit (1–2 sentences each)
-->

## What Changes

<!--
Describe what will change. Be specific about new capabilities, modifications, or removals.

For behavior changes with a clear before-and-after, use the From/To format (Markdown has no inline diff):

**<Section or Behavior Name>**
- From: <current state / requirement>
- To: <future state / requirement>
- Reason: <why this change is needed>
- Impact: <breaking / non-breaking, who's affected>

Repeat this block for multiple changes; describe pure additions or removals with a simple list.
-->

## Capabilities

### New Capabilities
<!--
Capabilities being introduced. Replace <name> with kebab-case identifier.
See openspec/specs/README.md for naming rules: use compound nouns (at least two words),
such as `user-auth`, `data-export`, or `api-rate-limiting`; avoid single-word names.
Each creates specs/<name>/spec.md
-->
- `<name>`: <brief description of what this capability covers>

### Modified Capabilities
<!--
Existing capabilities whose REQUIREMENTS are changing (not just implementation).
Only list here if spec-level behavior changes. Each needs a delta spec file.
Use existing spec names from openspec/specs/. Leave empty if no requirement changes.
-->
- `<existing-name>`: <what requirement is changing>

## Impact

<!-- Affected code, APIs, dependencies, systems -->
