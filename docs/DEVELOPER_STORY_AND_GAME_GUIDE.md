# LIBERTAS VINCTA
## Developer Story, Gameplay, Route, and Project Guide

**Status:** spoiler-complete developer reference
**Updated:** 2026-09-17
**Engine:** Godot 4.7 / 4.7.2 on Windows

This document explains the current game as implemented: narrative canon, player survival, progression, routes, endings, scene flow, architecture, tests, and maintenance rules. It is intentionally spoiler-heavy.

## 1. Source of Truth

Use sources in this order when information disagrees:

1. Runtime code and data in `scripts/`, `scenes/`, and `data/`.
2. `docs/STORY_CANON.md` for narrative facts.
3. `RULE AND STEPS TO SOLVE THE GAME STORY.md` for playable route rules.
4. `docs/CURRENT_GAME_FLOW_AND_LOGIC.txt` for system values and room flow.
5. Reports in `docs/` for implementation history and verification records.
6. Older design notes, which may describe superseded behavior.

Do not turn an interpretation into canon. The project deliberately does not resolve Els's ancestry, the Deprived One's original identity, the ritual's first origin, or all six missing hours.

## 2. Game Identity

**LIBERTAS VINCTA** is a 2D survival-horror exploration game about freedom being transferred rather than destroyed.

The player controls **Els Vantree**, an adult locksmith hired for a private appraisal at Hollowmere Estate. She wakes at 2:47 AM with no memory of entering the estate or the previous six hours. She remembers an unusually generous offer, signing a contract, and failing to read its addendum.

The estate sits above Cathedral Roots, the Chamber of Echoes, and a Ley-Nexus. Three seals contain senses taken from the imprisoned **Deprived One**, represented in gameplay by the Hound/zombie enemy:

- Hearing
- Sight
- Memory

Opening a seal returns that sense to the entity and removes a corresponding safety from Els. The player is not simply collecting upgrades. Each key changes the threat model and contributes to the Part I route decision.

Core theme:

> Freedom is never destroyed.
> It only changes hands.

## 3. Basic Story

Els wakes collapsed in the Cold Foyer. Her flashlight is nearby but out of reach. The opening establishes four facts:

- She is Els Vantree.
- She came to Hollowmere for an appraisal.
- The offer was suspiciously generous.
- She signed without reading the addendum and lost approximately six hours.

She retrieves the flashlight and tool pouch, tests the locked Grand Foyer door, and enters the estate. The first objective appears practical: explore, recover information, and find a way out.

The estate contains three sealed senses. The deeper Els goes, the more the Hound can hear, see, remember, and eventually track through Touch on the Vantree branch. Letters and environmental clues reveal that the estate has repeatedly transferred the burden of containment between people called Custodians or Jailers.

Part I ends when Els chooses an exit state. That state seeds Part II:

- Refusing all keys creates the Untouched branch.
- Restoring Hearing and meeting the letter threshold creates Vantree, the canon branch.
- Restoring Hearing and Sight creates Partial Mercy.
- Restoring all three senses creates the Loop, a false escape rather than a victory.

In Part II, Els reaches Cathedral Roots, the Chamber of Echoes, and finally the Ley-Nexus. She uses the branch-specific mechanic three times to open the Nexus descent, rings the Ward Bell, binds the Hound temporarily, and channels one of three final anchors.

## 4. Elaborate Story and Lore

### Hollowmere and the prison

Hollowmere is a domestic estate built over older containment architecture. The upper house presents respectable rooms, service passages, private bedrooms, a piano, a vanity, and letters. The basement exposes ritual stone, roots, flooded masonry, and the original ward logic. Cathedral Roots and the Chamber of Echoes show that the house is only the visible layer of a larger system.

The Deprived One was deprived of Hearing, Sight, and Memory and held through separate seals. The game establishes confinement and recurring custodial transfers, but not the entity's original crime, species, creator, or first name.

