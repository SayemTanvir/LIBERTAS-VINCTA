# LIBERTAS VINCTA

**Team:** 4's Compliment

**Theme:** Degree of Freedom

**Engine:** Godot 4.7 stable

LIBERTAS VINCTA is a 2D psychological survival-horror game set in Hollowmere Estate and the Sunken Cathedral beneath it. Els Vantree restores senses to the Deprived One by taking sealed keys. Every restored sense makes it faster and more perceptive: it renews hunts from fresh sounds, outruns a straight sprint once it can see, and predicts familiar hides and exits once it remembers. Taking all three keys creates a false escape that loops the house instead of winning.

The game contains the complete Part I estate route, the Part II Cathedral Roots, Chamber of Echoes, and Ley-Nexus, six successful endings across both parts, and the three-key Loop failure state. Source-defined story triggers, sensory escalation cues, threat music, camera impact, and peripheral danger feedback carry the tension between the original reveals.

## Run

1. Import `project.godot` in Godot 4.7 stable.
2. Wait for PNG and audio imports to finish.
3. Press F5.

Every launch plays the Hollowmere cinematic, then opens the main menu. Enter/Space or the Skip button advances to the menu. New Game starts Els's awakening; Continue loads your checkpoint.

Use F5 rather than running an individual floor scene. `Main` supplies Els, the Deprived One, HUD, audio director, checkpoints, and transition presentation.

## Controls

| Action | Input |
| --- | --- |
| Move | WASD or arrow keys |
| Sprint | Shift |
| Crouch | Ctrl |
| Interact, leave hiding, channel | E |
| Flashlight | F |
| Hold breath | B |
| Use gadget | Q |
| Blood or partial sigil | R |
| Stun Rite | T |
| Pause | Esc |
| Inventory / collected-letter count | Tab |
| Contextual field guide (pauses danger) | H |

Menu navigation uses arrows, Enter/Space, mouse hover/click, and standard Godot gamepad UI actions. Open How to Play and select the visible Controls button; the Right-arrow shortcut also works. Back and Escape preserve the originating menu. Settings, pause, help, credits and outcomes share the main menu's dark Gothic style, readable native type and red selection fades. Settings include draggable audio sliders, Ambience and dialogue subtitles. Tab opens illustrated inventory cards; letters and H's field guide use a wide reading view with scrolling and a Close button. See the [whole-game UI report](docs/NATIVE_UI_REPORT.md) for changes and validation.

## Full Walkthrough

See [Rules and Steps to Solve the Game Story](<RULE AND STEPS TO SOLVE THE GAME STORY.md>) for the complete spoiler walkthrough, every ending route, all room and pickup locations, monster rules, Part II branch solutions, and the full story explanation.

The flashlight has 90 seconds of charge and drains three times faster while sprinting. **28 of 94 tables (29.8%) have power stations**, identified by the supplied teal charger sprite and cyan CHARGE markers. The other tables are ordinary furniture. Stations are spread across all seven floors; not every room has one, and no room has more than one. Els stands still while the smaller machine charges. Press E to recharge gradually over 12 seconds; move to cancel and keep the charge gained. Damage interrupts charging. In Part II these power stations also restore health, so spending blood cannot permanently block progression. Breath can be held for 6 seconds and has a 15-second cooldown. Batteries, bottles, clocks, and lockpicks are persistent checkpoint inventory.

The Hollowmere cinematic plays at launch; New Game begins Els's awakening. The flashlight holding pose appears only while F has switched the light on. Switching it off restores normal idle/walking artwork immediately.

Continue restores Els at the saved checkpoint position with her saved progress.
Unreadable or malformed checkpoints return to the menu with an explanation and
remain on disk; choosing New Game explicitly replaces the old run. Returning
home also cancels a pending Loop transition. Pressing Q without a usable gadget
explains what is missing.

Character dialogue follows its speaker; narration uses a separate cinematic strip. Puzzles keep Els at her approach point, show step progress beside the E prompt, and remember partial progress when revisiting a room. See the [gameplay polish report](docs/GAMEPLAY_POLISH_REPORT.md) for pickup, animation, and verification details.

