# Whole-game interface refresh — 2026-09-16

## Result

The interface now carries the main menu's dark estate style through settings,
help, pause, credits, reading, inventory, loading and outcomes. Native Godot text
and controls replace the baked menu labels on these pages. Existing scenery,
paper grain and pickup artwork are reused; this pass generated no raster assets.

| Screen | Changes |
| --- | --- |
| Main menu | Larger action labels, descriptions and navigation hints; retains the estate scenery and transparent red selection animation. |
| Settings | Two organized columns, draggable audio sliders, numerical values, resolution arrows and explicit On/Off switches. Ambience and dialogue subtitles are now exposed alongside the existing settings. |
| How to play / Controls | Readable native instructions, twelve control bindings, and a visible Controls button. Keyboard shortcuts to Controls remain supported. |
| Pause | Matching dark page, current chapter, checkpoint explanation and clear Resume action. Subpages retain pause and restore the caller's focus. |
| Credits | Native team names and roles, including Ifat's Assets / Implementation credit, plus asset attribution. |
| Reading / Field guide | Wider serif reading column, restrained paper texture, visible scrollbar and scroll percentage, and a mouse-operable Close button. Long text remains fully scrollable. |
| Inventory | Four illustrated item cards with actual ledger quantities, collected-letter count and current freedom summary. |
| HUD | Slim animated health/charge meters, clearer item labels, framed interaction prompts, and separate positions for objectives, abilities, narration and ritual/charging progress. |
| Loading | Chapter identification, title, fine divider and a gently animated diamond. Existing loading and error-recovery flow remains intact. |
| Game over / Endings | Matching native outcome pages. Retry explicitly describes the checkpoint. Part I offers Continue to Part II; final endings offer Begin again. Canonical ending text remains in the reader. |

Shared components: `scripts/ui/ui_style.gd` defines colors, type, rules and
surfaces; `menu_sheet.gd` supplies the page layout, 0.16-second entrance and
0.12-second selection fade. Existing `image_state_menu.gd` retains keyboard,
mouse and standard controller UI input handling. `pause_page.gd` replaces the
pause artwork page in the pause host.

## Validation

Godot 4.7.2 on Windows, with the GL Compatibility renderer for visual review.
Test saves are isolated under `build/`.

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Native UI layouts, input, reading and rendered captures | 1,235 | 0 |
| UI input and full screen flow | 769 | 0 |
| Repeated interactions, dialogue and gameplay regression | 139 | 0 |
| Pointer slider and speech sizing regression | 14 | 0 |
| Home menu layout, headless | 40 | 0 |
| **Total** | **2,197** | **0** |

The native suite checks labels and actions at 1280×720, 1024×768, 1920×1080,
2560×1080 and 800×600. It exercises real pointer drags, subtitle toggling,
the Controls button, mouse dismissal, current inventory quantities, compact
icon bounds, contextual ending actions, HUD wrapping and narration/progress
separation. Hidden, clipped engine scroll-fade masks are excluded from the
inventory texture bounds check.

The flow suite covers keyboard, pointer, D-pad and standard UI action events,
paused submenus, letters, input leakage on dismissal, Retry, Part II continuation,
return to menu, loading and awakening. Its earlier rendered run also passed all
769 checks. Native UI assertions and screenshots completed without GDScript or
shader errors. One capture then returned the previously recorded Windows
`0xC0000005` renderer shutdown failure; see `../KNOWN_ISSUES.md`. A separate
headless run passed all 1,217 non-render checks and exited normally. The runner
also retains its existing Windows certificate-store warning.
The subsequent rendered repeat passed all 1,235 checks, saved all 18 captures,
and exited normally.

Eighteen final screenshots were captured and the major screens visually reviewed
under `build/native_ui_*.png`, including inventory, guide, settings, help, credits,
pause, outcomes, HUD, loading and simultaneous narration/progress. Visual review
caught and corrected intrinsic texture sizing and text wrapping that input-only
tests could not detect.

Final logs: `build/ui-native-verified.log`, `build/ui-native-repeat.log`,
`build/ui-native-headless-final.log`, `build/ui-native-flow-final.log`,
`build/ui-native-gameplay.log`, `build/ui-native-polish.log`,
`build/ui-native-home.log`.

```powershell
godot --path . tests/verify_native_ui.tscn
godot --headless --path . tests/verify_image_ui.tscn
godot --headless --path . tests/verify_gameplay_polish.tscn
godot --headless --path . tests/verify_ui_polish.tscn
godot --headless --path . tests/verify_home_widescreen.tscn
```

## Practical limits

Settings retain their existing session-only lifetime, stated on the page.
Fonts use the project's system-font fallbacks. Physical-controller comfort,
other operating systems and exported packages still require the release checks
in `QA.md`; export packages were not rebuilt in this UI pass.

The room-dressing integration also validates its optional JSON before use, so
missing or malformed supplemental decor cannot break scene and inventory
initialization. Its data was present for the final passing capture run, which
emitted no room-dressing warnings.
