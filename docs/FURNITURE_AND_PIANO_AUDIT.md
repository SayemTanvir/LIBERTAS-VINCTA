# Furniture orientation and seated piano audit

Follow-up: the user confirmed the metadata and output folder. See
`FURNITURE_FACING_REPORT.md` for the implemented controller and remaining art
requirements, and `QA_2026_09_16.md` for subsequent gameplay fixes. The text below
records the original pre-change audit, not the current implementation status.

Status: audit and implementation proposal only, 2026-09-16. No gameplay code,
scene, existing artwork, or save data changed during this audit. Existing
uncommitted work is preserved. The README was read in full before inspection.

## Project context established from the repository

- Godot 4.7 is declared in `project.godot` and the README; the engine executable
  was not found on PATH during this audit.
- The game is LIBERTAS VINCTA; the player is Els Vantree.
- Seven `scenes/levels/*_floor.tscn` scenes use `scripts/levels/estate_room.gd`.
  `data/estate_layout.json` defines 37 named room sections.
- This is a 2D elevated view of a shallow floor strip, with upright sprites and
  a scrolling Camera2D, not 3D models or a furniture-placement grid.
- Placement comes from `data/estate_art.json` and `data/room_dressing.json`.
  A 40-pixel AStarGrid2D is navigation data, not furniture wall-affiliation data.
- Els uses AnimatedSprite2D. The original reference is
  `assets/sprites/player/idle.png`: 3072 x 2048, 12 x 8 cells of 256 x 256,
  directions S, SW, W, NW, N, NE, E, SE, nominal foot anchor (128, 224).
- Els has short brown hair, a navy jacket, green shirt, brown cross-body
  satchel and burgundy boots. These identity details must remain unchanged.

## Orientation audit

`estate_room.gd::_ready()` builds the room and calls `EstateArt.dress()`.
`estate_art.gd::dress()` handles base furniture, interactable furniture,
ordinary tables and decorations. It then calls `room_dressing.gd::dress()`
for 178 supplemental furnishings, 46 tabletop decorations and nine rugs.

`estate_art.gd::_furnish()` selects a single texture by `spec.asset` and applies
only the optional `spec.flip` horizontal flip. `_set_sprite()` sets the texture,
width, tint and foot origin. No facing calculation or directional asset table
exists. The optional bench rotation is currently zero.

Nine front-elevation crops share `estate_front/furniture_front.png`.
Dining, wood and high chairs share the same chair crop. Other catalog props
use individual single-view sprites. Older furniture images and alternative
chair designs are not matching directional views of the currently used objects.
No directional fields were found in the texture catalog.

Physical boundaries are the back edge at y=354, front edge at y=634, left
edge at x=0 and right edge at x=layout.width. Named room `start`/`end`
coordinates do not create solid side walls. Treating every room-section edge
as a wall would invent walls across open passages.

Most placed footprints do not touch a boundary: supplemental furniture often
has its foot at y=395, 420, 590 or 605. Its shallow footprint does not say whether
the piece belongs to a wall grouping. A nearest-wall guess would also classify
freestanding furniture as wall furniture.

There is no player furniture dragging/moving feature or saved furniture layout
in the inspected runtime. Checkpoints store zone, player position and the
FreedomLedger snapshot. Room furniture is rebuilt from authored JSON on load.

## Logged issues before any fixes

### FURN-001 — foreground seating faces out of the room

- Reproduction: inspect the full Music Room view, `build/furnished_GF-03.png`,
  and its GF-03 entries in `data/room_dressing.json`.
- Actual: the foreground settee, wood chair and bench show their front faces
  toward the viewer, just like the background seating.
- Expected: these foreground seats present their backs to the viewer and face
  into the room.
- Severity: major visual defect relative to this request.
- Status: confirmed in an existing screenshot and the current data/code;
  not fixed. Requires true rear views; no sprites were flipped or distorted.

