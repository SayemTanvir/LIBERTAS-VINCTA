# Generated zombie sheets — all 13 actions

This archive contains **208 generated PNG sheets** covering **13 actions and 16 directions**, arranged for the original **4,672 frame cells**.

**These are intermediate generated images, not the requested finished production-quality transparent sprite pack.** The images have been copied without pixel modifications. Magenta backgrounds remain. Final transparency, cell alignment, and individual-frame export await permission to use local image-processing scripts.

The built-in image generation tool created the artwork from the supplied HD character reference. Original sprite sheets supplied the action, pose sequence, and view guides. Exact generation and correction prompts are included.

## Viewing

Extract the whole ZIP and open `preview.html` in a browser. Select an action and direction, play the sequence, or step through frames. Display size and preview FPS are illustrative; they are not native resolution or source timing metadata.

## Contents

- `sheets/<Action>/<Direction>.png`: selected original generated sheets.
- `manifest.json`: native dimensions, grids, direction names, expected frame counts and file hashes.
- `generation_prompts/`: exact prompts used with the built-in tool.
- `source_analysis/`: original animation inventory and reference findings.
- `raw_audit.json`: read-only checks, when present.

## Original structure

| Actions | Frames per direction | Grid |
|---|---:|---|
| Attack1, Idle, Run, Walk | 20 | 4 × 5 |
| Attack2, Attack3, Death1, Death2, Roar | 24 | 6 × 4 |
| Attack4, Lookup | 30 | 6 × 5 |
| Hit1, Hit2 | 16 | 4 × 4 |

Directions: `0`, `022`, `045`, `067`, `090`, `112`, `135`, `157`, `180`, `202`, `225`, `247`, `270`, `292`, `315`, `337`. Nominal directions proceed clockwise from 0 = back/up through 090 = right, 180 = front/down, 270 = left.

## Remaining quality work

The sheets are generated at the native dimensions recorded in the manifest. They are not native 512-pixel-per-frame HD renders. Frame-to-frame anatomy, accessories, proportions, and textures can vary; exact source-pose matching and perfectly smooth motion have not been achieved or certified. The original Lookup/180 repeated cell has not yet been enforced in these unmodified images.

Completing the transparency and registration pass will improve technical usability, but it will not by itself resolve all visual and animation differences. The user's production-quality requirements remain unmet.
