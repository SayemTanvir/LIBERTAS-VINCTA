# Field guide, charging and Convergence — 2026-09-15

## Result

- H opens Els' contextual field guide and pauses danger. Blood/partial rites now have explicit controls, effects, costs, cooldowns and gate instructions. HUD objectives, resonance counts and ready/cooldown states support the guide.
- Partial sigils now suppress active Hearing inside their circle instead of attempting to suppress already-dormant Memory. Blood circles suppress all senses, including Touch. Effect lifetime follows the scene's pause clock and cannot leak through saves or room changes.
- Out-of-range, unavailable, cooling-down and low-health casts explain why they failed without spending resources. A weak Els cannot accidentally die while activating the forge.
- 74 charging stations cover all 37 named rooms: exactly two in each, including the intro and Part II. Cyan labels and batteries identify them. Charge accumulates over 12 seconds; movement or damage cancels immediately and retains partial gains. Part II stations also replenish HP.
- CE-05 Nexus Descent now has a crouching shelter and a reusable distraction cache, so an empty gadget inventory does not block its three-use gate.
- Convergence has two hiding screens, two ward lanterns, a visible golden Ward Bell and labeled ending choices. Its camera keeps all three anchors in view.
- E at the bell binds the Hound for 32 seconds. Hold E at one anchor for 20 seconds; a timer and progress bar show completion. Pause freezes both timers. Release, movement, detection or damage interrupts the ritual without committing an ending. After expiry the bell is reusable.
- Stun clears current detection and prevents hearing reactions while stunned. The Touch-mutated Hound now inflicts Part II contact damage instead of incorrectly using the harmless blind-stage bump.
- README and the full spoiler walkthrough describe these implemented rules.

## Tests

Godot 4.7.2 on Windows. Test saves are isolated under `build/`.

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Estate art/layout and station counts | 1024 | 0 |
| Every station's collision-free approach, navigation and E selection | 74 | 0 |
| Abilities, systems and interruption | 67 | 0 |
| Canonical Vantree route, Part II, finale and Loop | 96 | 0 |
| Alternate routes and checkpoint recovery | 150 | 0 |
| Rendered field guide, charging and live-AI finales | 46 | 0 |
| Interaction/animation polish | 139 | 0 |
| Crouch, flashlight, pickups and sensing (headless) | 60 | 0 |
| Total | 1656 | 0 |

`verify_finishability.tscn` starts from prepared Part II branch states, then uses
normal movement, real ability costs and continuously held E in Convergence.
The Hound's AI remains active for all three endings: Vantree → Severance,
Partial Mercy → Vessel, Untouched → Custodian's Rest. No shortened channel or
automation-channel override is used. It also verifies pause, cancellation,
ward expiry and re-ringing after a failed attempt.

The canonical and alternate full-route tests isolate progression by disabling
enemy movement and placing Els at interactions. They validate the story/door/save
contracts; they are not a claim of a human-style live-enemy traversal of every room.
The station-access test checks every charger against actual collision, navigation
and target selection, rather than only counting entries in JSON.

## Render review

Inspected captures in `build/` include `finishability_field_guide.png`,
`finishability_partial_sigil.png`, `finishability_nexus_descent_hide.png`,
`finishability_ward_bell.png`, all three `finishability_convergence_*.png` frames,
and the three ending screens. The decorative Nexus wheel was moved up so it no
longer concealed the bell. Progress was separated from the objective text.

These engine runs report a Windows certificate-store warning; editor import also
cannot save global editor settings outside the workspace. The successful runtime
suites report no GDScript failures. Desktop gameplay was tested; exported Windows
and Web packages were not built in this pass.

## Charging density update

The earlier 74-station placement above is superseded: 28 of 94 tables now have
power stations (29.8%). The other 66 tables are ordinary furniture. All seven
floors retain charging access, including Nexus Descent and Convergence. The
supplied Estate Essentials powerstation.jpg provides idle, charging and full
artwork with runtime checkerboard masking. The original file is unchanged.

Updated asset checks: 913 passed. All 28 remaining stations passed navigation,
collision-free approach and E-selection checks.
Rendered charging and finale checks: 52 passed, including idle/charging/full
machine states, interruption and all three endings with live Hound AI.

## Room cap and interaction pose update

- No named room has more than one charging point. The duplicate Cold Foyer
  station moved to the Music Room, retaining 28 stations across 94 tables.
- Machines are 25% smaller (36 instead of 48 pixels wide). Els remains in a
  single standing pose while charging; movement still cancels and retains gains.
- Door interactions now walk Els into position before the key/handle animation.
  A blocked or out-of-range approach cannot unlock the door. The Music Room
  door and its open frame are scaled to her reach, with the key hand on the lock side.
- Verification: 950 asset/room checks, 28 station access checks, 9 door alignment
  checks, and 54 rendered charging/finale checks passed. The full playthrough
  suite also passed 150 checks. Door and charging poses were visually inspected.
