# Els crouch poses

Generated with the built-in OpenAI image-generation tool on 2026-09-15, using
`assets/sprites/player/pickup.png` as the character and palette reference.

The sheet contains sixteen crouched walking poses: four down-facing, four left-facing,
four rear-facing and four right-facing. Diagonal travel uses the nearest side profile.
There is no key or flashlight in these poses. The first pose in each row is held for
stationary crouching and hiding; the four poses loop while crouch-walking.

Prompt requested the same short brown bob, navy jacket, green shirt, brown trousers,
boots and crossbody satchel; deeply bent knees, low hips and a forward-leaning torso;
four rows by four columns with stable feet, no turning, no props or shadows, and true
transparent alpha. The returned 1254 × 1254 RGB image contains a neutral checker backing.
The player shader removes that backing at draw time; the original bitmap is unchanged.

`scripts/tools/build_crouch_frames.py` (Pillow) builds atlas regions with a common
512 × 512 canvas and foot anchor (256, 448). Rendering at scale 0.20 aligns these poses
with the existing standing animation's ground origin. No per-frame bitmap resizing is used.

The main player uses these frames via `scripts/player/player_poses.gd`.
Rendered verification: `tests/verify_smooth_gameplay.tscn`, captures under `build/smooth_*.png`.