### Els and the Vantree mystery

Els knows her name and profession but not why the estate contains evidence connected to her. The optional GF-05 nameplate assembles the surname **VANTREE**. CR-04 later reveals the full name in an impossible carving dated centuries before Els's birth.

This implies an inherited or repeating custodial role, but the implementation does not declare whether Els is a descendant, reincarnation, fabricated identity, or another kind of successor. Do not add a family tree or claim that a particular letter was written by an ancestor.

The recurring letter clue is:

> Forgive me, if you're reading this.
> It has to be someone.

This is evidence of a prior custodian's rationalization, not an answer to the mystery.

### Reveal ladder

1. Contract, addendum, appraisal, and missing six hours.
2. Foyer evidence about stolen senses.
3. Hearing restoration demonstrates that the Hound benefits from the key.
4. Letters change the title Custodian into the more troubling Jailer.
5. Later letters explain remembered hiding places, older stone, and the danger of completion.
6. CR-04 reveals Els's name and impossible date.
7. Vantree Part II gives the Hound its first spoken line: `Els. You have brought your name home.`
8. The Nexus forces Els to decide who carries, destroys, or becomes the prison.

## 5. Player Controls

| Action | Input | Purpose |
| --- | --- | --- |
| Move | W/A/S/D or arrows | Move through the room |
| Sprint | Shift | Fast movement; louder and drains flashlight faster |
| Crouch | Ctrl | Slower, quieter movement and reduced Sight range |
| Interact | E | Use objects, doors, hiding spots, bell, and anchors |
| Flashlight | F | Toggle the flashlight when owned |
| Hold breath | B | Suppress movement breathing for up to 6 seconds |
| Gadget | Q | Recharge from a battery at low charge, otherwise use bottle/clock |
| Sigil / ability | R | Use Blood Sigil or Partial Sigil when unlocked |
| Stun rite | T | Stun the Hound on the Blood Magic branch |
| Inventory | Tab | View items and letters |
| Field guide | H | Open the contextual guide and pause danger |
| Pause/back | Esc | Pause or leave the current UI |
| Quick turn | C | Reverse facing |

The controls are also implemented in `scenes/ui/controls_page.gd` and `project.godot`. Preserve both keyboard/controller navigation and the input guard that prevents a closing UI keypress from activating a nearby object.

## 6. Player Survival Systems

### Movement

- Walk speed: **141 px/s**
- Sprint speed: **256 px/s**
- Crouch speed: **70 px/s**
- Vertical movement uses a depth ratio of **0.55**.
- Acceleration is **1100**.
- Movement is collision-aware and uses `move_and_slide()`.
- Interactions use target-facing logic and authored approach offsets.

Sprint is faster than the Hound's normal patrol but not necessarily faster than a confirmed Stage 2 chase in a straight line. Use route planning, cover, and sound control rather than relying on speed alone.

### Noise

Noise is gameplay data, separate from audio volume. `NoiseModel` and `EventBus.noise_created` deliver events to the enemy.

Typical floor hearing radii:

- Carpet: 64 px
- Wood: 256 px
- Stone: 320 px
- Water: 448 px
- Glass/creak: 576 px

Crouching greatly reduces emitted noise. Sprinting is the loudest normal movement. Holding breath prevents movement-breathing pressure while active.

### Breath

- Capacity: **6 seconds**
- Cooldown after release/exhaustion: **15 seconds**
- Peripheral strain begins after approximately four seconds.

### Flashlight

- Base charge: **90 seconds**.
- Sprint drain is approximately triple the normal drain.
- Stationary charging takes **12 seconds** and movement or damage cancels the charge while retaining progress.
- Batteries provide charge and do not count as Echoes route mechanic uses.
- The flashlight exposes Els to Sight and should be managed rather than left on permanently.

### Hiding

Hiding spots are real interactables, not universal immunity. Entering a wall/table/bed shelter changes the player pose and collision state. Leaving restores the original approach position and collision.

