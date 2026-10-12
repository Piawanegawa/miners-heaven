## Context

See `proposal.md` for motivation and `specs/mining-progression/spec.md` for player-visible requirements. The repository has no existing game source or implementation conventions, so this design frames the capability as a greenfield system.

## Goals / Non-Goals

**Goals:**
- Maintain floor-wide invariants while supporting sideways expansion and depth progression beyond finite authored content.
- Keep ore access and upgrade-material acquisition reachable without circular dependencies.
- Define objective validation properties while leaving tuning constants configurable.
- Preserve the choice between collecting upgrade materials and paying a premium based on their sale value.

**Non-Goals:**
- Set final numeric balance constants, exact floor dimensions, enemy statistics, or skill formulas.
- Choose a game engine, storage architecture, or procedural-generation library before the codebase establishes those constraints.
- Add farming or general life-simulation systems; NPC equipment sales are limited to pickaxe upgrades for this scope.

## Decisions

### Extend floor content with a scalable progression function
Represent depth as an unbounded ordinal and derive each floor's progression profile from depth plus configurable balance parameters. The profile must preserve these invariants at every depth: a strictly advancing enemy challenge band and item-value tier, a defined ore/pickaxe requirement set, and identical profile bands/requirements across all lateral regions of a floor. An authored prefix may define early floors, but the progression rule must continue after that prefix without requiring additional authored floor records. Keep formulas and numeric coefficients configurable; the property tests validate ordering and continuity rather than fixed values.

Alternative considered: require a fully authored record for every floor. Rejected because that cannot fulfill progression beyond a finite authored set. A finite authored prefix remains useful for hand-authored early content.

### Validate pickaxe acquisition as an acyclic reachability graph
Model pickaxe tiers and material sources as a dependency graph rooted in the initial player state. Each upgrade's full material recipe must have a reachable source using current or lower-tier tools, and no path may depend on the target or a higher tier. Validate the graph for every configured upgrade and for generated tiers. This prevents an upgrade from requiring itself indirectly.

Alternative considered: rely on manual recipe review. Rejected because indirect cycles can be missed as tiers and recipes expand.

### Compare purchase cost against a defined recipe value
Compute the recipe's currency-equivalent value from the configured sale value of each required material and recipe quantity. Set the direct purchase price to approximately twice that sum, using a configurable multiplier with a default of 2.0. Validate the price against the configured multiplier and documented rounding rule. Specific recipe values remain balancing parameters, while the default comparison basis and multiplier are stable and testable. Leave the exact rounding tolerance configurable for currency denominations and avoid silently changing the default 2.0 relationship.

Alternative considered: compare currency price to mining time or player effort. Rejected because those costs are variable and not objectively verifiable as currency values.

### Guarantee combat progression through a measurable non-drop signal
On successful enemy defeat, grant a measurable progression increment (for example, combat-skill progress) independently of loot rolls. Common and special drops may supplement but cannot replace that contribution. Keep the increment configurable and ensure it applies once per successful defeat to avoid duplicate progress from repeated defeat events.

Alternative considered: guarantee a common item drop. Rejected because that can inflate the economy and still ties progress to item acquisition rather than character progression.

### Keep base equipment services intentionally narrow
The NPC equipment catalog in this change covers pickaxe upgrades; the same base services buy eligible finds and provide paid focused skill training. This matches the progression gates without implying a broader shop catalog.

Alternative considered: make the NPCs sell all mining equipment. Deferred to avoid expanding requirements beyond the confirmed pickaxe progression loop.

## Risks / Trade-offs

- [Unbounded numerical tiers may overflow or lose precision] -> Use a scalable representation suitable for large depth ordinals and test progression well beyond the authored prefix; define practical runtime limits only if the target platform requires them.
- [Strictly increasing difficulty or value may eventually become impractical] -> Keep scaling parameters configurable and verify invariants separately from balance/playability tuning.
- [Material sale values can be changed independently from purchase prices] -> Validate the premium relation against the current configured recipe values whenever balance data is checked.
- [Generated content can satisfy numeric ordering but feel repetitive] -> Treat variety as a content-quality risk; the spec requires stable floor bands, not unique layouts for every lateral extension.
- [No codebase exists to ground engine-specific choices] -> Resolve persistence, generation implementation, and test framework when the game codebase is established.