### FURN-002 — wall affiliation is absent from placement data

- Reproduction: inspect the two placement JSON files and `_furnish()`; compare
  the y=605 bench footprint with the physical front edge at y=634.
- Actual: no affiliation is stored; footprint contact cannot identify all
  authored wall groupings, and room labels are not physical side walls.
- Expected: reliable wall-relative facing, with freestanding pieces explicitly
  retaining their design convention.
- Severity: major implementation gap for the requested orientation feature.
- Status: minimal metadata proposal below; awaiting the confirmation explicitly
  required by the request before structural changes.

## Concrete metadata and behavior proposal (not implemented)

Add orientation-only facing zones alongside each room's existing dressing data.
Use room-local rectangles and a wall label; do not change coordinates, dimensions,
navigation, collision, or placement rules. An example for GF-03 is:

```json
"facing_zones": [
  {"wall": "back", "rect": [0, 354, 720, 81]},
  {"wall": "front", "rect": [0, 570, 720, 64]}
]
```

These are proposed authored zones for review, not claims of measured wall
contact. Side zones should exist only at real side boundaries or explicitly
authored furniture groupings, never automatically at every room label boundary.
This metadata belongs in room data rather than a hard-coded distance threshold.

Proposed resolver:

1. Intersect the item's full, scaled floor footprint with the authored zones;
   do not use only its foot point or origin cell.
2. Back -> down; front -> up; left -> right; right -> left.
3. At a corner, choose the candidate facing with more clear floor ahead, using
   existing collision geometry and excluding the item's own footprint. Use a
   stable back/front-before-side order only on an exact tie. Cardinal facings
   avoid requiring diagonal sprite views too.
4. Outside zones, preserve the item's authored facing/current appearance.
5. Resolve the corresponding explicit directional texture. If unavailable,
   retain existing art and record the missing asset; never rotate an upright
   sprite through 90/180 degrees or use a flip as a rear view.
6. Run after all placement paths and every room rebuild. Provide a refresh
   entry point for future runtime movement; there is no current drag path to
   patch. Do not introduce a new furniture movement mechanic.

Keep foot origins, Y sorting, contact-shadow nodes, collision and light
occluders unchanged. Directional detail offsets must be authored with the new
views: for example, a vase on a sideboard must not float after a texture swap.

## Missing directional artwork

The following counts are supplemental foreground placements at y>=570, not
the entire catalog or a count of test results:

| Furniture | Foreground count | Asset requirement |
| --- | ---: | --- |
| Bench | 42 | Matching rear view; side views for side-wall use |
| Wood chair | 12 | Matching rear/side views |
| Dining chair | 2 | Same shared chair artwork as wood chair |
| Settee | 7 | Matching rear/side views; arms/upholstery cannot be flipped into a back |
| Bed | 1 | Matching opposite-end/side views |
| Sideboard | 1 | Matching rear/side views; drawers/handles are not a back |
| Toy chest | 1 | Matching rear/side views, including its lid |
| Wine rack | 7 | Matching opposite/side views; bottle openings are directional |
| Serving cart | 3 | Matching views if oriented; handle and contents are asymmetric |

Bookcases, wine shelves, lecterns, washstands and the piano also need real
alternative views if future zones request a different facing. The high-chair
alias shares the chair requirement. Screens, sarcophagi and bathtubs need an
explicit design-facing decision before applying this rule; their long axes
alone do not identify a useful front. Crates and coat stands need no automatic
inward facing under the proposed convention.

Exclude rugs, wall art, ceiling lights, floor surfaces/decals, rubble, loose
pickups, tabletop details, round tables and pots from automatic facing. Keep
their existing art. Do not generate missing furniture variants without a new
instruction: the supplied request explicitly forbids that.

## Visual evidence and testing status