The Hound can remember used hiding places after Memory is restored. Repeating one shelter becomes dangerous. A witnessed hide can also remain relevant to the Hound's investigation logic.

### Health and damage

Part I capture is generally lethal and routes through the death/checkpoint recovery system. Part II uses HP:

- Untouched: blind-stage contact is deliberately nonlethal, including the Nexus.
- Vantree: maximum HP is reduced to **80%** and Touch/contact pressure is active.
- Partial Mercy: normal **100%** HP and partial sigil route.

The player has a hurt cooldown and existing lethal/nonlethal behavior. Do not bypass `FreedomLedger.damage()`, `player.take_hit()`, or the death flow when adding damage sources.

## 7. Hound / Deprived One Behavior

The active enemy scene is `scenes/enemy/deprived_one.tscn`; its runtime behavior is `scripts/enemy/deprived_one.gd`.

The enemy is a `CharacterBody2D` with a grounded collision footprint. It uses the directional zombie resource and foot-offset map:

- `scenes/enemy/new_zombie_frames.tres`
- `scripts/enemy/zombie_foot_offsets.gd`
- `shaders/zombie_chroma_guard.gdshader`
- `assets/sprites/new_zombie/`

Animations include idle, walk, run, attack, sniff, and stagger in eight directional views. Preserve the transparent sprite sheets and authored timing.

### AI states

The finite-state machine contains:

- `WANDER_BLIND`
- `PATROL_AUDIO`
- `INVESTIGATE`
- `HUNT_AUDIO`
- `PATROL_SIGHT`
- `CHASE`
- `INVESTIGATE_LAST_SEEN`
- `PREDICT_HUNT`
- `AMBUSH`

### Escalation stages

| Stage | Trigger | Hound behavior | Player response |
| --- | --- | --- | --- |
| 0 | No restored senses | Wanders 8-15 seconds; blind contact staggers but cannot catch Els | Learn the map and avoid careless positioning |
| 1 | Hearing restored | Patrols at about 142 px/s; two pings within 6 seconds or glass can start a 216 px/s, 10-second audio hunt | Crouch, choose surfaces, use distractions |
| 2 | Sight restored | Confirms vision, tracks exposure/light/line of sight, chases at about 282 px/s | Break sight, turn off light, use real cover |
| 3 | Memory restored | Remembers up to five locations, predicts routes, checks hiding priorities, ambushes exits | Change shelters and routes |
| Vantree Touch | Part II Vantree seed | Tracks floor transmission even while Els is crouched or still | Use distance, rubble, sigils, and timed stun |

The current merged close attack rules are important:

- Trigger radius is approximately **44 px**.
- The attack commits at about **25% of the active attack animation**.
- The player cannot bypass the committed hit by running directly through the Hound at the last moment.
- The strike remains close range and rechecks reach, line of sight, and hiding rules at impact.
- Walls remain active obstruction checks.
- Stun cancels a pending strike.
- Each attack applies damage once, then enters recovery.

Do not reintroduce old blood-hound callbacks such as `_sync_frame_mask`; the current zombie scene uses `_sync_zombie_footing()`.

## 8. Part I Map and Progression

Part I is divided into three floors and 20 named regions.

### Ground Floor

`GF-01 Grand Foyer`, `GF-02 Dining Hall`, `GF-03 Music Room`, `GF-04 Servant's Pantry`, `GF-05 Side Corridor`, `GF-06 Reading Nook`, `GF-07 Coat Room`, `GF-08 Trophy Hall`, `GF-09 Upper Stairwell`, `GF-10 Cellar Stairs`.

### Upper Floor

`UF-01 Portrait Gallery`, `UF-02 Master Bedroom`, `UF-03 Nursery`, `UF-04 Linen Hall`, `UF-05 Bathroom`, `UF-06 Stairwell Down`, `UF-07 Vent Junction A`.

