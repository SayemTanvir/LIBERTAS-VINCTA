# Door interaction alignment — 2026-09-16

The visible left-side lock now matches Els's key and handle gestures. The door
opens from that edge toward a fixed right hinge. Runtime atlas crops separate the
moving wooden leaf from four stationary frame/threshold pieces; the supplied PNG
is unchanged.

Approach movement aligns Els sideways or forward without backing her away from
the handle. The Music Room opens at her planted key stance, without the previous
sideways camera pull. Its north-facing key clip omits the sideways turn, and the
handle clip uses matching empty-handed frames. Departure moves forward from that
same stance. Opening and audio do not repeat before entry. Death during opening
cancels the remaining dialogue and transition.

## Validation

- Door alignment and opening: **25 checks, 0 failures**, including fixed hinge,
  stationary frame, close approaches, blocked approaches, forward entry and death.
- Estate assets: **950 checks, 0 failures** across all seven zones.
- Full playthrough: **150 checks, 0 failures**, including alternate routes,
  recovery, puzzle poses and endings.

Total: **1,125 checks passed**. Logs: `build/door_final_checks.log`,
`build/door_assets_verified.log`, `build/door_route_verified.log`.
Visually inspected `build/door_key_aligned.png` and `build/door_open_from_key.png`.
