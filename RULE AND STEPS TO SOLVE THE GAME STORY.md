# LIBERTAS VINCTA: Current Rules and Route Guide

This is the current implementation guide for the game as it exists in the codebase. It replaces the old walkthrough notes and reflects the actual state of the current project logic rather than the older design writeup.

> This guide is intentionally written to the code: the game state and route checks in the project are the source of truth.

## Verified current build state

The project was run in Godot 4.7 headless mode using the installed executable from `E:\New folder\Godot_v4.7-stable_win64_console.exe`.

The current runtime validation result is:

- route verification reached the full intro-to-nexus flow
- full-playthrough verification reported: `PLAYED Untouched -> Custodian's Rest`

This means the current verified path for the build is the Untouched route resolving to Custodian's Rest. Treat that as the active project state until a new, contradictory runtime check is run.

## 1. What the player is actually doing

The game is built around a simple structure:

1. Explore the estate.
2. Restore senses by taking keys.
3. Decide which ending route to pursue.
4. Enter the cathedral branch and unlock the final anchor route.
5. Reach one final anchor and complete the ending.

The most important rule is still this:

- Taking all three keys is not the winning route.
- The loop ending is triggered by taking all three keys and walking the wrong route through the estate.

## 2. Current route logic

The state machine is controlled by the save data and the route checks in the project. The current route rules are:

- 0 keys + 0 detections -> Untouched
- 1 key + 4 estate letters -> Vantree
- 2 keys -> Partial Mercy
- 3 keys -> Loop

In plain terms:

- Hearing alone is not bad by itself.
- The route is judged by which sense is restored and whether the required letter threshold is met.
- A full three-key run is a deliberate false escape, not a success route.

## 3. Current Part II rules

The Part II branch depends on the Part I ending:

### Vantree

- Touch mutation is active.
- Blood magic is available.
- HP cap is lowered for the route.
- The Hound becomes more dangerous through close-range contact pressure.

### Partial Mercy

- Hybrid / partial sigil route.
- Hearing is blocked by the sigil, but sight remains a real danger.

### Untouched

- Full gadget route.
- Q is the primary distraction path.
- Bottles, clocks, and batteries all behave differently and are tracked by the inventory state.

## 4. Controls and relevant actions

| Action | Input |
| --- | --- |
| Move | W A S D / Arrows |
| Sprint | Shift |
| Crouch | Ctrl |
| Interact | E |
| Flashlight | F |
| Hold breath | B |
| Gadget / distraction | Q |
| Sigil / blood magic | R |
| Stun rite | T |
| Inventory / letters | Tab |
| Field guide | H |
| Pause / back | Esc |

### Current gadget behavior

Q is not a generic drop action. In the current implementation, it behaves like this:

- if flashlight charge is low, Q uses a battery first
- otherwise it uses a bottle if one is available
- if there are no bottles, it uses a clock
- batteries do not count toward the Echoes descent gate
- bottles and clocks do count toward the route-specific descent checks

This matters a lot because the older guide text is out of date on the exact Q flow.

## 5. Distortion and distraction behavior

The current code treats a dropped bottle or clock as a temporary, high-priority distraction:

- it marks a specific location as the active distraction target
- the Hound tracks that point
- it holds there for the active 5-second window
- then the distraction state clears and normal behavior resumes

This is the correct behavior to keep in mind when testing. If a bottle is broken and then a clock is dropped, the newer event wins and the stale location does not keep overriding the later action.

## 6. The clean recommended full route

This is the route that best matches the current implementation and is the safest way to finish the game without relying on stale notes.

### Part I

1. Start the game and complete the intro.
2. Collect the flashlight and tool pouch.
3. Use the door once to record the first attempt, then continue into the estate.
4. Explore the ground floor and find the Hearing seal.
5. Restore Hearing.
6. Collect letters while moving through the estate.
7. If you are aiming for Vantree, get to four estate letters before the conduit route resolves.
8. Do not take the full three-key loop route.
9. Reach the ritual conduit and complete the route that matches your chosen ending.

### Vantree route

Use this if you want the canon route and the blood-magic branch:

- restore Hearing
- gather at least four estate letters
- do not take the full three-key route
- trigger the ritual conduit with the correct state
- continue into the cathedral and then the Echoes route

### Partial Mercy route

This branch is the two-key route:

- restore Hearing and Sight
- continue through the route logic that resolves from the saved state
- use the alternate branch mechanic instead of the full blood-magic route

### Untouched route

This route is the zero-key run:

- no key restoration
- zero detection threshold is required
- the front door is the relevant exit route
- the branch is the full gadget route in Part II

## 7. Part II flow

After Part I ends, the game seeds the branch state and sets up the Part II logic.

### Vantree Part II flow

- Touch mutation is active.
- Blood magic is available.
- The Hound reads nearby contact and close pressure differently.
- The forge and blood rite logic are the main gate.

### Partial Mercy Part II flow

- hybrid route logic
- partial sigil style behavior
- hearing suppression but still active sight risk

### Untouched Part II flow

- the full gadget route is active
- Q is the main route mechanic
- three uses can open the descent gate depending on the branch logic and current state

## 8. Final Nexus route

At the final convergence stage:

- ring the Ward Bell
- bind the Hound
- move to one of the named anchors
- hold E on the chosen anchor to complete the ending

The current ending names in the project are:

- Severance
- Custodian's Rest
- Vessel

Only one anchor completion is needed. The other anchors are alternate ending branches, not extra goals.

## 9. Best current approach to solving the game

If you want a practical solve path with the current project state:

1. Do not rely on the old long-form walkthrough as the final authority.
2. Treat the project code and save-state rules as the real source of truth.
3. Use the field guide in-game while playing.
4. Decide the branch early:
   - Vantree for blood-magic / touch path
   - Partial Mercy for hybrid route
   - Untouched for zero-key / gadget route
5. Follow the route checks in the actual project logic instead of the older design text.
6. If you want the currently verified ending in this build, use the Untouched route and complete Custodian's Rest.
7. Use the final anchor once the barrier is cleared.

## 10. Current project references

These are the files that matter most for the live logic:

- [project.godot](project.godot)
- [scripts/core/freedom_ledger.gd](scripts/core/freedom_ledger.gd)
- [scripts/enemy/deprived_one.gd](scripts/enemy/deprived_one.gd)
- [scripts/player/player.gd](scripts/player/player.gd)
- [scripts/systems/field_guide.gd](scripts/systems/field_guide.gd)
- [scripts/interactables/base_interactable.gd](scripts/interactables/base_interactable.gd)

## 11. Verification note

The project contains route and gameplay validation scripts under the tests folder, but this environment does not currently have a working Godot binary installed, so no fresh runtime validation can be claimed from here. The intent of this document is to align the project documentation with the actual code currently in the workspace.

