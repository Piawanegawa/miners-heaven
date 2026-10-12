## 1. Scalable Mine Progression

- [ ] 1.1 Define a configurable depth progression model for enemy challenge, item value, ore tiers, and pickaxe requirements; verify adjacent generated depths satisfy strict challenge/value advancement and have valid ore requirements
- [ ] 1.2 Implement lateral area generation from the owning floor profile; test multiple areas on one floor and assert identical enemy bands, item-value tiers, and ore/pickaxe requirements
- [ ] 1.3 Implement progression beyond the authored floor prefix; test generation at a depth greater than the last authored entry and verify all depth and floor-wide invariants without adding an authored record

## 2. Ore and Pickaxe Acquisition

- [ ] 2.1 Implement ore mining eligibility by required pickaxe tier; test that an insufficient pickaxe collects no ore and a sufficient pickaxe collects the deposit
- [ ] 2.2 Define material recipes and accessible sources for every pickaxe upgrade; run a dependency-graph validation test from the initial player state and assert every upgrade is reachable without its own or a higher-tier pickaxe
- [ ] 2.3 Implement material-based pickaxe upgrades; test that a player can acquire each target upgrade using only materials accessible before owning that target
- [ ] 2.4 Configure recipe quantities, material sale values, a default purchase multiplier of 2.0, and the currency rounding rule; test each direct price is approximately twice the currency-equivalent total sale value of its complete recipe within the documented rounding tolerance
- [ ] 2.5 Implement NPC direct pickaxe purchases; test successful purchase deducts the configured price and grants the same tier as the material route, and insufficient currency grants nothing

## 3. Base Economy, Skills, and Combat Progression

- [ ] 3.1 Implement sale of eligible finds at configured values; test sold quantities and currency balance changes match the item values
- [ ] 3.2 Define multiple distinct mining skills and map relevant actions to them; test each mapped action increases the corresponding measurable skill progress
- [ ] 3.3 Implement focused paid NPC skill training; test payment and selected-skill progress changes, including insufficient-currency behavior
- [ ] 3.4 Implement approachable enemies and per-defeat measurable progression independent of loot; test every successful enemy defeat increments character progression when no special item drops, and that a special drop does not replace that increment

## 4. Integrated Progression Verification

- [ ] 4.1 Integrate lateral exploration, descent, ore gates, both pickaxe paths, selling, training, and enemy progression; run an end-to-end test that reaches a deeper ore tier through both material collection and premium purchase paths
- [ ] 4.2 Run property tests across authored and generated depths for strict depth advancement, stable lateral floor invariants, and non-circular upgrade-material reachability; include depths beyond the authored prefix
