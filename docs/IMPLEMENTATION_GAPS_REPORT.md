# LIBERTAS VINCTA — implementation and verification report

Updated 17 September 2026. Tested with Godot 4.7.2 on Windows.

This report covers the seven Section J gaps, the requested letter/piano/battery/HUD changes, and regression checks for the preceding settings, intro, and nameplate work. It supersedes the reading-interface description in [FINAL_POLISH_REPORT.md](FINAL_POLISH_REPORT.md).

## 1. Files and architecture

The existing scene flow, input actions, image-menu selection system, checkpoint manager, and gameplay ledger remain in use. Production `.tscn` files did not need replacement; added test scenes exercise the existing scenes.

| Area | Scripts/data modified or added |
| --- | --- |
| Intro | `scripts/intro/estate_cinematic.gd` |
| Settings and fullscreen | `scripts/systems/session_settings.gd`; `scripts/ui/settings_page.gd`, `image_state_menu.gd`, `menu_sheet.gd`, `main_menu.gd` |
| Letters and inventory | `scripts/ui/scroll_document.gd` (new), `letter_reader.gd`, `game_hud.gd`; `data/estate_layout.json` |
| Nameplate | `scripts/interactables/nameplate_fragments.gd` (new), `base_interactable.gd`; `scripts/core/game_manager.gd` |
| Endings | `scripts/ui/ending_sequence.gd` (new), `game_hud.gd`; `scripts/levels/estate_art.gd`; `scripts/systems/field_guide.gd` |
| Loop and memory | `scripts/core/freedom_ledger.gd`, `scripts/main/main.gd`; `scripts/systems/memory_fragment.gd` (new) |
| Piano | `scripts/interactables/piano_performance.gd` (new), `base_interactable.gd` |
| Batteries | `freedom_ledger.gd`, `base_interactable.gd`, `scripts/player/player.gd`, `letter_reader.gd`, `field_guide.gd` |
| Compact HUD | `scripts/ui/survival_panel.gd`, `game_hud.gd` |
| Map reconciliation | `data/estate_art.json`; `scripts/levels/estate_art.gd`, `estate_room.gd`; `scripts/enemy/deprived_one.gd` |
| Documentation/tooling | `docs/FINAL_HORROR_GAME_CONTENT.md`, `docs/STORY_CANON.md`; `scripts/tools/integrate_authored_letters.py` |

Existing artwork, the supplied Horroroid font, and the original parchment are reused. No new images or Language setting were added.

## 2. Intro

Removed only the hardcoded `PROLOGUE / THE APPRAISAL` caption call. Its absolute-positioned label did not reserve a layout row. The 22.4-second timeline, title, skip control, audio and transitions remain intact.

**Gap 5 — Path A:** the intro door now says **Grand Foyer**, matching its existing Ground Floor / GF-01 arrival. The transition destination is unchanged.

## 3. Persistent settings

`SessionSettings` is the authoritative preference manager. It loads and applies a Godot `ConfigFile` at startup and saves immediately from setting setters.

- Master, Music, SFX, Resolution, Fullscreen and Screen Shake persist. Existing Ambience and Dialogue Subtitles preferences also persist.
- Missing, corrupt or invalid values fall back safely; finite volume values clamp to their valid range.
- Fullscreen and preferred windowed resolution are stored separately. Selecting a resolution while fullscreen does not leave fullscreen; exiting fullscreen restores the chosen windowed size, fitted to the monitor if necessary.
- Camera shake reads the same setting. New Game, Retry and scene changes do not reset preferences.

## 4. Save locations

