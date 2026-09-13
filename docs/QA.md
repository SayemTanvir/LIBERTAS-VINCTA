# LIBERTAS VINCTA: Quality Assurance

Validated with Godot 4.7 stable on 2026-09-13.

## Automated verification

| Suite | Coverage | Result |
| --- | --- | --- |
| `tests/verify_estate_assets.tscn` | 7 zones, 37 room regions, 60 textures, progression props, doors, pickup visibility, paths, hiding priorities, recharge coverage, and Nexus framing | 686 checks, 0 failures |
| `tests/verify_game_systems.tscn` | Inputs, all Part II seeds, movement, target-facing interactions, battery/noise values, enemy states, Hearing/Sight/Memory/Touch behavior, sigils, stun, anchor interruption, and cleanup | 66 checks, 0 failures |
| `tests/verify_game_route.tscn` | Awakening, canonical Vantree route, transitions, Part II, story-once triggers, branch gate, Nexus, Severance, and two Loop resets | 96 checks, 0 failures |
| `tests/verify_full_playthrough.tscn` | Actual interactions for Untouched, Partial Mercy, Loop, Custodian's Rest, Vessel, first-room capture, checkpoint restore, door-free respawn, post-recovery movement input, puzzle angles, and gated animations | 148 checks, 0 failures |

Run from the project directory:

```powershell
godot --headless --path . res://tests/verify_estate_assets.tscn
godot --headless --path . res://tests/verify_game_systems.tscn
godot --headless --path . res://tests/verify_game_route.tscn
godot --headless --path . res://tests/verify_full_playthrough.tscn
```

Runtime script errors, failed assertions, asset load errors, and leaked scene resources are treated as failures. The restricted Windows runner can emit a root-certificate-store warning; that warning is external to the offline game and does not affect the test exit status.

## Rendered verification

The normal OpenGL compatibility renderer was used for two presentation sweeps:

- `tests/capture_asset_sweep.tscn`: all 7 zones, using 38 viewpoints for 37 room regions.
- `tests/capture_animation_sweep.tscn`: tool pouch, piano, held flashlight, open doorway, capture, respawn, vanity, ritual, and monster stun.

The resulting frames were inspected for nonblank rendering, asset bounds, floor/wall coverage, door visibility, unobstructed interactions, player/prop orientation, key visibility, doorway arrival, and animation state. The screenshots are generated QA artifacts under `build/` and are not runtime dependencies.

## Gameplay acceptance record

- [x] Complete Untouched and seed its Part II branch.
- [x] Complete Vantree and the canonical Severance route.
- [x] Complete Partial Mercy and seed its Part II branch.
- [x] Trigger the three-key Loop twice and verify fragment A.
- [x] Complete Custodian's Rest and Vessel.
- [x] Verify the three branch-specific Echo gate solutions.
- [x] Verify 20-second anchors reject or reset on detection and damage.
- [x] Verify capture restores the exact checkpoint inventory, health, zone, and position.
- [x] Verify collapse and reverse respawn presentation while control and enemy logic are locked.
- [x] Verify first-room respawn emits no door cue, never invokes arrival, and initializes the entry door closed.
- [x] Verify recovery at normal time scale returns to `PLAYING` and accepts movement input.
- [x] Verify Continuing restores the serialized progression state.
- [x] Inspect all 37 room regions and all nine critical interaction animations with rendered frames.

## Release-only checklist

- [ ] Perform an unaccelerated external human balance pass for route duration, difficulty, controller comfort, and accessibility.
- [ ] Smoke-test exported Windows and Web builds using matching Godot 4.7 export templates.
- [ ] Confirm third-party asset license details and distribution requirements.
- [ ] Test the final audio mix on speakers and headphones once all production audio is locked.

Detailed player-experience findings and their resolutions are recorded in `docs/PRO_PLAYTEST_REPORT.md`.
