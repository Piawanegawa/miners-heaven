## Purpose

Provides an open-ended, relaxed mining progression loop where players choose how to explore, earn, and improve through mine floors, pickaxes, skills, base NPC services, and approachable encounters.

## ADDED Requirements

### Requirement: The mine supports unbounded exploration in two directions
The game SHALL allow players to reveal additional areas sideways on a floor and to descend through successively deeper floors without a fixed terminal floor or lateral boundary. Progression SHALL extend beyond any finite set of authored floor or tier definitions through a scalable rule or repeatable tier-generation model whose balancing constants are configurable.

#### Scenario: Continue exploring a floor sideways
- **WHEN** a player reaches the boundary of revealed terrain and continues sideways
- **THEN** additional area is revealed on the same floor
- **AND** the new area uses the floor-wide enemy challenge, item-value, and ore/pickaxe requirement bands

#### Scenario: Progress beyond authored floor definitions
- **WHEN** the player descends beyond the last explicitly authored floor or tier
- **THEN** the game generates or derives a subsequent floor using its scalable progression model
- **AND** the subsequent floor satisfies all depth progression invariants without requiring a new authored floor definition

### Requirement: Floors maintain consistent content invariants and depth advances progression
Each floor SHALL define a consistent enemy difficulty band, item-value tier, and set of ore tiers with their required pickaxe tiers. All areas on one floor SHALL use those same bands and requirements. Each successively deeper floor SHALL advance enemy challenge and item value, and SHALL provide ore progression consistent with its required pickaxe tier. Balancing constants MAY be configured without changing these ordering and consistency invariants.

#### Scenario: Compare adjacent floors
- **WHEN** two successive floors are generated or entered
- **THEN** the deeper floor's enemy challenge band is higher than the previous floor's
- **AND** its item-value tier is higher than the previous floor's
- **AND** its ore/pickaxe requirements are defined consistently for that floor

#### Scenario: Verify floor-wide invariants across lateral areas
- **WHEN** multiple areas on the same floor are generated or explored
- **THEN** each area's enemies remain within that floor's difficulty band
- **AND** each area's finds remain within that floor's item-value tier
- **AND** each ore deposit uses an ore tier and pickaxe requirement defined for that floor

### Requirement: Ore deposits require an adequate pickaxe
The game SHALL prevent a player from mining an ore deposit unless their pickaxe tier meets or exceeds that deposit's required tier.

#### Scenario: Attempt to mine ore with an insufficient pickaxe
- **WHEN** a player uses a pickaxe below the deposit's required tier
- **THEN** the deposit yields no ore and is not collected

#### Scenario: Mine ore with a sufficient pickaxe
- **WHEN** a player uses a pickaxe at or above the deposit's required tier
- **THEN** the deposit can be mined and its ore collected

### Requirement: Every pickaxe upgrade has accessible materials and a premium NPC purchase route
The game SHALL allow each higher-tier pickaxe upgrade to be obtained either by providing its required materials or by purchasing it from a base NPC. All materials required for an upgrade SHALL be obtainable without owning that upgrade or any higher-tier pickaxe; upgrade material dependencies SHALL NOT be circular. The NPC purchase price SHALL be approximately twice the currency-equivalent sale value of the complete material recipe. Recipe sale values and the multiplier SHALL be configurable; the default multiplier SHALL be 2.0.

#### Scenario: Obtain an upgrade through materials before owning it
- **WHEN** a player has not yet obtained a target pickaxe and gathers the target upgrade's required materials using currently available tools or other accessible sources
- **THEN** the player can exchange those materials for the target pickaxe
- **AND** no required material source depends on mining ore that requires the target or a higher pickaxe tier

#### Scenario: Verify upgrade dependency chain has no cycle
- **WHEN** the game's pickaxe upgrades and their required material sources are validated
- **THEN** every upgrade's required materials have an acquisition path from the initial available state
- **AND** no upgrade's material path transitively requires that upgrade or a higher tier

#### Scenario: Purchase an upgrade at a premium
- **WHEN** a player purchases a target pickaxe from a base NPC
- **THEN** the NPC grants the target pickaxe if the player can pay its listed price
- **AND** the listed price is approximately twice the currency-equivalent sale value of the complete material recipe, using the configured multiplier (2.0 by default)

### Requirement: Base NPCs support the mining economy and equipment progression
The game SHALL provide base NPC services to buy eligible found items from the player, sell pickaxe upgrades at the specified premium, and offer paid focused mining-skill training. This requirement does not mandate NPC sales of equipment outside pickaxe upgrades.

#### Scenario: Sell found items
- **WHEN** a player sells eligible found items to a buying NPC
- **THEN** the NPC exchanges them for currency at their configured item values

#### Scenario: Purchase pickaxe equipment
- **WHEN** a player has sufficient currency and buys an available pickaxe upgrade from an NPC
- **THEN** the player receives that pickaxe and pays the listed price

#### Scenario: Spend earnings on training
- **WHEN** a player has sufficient currency and selects available mining-skill training
- **THEN** the player pays the listed cost and receives the selected training benefit

### Requirement: Specific mining skills improve through practice and focused training
The game SHALL provide multiple distinct mining-related skills, advance each through relevant player activity, and allow focused NPC training to improve a selected skill.

#### Scenario: Improve a skill through relevant use
- **WHEN** a player performs an action relevant to a mining skill
- **THEN** that skill's measurable progress value increases

#### Scenario: Receive focused training
- **WHEN** a player pays for available training in a mining skill
- **THEN** the selected skill's measurable progress value increases

### Requirement: Every successfully defeated enemy contributes measurable character progression
The game SHALL keep mine enemies approachable and SHALL increase at least one measurable character-progression value for every successfully defeated enemy, independently of whether a special item drops. A special drop SHALL NOT be required for progress.

#### Scenario: Defeat an enemy without receiving a special drop
- **WHEN** a player successfully defeats an enemy and no special item drops
- **THEN** at least one measurable character-progression value increases as a result of that defeat

#### Scenario: Defeat an enemy with a special drop
- **WHEN** a player successfully defeats an enemy and a special item drops
- **THEN** the character-progression contribution still occurs
- **AND** the special item is an additional reward rather than the sole progress contribution
