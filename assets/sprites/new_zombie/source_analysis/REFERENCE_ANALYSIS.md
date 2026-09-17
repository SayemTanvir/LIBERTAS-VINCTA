# Zombie animation reference audit

The source contains **13 actions, 16 directions, 208 PNG sheets, and 4,672 occupied frame cells**.
Each source cell is 256 x 256 pixels. There is one exact repeated frame within a source sheet: Lookup Body 180, frame 29 repeats frame 14 (zero-based).
Retain this repeated cell: it is part of the original 30-cell Lookup sequence, not evidence of trailing empty padding.
The ZIP also contains 208 Godot texture `.png.import` sidecars and directory entries.

| Action | Frames per direction | Grid (columns x rows) | Source sheet pixels | Total frames |
|---|---:|---|---|---:|
| Attack1 | 20 | 4 x 5 | 1024 x 1280 | 320 |
| Attack2 | 24 | 6 x 4 | 1536 x 1024 | 384 |
| Attack3 | 24 | 6 x 4 | 1536 x 1024 | 384 |
| Attack4 | 30 | 6 x 5 | 1536 x 1280 | 480 |
| Death1 | 24 | 6 x 4 | 1536 x 1024 | 384 |
| Death2 | 24 | 6 x 4 | 1536 x 1024 | 384 |
| Hit1 | 16 | 4 x 4 | 1024 x 1024 | 256 |
| Hit2 | 16 | 4 x 4 | 1024 x 1024 | 256 |
| Idle | 20 | 4 x 5 | 1024 x 1280 | 320 |
| Lookup | 30 | 6 x 5 | 1536 x 1280 | 480 |
| Roar | 24 | 6 x 4 | 1536 x 1024 | 384 |
| Run | 20 | 4 x 5 | 1024 x 1280 | 320 |
| Walk | 20 | 4 x 5 | 1024 x 1280 | 320 |

## Direction mapping

The numeric filename tokens are preserved exactly. Nominal angles use 22.5-degree spacing; filenames truncate half degrees.
Compass labels describe facing direction on screen, inferred by inspecting the original sprites.

| Filename token | Nominal angle | Facing |
|---|---:|---|
| 0 | 0 | N |
| 022 | 22.5 | NNE |
| 045 | 45 | NE |
| 067 | 67.5 | ENE |
| 090 | 90 | E |
| 112 | 112.5 | ESE |
| 135 | 135 | SE |
| 157 | 157.5 | SSE |
| 180 | 180 | S |
| 202 | 202.5 | SSW |
| 225 | 225 | SW |
| 247 | 247.5 | WSW |
| 270 | 270 | W |
| 292 | 292.5 | WNW |
| 315 | 315 | NW |
| 337 | 337.5 | NNW |

## Ordering and timing

Frames are read left to right, top to bottom. This order is inferred from visible motion continuity.
No authoritative FPS, loop flags, animation resources, durations, events, or pivot definitions are supplied.
The `.png.import` files describe texture import settings, not animation timing.
Do not claim exact playback timing from this archive. Retain full cells to preserve the original registration.

## Machine-readable files

- `animation_manifest.json`: every sheet, direction, cell rectangle, alpha bounds and RGBA hash.
- `frame_inventory.csv`: one row per frame cell, 4,672 rows.
- `action_summary.csv`: action totals and layout.
- `reference_directions.jpg`: first idle frame in every direction, labeled by original filename.

## HD generation status

This audit describes the original reference. It is not a completed HD sprite recreation.
Generated tests must independently pass transparency, resolution, grid, pose, identity and playback checks before production use.