## Part I

The room graph uses the literal IDs `GF-01` through `GF-10`, `UF-01` through `UF-07`, and `BS-01` through `BS-09`. Hearing, Sight, and Memory activate successively stronger enemy behavior.

| Keys | Exit | Result |
| --- | --- | --- |
| 0 | Front door, after testing it once, with zero detections | Untouched |
| 1 | `BS-09` Ritual Conduit with at least 4 of 7 estate letters | Vantree |
| 2 | `BS-04` Flood Tunnel | Partial Mercy |
| 3 | Front door | Loop; keys and entity reset, no Part II seed |

The second completed Loop unlocks `vantree_memory_fragment_A`. The valid Part I endings produce distinct Part II seeds. Vantree gives the monster Touch, Els Blood Magic, and an 80% HP cap. Partial Mercy preserves two monster senses and gives Els partial sigils. Untouched preserves a full gadget kit and leaves all monster senses dormant.

## Part II

Part II spans six Cathedral Roots rooms (`CR`), five Chamber of Echoes rooms (`CE`), and the single-screen Ley-Nexus (`LN-CENTER`). It includes letters VIII through XIII, flooded and rubble surfaces, four crypt hiding alcoves, the name-carving reveal, branch mechanics, and a three-use skill gate. Nexus Descent (`CE-05`) now has a hiding alcove and a replenishing distraction cache. Convergence has two hiding screens and one power station.

### Blood rites and the descent

**Press H for Els' field guide.** It explains the branch you earned, controls, effects and the current objective. The HUD shows resonance progress, ability costs and cooldowns.

| Escape route | Echoes mechanic | Price and effect |
| --- | --- | --- |
| Vantree | E at the Sigil Forge, then R twice | Forge costs 6.4 HP and counts once. Each R costs 6.4 HP, draws a 12-second circle and has a 20-second cooldown. The Hound loses its senses, including Touch, while inside the circle. |
| Partial Mercy | R three times | Each circle costs 4 HP and blocks **Hearing only** for 12 seconds; Sight remains dangerous. Cooldown: 20 seconds. |
| Untouched | Q: use three bottles/clocks in Echoes | Batteries do not count. Q uses a battery first if charge is below 50 seconds (about 56%); otherwise bottles, then clocks. CE-05's cache prevents running out of distractions from blocking the gate. |

Vantree also grants **T: Stun Rite** — 16 HP, 6-second stun, 60-second cooldown, within the circle's 192-pixel reach. It clears current detection but does not count toward the descent. Failed casts spend nothing. Circles are local effects, do not prevent contact damage, and freeze during pause. Rest at a cyan power station when health is low.

### Convergence: choose one ending

All three named anchors remain in view. Ring the **golden Ward Bell with E** to bind the Hound for **32 seconds**, then reach one anchor and **hold E for 20 seconds**. The HUD shows ward time and a ritual progress bar. Detection, damage, movement or releasing E resets the ritual; pause freezes it. If an attempt fails, the bell can be rung again after its ward fades. Only one completed anchor is needed:

- `LN-A`: Severance
- `LN-B`: Custodian's Rest
- `LN-C`: Vessel

## Architecture

- `data/estate_layout.json`: room IDs, floor regions, surfaces, props, exits, requirements, items, and anchor choices.
- `data/estate_art.json`: atlas slices, imported furniture dressing, cathedral props, scale, tint, and collision footprints.
- `scripts/core/freedom_ledger.gd`: save schema, inventory, endings, loops, Part II seeds, HP, charge, and progression.
- `scripts/enemy/deprived_one.gd`: the nine-state sensory AI.
- `scripts/interactables/base_interactable.gd`: pickups, puzzles, hiding, doors, vents, recharging, forge, exits, and anchors.

## Verification

The maintained Godot tests cover layout/art, systems, the canonical route, and complete alternate-route recovery playthroughs:

