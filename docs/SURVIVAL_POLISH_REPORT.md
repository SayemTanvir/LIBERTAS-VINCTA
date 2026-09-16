# Furniture, pursuit and survival HUD — 2026-09-16

## Result

- Front-facing furniture replaces the angled bench, chairs, sideboard, bookcase,
  settee, bed, toy chest, washstand and bath. All seven upper-floor rooms plus
  Side Corridor and Reading Nook were rendered and inspected. Feet use level
  origins and shallow contact shadows. Upper-floor moonlight now has soft edges.
- Ordinary tables, chargers and previously unblocked hiding furniture have
  physical footprints. Chargers overlapping background furniture were moved
  forward into clear floor space. Coverage remains 28 of 94 tables, at most one
  station per named room, with every station reachable.
- Sight reaches 520 pixels in light and 260 in shadow, with a 140-degree cone.
  Uncovered targets within 110 pixels can be seen outside the cone. Confirmation
  takes 0.12 seconds nearby or 0.3 seconds farther away. Walls, hiding and sigils
  still apply; Sight still requires the relevant ward to be restored.
- Pursuit uses full-body collision sweeps, skips reachable grid waypoints and
  keeps its target when replanning. Depth movement preserves the planned direction.
  A 0.16-second sustained turn prevents rapid left/right sprite flips; playback
  rate is smoothed. Touch continually updates nearby targets during an audio hunt.
- Death invalidates pending vent/door callbacks and deferred travel. The player
  and audio director ignore duplicate death presentation. Nonfatal damage uses
  a short standing flinch and a brief hit cooldown, without a death scream.
- The native HUD groups health, flashlight percentage, smooth resource bars and
  four inventory counts in a dark bordered panel. Charging also shows its actual
  increasing battery percentage near the bottom of the screen.

## Verification

Godot 4.7.2 on Windows; GL Compatibility for rendered checks.

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Estate assets, room cap and navigation | 950 | 0 |
| All charging station approaches and E selection | 28 | 0 |
| Game systems and updated sight timing | 67 | 0 |
| Full route, puzzle and recovery playthrough | 150 | 0 |
| Live-Hound Convergence endings and charging | 54 | 0 |
| New survival regressions and HUD | 20 | 0 |
| Hound artwork and animation presentation | 136 | 0 |
| Repeated interactions, hiding and gameplay polish | 139 | 0 |
| **Total** | **1544** | **0** |

The new suite exercises close-range rear detection, pursuit progress and turning,
solid cover, navigation around an obstacle, walking into an ordinary table,
lethal damage during a vent delay, single death dispatch, nonfatal hit poses,
Touch target updates, incrementing charge percentage and viewport fit.
The route suite isolates enemy AI; the finale suite completes all three choices
with live AI. These are complementary checks, not a claim of a manual continuous
playthrough of every route.

Visual captures: `build/survival_UF-01.png` through `survival_UF-07.png`,
`survival_GF-05.png`, `survival_GF-06.png`, `survival_charging_hud.png` and
`survival_hud_800.png`. Generated artwork and provenance are in
`assets/environment/props/estate_front/`.

Logs contain existing certificate-store and shader-cache access messages. No
GDScript or shader compilation failures remain in the passing runs.
`git diff --check` passed. Desktop runtime was tested; export packages were not rebuilt.
