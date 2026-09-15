# Asset integration contract

Collision, interactions and sensing never infer dimensions or behavior from textures.

## Characters

The playable Els uses `scenes/player/female_frames.tres`, built from the ten sheets in
`ifat/female`. The Deprived One now uses `scenes/enemy/blood_hound_frames.tres`,
built from the supplied `assets/BG/02_Enemy/blood_hound_horror_monster_animation_sprite_sheet.png`.
The shared enemy scene replaces the zombie throughout the existing spawn flow.

Both scenes assign SpriteFrames directly, so their art is also visible in the editor.
Player animation names use `<action>_<direction>` with s, sw, w, nw, n, ne, e and se suffixes.
`character_animation.gd` maps player facing to those directions. The Blood Hound sheet
contains side profiles only: horizontal movement mirrors the sprite, vertical movement
retains its last horizontal facing, and turns preserve the current gait frame.

Player movement selects idle/walk/run or the new crouch_idle/crouch_walk poses.
Hiding moves the fully opaque crouched character into the shelter, and leaving returns
her to her approach position with collisions restored. The body is never squashed to crouch.
Key pickup, ordinary collection, lock work, door opening, piano work, reading, recharge
and channeling have separately selected clips. Caught plays death and holds its final frame.
The Blood Hound has 40 frames across idle, walk, sniff, run, attack and stagger clips.
Stationary searches use sniff, patrols use walk, and fast hunts/chases use run.
Playback follows actual movement speed; paw-contact frames trigger footstep audio.
Capture and Part II contact damage trigger a one-shot attack with a brief movement hold;
stun interrupts it with the supplied stagger poses. Damage values and sensing rules remain unchanged.

Blood Hound atlas margins align irregular source regions to a 360 by 224 canvas with
an authored (180, 204) ground anchor, using offset (0, -92) and scale 0.70 (0.79 in true form).
The independent 24 by 14 collision footprint stays at the ground origin. A vector mask
isolates each silhouette where neighboring source poses overlap rectangular crop bounds.
The source PNG is unchanged; each enemy has its own mask material synchronized on frame changes.
Awakening keeps its existing collapsed pose, reverse recovery and control lock.

Rebuild the checked-in resources after replacing sheets:

```powershell
python scripts/tools/build_character_frames.py
python scripts/tools/build_blood_hound_frames.py
```

The Blood Hound builder requires Pillow and writes atlas resources, clip IDs and SVG
mask geometry. Godot imports these assets automatically; Python is only needed to rebuild them.
Run `tests/verify_enemy_presentation.tscn` for frame/mask, facing, state and floor checks;
a rendered run also saves all 40 poses and the corrected room views under `build/`.
After pickup, the supplied directional flashlight holding pose supplies the upper body,
while the existing walk/run animation supplies the legs. Switching the light changes
the held pose and beam immediately; it never runs the sheet's turning sequence and
there is no separate hand-mounted flashlight sprite. Crouching and actions use their
own complete poses. The existing shadow-casting floor light follows the facing direction.

## Environment

The supplied 2D pack and piano are integrated by default through
`scripts/levels/estate_art.gd` and `data/estate_art.json`. See
[environment asset placement](ENVIRONMENT_ASSETS.md) for the installed furniture,
atlas region, remaining art slots and runtime verification commands.

Each `scenes/levels/{intro,ground,upper,basement}_floor.tscn` exposes:

- `environment_art`: assign a PackedScene containing the final room art.
- `use_imported_assets`: enabled by default; builds the supplied estate dressing when no custom `environment_art` is assigned.
- `show_placeholder_environment`: disable after assigning art.
- `zone_id`: selects layout data; preserve unless deliberately changing progression.
- `debug_noise`: leave false for release.

The artist scene should use room-local coordinates: floor/depth band y=354–634, foot positions generally y=375–615, wall above it. Intro width is 1,800; other groups are 7,200. Use upright side-facing sprites with visible floor depth. Background art should use a negative z index; foreground elements should use their foot Y or a suitable foreground z index.

Generated Geometry owns collision; Props owns Y-sorted furniture/interactables; Markers owns spawn/exit references. Replace visuals, not these gameplay responsibilities. The placeholder background includes subtle Parallax2D windows and floor seams.

