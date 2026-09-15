"""Atlas-only integration of generated crouch poses; source bitmap stays unchanged."""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SOURCE = 'assets/sprites/player/crouch/els_crouch_sheet.png'
image = Image.open(ROOT / SOURCE).convert('RGB')
width, height = image.size
regions = []
for row in range(4):
    for column in range(4):
        left, top = round(column * width / 4), round(row * height / 4)
        right, bottom = round((column + 1) * width / 4), round((row + 1) * height / 4)
        points = [(x, y) for y in range(top, bottom) for x in range(left, right)
                  if not (min(image.getpixel((x, y))) > 100 and max(image.getpixel((x, y))) - min(image.getpixel((x, y))) < 25)]
        assert points
        x0, y0 = min(x for x, _ in points), min(y for _, y in points)
        x1, y1 = max(x for x, _ in points) + 1, max(y for _, y in points) + 1
        w, h = x1 - x0, y1 - y0
        # A 512px canvas uses half the standing sprite scale: real crouched anatomy.
        regions.append(f'[sub_resource type="AtlasTexture" id="pose_{row}_{column}"]\n'
                       f'atlas = ExtResource("1")\nregion = Rect2({x0}, {y0}, {w}, {h})\n'
                       f'margin = Rect2({256-w/2}, {448-h}, {512-w}, {512-h})\nfilter_clip = true')
animations = []
for direction, row in [('s', 0), ('sw', 1), ('w', 1), ('nw', 1), ('n', 2), ('ne', 3), ('e', 3), ('se', 3)]:
    for action, indices in [('crouch_idle', [0]), ('crouch_walk', [0, 1, 2, 3])]:
        frames = ', '.join('{"duration": 1.0, "texture": SubResource("pose_' + str(row) + '_' + str(i) + '")}' for i in indices)
        animations.append('{"frames": [' + frames + f'], "loop": true, "name": &"{action}_{direction}", "speed": 7.0' + '}')
text = '[gd_resource type="SpriteFrames" load_steps=18 format=3]\n\n'
text += f'[ext_resource type="Texture2D" path="res://{SOURCE}" id="1"]\n\n'
text += '\n\n'.join(regions) + '\n\n[resource]\nanimations = [' + ',\n'.join(animations) + ']\n'
(ROOT / 'scenes/player/crouch_frames.tres').write_text(text, encoding='utf-8')
print('16 crouch poses aligned; source artwork unchanged.')
