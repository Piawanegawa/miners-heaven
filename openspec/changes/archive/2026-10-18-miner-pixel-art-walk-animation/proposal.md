# Proposal

## Why

The playable miner is currently represented by flat polygon placeholders, so the game has no distinct character identity and movement has no visual feedback. A compact pixel-art sprite with directional walking animation will make the existing movement feel intentional while preserving the current top-down foundation.

## What Changes

- Replace the miner's polygon placeholder with a pixel-art 3/4-view character sprite.
- Add a four-direction walk cycle for up, down, and side views; mirror the side view for left-facing movement.
- Select the animation and facing from actual player movement, preserve the last facing while idle, and keep artwork anchored at the feet above the existing ground-level collision footprint.
- Configure the sprite for crisp pixel rendering at the project's existing zoom.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `top-down-game-foundation`: Replace the placeholder player visual with a pixel-art miner and require directional walking feedback without changing movement or collision behavior.

## Impact

- `scenes/player/player.tscn` and player presentation code will gain the sprite and animation setup.
- New sprite texture and animation resources will be added to the project and imported with nearest-neighbor filtering.
- Player scene tests will verify directional facing, walk/idle transitions, mirroring, and preservation of the ground anchor and collision shape.
