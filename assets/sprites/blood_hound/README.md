# Blood Hound presentation

Source: `assets/BG/02_Enemy/blood_hound_horror_monster_animation_sprite_sheet.png`, supplied by the project owner. The original PNG is unchanged.

`scenes/enemy/deprived_one.tscn` now uses this monster through `blood_hound_frames.tres`.

- Rows 1–5: idle (7), walk (8), sniff (7), run (7), attack (7).
- First four poses of row 6: stagger (4). Collapse and howl poses are unused.
- The supplied poses face right; left travel mirrors them. No separate front/back art is supplied.
- Fixed 360 × 224 frame canvas, ground anchor (180, 204), normal scale 0.70.
- `frame_masks.svg` contains vector clipping geometry derived from the source alpha channel. IDs in its red channel match `clips.json`; keep its import lossless, at scale 1, with mipmaps disabled.
- Each enemy owns its shader material so one enemy's frame changes cannot affect another.

Rebuild with `python scripts/tools/build_blood_hound_frames.py` (Pillow required).
Verify with Godot and `res://tests/verify_enemy_presentation.tscn`.