```powershell
godot --headless --path . tests/verify_furniture_facing.tscn
godot --headless --path . tests/verify_checkpoint_edges.tscn
godot --headless --path . tests/verify_live_campaign.tscn
godot --headless --path . tests/verify_image_ui.tscn
godot --headless --path . tests/verify_gameplay_polish.tscn
godot --headless --path . tests/verify_estate_assets.tscn
godot --headless --path . tests/verify_game_systems.tscn
godot --headless --path . tests/verify_game_route.tscn
godot --headless --path . tests/verify_full_playthrough.tscn
godot --path . tests/verify_finishability.tscn
```

The live campaign test completes Untouched through Custodian's Rest at normal speed, with real movement/E/Q and active AI. It uses the same Part II transition as the Descend button. The latest finishability pass includes actual movement and held-E rituals with the Hound's AI running for all three Convergence endings, plus guide, charging, pause, cancellation and retry checks. The route suites cover all four Part I outcomes, Part II progression and checkpoint recovery. See the [finishability report](docs/FINISHABILITY_REPORT.md) for current results and the distinction between live-AI finale tests and isolated route/system checks.

See the [professional playtest report](docs/PRO_PLAYTEST_REPORT.md), [asset credits](ASSET_CREDITS.md), and [AI disclosure](AI_DISCLOSURE.md).

## Survival polish (2026-09-16)

All 37 rooms now include furniture suited to their purpose: 178 additional pieces,
decorations on 46 ordinary tables and nine rugs that soften footsteps. Main routes,
doorways, hiding spots and charging stations remain accessible. See the
[room dressing report](docs/ROOM_DRESSING_REPORT.md) for placement data and checks.

The named upper-floor rooms, Reading Nook and Side Corridor use front-facing
furniture with level feet, contact shadows and physical table footprints.
The HUD separates health, flashlight percentage and inventory; charging shows
the live battery percentage.

The Hound sees farther (520 pixels in light, 260 in shadow), with a 140-degree
cone and close-range awareness. Chase steering follows collision-safe paths
without repeatedly returning to grid centers; small corrections do not flip the
running sprite. Touch updates pursuit while the player remains nearby.

Death cancels pending vent and door travel. Nonfatal hits use a short flinch;
only a fatal hit starts the death presentation. See docs/SURVIVAL_POLISH_REPORT.md.

## Dedicated action animation (2026-09-16)

Nine new Els sprite sheets provide separate torch, vent, lock, piano, cover, bag
and key animations, including torch walking/running and reversed cover exits.
The Hound now commits to a visible strike with checked contact, evasion and recovery.
See the [animation report](docs/ACTION_ANIMATION_REPORT.md) for previews, asset
provenance and gameplay validation.

## Orientation and QA follow-up (2026-09-16)

All 37 room sections now have explicit facing zones. Furniture uses its full
footprint to choose an inward direction, recalculated when placed, moved by code,
or rebuilt from a checkpoint. Corners prefer the clearer inward approach;
freestanding pieces retain their authored facing. Rugs, lights, wall art and
non-facing decoration are excluded. Room dimensions and collision are unchanged.

**The visual furniture fix still needs directional artwork.** There are 77
placements requiring missing views, principally rear-facing seating. Their
original sprites remain visible rather than being distorted. The
[implementation report](docs/FURNITURE_FACING_REPORT.md) lists missing assets,
behavior and test coverage. The game has no player furniture-dragging feature.

The seated piano replacement is also pending: both generated drafts failed the
required transparency and frame-grid checks. The existing three-step piano seal
and its current animation remain active. See the
[Stage 1 asset status](assets/sprites/player/actions/piano_seated/README.md).

### Changelog

- Fixed Continue restoring the entrance instead of the saved position.
- Added checkpoint validation, preserved corrupt saves and enforced resource bounds.
- Cancelled stale Loop callbacks when leaving the run.
- Added empty-gadget feedback and enemy target reacquisition.
- Kept the Hound's six-second hearing memory frozen during pause.
- Added furniture-facing metadata and explicit missing-view diagnostics.
- Corrected cinematic instructions and added the Ward Bell to short ending checklists.

See the [QA bug log and verification limits](docs/QA_2026_09_16.md).