### Basement

`BS-01 Cellar Stairs`, `BS-02 Wine Cellar`, `BS-03 Ossuary Nook`, `BS-04 Flooded Cellar`, `BS-05 Ritual Chamber`, `BS-06 Root Cellar`, `BS-09 Ritual Conduit`.

The key order is fixed:

1. Hearing: locked piano seal in GF-03; consumes one lockpick.
2. Sight: locked vanity seal in UF-02; consumes one lockpick.
3. Memory: cracked ritual seal in BS-05; consumes no lockpick.

The piano and vanity are three-step progression puzzles. The cracked ritual seal is a one-step interaction. Completed puzzles remain visible but cannot be solved repeatedly.

The vent graph connects GF-08, UF-04, UF-07, and BS-02. Doors and vents are actual scene transitions; open room boundaries are not automatically walls.

## 9. Part I Routes

There are **four Part I outcomes**, but only three are successful chapter routes.

| Outcome | Required state | Exit | Result |
| --- | --- | --- | --- |
| Untouched | 0 keys and 0 detections; test the door first, then use it again | Front Door in GF-01 | Successful Part I; seeds full gadget branch |
| Vantree | Hearing only plus at least 4 of 7 estate letters | Ritual Conduit in BS-09 | Successful Part I; canon route, seeds Touch/Blood Magic |
| Partial Mercy | Hearing and Sight; Memory not restored | Flood Tunnel in BS-04 | Successful Part I; seeds hybrid/partial sigil branch |
| Loop | All 3 keys | Front Door in GF-01 | False escape; resets Part I instead of entering Part II |

The player does not win by collecting all keys. A second completed Loop unlocks `vantree_memory_fragment_A`.

### Untouched route

- Do not restore any key.
- Avoid all detection events.
- Test the front door once, then use it again.
- Part II keeps the ordinary senses dormant and supplies the full gadget branch.

### Vantree route

- Restore Hearing at the piano.
- Collect at least four estate letters.
- Do not restore Sight or Memory.
- Reach BS-09 and complete the Ritual Conduit route.
- This is the canon route and the fullest supported story reveal.

### Partial Mercy route

- Restore Hearing and Sight.
- Do not restore Memory.
- Reach BS-04 and use the Flood Tunnel route.
- Part II retains Hearing and Sight and supplies hybrid/partial sigil behavior.

### Loop route

- Restore Hearing, Sight, and Memory.
- Use the Front Door.
- Els returns to GF-01, ordinary progression resets, and no Part II seed is created.
- The second completed Loop unlocks Memory Fragment A.

## 10. Part II Branches

Part II contains:

- Cathedral Roots: CR-01 through CR-06
- Chamber of Echoes: CE-01 through CE-05
- Ley-Nexus Convergence: LN-CENTER with LN-A, LN-B, LN-C

### Untouched branch

All three ordinary senses remain dormant. The first live Roots threat begins at CR-03. Q is the main route mechanic.

The branch supplies a full kit of batteries, bottles, and clocks. Three successful gadget uses open CE-05. Bottles and clocks count as mechanic uses; batteries do not.

### Vantree branch

Touch mutation and Blood Magic are active. Maximum HP is 80% of normal. Touch transmission depends on floor material:

- Bare stone: approximately 480 px
- Rubble: approximately 160 px
- Elevated Choir lane: approximately 96 px

Crouching and standing still do not suppress Touch. The player can use Blood Sigil and Stun Rite after unlocking the branch ability at the Sigil Forge.

### Partial Mercy branch

Hearing and Sight remain active, Memory remains dormant, and Els receives a four-percent partial sigil. The partial sigil suppresses Hearing in its area but does not grant full Blood Magic protection.

## 11. Part II Abilities and Gates

### Gadget Q

Current implementation order:

