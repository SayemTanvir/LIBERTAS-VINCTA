# Front-facing manor furniture

`furniture_front.png` was generated with OpenAI's built-in image generation tool
on 2026-09-16, using the project's supplied wooden bench and previous domestic
atlas as visual references. Native size: 1254 x 1254, RGB. The original file is
preserved, including its painted checkerboard; runtime crops remove connected
background through `scripts/levels/furniture_cutout.gd` and cache transparency.
Mask seeds also clear the bench and chair gaps without erasing ivory upholstery.

Nine crops in `data/estate_art.json`: bench, sideboard, bookcase, settee, bed,
toy chest, washstand, bathtub and chair. The chair also dresses dining/high-chair
placements. Furniture uses level front elevations, zero bench rotation, foot
origins and shallow contact shadows. Existing gameplay footprints stay separate
from art; ordinary and charging tables now also have physical footprints.

## Generation brief

Create a 3-column by 3-row atlas of exactly nine individual furniture sprites.
Use the existing domestic furniture identity/materials and wooden bench style.
Change viewpoint to face straight toward the camera with level horizontal edges,
symmetric front elevation and only a slight view of top surfaces. No isometric
or three-quarter angles, diagonal tilt or receding side panels. Complete feet
rest on a shared horizontal baseline. Crisp hand-painted 2D shading, walnut,
dark teal outlines, burgundy cloth, ivory and antique brass. Row 1: bench,
sideboard, bookcase. Row 2: settee, bed viewed from the foot end without canopy,
open toy chest. Row 3: mirrored washstand with basin/jug, horizontal broadside
clawfoot bathtub, slatted dining chair. Complete isolated objects with generous
padding. No floor, external shadows, labels, gridlines or watermarks. Request
transparent RGBA output; the delivered RGB backing is masked at runtime.
