# LIBERTAS VINCTA

A 2D survival-horror exploration game built in Godot 4.7. The current codebase is the source of truth for the game flow, route logic, and branch behavior.

This project is currently structured around a clear three-part loop:

1. Part I: Hollowmere Estate, keys, letters, and the ending route decision.
2. Part II: Cathedral Roots, Echoes, and the descent gate.
3. Nexus: one anchor choice and the final ending.

The game is not a freeform sandbox. The route logic, monster escalation, inventory rules, and endings are explicitly tracked in the save state and scripted interactions.

## Quick summary

- Goal: escape or resolve the estate without losing control of the run.
- Core loop: explore, collect letters, restore senses, choose a route, reach the final anchor.
- Winning condition: complete the correct exit/anchor route for the branch you are on.
- Losing condition: take all three keys and trigger the loop ending instead of a real escape.
- Current monster escalation: hearing first, then sight, then memory; Vantree adds touch-based pressure and blood magic.

## Current controls

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
| Inventory / letters | Tab |
| Field guide | H |
| Pause / back | Esc |

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

- Vantree: Touch mutation + blood magic + lower HP cap.
- Partial Mercy: hybrid sigil route.
- Untouched: full gadget route with extra bottles/clocks and no active monster senses.

The field guide and current logic are the most reliable source of branch behavior. Use H during play.

### Gadget rule

Q is the current distraction action. In the current implementation:

- If flashlight charge is below the battery threshold, Q spends a battery first.
- Otherwise, it consumes a bottle if available.
- If no bottle remains, it falls back to a clock.
- Batteries do not count toward the Echoes three-use descent gate.
- Bottles and clocks do count as active distractions for the "three uses" route.

This is an important difference from older notes and should be treated as the real rule.

### Disturbance behavior

Current distraction logic is temporary and high-priority:

- a dropped bottle or clock creates a local noise source
- the Hound will lock onto the distraction point
- it stays there for the active 5-second hold window
- after that, the distraction is cleared and the enemy resumes normal behavior

This keeps a decoy from lingering as a stale target after its useful window ends.

## Recommended current route

This is the cleanest current route if you want the canonical Vantree branch and a full run.

### 1. Intro and estate start

- Start New Game.
- Get the flashlight and tool pouch.
- Use the front door once to register the attempt and continue into the estate.
- Do not treat the very first door interaction as a full escape. The route logic records it and uses it as a state check.

### 2. Ground floor

- Find and restore Hearing.
- Pick up letters as you go, but do not rush for the sight seal if you are aiming for the Vantree route.
- Use the piano lock sequence and collect the Hearing key.
- Keep a close eye on noise and sprinting. The Hound becomes more reactive once hearing is back.

### 3. Upper floor

- Collect letters and keep moving.
- If you are aiming for Vantree, you need four estate letters but do not take the Sight key yet.
- The route is based on the letter threshold, not simply an arbitrary "all letters" completion.

### 4. Basement

- Continue to the basement route.
- At the ritual conduit, the route checks the current state: one restored sense plus the letter count.
- If the game recognizes Vantree eligibility, the conduit resolves accordingly.

### 5. Part II start

Once the Part I ending is triggered:

- Vantree starts with blood magic and touch-based pressure.
- Max HP is reduced to match the branch.
- The Hound is stronger and more aggressive about nearby contact.

### 6. Cathedral Roots and Echoes

- Reach the roots and then the Chamber of Echoes.
- Use the branch mechanic the current code expects.
- Vantree route: use the Sigil Forge and blood sigils, then use the final route logic to open Nexus Descent.
- Untouched route: full gadget flow is the principal mechanic.
- Partial Mercy: hybrid / partial sigil flow.

### 7. Nexus Convergence

- Ring the Ward Bell to bind the Hound.
- Move to one anchor.
- Hold E to complete the chosen ending.
- Only one anchor needs to be completed.

## Current ending set

The final branch names in the current code are:

- Severance
- Custodian's Rest
- Vessel

These are reached through the Nexus anchor system after the ward is established.

## Project structure

Key files for understanding the current behavior:

- [project.godot](project.godot) — input map and project config
- [scripts/core/freedom_ledger.gd](scripts/core/freedom_ledger.gd) — route logic, ending conditions, branch seeds
- [scripts/enemy/deprived_one.gd](scripts/enemy/deprived_one.gd) — monster AI, hearing/sight/memory logic, distraction response
- [scripts/player/player.gd](scripts/player/player.gd) — Q gadget, sigil, lighting, and movement logic
- [scripts/systems/field_guide.gd](scripts/systems/field_guide.gd) — current in-game guidance and objective text

## Notes for contributors

- The project has a large number of validation scripts in the tests folder; treat them as the current route and behavior references when the older docs conflict with the actual code.
- The older walkthroughs are dated and should not be treated as the current source of truth.
- If there is a disagreement between the design docs and the live code, the live code and the structured save-state rules should win.

## Verification status

The workspace includes many route and gameplay validation scripts under the tests folder, but this environment does not currently have a runnable Godot binary available, so no fresh runtime pass can be claimed from here. The current project files and route logic are the best active source for the implementation state.
