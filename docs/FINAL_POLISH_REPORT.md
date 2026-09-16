# Final polish, story flow, and persistent settings

**Follow-up:** [IMPLEMENTATION_GAPS_REPORT.md](IMPLEMENTATION_GAPS_REPORT.md) records the completed seven gaps, restored animated parchment, full authored letters, seated piano, individual batteries and compact HUD. Its reader description supersedes the earlier interface described here.

Implemented and tested on Godot 4.7.2, 16 September 2026.

## Result

The intro no longer displays its Prologue caption. Preferences survive application restart. Existing menu scenery fills the viewport while controls keep their proportions and input alignment. The optional family nameplate now gathers and assembles into VANTREE before opening the document reader; its consumed fragments and completion state survive checkpoint restoration. All thirteen letters received a restrained narrative coherence pass.

No new artwork was generated or substituted. Existing menu images, the Horroroid title font, navigation architecture, character actions, speech bubbles, and document-reader assets remain in use. No Language option was added.

## Architecture and files

The implementation follows the existing startup → front end → loading → awakening → gameplay flow. `SessionSettings` remains the preference authority; `FreedomLedger` and `GameManager` retain run/checkpoint ownership. Menus retain `ImageStateMenu` selection, focus, mouse, and action dispatch. Documents use the existing HUD reader and READING state.

| Area | Modified or added files |
| --- | --- |
| Intro caption | [estate_cinematic.gd](../scripts/intro/estate_cinematic.gd) |
| Preferences | [session_settings.gd](../scripts/systems/session_settings.gd), [settings_page.gd](../scripts/ui/settings_page.gd) |
| Menu scaling | [image_state_menu.gd](../scripts/ui/image_state_menu.gd), [menu_sheet.gd](../scripts/ui/menu_sheet.gd), [main_menu.gd](../scripts/ui/main_menu.gd) |
| Fragment interaction | [nameplate_fragments.gd](../scripts/interactables/nameplate_fragments.gd) (new), [base_interactable.gd](../scripts/interactables/base_interactable.gd), [estate_art.gd](../scripts/levels/estate_art.gd) |
| Reading and messages | [game_manager.gd](../scripts/core/game_manager.gd), [game_hud.gd](../scripts/ui/game_hud.gd), [letter_reader.gd](../scripts/ui/letter_reader.gd) |
| Runtime narrative | [estate_layout.json](../data/estate_layout.json) |
| Narrative documentation | [STORY_CANON.md](STORY_CANON.md), [FINAL_HORROR_GAME_CONTENT.md](FINAL_HORROR_GAME_CONTENT.md) |

Production scene files did not need replacement: their scripts construct the existing UI and data-driven interactions. New `.tscn` files are test harnesses only.

## Intro

Removed the single `_caption` call containing `P R O L O G U E / T H E A P P R A I S A L`. Its absolute-positioned subtitle does not reserve layout space, so removing it leaves no empty row. The 22.4-second timeline, title, other captions, skip control, audio cues, and menu transition remain unchanged. Natural completion, skip, and awakening are covered by the cinematic regression.

## Saved settings