1. If flashlight charge is below the low-charge threshold, Q attempts to recharge from a battery.
2. Otherwise Q consumes a bottle if one is available.
3. If no bottle remains, Q uses a clock.
4. If no usable resource exists, the player receives feedback and spends nothing.

Bottles and clocks create remote noise/distraction. The Hound tracks the active distraction for approximately five seconds, then resumes normal behavior. A newer distraction replaces a stale target.

### Blood / partial sigil R

- Requires the appropriate branch and unlock state.
- Full Blood Sigil costs **8% of max HP**.
- Partial Sigil costs **4% of max HP**.
- Cooldown: **20 seconds**.
- Blood circles suppress senses in their area for approximately **12 seconds**.
- Low-health, out-of-range, unavailable, and cooldown failures spend nothing.

### Stun Rite T

- Blood Magic branch only.
- Range: approximately **192 px**.
- Duration: **6 seconds**.
- Cost: **20% HP**.
- Cooldown: **60 seconds**.
- Range is checked before spending health or starting cooldown.
- Stun clears current detection and prevents hearing responses while active.

### Nexus gate

CE-05 opens after three successful uses of the active branch mechanic. The final Nexus has no retreat passage. The Ward Bell binds the Hound for approximately **32 seconds**. Each anchor requires an uninterrupted **20-second hold**.

Detection, damage, release, movement, or interruption resets an anchor channel. Pause freezes the relevant timers.

## 12. Final Endings

The three final endings are separate from the three Part I chapter outcomes.

| Anchor | Ending | Meaning |
| --- | --- | --- |
| LN-A | Severance | Destroy the Deprived One and the inherited bond |
| LN-B | Custodian's Rest | Els becomes the living ward |
| LN-C | Vessel | Bind the entity into a new key for another hand |

Canonical tested branch-to-ending combinations include:

- Vantree -> Severance
- Partial Mercy -> Vessel
- Untouched -> Custodian's Rest

The engine supports all three endings from the final Convergence. Only one anchor must complete.

## 13. Save, Checkpoint, and Recovery Flow

`GameManager` owns zone transitions, save paths, state, entry modes, arrivals, checkpoint recovery, and loop transitions. `FreedomLedger` owns progression and snapshot data.

Continue restores the serialized zone, position, keys, letters, entity stage, ending, loop count, Part II seed, inventory, hiding history, detections, flashlight charge, HP, mechanic uses, and completed Nexus anchor. Invalid saves are rejected without corrupting the original bytes.

Checkpoints are created by room transitions and sense pickups. Capture/death restores the exact checkpoint, including position and resources. Recovery plays the reverse collapse animation, starts with doors closed, avoids replaying an arrival, returns to `PLAYING`, and restores player control.

New Game clears prior progression. The current save path is normally user data; tests use isolated files under `build/`.

## 14. Runtime Architecture

### Autoloads

Configured in `project.godot`:

- `EventBus`: cross-system signals for noise, audio, tension, detection, capture, abilities, and UI events.
- `FreedomLedger`: keys, letters, HP, flashlight, inventory, route state, loop count, branch seed, and snapshots.
- `GameManager`: application/game state, zones, saves, checkpoints, transitions, and UI flow.
- `NoiseModel`: surface-based movement noise.
- `SessionSettings`: persistent display/audio/settings preferences.
- `CollectibleManager`: sequential letter discovery state.

### Main scene flow

`scenes/intro/startup.tscn` is the application entry. It plays the 22.4-second exterior cinematic, then opens the front end/main menu.

New Game enters the awakening sequence and then `scenes/main/main.tscn`. Main chooses a floor scene based on `GameManager.zone`, creates the room, places the player, restores or creates a checkpoint, and spawns `scenes/enemy/deprived_one.tscn` outside the immediate player approach.

Primary runtime floor scenes:

- `intro_floor.tscn`
- `ground_floor.tscn`
- `upper_floor.tscn`
- `basement_floor.tscn`
- `roots_floor.tscn`
- `echoes_floor.tscn`
- `nexus_floor.tscn`

