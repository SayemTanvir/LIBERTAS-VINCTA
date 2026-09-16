# UI integration report

## Compact status panel — 2026-09-16

The health/battery/inventory panel is now 344 × 118 instead of 464 × 150,
reducing its footprint by about 42%. It uses a softer translucent background,
rounded corners, a restrained border, four-pixel meters and compact inventory
rows. Exact health, charge percentage and item counts remain visible. The freedom
summary is shortened to fit, and nearby objective/room text follows the panel's
actual height on narrow layouts.

Validation: `verify_native_ui` passed **1,235 checks with 0 failures**, including
18 rendered captures. Inspected `build/native_ui_hud_1280.png` and
`build/native_ui_hud_800.png`; log: `build/compact_hud_ui.log`.

## Current interface — 2026-09-16

The [whole-game native UI refresh](NATIVE_UI_REPORT.md) supersedes the older
parchment menu mappings below. Settings, help, credits, pause and outcomes now
share the main menu's dark estate style with native controls. Inventory uses item
cards; letters and the field guide use a wide, dark reading view. The latest pass
completed 2,197 checks with zero failures and captured 18 review images.

The remaining sections record the earlier artwork integration and provenance.

Implemented and verified with the installed Godot 4.7.2 stable executable. The initial UI used supplied `assets/BG` PNGs; the main menu now uses the generated scenery described below. `build/ui_*.png` files are ignored runtime verification screenshots, not game assets. Later gameplay/HUD changes are documented in `SURVIVAL_POLISH_REPORT.md`.

## Main menu refresh — 2026-09-16

- Background: `assets/ui/menu/hollowmere_dark_menu.png`, generated using the built-in imagegen tool. The complete prompt is in its adjacent README.
- Presentation refinement: tracked serif title, small estate emblem, italic story tagline, restrained brass dividers and spaced sans-serif actions. New Game and Continue have stronger visual priority. Transparent buttons use an oxblood gradient with a fine red edge, sliding text and a selection arrow; brief option descriptions fade in beneath the menu. Hitboxes stay stationary during animation.
- Title and all six actions are native controls directly over the scenery. There is no menu panel or idle button backing. Hover and keyboard/controller selection fade to red over 0.12 seconds; pointer exit restores transparency. Keyboard navigation owns the highlight even when the pointer rests over another row.
- Background uses uniform cover scaling; controls use a separate safe layout to remain visible from 4:3 to ultrawide. Pause and other pages retain their existing artwork and navigation.
- Rendered checks: `verify_home_widescreen` covers five resolutions and all six selection states. `verify_image_ui` exercises real pointer, keyboard and gamepad events, transparent idle states, red hover, mixed input, settings, pause, results and gameplay transitions.
- Initial dark-menu validation: **705 checks, 0 failures** (100 widescreen + 605 UI flow). Logs: `build/dark_menu_final_layout.log` and `build/dark_menu_final_ui.log`. Inspected neutral/hover captures and final 1080p and 4:3 layouts.
- Refined presentation validation: **705 checks, 0 failures** (100 widescreen + 605 UI flow), recorded in `build/menu_refinement_layout.log` and `build/menu_refinement_ui.log`. Final 1080p, 4:3 and transparent idle captures inspected.

## Files and reusable components

- Replaced menu behavior in `scripts/ui/{main_menu,settings_page,controls_page,credits_page,front_end,pause_menu,menu_navigation}.gd` and rebuilt the front-end/pause host scenes.
- Added `image_state_menu.gd`, `menu_art.gd`, `settings_values.gd`, `rules_page.gd`, `result_menu.gd`, `message_bubble.gd`, and `letter_reader.gd`.
- Added `scenes/ui/{rules_page,game_over,chapter_complete,message_bubble,letter_reader}.tscn`.
- Integrated speech, reading, inventory, and results in `game_hud.gd`; replaced the legacy loading visuals in `loading_screen.gd/.tscn` with the existing bubble template.
- Minimal integration changes: `game_manager.gd` waits for Retry and guards input after UI dismissal; `player.gd` checks that guard; `room_camera.gd` respects screen shake; `session_settings.gd` applies display settings; `project.godot` adds the artwork's Tab inventory action. Removed the routine item-collected subtitle from `base_interactable.gd`.
- Added `tests/verify_image_ui.gd/.tscn`; updated the existing full-playthrough test to select Retry before checking recovery.
- Godot generated resource import metadata during validation. Existing gameplay audio and player/enemy sprite-resource edits were not changed by this implementation.

## Asset mapping

All paths below are relative to `assets/BG`.

| Screen | Supplied PNGs |
| --- | --- |
| Main menu | `../ui/menu/hollowmere_dark_menu.png` with native title and buttons |
| Settings | `04_Settings/states/settings_{master_volume,music,sfx,resolution,fullscreen,screen_shake,back}_active.png` |
| Rules | `05_Rules/rules_screen_back_active.png` |
| Controls | `06_Controls/controls_screen_back_active.png` |
| Pause | `07_Pause_Menu/states/pause_menu_{resume,settings,rules,main_menu}_active.png` |
| Game Over | `08_Game_Over/states/game_over_{retry,main_menu}_active.png` |
| Chapter Complete | `09_Chapter_Complete/states/chapter_complete_{continue,main_menu}_active.png` |
| Credits | `10_Credits/credits_final_corrected_back_active.png` |
| Speech and loading | Bottom wide bubble in `01_Message_UI/dialogue_speech_bubbles_sprite_sheet.png`, atlas region `(140,535,1170,474)` |
| Letters, inventory, ending narrative | `01_Message_UI/collectible_letter_parchment_scroll.png` |

