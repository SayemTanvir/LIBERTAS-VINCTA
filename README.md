# LIBERTAS VINCTA

<div align="center">
  <img src="https://img.shields.io/badge/Godot-4.7-478cbf?style=for-the-badge&logo=godot-engine&logoColor=white" alt="Godot 4.7" />
  <img src="https://img.shields.io/badge/Genre-Survival%20Horror-8b0000?style=for-the-badge" alt="Survival Horror" />
  <img src="https://img.shields.io/badge/Format-2D%20Exploration-1f2937?style=for-the-badge" alt="2D Exploration" />
</div>

A tense branching 2D survival-horror exploration game built in Godot 4.7. Every route, ending, enemy escalation, and inventory rule is tracked in the live code and save-state flow, making the estate feel deliberate, dangerous, and replayable.

## Play now

<div align="center">
  <a href="https://github.com/<your-username>/<your-repo>/releases">
    <img src="https://img.shields.io/badge/Windows-Playable%20Build-2ea043?style=for-the-badge&logo=windows&logoColor=white" alt="Download Windows build" />
  </a>
</div>

The latest playable Windows executable is available from the GitHub Releases page. Download the build, launch the executable, and enter the estate immediately.

## The Estate Awakens

This project follows a three-part loop:

1. Part I: Hollowmere Estate, keys, letters, and the route decision.
2. Part II: Cathedral Roots, Echoes, and the descent gate.
3. Ley Nexus: a wide arena with Destroy, Flee, and Remain outcomes.

The game is not a freeform sandbox. The route logic, monster escalation, inventory rules, and endings are explicitly tracked in the save state and scripted interactions.

### Core objective

- Escape or resolve the estate without losing control of the run.
- Reach the Ley Nexus and complete Destroy, or finish Flee as an escape ending.
- Taking all three keys triggers the Loop and is not a victory route.

---

## Gameplay highlights

<div align="center">
  <table>
    <tr>
      <td><img src="snapshots/Screenshot%202026-09-17%20231123.png" width="320" alt="Gameplay screenshot 1" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20231149.png" width="320" alt="Gameplay screenshot 2" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20231232.png" width="320" alt="Gameplay screenshot 3" /></td>
    </tr>
  </table>
</div>

## Quick summary

- Goal: survive the estate, reach the Nexus, and complete the correct ending path.
- Core loop: explore, collect letters, restore senses, choose a route, reach the Ley Nexus.
- Winning condition: finish Destroy or escape through Flee.
- Reset condition: take all three keys and trigger the Loop, or choose Remain in the Nexus.
- Monster escalation: hearing first, then sight, then memory; Vantree adds touch pressure and blood magic.
- Verification suites cover the current route, progression, Nexus, and ending systems.

---

## Controls

| Action | Input |
| --- | --- |
| Move | W A S D / Arrows |
| Sprint | Shift |
| Crouch | Ctrl |
| Interact / use / leave hiding | E |
| Flashlight | F |
| Hold breath | B |
| Gadget / distraction | Q |
| Sigil / blood magic | R |
| Stun rite | T |
| Blood Trap | Y |
| Inventory / letters | Tab |
| Field guide | H |
| Pause / back | Esc |
| Quick turn | C |

---

## Current behavior and rules

### Part I route logic

The game recognizes four basic Part I end states:

- Untouched: 0 keys, zero detections, then use the front door.
- Vantree: 1 key plus 4 estate letters, then ritual conduit.
- Partial Mercy: 2 keys, then flood tunnel route.
- Loop: all 3 keys, which intentionally fails and resets the run.

The key order is fixed in code:

- Hearing
- Sight
- Memory

The player does not win by taking every key. Taking all three keys is the loop state, not a success route.

### Part II branch logic

Part II is seeded from the Part I ending:

- Vantree: touch mutation + blood magic + lower HP cap.
- Partial Mercy: hybrid sigil route.
- Untouched: full gadget route with extra bottles and clocks, and no active monster senses.

The field guide and current logic are the most reliable source of branch behavior. Use H during play.

### Gadget rule

Q is the current distraction action. In the current implementation:

- If flashlight charge is below the battery threshold, Q spends a battery first.
- Otherwise, The Power is selected during the Nexus Destroy sequence.
- If The Power is unavailable, it consumes a bottle if available.
- If no bottle remains, it falls back to a clock.
- Batteries do not count toward the Echoes three-use descent gate.
- Bottles and clocks do count as active distractions for the three-use route.

