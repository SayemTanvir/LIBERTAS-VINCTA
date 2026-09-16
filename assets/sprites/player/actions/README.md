# Dedicated Els action sheets

Generated for this project on 2026-09-16 with OpenAI's built-in image generation,
using the supplied `../idle.png` as Els's identity and outfit reference.
Full prompts, correction prompts and selected output filenames are in `prompts.json`.

| Sheet | Use |
| --- | --- |
| `torch_use.png` | Raise, switch, aim; reversed for lowering; final pose for idle |
| `torch_move.png` | Separate walking and running cycles with a held flashlight |
| `vent_enter.png` | Stand, kneel, crawl; reversed for emergence |
| `door_unlock.png` | Retrieve key, reach, turn the lock, withdraw |
| `piano.png` | Two-handed keyboard/lock work |
| `hide_wall.png` | Tuck into tall cover and hold a quiet stance |
| `hide_table.png` | Crouch, crawl, curl below furniture; reversed for leaving |
| `bag_pickup.png` | Lift and inspect a small tool bag, then stow it |
| `key_pickup.png` | Pinch a small key, inspect it, and pocket it |

## Integration

Each sheet has four authored directions: south, west, north, east. The animation
loader maps the game's eight facing directions to these rows. Eight sheets contain
24 poses each; the movement sheet contains 32. The atlas uses measured silhouettes,
not assumed equal cell dimensions, because the generated layouts vary slightly.

`tools/measure_action_frames.py` reads images and writes `frames.json` with crop
rectangles, foot offsets, and a consistent 69-pixel standing height in game units.
It does not edit image pixels. `scripts/player/action_frames.gd` registers the clips
and supplies this metadata to the player's sprite.

The transparency requests produced painted backgrounds on several outputs. Built-in
edits replaced those backgrounds with magenta for reliable runtime chroma keying in
`shaders/player_held_pose.gdshader`. These source PNGs intentionally retain that
backing; use them through the action loader/material. The normal game renderer
displays transparent silhouettes. Original character sheets remain intact.

Looping torch gaits use complete body poses. The old held-body overlay is only an
optional fallback if a generated movement asset is missing. Wall clips omit poses
that turn away from cover; crouch/vent holds and exits use their dedicated sources.

Run `tests/verify_action_animation.tscn` for transition, damage, atlas and grounding
checks. With a normal renderer it also saves action previews in `build/actions_e.png`
and `build/actions_n.png`, torch gaits in `build/actions_gaits.png`, and in-room
torch, cover and vent previews in `build/action_world_*.png`.
