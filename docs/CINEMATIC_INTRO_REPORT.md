# Hollowmere cinematic intro — 2026-09-15

Every application launch plays the 22.4-second exterior sequence, then opens the
main menu. `scenes/intro/startup.tscn` is the project entry scene. Natural completion
and Skip both return to `front_end.tscn` and remove the cinematic's local audio.
The intro is independent of save files and playthrough flags. New Game starts Els's
awakening directly; Continue and returning to the menu do not repeat the exterior.

Launch-flow verification on 2026-09-16: **43 checks, 0 failures** in
`tests/verify_cinematic_intro.tscn` (`build/startup_intro.log`). Covers natural
completion, keyboard Skip without accidental menu activation, repeated launch,
save preservation, New Game awakening, Continue, audio cleanup and viewport fit.
The earlier verification counts below describe the original in-game integration.

## Presentation

### HD upgrade, 2026-09-15

The house now uses the generated `05_house_hd.png` (1254 x 1254), replacing
the approximately 185 x 180 crops described in the original report below.
Whole-image sampling removes house dissolving/ghosting and preserves square
proportions. Weather, bats, lightning, audio and the camera approach remain.
The updated rendered cinematic suite passed **35 checks, 0 failures**, including
a new 1920 x 1080 capture at `build/intro_full_hd.png`, visually inspected.
The following source limitations and 34-check results describe the original pass.

- Slow approach with blended house, rain and fog views.
- Two bat crossings, eight aligned wing poses and seven independent flight phases.
- Moving rain/mist, vignette and two soft lightning cues with delayed thunder.
- Story text followed by the LIBERTAS VINCTA title and Degrees of Freedom theme.
- Wind and title sting on the existing, user-adjustable audio buses.
- Enter/Space or pointer Skip fades out the cinematic and opens the main menu.
- The timeline and local audio respect pause; all cinematic children are removed on exit.
- The composition scales uniformly and letterboxes on taller viewports.

Source images are unchanged. Atlas crops exclude printed sheet annotations;
runtime compositing removes noisy transparency and feathers weather seams. House
frames are approximately 185×180 pixels, so background detail remains limited by
the supplied contact sheet. No additional image generation was used.

## Verification

Godot 4.7.2, Windows, GL Compatibility for visual checks:

| Suite | Checks | Failures |
| --- | ---: | ---: |
| `tests/verify_cinematic_intro.tscn` | 34 | 0 |
| `tests/verify_game_route.tscn` | 96 | 0 |
| `tests/verify_full_playthrough.tscn` | 150 | 0 |
| Total | 280 | 0 |

The cinematic suite covers normal completion, keyboard skip, pause/resume, menu
exit, legacy checkpoint loading, control restoration, cleanup, audio cue delivery,
and viewport fitting. Rendered frames inspected: `build/intro_establishing.png`,
`intro_lightning.png`, `intro_title.png`, `intro_mist.png`, `intro_tall_viewport.png`
and `intro_paused.png`.

The runtime logs also contain existing Windows certificate-store / shader-cache
messages and a GL texture-atlas warning from `player.gd:52`. No cinematic script
or shader compilation errors were reported. `git diff --check` passed.
