# Widescreen home menu

Generated using OpenAI's built-in image generation tool in image-edit mode on 2026-09-14.

- `main_menu_start_active.png`: 1672 x 941 expanded scene with additional ceiling and floor, replacing the earlier 1785 x 881 (~2.03:1) composition.
- `main_menu_highlight_regions.png`: matching neutral Start and active Continue, Settings, Rules, Credits, Exit crops.

The menu shares one background across all six states. Display scaling is uniform on both axes. The approximately half-pixel aspect-ratio rounding difference from exact 16:9 is covered at the edges rather than letterboxed. Other desktop aspect ratios crop outer scenery; button labels and actions are unchanged. AI outpainting reconstructs decorative detail. Previous artwork remains in `../restored/`.

## Expansion prompt

Use case: precise-object-edit / vertical outpainting. This existing home menu is TOO WIDE (1785x881 ~2.03:1) and produces black bars at top and bottom on a 16:9 game screen. Regenerate it as a TRUE 16:9 high-resolution landscape fullscreen image, preferably 1920x1080. IMPORTANT: DO NOT stretch, vertically squash, zoom, crop, or redesign the existing image. Add natural new scenery ABOVE AND BELOW the existing composition until the canvas is 16:9. The existing artwork should span the full width and occupy about 87.75% of output height, centered vertically, with about 6.125% new imagery above and 6.125% below. Paint a seamless continuation of carved timber architecture, chandelier/ceiling above and reflective patterned gothic stone floor below. All original objects retain their proportions and relative positions. Preserve the existing six-button parchment design, exact typography character and labels 'Start', 'Continue', 'Settings', 'Rules', 'Credits', 'Exit', same order. Preserve title 'LIBERTAS VINCTA', subtitle 'Hollowmere Estate', and icons/labels 'HEARING', 'SIGHT', 'MEMORY'. Start only is highlighted cream/gold; all other buttons dim parchment. High-resolution clean sharp detail matching the input. No black strips, bars, blank margins, letterboxing, frames, or borders on ANY edge. Single 16:9 full screen image filled edge to edge with detailed scene. Do not add any extra UI or labels.

## Selection-source prompt

Use case: precise-object-edit. Make a matching selection atlas from this exact newly expanded 16:9 home menu. Preserve its pixel dimensions 1672x941, exact background, positions, shapes, text and font sizes. ONLY change button illumination: Start becomes neutral muted parchment like current Continue. ALL FIVE lower buttons Continue, Settings, Rules, Credits, Exit become bright pale cream with luminous gold borders exactly like the input Start. Keep their current widths, heights, filigree, label styles and locations unchanged, do not enlarge highlighted buttons. Multiple simultaneous highlights are intentional; this is a source image from which individual selected buttons will be cropped. No change to any other scene detail, title, icons, layout or aspect ratio; no bars, borders, blur, additional text or controls.