Every supplied PNG was inspected, including the contact sheets, fullscreen reference, and enemy sheet. The enemy artwork was not integrated because this task preserves the existing enemy system.

Some supplied main-menu states omit an option; right-hand pause states contain a shifted crop; settings states mix 384?512 and 512?512 frames. Main, pause, and settings therefore keep a stable source background and switch cached atlas regions from the selected PNG. These regions are displayed at canonical positions, so all options remain present and hotspots do not move. Full-screen state switching is used for results. The main-menu contact-sheet border is excluded with an atlas region. Runtime setting values replace the baked example values with source parchment/track/diamond regions and live text; the baked row names remain authoritative.

## Interaction and context

- One `current_index` controls both actual button focus and the displayed selected-state texture. Hover, focus, click, arrows, and standard UI actions converge on `set_selection()`.
- Up/Down wrap, Enter/Space accept, Escape/`ui_cancel` returns or resumes. Keyboard echoes are consumed. Analog-axis changes are latched to avoid repeated movement while held. No delayed navigation or image crossfade is used.
- Textures and atlas resources are prepared once when the host opens. Navigation changes texture references; it does not reload images or recreate scenes.
- Pages share a navigation stack and restore selection on Back. Gameplay remains paused throughout pause submenus.
- The supplied menus do not contain a Controls button. Select Rules and press Right to open Controls directly, or press Right/right-click on the Rules page. Back returns to the actual caller. This avoids inventing an additional visual button.
- Continue retains the existing save behavior, including starting a new game if no usable save exists. Retry calls the existing checkpoint recovery. Part I Continue calls the existing Part II flow. Final endings preserve their narrative on parchment and retain the existing new-game continuation.
- Existing switch recordings provide quiet selection/confirm/back cues. Re-selecting the same entry is silent.

## Reading and settings

Speech uses the supplied bubble with safe text margins, wrapping, and paging for long messages. Existing timed subtitles keep their queue and timing; acknowledged messages pause until advanced. E/Enter/Space advance speech. Letters preserve collection logic, pause gameplay, scroll with arrows/wheel, and close with E/Enter/Space/Escape. The player input guard prevents a closing press from activating a nearby object. Tab displays a read-only view of the ledger inventory on parchment, matching the supplied Controls artwork.

Master, Music and SFX apply immediately to their existing AudioServer buses, including mute at zero. Resolution cycles 1280?720, 1600?900 and 1920?1080; fullscreen toggles the window mode, with the chosen windowed size restored on exit. Screen shake controls the existing camera offset. Session settings remain session-only, as before. The Ambience bus and subtitle setting remain available to existing code. There is no Language row.

## Removed legacy UI

Removed old generated menu titles/captions, settings widgets, rules/controls/credits text, HUD reading/result panels and visible modal buttons, and the old loading button/ward decoration. Deleted the unused `menu_page`, `menu_button`, `menu_background`, `ward_seal`, and `story_page` scripts/scenes after checking references. Existing gameplay status, prompts, ending narrative, letter text, and dialogue remain functional.

## Verification

| Test | Result |
| --- | --- |
| UI viewport-input and scene-flow suite | 592 checks, 0 failures in both final rendered and headless runs |
| Existing estate assets/layout | 686 checks, 0 failures |
| Existing game systems | 66 checks, 0 failures |
| Existing canonical route | 96 checks, 0 failures |
| Existing full playthrough | 150 checks, 0 failures |

The UI suite injects actual keyboard, mouse, D-pad, and standard action events into Godot. It verifies wrapping, ignored echoes, focus/art synchronization, click routing, setting values and buses, context restoration, paused submenus, scrolling, input leakage, capture/Retry, endings, Part II continuation, Start through the loading/awakening flow, and Main Menu cleanup. It checks non-overlapping hotspots and uniform artwork scaling at 1280?720, 1600?900, 1920?1080, plus 1024?768. Rendered screenshots were inspected for state artwork, duplicate text, borders, typography and safe reading areas. Fullscreen was exercised in the rendered Windows run. The final headless run passed the same 592 checks after legacy-file cleanup.

Re-run with:

```powershell
godot --path . tests/verify_image_ui.tscn
godot --headless --path . tests/verify_image_ui.tscn
godot --headless --path . tests/verify_estate_assets.tscn
godot --headless --path . tests/verify_game_systems.tscn
godot --headless --path . tests/verify_game_route.tscn
godot --headless --path . tests/verify_full_playthrough.tscn
```

No failing UI or gameplay regression check remains. Testing used scripted real viewport events plus visual inspection, not a human-operated physical controller session. A physical gamepad and subjective sound-level playtest remain unverified. Godot prints a Windows root-certificate-store error in this restricted environment; the local game and tests run successfully without network access. Source artwork differences are normalized at runtime; the underlying supplied PNGs remain unchanged.

## Follow-up: Ifat contribution credit

At the user's request, Ifat's visible role is now **Assets / Implementation**. The built-in image editing tool supplied `assets/BG/10_Credits/credits_contributions.png`. `credits_page.gd` displays only its `(714,350,250,30)` contribution region over the existing credits page, preserving every other original region. The updated scene was rendered and visually verified at 1280?720.

Edit prompt: Use case: text-localization. Edit target: the supplied existing LIBERTAS VINCTA credits-screen PNG. Change exactly one contribution line: replace 'Ifat / Assets' with 'Ifat / Assets / Implementation'. Preserve the original Ifat name, existing Assets word, slash alignment, serif font, font size, dark ink color and baseline; append ' / Implementation' immediately after Assets on that same line. Preserve all other text, all other people and roles, parchment texture, background, title, Back button, composition and dimensions (1672 x 941) unchanged. Do not redesign, redraw, recolor, upscale or alter any other part of the image. This is a tiny text correction to an existing game asset.