Built-in art places furniture bodies using explicit positions and footprints in
the art catalog. Floor decorations, piano, vanity, ritual lectern and Custodian
table also register collision with navigation before its grid is built.
Interaction origins remain in front of their supporting furniture collision.
Loose pickups and passages use the generated essentials atlas; keys receive
high-contrast markers while retaining normal floor sorting. Door roots align to
the rear wall at y=362. A successful passage opens around its left edge over a
dark doorway, moves Els through, and loads the destination with that door open.
Els emerges to y=418 before the destination door closes and control returns.

`data/estate_layout.json` supplies prop type, unique ID, position and exported behavior values. Tune future art placement there or replace the builder with authored children using the same interaction contract. If furniture collision changes, update the matching navigation blockers and verify prop accessibility and enemy navigation in Godot.

## Props

Reusable presets are under `scenes/interactables/`. Assign Texture2D assets at `Visual/Sprite2D.texture`, then align position and scale. The placeholder hides automatically when a texture is supplied. Keep root script, Visual and child names intact.

Use distinct sprites for doors, keys, letters, flashlight, lockpick kit, hiding spots and puzzle seals. Text is replaceable in the layout JSON. IDs must remain unique; progression saves those IDs. Key and letter collection does not depend on visual size. The tool pouch and ordinary items use the crouching `collect` clip; `pickup` is reserved for the brass key. Collected pickups hide their entire child presentation on collection and reload.

## Audio

Assign AudioStream resources on `scenes/systems/audio_director.tscn` (or the Main/Audio instance's Inspector overrides). Named AudioStreamPlayer children are constructed at runtime. Every unassigned slot remains silent.

| Exported slots | Suggested format / content | Bus |
| --- | --- | --- |
| rain, house_ambience | Loop-ready OGG ambience | Ambience |
| drip, breathing, building_creak | Short WAV/OGG accents | Ambience |
| wood_footsteps, stone_footsteps, water_footsteps | Short footstep WAV files | SFX |
| key_sting | Short sense-restoration accent | SFX |
| monster_breathing, monster_search | Creature accents | SFX |
| door, lockpick, flashlight, ui | Short interaction/UI sounds | SFX |
| calm_music, searching_music, chase_music | Loop-ready OGG tension layers | Music |

Master, Music, Ambience and SFX buses are defined in `default_bus_layout.tres`. Tension changes crossfade over 1.2 seconds; key screen treatment lasts 0.65 seconds. Gameplay noise is an EventBus signal, separate from audible sound. Leave detection balance independent of sound volume.

## UI and story

Fresh Start now plays the 22.4-second Hollowmere exterior prologue before Awakening.
All four supplied `assets/BG/11_intro/` sheets are composed by
`scripts/intro/estate_cinematic.gd` and `shaders/intro_estate.gdshader`:
house approach/dissolves, eight-pose bat flight, lightning and moving rain/mist.
Sheet labels are cropped out; the house's low-alpha artifacts and weather tile seams
are masked at runtime. Wind, two delayed thunder cues and a title sting use the
existing audio buses. Enter/Space or the Skip button fades into Awakening; Escape
pauses the visual timeline and local audio. The composition fits the viewport while
preserving its aspect ratio. Continue/checkpoint entry bypasses the exterior.
See `assets/BG/11_intro/README.md` for source frame limitations and mapping.

Assign a Theme resource to `Main/UI.ui_theme`. The UI provides readable default controls without external fonts. Replace sense text with icons only while retaining ledger-driven state. Subtitle queue accepts optional speaker, line and duration; current gameplay uses timed advancement. Letters pause danger and close with E/Esc. No final letter pages are claimed.

Edit Awakening timing/lines in `scripts/intro/awakening.gd` and pickup/door lines in BaseInteractable. Letter slots and provisional text are in the JSON. Ending titles/text are isolated in `GameHUD.show_ending()`. The supplied brief's Els lines are already wired.

## Integration checklist

1. Verify the player's eight directions and the Blood Hound's mirrored movement, attack and stun clips.
2. Assign room-art scenes; hide only environment placeholders.
3. Align props to their existing foot markers and assign textures.
4. Assign audio streams and check loops, mix and subtitle timing.
5. Assign Theme/icons; verify 1280×720, 16:10 and fullscreen.
6. Fill credits/licenses and review placeholder narrative text.
7. Play through each ending and check collisions, stealth, checkpoints and menus.
8. Install matching export templates; test Windows and Web independently.
