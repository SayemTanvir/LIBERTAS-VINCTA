# LIBERTAS VINCTA: Implementation Report

Validated with Godot 4.7 stable on 2026-09-13. The current build implements the complete estate and cathedral game described by the rulebook, not the earlier greybox milestone.

## Playable scope

- Cold Foyer awakening and door transition
- Ground Floor, Upper Floor, and Basement across 24 Part I room regions
- Cathedral Roots, Chamber of Echoes, and Ley-Nexus across 13 Part II room regions
- Hearing, Sight, Memory, and branch-specific Touch progression
- Untouched, Vantree, Partial Mercy, and the deliberate three-key Loop
- Severance, Custodian's Rest, and Vessel at the Nexus
- Checkpoint saves, Continue, capture recovery, Loop recovery, and New Game reset
- Imported room dressing, furniture, piano, doors, pickups, and generated cathedral assets

The seven runtime zones contain 37 named room regions. Layout is data-driven through `data/estate_layout.json`; art placement and atlas slices are defined by `data/estate_art.json`.

## Route contract

| Keys | Exit and gate | Result |
| --- | --- | --- |
| 0 | Front Door after one test, with zero detections | Untouched |
| Hearing only | `BS-09`, with at least 4 of 7 Part I letters | Vantree |
| Hearing and Sight | Flood Tunnel in `BS-04` | Partial Mercy |
| Hearing, Sight, Memory | Front Door | Loop reset; no Part II seed |

Part II inherits a distinct seed from each successful Part I route:

- Untouched supplies gadgets and leaves the entity's senses dormant.
- Vantree mutates Touch, unlocks Blood Magic, and limits Els to 80 maximum HP.
- Partial Mercy preserves Hearing and Sight and unlocks partial sigils.

Each branch must complete three successful mechanic uses before the Nexus descent opens. All three Nexus anchors require a continuous 20-second interaction; releasing `E`, detection, or damage resets progress.

## Architecture

| Module | Responsibility |
| --- | --- |
| `scripts/core/freedom_ledger.gd` | Inventory, keys, senses, endings, Part II seed, persistent flags, health, charge, and save data |
| `scripts/core/game_manager.gd` | Runtime state, transitions, checkpoints, Continue, restart, respawn, and Loop reset |
| `scripts/levels/estate_room.gd` | Builds rooms, geometry, props, markers, surfaces, and automatic story triggers from JSON |
| `scripts/interactables/base_interactable.gd` | Doors, puzzles, pickups, exits, hiding, vents, recharge, forge, lore, and Nexus anchors |
| `scripts/player/player.gd` | Movement, flashlight, gadgets, sigils, stun, interaction, damage, and animation presentation |
| `scripts/enemy/deprived_one.gd` | Nine-state sensory AI, navigation, chase, Memory prediction, Touch, damage, and stun feedback |
| `scripts/systems/audio_director.gd` | Ambience, cues, threat layers, and deterministic playback cleanup |
| `scripts/ui/game_hud.gd` | HUD, subtitles, letters, pause, ending flow, and status feedback |

Cross-system communication uses `EventBus`; player progress uses `FreedomLedger`; transient world construction remains owned by the active room scene.

## Player and presentation

Movement is normalized across the elevated room plane and uses a foot collider, Y sorting, camera limits, surface-aware noise, sprint, crouch, and hold-breath states. The flashlight is held at hand scale and casts onto the floor. Puzzle poses are target-specific for the piano, vanity, and ritual seal.

Door transitions show the opened leaf and dark threshold, move Els through it, load the destination at its paired doorway, and close the arrival door. Capture plays collapse, restores the exact saved state and position, then fades in while the supplied collapse animation reverses into a standing recovery. Enemies and controls stay inactive until recovery completes. The false-exit Loop uses the same prone-to-standing presentation.

Interaction facing is derived from the live player-to-target vector. Authored piano, vanity, and ritual offsets retain exact staging while using that target angle. Checkpoint recovery has priority over passage arrival state, initializes every passage directly closed, and cannot replay an arrival or door-closing cue.

The fade and reverse-collapse animation run together, but returning to `PLAYING` no longer awaits a tween signal that may already have fired. Recovery explicitly restores player control after the animation completes.

## Interaction safeguards

- Completed puzzles remain visible but cannot be solved repeatedly.
- Sealed or gated objects do not play success-like pickup or unlock animations.
- The piano and vanity consume one lockpick on their first successful attempt.
- The cracked ritual seal is a one-step Sight-gated interaction and consumes no lockpick.
- CR-04 and CE-03 source-defined reveals share persistent one-time flags with nearby lore interactions.
- CE-01 presents a hint for the active branch only.
- Stun Rite validates its 192-pixel range before spending health or starting cooldown.
- An anchor cannot begin while Els is detected and continuously validates live detection while channeling.

## Enemy progression

| Stage | Capability |
| --- | --- |
| Deprived | Dormant navigation pressure; no Hearing or Sight response |
| Hearing | Investigates surface noise and escalates repeated noise into a hunt |
| Sight | Uses FOV, range, occlusion, and exposure confirmation; outruns a straight sprint |
| Memory | Records confirmed routes and used hiding places, predicts exits, and ambushes repeats |
| Vantree Part II | Touch reads floor transmission and uses the true-form presentation |

The enemy uses `AStarGrid2D` around inflated obstacles and still relies on `CharacterBody2D` collision for physical movement. It does not teleport through geometry. Stun uses distinct sway and desaturation because the supplied monster sheet contains no dedicated stagger frames.

## Assets

Gameplay and art remain separated: collision, interaction IDs, and route logic do not depend on image filenames. The current asset sweep verifies all 60 catalog textures, object transparency, room coverage, interaction access, and navigation. See `ASSET_CREDITS.md` and `docs/ENVIRONMENT_ASSETS.md` for source and integration details.

## Verification

| Suite | Result |
| --- | --- |
| Estate assets/layout | 686 checks, 0 failures |
| Systems and AI | 66 checks, 0 failures |
| Canon Vantree-to-Severance route | 96 checks, 0 failures |
| Alternate outcomes, recovery, and remaining Nexus endings | 148 checks, 0 failures |
| Rendered room sweep | 7 zones, 38 viewpoints for 37 room regions |
| Rendered animation sweep | 9 critical states |

The integration routes use actual scenes and interaction nodes. Enemies are frozen only where deterministic path coverage is required; sensing, chase, damage, interruption, and recovery receive separate live-system checks.

## Remaining release work

No known story-route or runtime blocker remains in the verified build. Public distribution still requires asset-license confirmation, matching Godot 4.7 export templates, exported Windows/Web smoke tests, and normal-speed human balance/accessibility testing. These release items are tracked in `KNOWN_ISSUES.md` and do not change the story.