### Disturbance behavior

Current distraction logic is temporary and high-priority:

- A dropped bottle or clock creates a local noise source.
- The Hound will lock onto the distraction point.
- It remains there for the active five-second hold window.
- After that, the distraction is cleared and the enemy resumes normal behavior.

---

## Recommended route

This is the cleanest current route if you want the canonical Vantree branch and a full run.

### 1. Intro and estate start

- Start a new game.
- Pick up the flashlight and tool pouch.
- Use the front door once to register the attempt and continue into the estate.
- Do not treat the first door interaction as a full escape; it is a state check.

### 2. Ground floor

- Restore Hearing.
- Collect letters as you go, but do not rush the sight seal if aiming for the Vantree route.
- Use the Piano lock sequence and collect the Hearing Key.
- Stay alert to noise and sprinting; the Hound grows more reactive after hearing returns.

### 3. Upper floor

- Collect letters and keep moving.
- For Vantree, you need four estate letters but do not take the Sight Key yet.
- The route is based on the letter threshold, not an arbitrary all-letters completion.

### 4. Basement

- Continue into the basement route.
- At the ritual conduit, the route checks the current state: one restored sense plus the letter count.
- If the game recognizes Vantree eligibility, the conduit resolves accordingly.

### 5. Part II start

Once the Part I ending is triggered:

- Vantree starts with blood magic and touch-based pressure.
- Max HP is reduced to match the branch.
- The Hound becomes stronger and more aggressive about nearby contact.

### 6. Cathedral Roots and Echoes

- Reach the roots and then the Chamber of Echoes.
- Use the branch mechanic the current code expects.
- Vantree route: use the Sigil Forge and blood sigils, then open Nexus Descent.
- Untouched route: full gadget flow is the primary mechanic.
- Partial Mercy: hybrid or partial sigil flow.

### 7. Ley Nexus

- Enter through the Nexus Descent in CE-05.
- Find LN-A, then move right to collect the Knife.
- Continue toward the middle to find and read the Guide Letter.
- Reading the Guide Letter reveals The Power at the far end of the arena.
- Return to LN-A for Destroy, or use LN-B/LN-C for Flee/Remain.

---

## Current ending set

The current Ley Nexus outcomes are:

- Destroy: collect Knife, read Guide Letter, collect The Power, use Blood Trap, and drop The Power into the bound Hound.
- Flee: hold E at LN-B for 20 uninterrupted seconds, enter the door, read the coward narration, and return to the main menu.
- Remain: hold E at LN-C for 20 uninterrupted seconds, enter the door, and reset to the Ground Floor through the Loop reset system.

---

## Project structure

Key files for understanding the current behavior:

- [project.godot](project.godot) — input map and project configuration
- [scripts/core/freedom_ledger.gd](scripts/core/freedom_ledger.gd) — route logic, ending conditions, and branch seeds
- [scripts/enemy/deprived_one.gd](scripts/enemy/deprived_one.gd) — monster AI, hearing/sight/memory logic, and distraction response
- [scripts/player/player.gd](scripts/player/player.gd) — Q gadget, sigil, lighting, and movement logic
- [scripts/systems/field_guide.gd](scripts/systems/field_guide.gd) — current in-game guidance and objective text

---

## Visual gallery

<div align="center">
  <table>
    <tr>
      <td><img src="snapshots/Screenshot%202026-09-17%20231149.png" width="320" alt="Gameplay gallery image 1" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20231246.png" width="320" alt="Gameplay gallery image 2" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20231309.png" width="320" alt="Gameplay gallery image 3" /></td>
    </tr>
    <tr>
      <td><img src="snapshots/Screenshot%202026-09-17%20231543.png" width="320" alt="Gameplay gallery image 4" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20231811.png" width="320" alt="Gameplay gallery image 5" /></td>
      <td><img src="snapshots/Screenshot%202026-09-17%20232000.png" width="320" alt="Gameplay gallery image 6" /></td>
    </tr>
  </table>
</div>

---

## Verification status

Fresh runtime verification was completed with the installed Godot executable:

- Command used: `"E:\New folder\Godot_v4.7-stable_win64_console.exe" --headless --path . res://tests/verify_game_route.tscn --quit-after 600`
- Result: the route suite reached the full intro-to-nexus flow successfully.
- Command used: `"E:\New folder\Godot_v4.7-stable_win64_console.exe" --headless --path . res://tests/verify_full_playthrough.tscn --quit-after 600`
- Result: the documented commands exercise the route and full-playthrough suites.

