# Gameplay and presentation polish — 2026-09-15

## Changes

- Character speech follows its speaker through world movement, camera tracking, and zoom. The supplied cloud artwork sizes around measured text, uses consistent readable typography, and splits long text at shaped line boundaries. The tail keeps the same side throughout a line, and the cloud stays inside the viewport.
- Narrator/storyteller lines use a separate dark vignette strip with warm serif type, a restrained gold rule, and a fade. Loading uses the same narration presentation. Letter reading and ending parchment retain their existing behavior.
- Timed dialogue no longer consumes E when a nearby object or hiding place needs that input. Acknowledged messages and letters still block gameplay and guard their dismissal press. Page timing accommodates the text length.
- Piano, vanity, and ritual actions face their targets without changing Els's position. Both the prop origin and authored reach point can be selected through unobstructed interaction rays. The old piano pose was 78 pixels away from a target with a 76-pixel selection radius, forcing the player to return after each step.
- Puzzle progress is displayed in the nearby interaction prompt. The old queued “Click, N of 3” speech has been removed. Partly completed steps persist in the ledger so returning to a room does not spend a second lockpick.
- Pickup state and visibility change together when awarded. Keys, letters, tools, batteries, bottles, clocks, and flashlights have compact sizes and draw on the floor below characters. Contact ellipses and glints replace oversized opaque diamond badges. Pickup dressing no longer leaves furniture shadows behind.
- Neutral reach animation is used for ordinary objects; the key-specific clip is reserved for keys. Unlock actions also use the correctly facing reach artwork because the supplied unlock sheet turns its arm away from the target midway through east/west poses. Action playback matches its duration, actions keep feet planted, crouching eases into posture, held idle poses receive subtle breathing, and walk/run changes preserve gait phase. Locomotion speed follows actual movement. Flashlight overlays hide during hand actions and collapse.
- Successful gadget use and magic receive a short hand action that yields immediately to movement so it cannot prevent an escape. Sigils ease in, pulse, and fade without changing their sensing radius or duration.
- Human-readable room names fade into the HUD. Repeated room-ID labels on walls are removed; gadget counts use full names.

## Asset cleanup

Removed two unused catalog entries and their PNG/import pairs after checking source references:

- `RestaurantFixtures/fooddrink_restaurant_fixtures_table_dining_square_four_01.png`
- `RestaurantProps/fooddrink_restaurant_props_place_setting_complete_01.png`

Both were under `assets/environment/props/food_drink_2d_mega_props/Tiles/`. The remaining catalog contains 58 textures. Original licenses remain in place. No image assets were generated or edited.

## Files

- `scripts/ui/message_bubble.gd`: shared paging with two presentation modes.
- `scripts/ui/game_hud.gd`, `scenes/ui/loading_screen.tscn`: speaker routing, interaction priority, narration, prompts, and room naming.
- `scripts/interactables/{base_interactable,pickup_marker}.gd`: stationary interactions, persistent steps, pickup removal, glints.
- `scripts/levels/estate_art.gd`, `data/estate_art.json`: scale, floor ordering, removal of duplicate dressing and unused catalog entries.
- `scripts/player/{player,character_animation,sigil_field}.gd`: action timing, movement/posture transitions, gait continuity, and magic presentation.
- `tests/verify_gameplay_polish.gd/.tscn`: new input, persistence, layout, and rendered regression coverage.
- `tests/verify_full_playthrough.gd`: vanity assertion now checks that Els stays at her approach point.
- `tests/capture_animation_sweep.gd`: explicitly positions the test actor before recording a stationary action.

## Story fidelity

Reviewed all 21 Markdown files present in the repository, including the full walkthrough and `docs/STORY_CANON.md`. The earlier `LIBERTAS VINCTA.md` mentioned by those documents is not present; the available canon and playable walkthrough were used. The six successful endings, three-key Loop, sense order, branch mechanics, letter gates, 20-second anchors, and unresolved Vantree mystery are preserved.

## Verification

Executed with installed Godot 4.7.2, using separate test save files:

| Suite | Checks | Failures |
| --- | ---: | ---: |
| New gameplay/presentation regression | 123 | 0 |
| Existing UI polish | 14 | 0 |
| Image UI and input/scene flow | 592 | 0 |
| Estate assets, accessibility, and navigation | 680 | 0 |
| Game systems and AI | 66 | 0 |
| Canonical story route | 96 | 0 |
| Alternate endings and recovery | 150 | 0 |

The focused suite uses real E events for repeated piano, vanity, and ritual inputs; tests missing/collected world visuals and room revisits; checks every wrapped page for retained text and bounds at 1280×720, 1600×900, 1920×1080, and 1024×768; checks speaker tracking, narration routing, modal movement blocking, action timing, and gait continuity. It also runs with the OpenGL renderer and captures screenshots under `build/gameplay_polish_*.png`.

Run it with `godot --headless --path . tests/verify_gameplay_polish.tscn`, or omit `--headless` for screenshots. Pagination uses Godot's [TextParagraph line ranges](https://docs.godotengine.org/en/stable/classes/class_textparagraph.html#class-textparagraph-method-get-line-range).

These are scripted engine playthroughs and rendered inspections. Exported builds and an external human balance/controller pass remain outside this validation, as recorded in the existing QA checklist. The restricted runner emits the existing Windows certificate-store warning; no gameplay script/resource failure is accepted by these results.

Two rendered capture runs completed their checks/screenshots but returned Windows access-violation status `0xC0000005` during process shutdown. A repeat of the focused rendered suite exited normally, as did normal menu and opening-scene smoke tests. No GDScript error accompanied the exits. The cause is unconfirmed; this remains recorded in `KNOWN_ISSUES.md` for the external hardware pass.
