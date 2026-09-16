# Seated piano assets — Stage 1 rejected drafts

Stage 1 is **not complete**. No image in this folder is approved for runtime use.
The built-in image generator was used with Els's original `../../idle.png`
and the existing `assets/environment/props/music_room/piano1.png` as references.
The piano already contains its wooden stool, so no duplicate chair was requested.

Both attempts returned **1774 x 887 RGB PNGs with no alpha channel**, despite
requests for a 2048 x 1024 RGBA atlas with 256 x 256 cells. A targeted background
extraction retry still contained a painted checkerboard. The loop also shows
lower-body variations that require further correction before fixed-hip approval.

- `rejected/els_piano_draft.png`: initial seated idle, eight-frame playing loop,
  three sit frames and three stand frames.
- `rejected/els_piano_alpha_retry.png`: failed transparency correction.
- `prompts.json`: exact generation prompt and correction brief.

The drafts resemble Els's hair and outfit but do not meet the strict production
specification. No compliant animation sheets or transparent GIF/APNG previews
are claimed. No existing piano code, animation resource or artwork was removed
or replaced. Stage 2 remains blocked by asset quality, not by missing permission.

Required next asset: a real RGBA atlas with fixed-size cells, stable seated hips
and legs, correct hands/seat alignment and the original character identity.
