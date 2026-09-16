# Furnished rooms — 2026-09-16

All 37 rooms now have additional furniture chosen for their purpose: **178 new
furnishings**, decorations on **46 existing ordinary tables**, and **9 rugs**.
The room-relative placements and descriptions are editable in
`data/room_dressing.json`; `scripts/levels/room_dressing.gd` builds the scenery.

- Foyers and corridors: waiting seats, coat stands and closed storage.
- Dining/service rooms: chairs, serving carts, plates and pantry storage.
- Library/music rooms: shelves, books, listening seats and reading groups.
- Bedrooms/nursery: seating, screens, storage, toys and a small nursery bed.
- Cellars: bottle racks, crates, cupboards and work surfaces.
- Cathedral: pew-like benches, lecterns, sarcophagi and architectural rubble.
- Convergence: perimeter furniture leaves the bell and all anchors approachable.

New furniture is grounded with contact shadows, Y sorting and solid footprints
for both Els and the Hound. Low foreground pieces add depth; tall storage stays
near the back wall. The central walking lane remains open. The Nexus Descent
alcove has wide approaches on both sides. Decorative rugs use the existing CARPET
footstep behavior and do not cover the authored glass route.

Charging remains **28 stations / 94 tables**, with at most one station per room.
Tabletop decoration does not create extra pickups or charging points. Artwork
comes from the existing asset catalog; no new raster artwork was generated.

## Verification

- `verify_room_dressing`: 503 checks passed, including all interactions reachable,
  physical footprints, clear walking lanes, room coverage and rug footsteps.
- `verify_ward_access`: all 28 charging stations remain usable.
- `verify_full_playthrough`: 150 checks passed across story routes and recovery.
- `verify_estate_assets`: 1,001 checks passed across all seven zones.
- `verify_finishability`: 41 headless checks passed, including all three endings
  reached with normal movement, held-E rituals and the Hound's AI running.
- Rendered 13 room views at `build/furnished_<room ID>.png`; inspected domestic,
  storage, cathedral and Convergence layouts.

The live finale test resets pause after removing the outgoing ending scene so
headless runs cannot inherit its final pause frame between independent routes.

Total: **1,723 checks, 0 failures**. Final logs are `build/furnished_final_visual.log`,
`build/furnished_charging.log`, `build/furnished_route.log`,
`build/furnished_assets_final.log` and `build/furnished_finales_verified.log`.
