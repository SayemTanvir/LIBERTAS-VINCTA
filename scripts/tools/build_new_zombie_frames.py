"""Prepare the supplied zombie sheets for Godot and build their SpriteFrames resource.

The generated source sheets use #ff00ff as a temporary matte. This tool converts
that matte to real alpha, normalizes each sheet to its documented cell grid, and
builds the directional animations used by the Deprived One scene. The source
artwork under assets/sprites/new_zombie/sheets remains unchanged.
"""

import argparse
from pathlib import Path

from PIL import Image, ImageChops


ROOT = Path(__file__).resolve().parents[2]
SOURCE_ROOT = ROOT / "assets" / "sprites" / "new_zombie" / "sheets"
OUTPUT_ROOT = ROOT / "assets" / "sprites" / "new_zombie" / "transparent"
RESOURCE_PATH = ROOT / "scenes" / "enemy" / "new_zombie_frames.tres"
FOOT_OFFSETS_PATH = ROOT / "scripts" / "enemy" / "zombie_foot_offsets.gd"

# Eight views are enough for the game's movement while retaining the supplied
# cardinal and diagonal artwork without mirroring a one-sided attack.
DIRECTIONS = ("0", "045", "090", "135", "180", "225", "270", "315")
ACTIONS = {
    "idle": ("Idle", 4, 5, 20, 10.0, True),
    "walk": ("Walk", 4, 5, 20, 15.0, True),
    "run": ("Run", 4, 5, 16, 16.0, True),
    "attack": ("Attack1", 4, 5, 20, 14.0, False),
    "sniff": ("Lookup", 6, 5, 30, 12.0, True),
    "stagger": ("Hit1", 4, 4, 16, 14.0, False),
}
CELL_SIZE = 256
FOOT_BASELINE = 220
BASE_OFFSET_Y = -92


