# Hollowmere cinematic source sheets

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