The project files and route logic remain the authoritative source of truth. Run the commands above after changing gameplay or ending behavior.

---

## Notes for contributors

- The project has a large number of validation scripts in the tests folder; treat them as the current route and behavior references when older docs conflict with the live code.
- The older walkthroughs are dated and should not be treated as the current source of truth.
- If there is disagreement between design docs and the game code, the live code and the structured save-state rules take precedence.

## Complete gameplay guide

The following is the current spoiler walkthrough and supersedes older notes describing the retired Ward Bell or Severance/Custodian's Rest/Vessel presentation.

### Controls

| Action | Input |
| --- | --- |
| Move | W A S D / Arrow Keys |
| Sprint | Shift |
| Crouch | Ctrl |
| Hold breath | B |
| Flashlight | F |
| Interact, collect, read, hide, solve, or use doors | E |
| Gadget | Q |
| Blood Sigil | R |
| Stun Rite | T |
| Blood Trap | Y |
| Inventory and letters | Tab |
| Field Guide | H |
| Quick turn | C |
| Pause / close | Esc |

### Start: Cold Foyer

1. Pick up the flashlight.
2. Pick up the Tool Pouch. It gives three lockpicks.
3. Test the intro door once.
4. Return after collecting the required items and press E again.
5. Enter the Ground Floor.

Power stations recharge the flashlight while Els remains still. In Part II they also restore HP. Movement or damage interrupts the session. Batteries are needed for flashlight charging.

### Interactions

- Pickup: flashlight, Tool Pouch, keys, letters, batteries, bottles, clocks, Knife, Guide Letter, and The Power.
- Puzzle: Piano Seal, Vanity Seal, and Cracked Ritual Seal.
- Hiding: tables, wardrobes, beds, toy chests, coat racks, and Nexus screens.
- Doors and vents: approach the target and press E.
- Lore: Foyer Note, Vantree nameplate fragments, and one-time story events.

The Piano Seal takes three steps and one lockpick. The Vanity Seal takes three steps and one lockpick. The Cracked Ritual Seal takes one step and no lockpick.

### Hound rules

- With no keys, the Hound wanders without Hearing, Sight, or Memory. Contact is a non-lethal stagger on this branch.
- Hearing makes noise dangerous. Two close audible pings can start an audio hunt.
- Sight makes exposure, line of sight, and flashlight use dangerous.
- Memory makes repeated hiding places and repeated routes unsafe.
- Untouched Part II keeps ordinary senses dormant and relies on gadgets.
- Vantree Part II adds Touch mutation and Blood Magic, with an 80 HP maximum.
- Partial Mercy keeps Hearing and Sight active while Memory remains dormant.

### Key and letter sequence

The fixed key order is:

1. Hearing Key: Ground Floor Music Room, after the Piano Seal.
2. Sight Key: Upper Floor Master Bedroom, after the Vanity Seal.
3. Memory Key: Basement Ritual Chamber, after the Cracked Ritual Seal.

The Hearing Key is visible from the beginning but cannot be collected before its seal is complete. After Hearing is collected, Letter I appears. After Letter I is read, the Sight Key appears. After Sight is collected, Letter II appears.
After Letter II is read, the Memory Key appears. Collected keys and letters disappear. Only the current progression key or letter is visible and collectible.

Letter I directs Els to the Upper Floor Master Bedroom and Vanity Seal. Letter II directs Els to the Basement Ritual Chamber and Cracked Ritual Seal.

### Part I endings

#### 0 keys: Untouched

Do not collect a key and do not trigger detection. Test the Ground Floor Front Door, then use it again. Choose Untouched and continue into Part II.

#### 1 key: Vantree

Collect only Hearing. Read at least four estate letters. Do not collect Sight or Memory. Use the BS-09 Ritual Conduit, then continue into Part II.

#### 2 keys: Partial Mercy

Collect Hearing, read Letter I, then collect Sight. Do not collect Memory. Use the BS-04 Flooded Cellar Maintenance Exit, then continue into Part II.

#### 3 keys: Loop

Collect Hearing, read Letter I, collect Sight, read Letter II, and collect Memory. Return to the Ground Floor Front Door. The Loop resets the Ground Floor run, clears keys, letters, ordinary inventory, and hiding history, and creates no Part II seed.

### Reaching the Ley Nexus

For the 0-key route, finish Untouched, continue into Roots, cross the Roots to the Chamber of Echoes, use the current branch mechanic successfully three times, then use the Nexus Descent in CE-05.

