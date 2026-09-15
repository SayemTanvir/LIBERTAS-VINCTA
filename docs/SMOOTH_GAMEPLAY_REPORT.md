# Crouch, shelter and action polish — 2026-09-15

## Result

- Sixteen generated crouch poses replace the scaled standing pose. Movement uses the existing acceleration and slower crouch speed. The actor remains opaque while entering shelter, crouches visibly at the table's front opening, and returns to its safe approach position when leaving. Capture cancels shelter motion and restores collision.
- While switched on, the flashlight uses the original directional holding artwork above animated walking legs. Switching it off (including an empty battery) removes the holding pose and restores normal idle/walking artwork immediately, without restarting the gait or playing a turning sequence. Hand actions use their own full-body clips.
- Distinct clip selections cover key pickup, ordinary collection, locks, doors, piano work, reading, recharge and channeling. Keys are drawn only in key-related actions. Long action cancellation clears both the control lock and animation lock.
- Batteries, clocks, tools and other pickups hide all attached visuals when awarded and remain absent on room reload. Their ledger IDs remain authoritative.
- Speech is smaller, tracks the head with eased motion, fades in over 0.16 seconds, and paginates into three speech lines. Narration retains its separate presentation.
- Hearing turns and replans toward new sounds immediately; active hunts refresh their path at 0.12 seconds. Memory investigates known shelters instead of a fixed map edge. Crouching with the flashlight off reduces visual range to 72%; sealed senses still cannot detect the player through those channels.
- The HUD connects degrees of freedom to released bonds and the Hound's senses. Part II shows the ability granted by the chosen branch.

## Sources and implementation

`scripts/player/player_poses.gd` curates existing action frames and loads the new crouch atlas.
`shaders/player_held_pose.gdshader` separates held upper-body art from animated legs and
masks the generated crouch sheet's neutral backing. The generated PNG stays unchanged;
its reference, prompt, layout and rebuilding instructions are in the adjacent README.

The former crouch compression and generic unlock/flashlight behavior described in the
earlier `GAMEPLAY_POLISH_REPORT.md` are superseded by this change.

## Verification

Godot 4.7.2 engine runs, using isolated test saves:

| Suite | Checks | Failures |
| --- | ---: | ---: |
| Crouch, hiding, flashlight, pickups, sensing and rendered captures | 56 | 0 |
| Repeated interactions, speech paging, input and animation | 139 | 0 |
| Gameplay systems, AI and interrupted channels | 67 | 0 |
| Canonical route and loop | 96 | 0 |
| Alternate endings, capture and recovery | 150 | 0 |
| UI polish | 14 | 0 |
| Estate assets and navigation | 683 | 0 |

Rendered frames inspected under `build/smooth_*.png` and `build/animation-sweep/` cover
visible crouching under the table, all four flashlight facings, compact speech, and nine
action/recovery scenes. These scripted and rendered checks do not establish that every
possible gameplay bug or hardware-specific export issue has been eliminated.
