# Hollowmere cinematic source sheets

## HD background upgrade (2026-09-15)

The runtime now uses `05_house_hd.png`, a complete **1254 x 1254 RGB** image
generated with OpenAI's built-in image generation using `01_house_animation.png`
as reference. It replaces the tiny house crops described below. The original
four sheets remain unchanged; bats, lightning and weather remain animated.
The new image is imported losslessly, without resizing, and sampled as a whole
with square proportions during the slow camera approach. It is a detailed
reconstruction of the Gothic house rather than a pixel-identical enlargement.

Prompt summary: Reconstruct one high-resolution view of the supplied Gothic
mansion, preserving its asymmetrical stone architecture, pointed right tower,
amber windows, upper-right full moon, trees, mist and rain-wet approach. Resolve
masonry, slate, window mullions and reflections in cinematic painted realism.
Retain the midnight teal palette. Single square scene, opaque sky, no labels,
text, bats, lightning or rain streaks (these are animated separately).
The prompt requested ideally 2048 x 2048; delivered native resolution is 1254 x 1254.

## Original sheet integration (superseded for the house)

All four PNGs were supplied by the project owner. Their original pixels are unchanged.

| Sheet | Runtime use |
| --- | --- |
| `01_house_animation.png` | Cropped base, rain and fog views, slowly dissolved during the camera approach. The printed headers and frame numbers are excluded. |
| `02_bat_flight.png` | Eight nonuniform wing poses, aligned at the body and isolated with texture-coordinate polygons. Seven bats cross at two depths. |
| `03_lightning.png` | A cropped bolt with a soft illumination pulse, paired with delayed thunder. |
| `04_storm_rain_mist.png` | Moving, blended weather samples with feathered tile boundaries. |

Implementation: `scripts/intro/estate_cinematic.gd` and `shaders/intro_estate.gdshader`.
The title sequence lasts 22.4 seconds, then hands off to `awakening.gd`.
Enter/Space or the Skip button fades to the wake-up scene. Escape opens the existing pause menu.
Continue/checkpoint entry bypasses this exterior sequence. New Game resets it.

The house source is a 1536×1024 contact sheet; each usable house view is approximately
185×180 pixels, despite the resolution text printed in the image. Runtime presentation
uses filtered sampling and alpha cleanup; it does not claim these are full-HD source frames.