The existing `build/furnished_GF-03.png` was opened and inspected. Its back
row contains the grand piano and stool between tables/storage; the foreground
settee, chair and bench face the camera. After a complete fix, that foreground
group should show backs while the piano remains in its established view.
There is no after image because no orientation change has been applied.

| Requested edge case | Audit result / execution status |
| --- | --- |
| All four walls and corner | Resolver test pending metadata approval and assets |
| Multi-cell item | Footprints already available; new resolver test pending |
| Freestanding | Preserve authored appearance proposed; test pending |
| Live drag/move | No existing gameplay feature; refresh test pending |
| Irregular room | Current physical floor strips are rectangular; future explicit zones proposed |
| Non-facing decoration | Exclusion policy proposed; regression test pending |
| Old saved layout | No saved furniture layout; room rebuild integration test pending |
| Y sorting and lighting | Existing foot sorting and footprint occluders identified; new-view visual QA pending |

No engine tests or full playthrough were performed in this audit. Previous
reports' passing totals are historical and are not claimed as new validation.

## Piano Stage 1 preparation

Stage 1 is asset creation only. The requested output-path field was blank;
`assets/sprites/player/actions/piano_seated/` has been proposed for confirmation.
No seated sprite assets have been generated yet.

The existing piano crop `[357,49,270,287]` in `piano1.png` already includes
the matching wooden stool. It must not acquire a duplicate chair. New Els
frames should omit furniture and align to that stool, facing toward the
keyboard in its existing elevated view. Verify the precise seat anchor before
integration rather than reusing the obsolete action offset as a teleport point.

Prepare a 256 x 256-cell seated idle and 6-8-frame play loop, plus optional
sit/stand transitions and GIF/APNG previews. Keep hips fixed during the loop.
Match the inspected idle reference rather than treating the newer action
sheets' variable crops or magenta backings as the output specification.

The supplied request explicitly says to report Stage 1 and obtain confirmation
before starting Stage 2. No piano code should be replaced before that review.

## Piano references identified for the later Stage 2 audit

- `data/estate_layout.json`: `piano_seal`, its three puzzle steps, 1.1-second
  action, `piano` override, and hearing-key requirement.
- `data/estate_art.json`: piano texture crop and interactable footprint/scale.
- `scripts/interactables/base_interactable.gd`: `interact()`, `_action_animation()`,
  `_prepare_action_pose()`, `_work_puzzle()`, and `piano_screech` on hearing-key pickup.
- `scripts/player/player.gd`: generic action/control/animation lifecycle.
- `scripts/player/player_poses.gd`: fallback `piano_*` clips copied from interact.
- `scripts/player/action_frames.gd`: generated non-looping `piano_*` clips.
- `assets/sprites/player/actions/piano.png` and `frames.json`: current art/crops.
- `scripts/player/character_animation.gd`: direction selection and animation dispatch.
- Tests referencing piano: `verify_action_animation`, `verify_estate_assets`,
  `verify_full_playthrough`, `verify_gameplay_polish`, `verify_game_route`,
  `verify_smooth_gameplay`, and `capture_animation_sweep`.

The current interaction is a lock/seal puzzle that gates the Hearing key, not
an independent endless musical performance. Preserve lockpick cost, three-step
progress, persistence and the sense/story triggers when adding seated visuals.
This distinction requires explicit treatment in the Stage 2 implementation.

## Optional polish (not applied)

After true directional art is approved, vary already-supported tabletop props
and furnishing selections to reduce repetition. Keep positions fixed: jitter
would affect clearance and lies outside this orientation-only change. The
existing runtime supports tint, width and details, but no matching directional
variant set is presently available. Any new variation remains optional.

## Remaining work

Await the adjacency-metadata decision and Stage 1 destination. Then implement
the authorized orientation paths to the extent supported by actual art and
generate/verify the seated assets. Obtain the required Stage 1 asset review
before replacing piano code. The exhaustive QA, bug-fix and final README/story
alignment task remains outstanding; this audit is not that playtest report.