Preferences are stored in **`user://settings.cfg`**, using Godot `ConfigFile`. On normal Windows installations this resolves beneath `%APPDATA%\Godot\app_userdata\LIBERTAS_VINCTA\`.

- `_ready()` loads and applies preferences before the startup scene becomes interactive.
- Each setting setter applies its value and saves immediately; no Apply button is needed.
- Master, Music, SFX, Fullscreen, Resolution, and Screen Shake persist. The already-existing Ambience and Dialogue Subtitles options also persist.
- Missing files/keys use defaults. Invalid types, unsupported resolutions, nonfinite audio values, and malformed files are handled safely. Finite volume values are clamped to 0–100%.
- Resolution choices include 1280×720, 1366×768, 1600×900, and 1920×1080.
- Fullscreen uses the display's fullscreen size. Changing resolution while fullscreen changes the preferred windowed size without leaving fullscreen. Turning fullscreen off restores that preference, proportionally fitting it to the monitor's usable area if necessary.
- Existing camera-shake code reads the same authoritative setting; tests check the actual camera offset with shake disabled and enabled.
- If saving fails, the settings page explicitly reports that changes are active but could not be saved.
- Preferences are separate from checkpoint reset, New Game, Retry, and scene transitions.

Restart tests launch separate Godot processes with the production settings script and an isolated configuration under `build/`. They do not overwrite the player's settings.

## Fullscreen and input alignment

A shared `cover_background()` helper presents the existing scenery through a full-viewport `TextureRect` using `STRETCH_KEEP_ASPECT_COVERED`. Scenery may crop at the edges on a different aspect ratio; it does not distort. The UI design uses a uniform fit scale and remains centered, keeping controls fully visible. Main-menu title and button content retain their existing independent layout. Filtering is linear and page content clips at the viewport boundary.

The same presentation is used by Settings, Rules, Controls, Credits, Pause, Game Over, and Chapter Complete. Existing focus, mouse-hover synchronization, selection-image support, and action signals remain owned by the original menu base.

Verified the four requested resolutions and actual **3200×2000 fullscreen** on the available Windows/Intel Arc display. Additional existing layout checks include 800×600, 1024×768, and ultrawide sizes.

## Family nameplate

The existing `scratched_nameplate` interaction in GF-05 is now at `(3420, 480)` on the floor, reachable through normal interaction targeting.

1. Els performs the existing short collection action without teleporting.
2. If damage/detection interrupts the reach, nothing is consumed and the interaction can be retried.
3. The world pauses for inspection. Three pieces, cut from the already-integrated metal texture, lift from their projected floor positions and join with staggered tweens.
4. Each piece exposes part of one inscription. Joining them restores **VANTREE** as a continuous word.
5. The three collected floor pieces vanish. Two small, non-interactive chips remain.
6. The existing document reader opens the reconstructed account. Closing it restores gameplay and blocks the closing key from immediately triggering another interaction.
7. `nameplate_assembled` is saved in the existing checkpoint. Repeated input cannot replay collection. Restored rooms retain the consumed visuals.

Older checkpoints that only recorded the former static inspection can still perform the new assembly once. The nameplate does not count as a numbered letter and does not alter the four-letter Vantree route requirement.

The recovered family name is Els's surname, **Vantree**. No contradictory surname was found to replace. The new clue reveals no first name, ancestry, or explanation of the later impossible carving. The portrait is still a lore reference, not a newly introduced collectible asset.

## Letters and Els's speech

- Reviewed and lightly expanded all thirteen runtime letters while retaining their IDs, locations, number, and route requirements.
- Neutral numbered titles replace the automatic “Vantree” archive attribution, so the UI does not establish ownership before the player finds evidence. The reader now labels documents “Hollowmere / Documents.”
- Letters I–VII progress through the wards, Custodian/Jailer distinction, and danger of completing every lock. Their warnings remain understandable if encountered before or after taking a key.
- Letter III and V explicitly describe the period before Sight and Memory were sealed. Letters XII–XIII describe a past account rather than asserting that the entity currently speaks on every branch.
- Letters VIII–XI develop older stone, names, and transfer of the burden. They do not invent Els's ancestry or the prison's origin.
- Preserved the “Freedom is never destroyed” theme and included the existing “Forgive me ... It has to be someone” breadcrumb.
- The foyer note now opens in the document reader, instead of displaying document text as Els's speech.
- Key comments describe the action Els actually witnessed or a cautious next step. They no longer assert that an offscreen monster has visibly turned or demonstrated memory.
- Piano, vanity, and ritual completion have specific short comments. Duplicate queued/active comments are suppressed to prevent repeated interaction attempts from flooding speech.
- Existing speaker tracking, wrapping, pagination, reading time, narration separation, and scrolling remain in use. The full-name/date reveal at CR-04 and Vantree-only first voice at CE-03 are preserved.

The longer authored letter expansions in the content bible remain proposals; runtime text is in `data/estate_layout.json`, as the bible's new update note explains.

## Tests performed

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Final polish, rendered (four laptop sizes, real fullscreen, fragments, reader, letters, shake) | 804 | 0 |
| Final polish, final headless run including old-save compatibility | 648 | 0 |
| Existing native UI regression | 1,217 | 0 |
| Existing image-menu/input regression | 769 | 0 |
| Existing cinematic intro regression | 35 | 0 |
| Existing full playthrough: alternate routes, capture/retry, endings | 150 | 0 |
| Existing canonical Vantree route, Part II, finale, Loop | 96 | 0 |
| Existing home widescreen layout | 100 | 0 |
| Settings write process | 1 | 0 |
| Settings read in a fresh headless process | 7 | 0 |
| Invalid/missing settings cases | 6 | 0 |
| Settings read in a fresh rendered process, fullscreen/windowed transition | 12 | 0 |
| **Total** | **3,845** | **0** |

Also loaded **104 production scripts, scenes, and shaders** successfully in a resource audit. `git diff --check` passed. UI test fixtures now isolate preference writes; the resolution-navigation assertion includes the new 1366×768 option.

New test harnesses: `verify_final_polish`, `verify_settings_restart`, and `verify_project_resources` under `tests/`. Existing native/image/UI-polish tests use `settings_fixture.gd`; the home coverage assertion inspects the actual background bounds.

### Visual evidence

- [Fullscreen menu preview](../build/final_polish_fullscreen_preview.png)
- [Settings at 1366×768](../build/final_polish_settings_page_1366.png)
- [Floor fragments before collection](../build/final_polish_fragments_before.png)
- [Fragments gathering](../build/final_polish_fragments_gathering.png)
- [Joined Vantree plate](../build/final_polish_fragments_joined.png)
- [Nameplate document](../build/final_polish_nameplate_document.png)

Captures and logs are local, ignored artifacts in `build/`.

## Remaining limitations

No failing functional checks remain in the tested flows. Fullscreen testing used the available Windows display; multi-monitor switching and other operating systems were not exercised. The native UI suite emitted shutdown object/resource cleanup warnings. The sandbox also emitted certificate-store messages, and the intentional malformed-config test emitted Godot's expected parse diagnostic; those runs completed successfully.