For the 1-key route, finish Vantree at BS-09, continue into Roots, reach the Chamber of Echoes, use the Vantree branch mechanic three times, and use the CE-05 Nexus Descent.

For the 2-key route, finish Partial Mercy at BS-04, continue into Roots, reach the Chamber of Echoes, use the Partial Mercy mechanic three times, and use the CE-05 Nexus Descent.

The 3-key route goes to the Loop instead of the Nexus. After the reset, choose the 0-key, 1-key, or 2-key route to reach Part II and the Nexus.

### Finding the Guide Letter in the Ley Nexus

The Guide Letter is not in Part I and cannot be collected before entering the Nexus. Use this exact order after CE-05's Nexus Descent:

1. Find LN-A, the Destroy rune, in the western/left side of the wide arena.
2. Move right from LN-A and collect the Knife.
3. Continue right toward the middle of the arena.
4. The Guide Letter is after the Knife and before LN-B, the Flee rune.
5. Press E on the Guide Letter and read it completely.
6. Reading it reveals The Power at the far end of the arena.
7. Collect The Power and return to LN-A.

Landmark order:

`LN-A -> Knife -> Guide Letter -> The Power -> LN-A`

### Ley Nexus endings

#### Destroy: final victory

1. Collect the Knife.
2. Read the Guide Letter.
3. Collect The Power after it appears.
4. Return to LN-A and press E once. This starts the red alarm and the Hound's hunt.
5. Bring the Hound within approximately 192 pixels.
6. Press Y for Blood Trap. It costs 40 HP and binds the Hound for 18 seconds.
7. Approach the bound Hound and press E on the trap prompt.
8. The Power is consumed, the Hound dies, and an ending door appears.
9. Enter the ending door with E.

#### Flee: completed escape

Go to LN-B and hold E for 20 uninterrupted seconds. Movement, damage, detection, or releasing E resets the hold. Enter the door that appears. The coward narration plays as a letter-style ending. After the narration is closed, the save and checkpoint are cleared and the game returns to the main menu.

#### Remain: restart

Go to LN-C and hold E for 20 uninterrupted seconds. Enter the door that appears. The Loop reset system returns Els to the Ground Floor and clears the current keys, letters, inventory, and Nexus progress.

### Nexus alarm and survival

The Hound patrols the full arena. Touching any rune for the first time starts the red alarm and gives the Hound the player's trail. Use hiding screens and rubble routes to break line of sight. Pause freezes finale timers. LN-B and LN-C require 20 uninterrupted seconds; LN-A requires the Destroy item sequence.

### Q priority

Q checks items in this order:

1. Battery when flashlight charge is below approximately 56 percent.
2. The Power during the Nexus Destroy sequence.
3. Bottle.
4. Clock.

The Power is placed only through the trapped-Hound interaction; it is not consumed as an ordinary distraction.

### Project structure

Key gameplay files:

- [project.godot](project.godot): project settings and input map.
- [scripts/core/freedom_ledger.gd](scripts/core/freedom_ledger.gd): progression, inventory, route eligibility, and branch state.
- [scripts/core/game_manager.gd](scripts/core/game_manager.gd): scene transitions, endings, Loop reset, save handling, and Flee-to-menu completion.
- [scripts/interactables/base_interactable.gd](scripts/interactables/base_interactable.gd): pickup, letter, key, puzzle, door, rune, and trap interactions.
- [scripts/enemy/deprived_one.gd](scripts/enemy/deprived_one.gd): Hound AI and senses.
- [scripts/player/player.gd](scripts/player/player.gd): movement, gadgets, Blood Sigil, Stun Rite, and Blood Trap.
- [scripts/levels/nexus_room.gd](scripts/levels/nexus_room.gd): Nexus alarm, outcomes, Power placement, and ending door.
- [scripts/systems/field_guide.gd](scripts/systems/field_guide.gd): in-game guide.
- [data/estate_layout.json](data/estate_layout.json): room and interaction layout.

### Verification

Run the focused or full suites with the installed Godot 4.7 executable:

```powershell
godot --headless --path . res://tests/verify_game_route.tscn --quit-after 600
godot --headless --path . res://tests/verify_full_playthrough.tscn --quit-after 600
godot --headless --path . res://tests/verify_nexus_finale.tscn --quit-after 600
```

The live project files and automated tests are the source of truth when older documentation conflicts with the current implementation.
