# Reference HUD and Horroroid title

## Result

- Refined the reference-inspired metal plate into a compact charcoal HUD with recessed red health and teal flashlight meters and four evenly spaced inventory sockets. A patina shader darkens and softens the existing texture to match the estate.
- Aligned the header, equal-width meters, inventory labels and counts, and footer on a shared 640-by-212 layout. Consistent cream text replaces the mixed dark/light lettering; discreet right-aligned shortcut text replaces the large plaque.
- Labels, exact values, item icons and counters are rendered live by Godot. No health, charge or inventory data is baked into the plate.
- Added smooth fractional meter movement, delayed damage feedback, low-resource pulses, charging highlights and pickup flashes. Fresh or restored hidden HUDs synchronize directly to the ledger. Pausing freezes presentation time.
- Kept the HUD readable by accounting for viewport scaling: a 20-pixel screen inset and a preferred physical width of 560–680 pixels reduce its footprint. Objectives move below it when there is insufficient space beside it.
- Applied the supplied regular Horroroid font to the game title on both the opening cinematic and main menu, with width fitting. Body text retains the readable existing font.

## Assets and provenance

The final backing is [hollowmere_metal_plate.png](../assets/ui/hud/hollowmere_metal_plate.png), generated using the built-in imagegen tool from the supplied reference. The initial checkerboard draft was corrected to opaque dark stone before integration. Both complete prompts are in [the asset README](../assets/ui/hud/README.md).

The supplied font is [horroroid.ttf](../assets/fonts/horroroid/horroroid.ttf). Its original [license notice](../assets/fonts/horroroid/LICENSE.txt) is preserved: non-commercial use is free; commercial use has separate author terms.

## Verification

Godot 4.7.2 runs after the alignment refinement:

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Reference HUD, rendered | 99 | 0 |
| Existing native UI regression, headless | 1,217 | 0 |
| **Total** | **1,316** | **0** |

The cinematic intro regression also passed all 35 checks during the earlier font integration; the alignment refinement does not change the intro.

The reference suite exercises real ledger changes, fractional charge convergence, damage trails, acquisition/consumption, pause, branch health caps, empty meters, multiple viewport sizes, objective placement, and both title font resources.

Rendered screenshots were inspected:

- [HUD at 1280 × 720](../build/reference_hud_1280.png)
- [HUD at 800 × 600](../build/reference_hud_800.png)
- [Low health and charge](../build/reference_hud_low.png)
- [Horroroid main menu](../build/reference_horroroid_menu.png)
- [Horroroid opening cinematic](../build/reference_horroroid_intro.png)

Screenshots and test logs are local artifacts under the ignored `build/` directory. Engine startup emitted sandbox environment messages for the root certificate store and shader/editor cache writes; imports, rendering and the test suites completed successfully. No game-script or shader compilation failures occurred.
