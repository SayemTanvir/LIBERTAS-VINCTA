# Furniture facing implementation — 2026-09-16

The orientation system is implemented and tested. **The visual correction is
incomplete because matching directional furniture sprites are absent.** Existing
art remains unchanged for those objects, as required by the request.

## Behavior

`data/room_dressing.json` now supplies explicit `facing_zones` for each of the
37 sections. Back zones cover y=354..435; front zones cover y=570..634. These
are approved authored furniture groupings, not guessed wall-contact distances.
Side zones occur only at the actual floor-strip boundaries. No side wall is
invented at the open boundary between named sections.

`scripts/levels/furniture_facing.gd` resolves the whole scaled floor footprint
against these zones. Back -> down, front -> up, left -> right, right -> left.
If two zones overlap, it compares clear inward corridors using the existing
blockers; exact ties use down/up/right/left order. An explicit alcove zone works
without requiring a rectangular-room nearest-wall calculation. Current floors
are rectangular strips; this does not introduce irregular room geometry.

Outside zones, a prop retains its authored facing. `furniture_facing` in
`data/estate_art.json` is an explicit opt-in catalog, excluding rugs, round tables,
lights, wall art, rubble, loose pickups and tabletop details. Axis-only props
such as sarcophagi/screens/bathtubs retain their existing authored presentation.

`EstateArt.bind_facing()` records the existing footprint and visual. Base
furniture, interactive furniture with a footprint, floor decorations and the
supplemental dressing all call it. The controller runs after placement and
again on transform changes. Newly bound entries share the same live registry.
There is no existing player furniture-dragging feature to change; runtime
transform movement is tested. Placement/collision/navigation remain owned by
their existing systems.

Checkpoint loads rebuild rooms from the JSON and recalculate facing. No saved
furniture orientation field or save migration is needed. Old checkpoints store
the ledger/player position, not a separate furniture layout.

## Directional art contract

Each opted-in asset has a `native` direction and `variants` dictionary. A future
real rear-view asset can be registered as:

```json
"bench": {
  "native": "down",
  "variants": {"up": {"asset": "bench_rear"}}
}
```

`bench_rear` must be a real entry in the texture catalog. This example has not
been installed and is not a claim that rear artwork exists. Furniture with
tabletop details additionally requires `detail_offsets`, in the original detail
order, for the new view. Missing texture keys or detail offsets fall back safely.

The resolver never rotates an upright 2D sprite or mirrors it into a fake back.
It restores native art before each resolution, so moving from a supported view
to an unsupported view cannot leave a stale variant. Foot origin, width, shadow,
Y sorting, collision and lighting occluders remain unchanged.

Runtime metadata distinguishes intent from appearance:

- `furniture_facing`: desired direction (or `authored`).
- `furniture_facing_applied`: the view actually shown.
- `missing_furniture_view`: asset/direction missing for this placement.

`FurnitureFacing.missing_views()` groups affected nodes. The test exports a
complete per-floor instance list to `build/missing_furniture_views.json`.

## Missing views in the current layout

| Asset | Direction | Placements |
| --- | --- | ---: |
| Bench | Up / rear | 42 |
| Bench | Left | 1 |
| Wood chair | Up / rear | 12 |
| Dining chair (shared chair crop) | Up / rear | 2 |
| Settee | Up / rear | 7 |
| Wine rack | Up / rear | 7 |
| Serving cart | Up / rear | 3 |
| Bed | Up / opposite end | 1 |
| Sideboard | Up / rear | 1 |
| Toy chest | Up / rear | 1 |
| **Total** | | **77** |

Bookcases, wine shelves, high chairs, lecterns, washstands and the piano will
also need matching views if moved to a zone requiring another direction. Their
current native views remain in use. No furniture artwork was generated or edited.

## Verification and visual limit

- `verify_furniture_facing`: 452 checks, zero failures. Covers four walls,
  stable corner tie, obstructed corner choosing more open floor, wide footprints,
  center placement, an explicit local alcove, live movement, reload, exclusions,
  variant dispatch and invalid-view fallback.
- `verify_room_dressing`: 503 checks, zero failures; includes routes and collision.
- `verify_estate_assets`: 1,001 checks, zero failures across all seven floors.
- `verify_ward_access`: all 28 charging stations remain usable.

The variant-dispatch test uses a clearly labeled texture-alias fixture to test
selection; it is not visual proof of rear-view furniture. The existing full-room
reference is `build/furnished_GF-03.png`: its foreground settee, chair and bench
still display front artwork, while their desired facing is now up and each
missing rear view is reported. There is no claimed visual before/after improvement
until these genuine views are supplied. Lighting and shadow geometry have not
changed; new directional art will still need in-room visual QA.

Optional natural variation remains unapplied. Existing tabletop variants may
be varied later; no position jitter, room resize or new placement rules were added.