Preferences: **`user://settings.cfg`**. On Windows, this is under `%APPDATA%\Godot\app_userdata\LIBERTAS_VINCTA\`.

Individual battery percentages and collected/assembled story states use the existing `FreedomLedger` checkpoint snapshot. Legacy checkpoints containing only a battery count migrate each carried cell to 100%. Test saves/configurations use isolated paths under ignored `build/`.

## 5. Fullscreen and compact HUD

Existing menu scenery fills the viewport with aspect-preserving cover scaling. UI content uses uniform fit scaling, so button hitboxes, hover, focus and selected actions share the same transform. No replacement menu artwork was introduced.

The gameplay status plate is now **480 × 159 logical pixels**, down from 640 × 212, with a physical width of roughly 400–480 pixels. Its original aspect ratio is preserved. Health and flashlight retain live values, slim meters, smooth interpolation, damage trails and low-resource feedback. Text and item positions were reflowed; a default-font minimum-height issue in the footer was caught and fixed by the bounds test.

## 6. Family nameplate

The GF-05 fragments are reachable at `(3420, 480)`. Els reaches for them, then three existing-art pieces lift into an overlay and gather into the reconstructed plate. Reading opens after assembly through the same parchment reader used for letters.

## 7. Fragment consumption and state

Collected floor pieces disappear. `nameplate_assembled` prevents duplicate collection and survives checkpoint restoration. A former inspection-only checkpoint still permits the first animated assembly. Damage/detection during the initial reach cancels without consuming pieces. The world is paused during assembly/reading and resumes on dismissal.

## 8. Family and story consistency

The assembled surname is **VANTREE**, matching **Els Vantree**. It does not claim to identify the portrait or resolve her ancestry. Foyer, key and interaction comments describe observed events rather than stating later discoveries as known facts. Neutral numbered letter titles preserve the discovery sequence.

**Gap 1:** all thirteen full authored Section 5 bodies are now integrated, retaining their original IDs, scenes and coordinates. An independent text comparison confirmed exact agreement with the bible. Only four of **Letters I–VII** satisfy the Vantree gate. Letter XIII retains its uncertainty and ends exactly:

> Forgive me, if you're reading this.
> It has to be someone.

Unknown ancestry, entity origin, ritual origin and missing hours remain unresolved.

## 9. Requested interactions and remaining Section J gaps

### Letters

The old full parchment artwork is restored. It unrolls over 0.7 seconds, then reveals text at 55 characters per second. Long documents are divided into measured pages; their complete text is retained. Previous/Next buttons, arrows and the mouse wheel change pages. Enter/E reveals the current text, then advances; on the last complete page it closes. Esc closes immediately through a short roll-up. Reading blocks world interaction.

### Piano

Els walks to the existing bench using collision-aware movement, assumes a seated pose, moves her hands through a short playing phrase, and stands up. The pose is a small articulated rig using the installed Els action texture; rejected seated-image drafts are not used. Sound is a procedurally synthesized damped-string piano phrase on the SFX bus, with separate note attacks.

The existing three-step seal remains. One lockpick is consumed on the first successful step. The following steps remain reachable from the bench without walking to a distant reset point. Damage cancels the performance and restores the visible actor and controls.

### Batteries

Each collected cell starts at **100%**, storing the existing **45 seconds** of flashlight energy. The bag lists each cell's remaining percentage and scrolls for longer inventories. Q and stations draw from this same supply. Partial use retains the remaining percentage; empty cells disappear. A full flashlight does not waste the unused remainder.

**No battery means no flashlight charging.** Part II stations retain their existing health recovery independently. Initial flashlight ownership and run-reset charge defaults remain part of the existing campaign setup.

### Gap 2 — distinct finales

Each final anchor still requires an uninterrupted **20-second hold**, under the existing reusable **32-second bell ward**.

| Ending | Presentation | Els's exact line | Exact card |
| --- | --- | --- | --- |
| Severance | Anchor fragments collapse; Hound and ward lines fade; empty-space hold | No next keeper. | The captive and the bond are destroyed. |
| Custodian's Rest | Els channels inside a settling ward | Then the door stays with me. | Els Vantree becomes the living ward. |
| Vessel | Lines contract into an existing key; Els lifts it | Small enough to carry. Heavy enough to pass on. | The prison waits in another key. |

LN-A and the guide explicitly describe destroying the entity and bond. The result controls and existing final closing text follow each sequence.

### Gap 3 — second Loop

Loop reset retains remaining lockpicks with a minimum of two. The counter, normal key/letter/supply resets and flashlight ownership behave as documented. The second wake opens approved **Memory Fragment A**; a keyboard/mouse-accessible bag button rereads it. Two complete piano → vanity → Memory → Front Door repetitions passed.

### Gap 4 — Path B

Removed the false pantry glass/bypass and upper shadow-strip visuals. Their placeholder nodes are hidden as well. Actual rugs, floor noise, light exposure and opaque cover retain their existing rules. Room descriptions, catalog entries and walkthrough claims now match.

### Gap 6 — Path A

Removed the upper side table at `(7130,392)` and its candle beyond the 7000-wide zone. The corresponding catalog entries identify them as removed. Source bounds checks also covered 178 room-local furnishing positions.

### Gap 7 — Path A

Untouched deliberately keeps all three senses dormant throughout Part II, including the Nexus. Blind contact staggers without HP loss. Vantree's Touch exception remains separate; no new lethal Untouched ability or lore was invented.

Sections J/K, affected room/catalog entries, puzzle instructions and walkthrough steps were reconciled with these choices.

## 10. Tests and visual verification

Final successful runs:

| Suite | Result |
| --- | --- |
| Full letter bodies, pagination and gate | 120 checks, 0 failures; headless and rendered |
| Three final sequences and unchanged channel duration | 21 checks, 0 failures; headless and rendered |
| Two complete Loops and memory reveal | 91 checks, 0 failures |
| Removed misleading strips | 3 checks, 0 failures |
| Untouched contact across Roots/Echoes/Nexus | 15 checks, 0 failures |
| Piano, batteries, inventory and compact HUD | 24 checks, 0 failures; rendered piano and bag also checked |
| Intro, nameplate, document flow and all image pages | 648 headless / 805 rendered checks, 0 failures |
| Native UI and responsive layout | 1,217 checks, 0 failures |
| Real keyboard/mouse menu flow, pause, retry and chapter transitions | 769 checks, 0 failures |
| Widescreen home page | 100 checks, 0 failures |
| Gameplay systems | 67 checks, 0 failures |
| Canon route through Part II and Severance | 96 checks, 0 failures |
| Alternate endings, full Loop and capture/recovery | 150 checks, 0 failures |
| Compact HUD live meters, bounds and supplied font | 94 checks, 0 failures |
| Checkpoint edge cases | 36 checks, 0 failures |
| Resource loading | 108 resources, 0 failures |
| Room dressing | 178 furnishings / 503 checks, 0 failures |
| Ward/station access | 28 stations, 0 failures |
| Separate-process settings write/read and invalid-config fallback | 1 / 7 / 6 checks, 0 failures |

Image pages were exercised at 1280×720, 1366×768, 1600×900 and 1920×1080, plus actual fullscreen on the available Windows display. Existing smaller and ultrawide layout suites also passed. Old tests expecting instant letter dismissal, arbitrary gate-letter IDs or a standing piano pose were updated to the requested behavior, then rerun successfully.

Inspected rendered captures: [parchment reader](../build/scroll_reader.png), [piano bench](../build/piano_seated.png), [battery inventory](../build/battery_bag.png), and [Severance](../build/ending_severance.png), [Custodian's Rest](../build/ending_custodian_rest.png), [Vessel](../build/ending_vessel.png). Logs and screenshots remain ignored local artifacts in `build/`.

## 11. Limits

The piano uses an articulated version of existing art and synthesized sound; no new hand-drawn seated atlas or recorded piano performance is claimed. Finales are short in-engine sequences using existing assets. Other operating systems and multi-monitor switching were not tested.

Godot emitted environment certificate-store/shader-cache diagnostics in some runs. Occasional test-shutdown resource warnings did not reproduce in the verbose HUD teardown run. The intentionally malformed settings fixture emits an expected parse diagnostic. These are distinguished from functional test failures above.