def key_magenta_to_alpha(image: Image.Image) -> Image.Image:
    """Turn the generated magenta backing and its edge bleed into transparency."""
    rgb = image.convert("RGB")
    red, green, blue = rgb.split()
    # Fuchsia has both red/blue much stronger than green. Values above 40 are
    # fully transparent; the 8..40 ramp eliminates pink edge halos.
    magenta_strength = ImageChops.subtract(ImageChops.darker(red, blue), green)
    alpha_lut = [255 - max(0, min(255, (strength - 8) * 255 // 32)) for strength in range(256)]
    rgb.putalpha(magenta_strength.point(alpha_lut))
    return rgb


def prepare_sheet(source: Path, destination: Path, columns: int, rows: int) -> None:
    """Normalize a generated grid to exact 256px cells and write transparent PNG."""
    with Image.open(source) as image:
        normalized = image.resize((columns * CELL_SIZE, rows * CELL_SIZE), Image.Resampling.LANCZOS)
        clean = key_magenta_to_alpha(normalized)
        destination.parent.mkdir(parents=True, exist_ok=True)
        temporary = destination.with_name(destination.stem + ".tmp.png")
        clean.save(temporary, compress_level=6)
        with Image.open(temporary) as written:
            written.verify()
        temporary.replace(destination)


def build_resource() -> None:
    textures: dict[str, str] = {}
    regions: list[str] = []
    animations: list[str] = []
    for name, (source_action, columns, rows, frame_count, fps, loop) in ACTIONS.items():
        for direction in DIRECTIONS:
            texture_path = f"assets/sprites/new_zombie/transparent/{source_action}/{direction}.png"
            texture_id = str(len(textures) + 1)
            textures[texture_path] = texture_id
            frames: list[str] = []
            for frame in range(frame_count):
                x = frame % columns
                y = frame // columns
                region_id = f"frame_{len(regions)}"
                regions.append(
                    f'[sub_resource type="AtlasTexture" id="{region_id}"]\n'
                    f'atlas = ExtResource("{texture_id}")\n'
                    f'region = Rect2({x * CELL_SIZE}, {y * CELL_SIZE}, {CELL_SIZE}, {CELL_SIZE})'
                )
                frames.append('{"duration": 1.0, "texture": SubResource("' + region_id + '")}')
            animations.append(
                '{"frames": [' + ',\n'.join(frames) + '],\n'
                f'"loop": {str(loop).lower()},\n'
                f'"name": &"{name}_{direction}",\n'
                f'"speed": {fps}' + '\n}'
            )
    text = f'[gd_resource type="SpriteFrames" load_steps={len(textures) + len(regions) + 1} format=3]\n\n'
    text += '\n'.join(
        f'[ext_resource type="Texture2D" path="res://{path}" id="{resource_id}"]'
        for path, resource_id in textures.items()
    )
    text += '\n\n' + '\n\n'.join(regions)
    text += '\n\n[resource]\nanimations = [' + ',\n'.join(animations) + ']\n'
    RESOURCE_PATH.write_text(text, encoding="utf-8")


def build_foot_offsets() -> None:
    """Generate per-frame offsets that keep the zombie's lowest foot planted."""
    entries: list[str] = []
    for name, (source_action, columns, rows, frame_count, _, _) in ACTIONS.items():
        for direction in DIRECTIONS:
            sheet_path = OUTPUT_ROOT / source_action / f"{direction}.png"
            with Image.open(sheet_path) as image:
                alpha = image.convert("RGBA").getchannel("A")
                offsets: list[int] = []
                for frame in range(frame_count):
                    x = (frame % columns) * CELL_SIZE
                    y = (frame // columns) * CELL_SIZE
                    cell_alpha = alpha.crop((x, y, x + CELL_SIZE, y + CELL_SIZE))
                    # A thin dangling chain can extend below a planted foot. Reduce
                    # each row to its average alpha coverage, then take the lowest
                    # row with a substantial silhouette instead of the lowest pixel.
                    row_coverage = cell_alpha.resize((1, CELL_SIZE), Image.Resampling.BOX)
                    foot_bottom = FOOT_BASELINE
                    for row in range(CELL_SIZE - 1, -1, -1):
                        if row_coverage.getpixel((0, row)) >= 12:
                            foot_bottom = row + 1
                            break
                    offsets.append(BASE_OFFSET_Y + FOOT_BASELINE - foot_bottom)
            values = ", ".join(str(offset) for offset in offsets)
            entries.append(f'\t"{name}_{direction}": PackedFloat32Array([{values}])')
    text = "# Generated by scripts/tools/build_new_zombie_frames.py.\n"
    text += "class_name ZombieFootOffsets\n\n"
    text += f"const BASE_OFFSET_Y := {BASE_OFFSET_Y}.0\n"
    text += "static var frame_offset_y := {\n" + ",\n".join(entries) + "\n}\n\n"
    text += "static func offset_y(animation: StringName, frame: int) -> float:\n"
    text += "\tvar values = frame_offset_y.get(str(animation), PackedFloat32Array())\n"
    text += "\tif values.is_empty():\n\t\treturn BASE_OFFSET_Y\n"
    text += "\treturn values[clampi(frame, 0, values.size() - 1)]\n"
    FOOT_OFFSETS_PATH.write_text(text, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Export transparent zombie sheets and SpriteFrames.")
    parser.add_argument("actions", nargs="*", choices=sorted({details[0] for details in ACTIONS.values()}), help="Source actions to export; defaults to all.")
    parser.add_argument("--resource-only", action="store_true", help="Only rebuild new_zombie_frames.tres.")
    args = parser.parse_args()
    selected_actions = set(args.actions) if args.actions else {details[0] for details in ACTIONS.values()}
    for source_action, columns, rows, _, _, _ in ACTIONS.values():
        if args.resource_only or source_action not in selected_actions:
            continue
        for direction in DIRECTIONS:
            source = SOURCE_ROOT / source_action / f"{direction}.png"
            destination = OUTPUT_ROOT / source_action / f"{direction}.png"
            if not source.is_file():
                raise FileNotFoundError(source)
            prepare_sheet(source, destination, columns, rows)
    build_resource()
    build_foot_offsets()
    prepared = 0 if args.resource_only else len(selected_actions) * len(DIRECTIONS)
    print(f"Prepared {prepared} transparent sheets, {RESOURCE_PATH.relative_to(ROOT)}, and {FOOT_OFFSETS_PATH.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
