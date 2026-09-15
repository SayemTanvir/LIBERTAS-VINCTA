# Hollowmere cinematic intro — 2026-09-15

Fresh Start plays a 22.4-second exterior sequence using all four supplied sheets in
`assets/BG/11_intro/`, then fades into the existing Els awakening. Continue and
checkpoint entries bypass the exterior; a new game resets the seen flag.

## Presentation

- Slow approach with blended house, rain and fog views.
- Two bat crossings, eight aligned wing poses and seven independent flight phases.
- Moving rain/mist, vignette and two soft lightning cues with delayed thunder.
- Story text followed by the LIBERTAS VINCTA title and Degrees of Freedom theme.
- Wind and title sting on the existing, user-adjustable audio buses.
- Enter/Space or pointer Skip fades to Awakening. Escape opens the existing pause UI.
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