### Room and data responsibilities

- `data/estate_layout.json`: named rooms, progression props, passages, interactions, story IDs, and coordinates.
- `data/estate_art.json`: textures, surfaces, furniture, footprints, decorations, and visual catalog data.
- `data/room_dressing.json`: supplemental room furnishings and decorations.
- `scripts/levels/estate_room.gd`: room physics, navigation, surfaces, spawning, and progression environment.
- `scripts/levels/estate_art.gd`: runtime environment dressing.
- `scripts/interactables/base_interactable.gd`: interaction contracts, action poses, locks, hiding, passages, puzzles, and pickups.
- `scripts/player/player.gd`: movement, light, breath, gadgets, sigils, stun, hiding, damage, and action dispatch.
- `scripts/enemy/deprived_one.gd`: Hound state machine, sensing, navigation, collision, attack, and presentation.
- `scripts/ui/game_hud.gd` and `scripts/ui/survival_panel.gd`: objectives, narration, health, flashlight, inventory, prompts, and finale progress.

### Audio and presentation

`audio_director.gd` maps `EventBus.audio_requested` cues to organized assets and uses the existing Master, Music, Ambience, and SFX buses. Gameplay sensing must not depend on the audible volume setting.

Themes, menus, reading views, field guide, inventory, settings, pause, credits, and endings use the native dark-estate UI refresh. Preserve keyboard focus, controller actions, stable hitboxes, and pause behavior when editing UI.

## 15. Developer Setup and Common Commands

Open the repository root in Godot 4.7 or 4.7.2. The project declares GL Compatibility and a 1280x720 logical viewport.

Run the game:

```powershell
godot --path .
```

Run the main automated suites:

```powershell
godot --headless --path . res://tests/verify_estate_assets.tscn
godot --headless --path . res://tests/verify_game_systems.tscn
godot --headless --path . res://tests/verify_game_route.tscn
godot --headless --path . res://tests/verify_full_playthrough.tscn
godot --headless --path . res://tests/verify_finishability.tscn
godot --headless --path . res://tests/verify_live_campaign.tscn
```

Run focused verification when changing a subsystem:

```powershell
godot --headless --path . res://tests/verify_enemy_presentation.tscn
godot --headless --path . res://tests/verify_action_animation.tscn
godot --headless --path . res://tests/verify_distraction_tracking.tscn
godot --headless --path . res://tests/verify_checkpoint_edges.tscn
godot --headless --path . res://tests/verify_cinematic_intro.tscn
godot --headless --path . res://tests/verify_native_ui.tscn
```

Capture rendered sweeps with the Compatibility renderer:

```powershell
godot --rendering-method gl_compatibility --path . res://tests/capture_asset_sweep.tscn
godot --rendering-method gl_compatibility --path . res://tests/capture_animation_sweep.tscn
```

The repository reports historical Godot 4.7.2 validation totals in `docs/QA.md`, `docs/QA_2026_09_16.md`, and related reports. Re-run locally before claiming a new result.

## 16. Asset and Content Rules

- Preserve supplied source artwork; do not regenerate, upscale, reconvert, or replace it unnecessarily.
- Keep texture aspect ratios and authored atlas regions.
- Collision and navigation are authored independently of texture size.
- Keep player/enemy scene node names and interaction IDs stable.
- Use real directional artwork for furniture; do not fake rear views by rotating or mirroring unsuitable upright sprites.
- Keep `data/estate_layout.json` IDs stable because saves and tests depend on them.
- Keep generated resources reproducible through their existing tools. For zombie resources, use `scripts/tools/build_new_zombie_frames.py` only when source sheets intentionally change.
- Do not add unsupported lore, survival items, weapons, salt, exorcisms, or new route requirements.
- Keep story text and player-facing spoiler boundaries separate from internal developer documentation.

## 17. Test Coverage and Current Risks

Historical project QA records report successful coverage for:

