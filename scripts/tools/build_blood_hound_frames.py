"""Build atlas resources and vector clipping masks from the supplied alpha channel.

Requires Pillow. The source artwork is read only; no bitmap is edited or generated.
Unevenly spaced poses can overlap in rectangular bounds, so each connected silhouette
gets a vector mask ID. Every atlas has a fixed canvas and an authored ground anchor.
"""
from collections import deque
from pathlib import Path
import json
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SOURCE = 'assets/BG/02_Enemy/blood_hound_horror_monster_animation_sprite_sheet.png'
OUTPUT = ROOT / 'assets/sprites/blood_hound'
# Row limits, body anchors (excluding tails), ground line, playback FPS, loop.
CLIPS = {
    'idle': (0, 126, [108, 280, 459, 633, 806, 982, 1157], 118, 7, True),
    'walk': (126, 252, [114, 303, 489, 679, 853, 1045, 1248, 1434], 243, 10, True),
    'sniff': (252, 365, [111, 322, 524, 710, 899, 1085, 1280], 355, 8, True),
    'run': (365, 507, [105, 310, 573, 813, 1040, 1260, 1450], 501, 13, True),
    'attack': (507, 649, [114, 286, 509, 750, 992, 1203, 1399], 645, 12, False),
    'stagger': (649, 800, [94, 246, 391, 573], 784, 9, False),
}
CANVAS = (360, 224)
FOOT = (180, 204)


def main():
    image = Image.open(ROOT / SOURCE)
    width, height = image.size
    alpha = list(image.getchannel('A').get_flattened_data())
    pending = bytearray(value > 20 for value in alpha)
    components = []
    for index in range(width * height):
        if not pending[index]:
            continue
        pending[index] = 0
        queue = deque([index])
        pixels = []
        while queue:
            point = queue.popleft()
            pixels.append(point)
            x, y = point % width, point // width
            for neighbor in (point - 1 if x else -1, point + 1 if x + 1 < width else -1,
                             point - width if y else -1, point + width if y + 1 < height else -1):
                if neighbor >= 0 and pending[neighbor]:
                    pending[neighbor] = 0
                    queue.append(neighbor)
        if len(pixels) > 300:
            xs, ys = [p % width for p in pixels], [p // width for p in pixels]
            components.append({'bounds': [min(xs), min(ys), max(xs) + 1, max(ys) + 1], 'pixels': pixels})

    OUTPUT.mkdir(parents=True, exist_ok=True)
    regions, animations, paths, manifest = [], [], [], {}
    for action, (top, bottom, anchors, baseline, fps, loop) in CLIPS.items():
        poses = sorted((c for c in components if top <= c['bounds'][1] < bottom), key=lambda c: c['bounds'][0])
        assert len(poses) >= len(anchors), (action, len(poses))
        frames, ids = [], []
        for pose, anchor in zip(poses, anchors):
            clip_id = len(regions) + 1
            ids.append(clip_id)
            x0, y0, x1, y1 = pose['bounds']
            margin_x, margin_y = FOOT[0] + x0 - anchor, FOOT[1] + y0 - baseline
            assert margin_x >= 0 and margin_y >= 0
            assert margin_x + x1 - x0 <= CANVAS[0] and margin_y + y1 - y0 <= CANVAS[1]
            regions.append(f'[sub_resource type="AtlasTexture" id="frame_{clip_id}"]\n'
                           f'atlas = ExtResource("1")\nregion = Rect2({x0}, {y0}, {x1-x0}, {y1-y0})\n'
                           f'margin = Rect2({margin_x}, {margin_y}, {CANVAS[0]-(x1-x0)}, {CANVAS[1]-(y1-y0)})\nfilter_clip = true')
            frames.append('{"duration": 1.0, "texture": SubResource("frame_' + str(clip_id) + '")}')
            # Scanline runs are lossless vector clipping geometry, separate from source color.
            runs = []
            points = sorted(pose['pixels'])
            start = previous = points[0]
            for point in points[1:] + [-1]:
                if point == previous + 1 and point // width == previous // width:
                    previous = point
                    continue
                runs.append(f'M{start % width},{start // width}h{previous-start+1}v1h-{previous-start+1}z')
                start = previous = point
            paths.append(f'<path fill="rgb({clip_id},0,0)" d="{"".join(runs)}"/>')
        manifest[action] = ids
        animations.append('{"frames": [' + ',\n'.join(frames) + '], "loop": ' + str(loop).lower()
                          + f', "name": &"{action}", "speed": {float(fps)}' + '}')
    (OUTPUT / 'frame_masks.svg').write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}">'
                                          + ''.join(paths) + '</svg>\n', encoding='utf-8')
    (OUTPUT / 'clips.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    resource = f'[gd_resource type="SpriteFrames" load_steps={len(regions)+2} format=3]\n\n'
    resource += f'[ext_resource type="Texture2D" path="res://{SOURCE}" id="1"]\n\n'
    resource += '\n\n'.join(regions) + '\n\n[resource]\nanimations = [' + ',\n'.join(animations) + ']\n'
    (ROOT / 'scenes/enemy/blood_hound_frames.tres').write_text(resource, encoding='utf-8')
    print(f'Blood Hound: {len(regions)} aligned frames, {len(animations)} clips; source PNG unchanged.')


if __name__ == '__main__':
    main()
