# LIBERTAS VINCTA: Professional Playtest Report

**Pass date:** 2026-09-13  
**Authority:** `RULE AND STEPS TO SOLVE THE GAME STORY.md` for playable rules, cross-checked against the original `LIBERTAS VINCTA.md` for story fidelity.

## Scope

The pass exercised the Vantree, Untouched, Partial Mercy, and Loop outcomes; all three Ley-Nexus anchors; every zone transition; capture and checkpoint recovery; key, tool, puzzle, flashlight, door, damage, death, respawn, and stun presentation; all 37 room regions; all 60 catalog textures; and the three Part II branch gates.

The playthrough was performed through the actual scenes and interaction nodes with enemies active for system checks and disabled only when deterministic route traversal was required. Separate rendered sweeps inspected every room and the nine critical animation states.

## Bad Experiences Found and Resolved

| Severity | Player experience | Resolution |
| --- | --- | --- |
| Critical | An anchor could begin while the monster had already detected Els, allowing a channel to continue without a fresh detection signal. | Anchors now reject an already-detected start and continuously inspect live detection as well as damage/detection events. |
| High | Capture cut to a standing checkpoint with no recovery animation. | Capture now holds the death pose, restores the exact checkpoint, fades in, and reverses the collapse animation before control and enemy processing resume. |
| High | A first-room checkpoint recovery could be presented like another doorway arrival, producing an irrelevant door-close beat. | Respawn now overrides passage arrival state, starts with all doors closed, and emits no door cue. |
| High | The three-key Loop played the collapse forward, making Els appear to fall again before snapping upright. | The Loop now begins prone and uses the same reverse recovery sequence while gameplay remains locked. |
| High | Stun Rite consumed 20% health and its cooldown when the monster was outside the 192-pixel radius. | Range is validated first; failed attempts spend no health and start no cooldown. |
| Medium | The cracked ritual seal silently consumed a lockpick even though only the piano and vanity are lockpick puzzles. | The ritual seal is now a one-step, no-lockpick interaction with a dedicated reach pose. |
| Medium | Completed piano and vanity puzzles could be worked again after completion or respawn. | Completed puzzles stay visible but are no longer targetable. |
| Medium | CR-04 and CE-03 one-time reveals could repeat through their nearby lore props. | Automatic source-defined triggers and manual availability now share the same persistent one-time flags. |
| Medium | CE-01 delivered a Blood Magic/forge hint to Untouched and Partial Mercy players. | The automatic hint is branch-specific for gadgets, partial sigils, or Touch/Blood Magic. |
| Medium | A sealed key or gated puzzle could play a successful pickup/unlock pose before reporting failure. | Requirement checks now suppress success-like action poses when the interaction is still sealed. |
| Medium | Scene audio playback resources survived deterministic floor changes and polluted long play sessions/tests. | Audio directors now stop playback, clear streams, and release their players on scene exit. |
| Medium | New Game could leave an older Continue file available during the new introduction; malformed position data could also break Continue. | New Game clears the previous save, tests use isolated save files, and Continue validates its saved position before restoring. |
| Low | Room load forced a flashlight toggle animation and cue even though the flashlight was only being initialized as off. | Runtime initialization now updates the flashlight silently; player-triggered toggles retain their animation and sound request. |
| Low | The monster had no supplied stagger animation, so Stun visually fell back to an ordinary idle. | Stun now uses a procedural sway and desaturated tint, while Memory/Touch branches keep their larger true-form treatment. |
| Low | Generic interactions could animate using Els's previous movement direction instead of aiming at the object. | Every interaction now derives facing from the live target angle; authored puzzle offsets remain intact. |

## Visual Review

- Furniture footprints remain outside passage openings, and all generated navigation paths remain connected.
- Benches retain the camera-facing rotation across intro, Ground, Upper, and Basement zones.
- The piano, vanity, and ritual seal action positions face their targets without placing Els inside the furniture collision.
- Hearing, Sight, and Memory keys remain separately visible with gold pickup markers.
- Open doors retain the dark doorway void; Els aligns below the threshold, walks through, fades inside it, emerges at the matching destination door, and the door closes behind her.
- The held flashlight is hand-sized. Its illumination stays on the floor and does not cover Els's body.
- No photographed room tail is blank or left outside the imported floor/wall bands.

## Verification Record

| Suite | Result |
| --- | --- |
| Estate assets/layout | 686 checks, 0 failures |
| AI, abilities, interaction systems | 66 checks, 0 failures |
| Canon Vantree route and Severance | 96 checks, 0 failures |
| Untouched, Partial Mercy, Loop, recovery, remaining Nexus endings | 147 checks, 0 failures |
| Rendered room sweep | 7 zones, 38 viewpoints for 37 room regions |
| Rendered animation sweep | 9 critical states captured |

The only console message left in the isolated headless runner is Godot's Windows root-certificate-store warning; it is external to gameplay. Before distribution, the remaining release tasks are the asset-license confirmations and matching Godot 4.7 export templates already listed in `KNOWN_ISSUES.md`.