- Estate layout, art bounds, navigation, props, stations, and room dressing.
- Player movement, crouch, hiding, flashlight, breath, pickups, actions, and recovery.
- Hearing, Sight, Memory, Touch, sigils, stun, distractions, and Hound presentation.
- Canonical Vantree route, Untouched, Partial Mercy, Loop, and all three final endings.
- Checkpoint restore, malformed save handling, intro/menu flow, native UI, and finale interruption.

Known release risks remain:

- Rendered Windows capture can intermittently exit with native `0xC0000005` during shutdown after successful checks.
- Windows and Web export templates are not bundled and must match the installed Godot version.
- Asset license and attribution details still need final public-release confirmation for supplied zombie sprites, piano art, and footstep recordings.
- Physical controller comfort, subjective audio mix, and exported builds require a release pass.
- Missing true directional variants remain for some furniture; the resolver preserves existing art when a correct view is unavailable.
- Piano Stage 1 replacement artwork remains blocked by invalid drafts; the existing three-step piano seal gameplay is still authoritative.
- Multiple simultaneous enemies are not an authored game mode.

## 18. Important Superseded Notes

Some older reports describe the pre-merge Blood Hound implementation. For the current enemy, use the directional zombie resource, `ZombieFootOffsets`, grounded offsets, 44 px attack radius, 25% attack commitment, and `zombie_chroma_guard.gdshader`.

Some earlier UI reports describe image-based menus. The current native UI reports and the current `main_menu.gd` are newer. The launch cinematic is the application startup sequence; New Game begins Awakening directly.

`docs/FURNITURE_AND_PIANO_AUDIT.md` contains proposals and rejected/blocked work. Treat its proposal sections as non-shipped unless the current data, scene, script, and tests confirm otherwise.

## 19. Practical Developer Checklist

Before changing story or progression:

- Check `docs/STORY_CANON.md`.
- Check `FreedomLedger` route fields and the relevant interactable IDs.
- Update route tests and the spoiler walkthrough.
- Verify Loop and checkpoint behavior.

Before changing player survival:

- Preserve collision layers and masks.
- Preserve hiding entry/exit collision restoration.
- Preserve `take_hit`, hurt cooldown, death, and checkpoint recovery.
- Test flashlight, breath, noise, gadgets, abilities, and anchors.

Before changing the Hound:

- Preserve target reacquisition and obstruction checks.
- Preserve state-stage gating and hiding rules.
- Preserve directional animation names and foot offsets.
- Test the close attack at 44 px, early commit at 25%, wall obstruction, stun cancellation, and direct run-through behavior.

Before changing assets or room art:

- Keep authored IDs, collision footprints, navigation blockers, and interaction points.
- Run estate asset and room dressing tests.
- Render the affected room or animation sweep.
- Check licenses and attribution before distribution.

Before release:

- Run all headless route/system/finishability suites.
- Run a Compatibility rendered smoke test.
- Build Windows and Web exports with matching templates.
- Perform human controller, accessibility, audio, balance, and save/restart checks.
- Reconcile `README.md`, `RULE AND STEPS TO SOLVE THE GAME STORY.md`, and this document if behavior changes.

## 20. Key References

- [README](../README.md)
- [Story canon](STORY_CANON.md)
- [Current route guide](../RULE%20AND%20STEPS%20TO%20SOLVE%20THE%20GAME%20STORY.md)
- [Current flow and logic](CURRENT_GAME_FLOW_AND_LOGIC.txt)
- [Final content bible](FINAL_HORROR_GAME_CONTENT.md)
- [Finishability report](FINISHABILITY_REPORT.md)
- [Quality assurance](QA.md)
- [Implementation gaps and shipped fixes](IMPLEMENTATION_GAPS_REPORT.md)
- [Environment assets](ENVIRONMENT_ASSETS.md)
- [Known issues](../KNOWN_ISSUES.md)
