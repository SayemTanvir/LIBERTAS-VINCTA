# LIBERTAS VINCTA Floor Map Generation Prompts

These prompts are designed to generate tactical overhead maps in the style of the supplied reference image: grayscale aerial/architectural background, pale cyan room outlines, readable white labels, and a bright yellow player marker.

Use one prompt per image. Keep the same visual language, label treatment, camera angle, and color palette across the complete map set.

## Shared Visual Direction

Append this to every prompt:

> Create a tactical top-down exploration map for a psychological survival-horror game. Use a grayscale aerial architectural texture as the background, with charcoal black, foggy gray, desaturated blue-gray, and muted green-gray surfaces. Draw all walls, room boundaries, fences, paths, doors, tunnels, and blocked areas with thin glowing pale-cyan lines. Use clean white condensed sans-serif labels placed inside or beside locations. Use a small bright yellow triangular player marker with a subtle dark outline. Preserve a slightly worn surveillance-map texture, restrained contrast, soft vignette, mild film grain, and a believable overhead navigation layout. Make every label legible and correctly spelled. No decorative fantasy symbols, no UI panels, no legend, no compass unless requested, no extra locations, no invented text, no perspective distortion, no 3D game-render look. 16:9 composition, high readability, game map asset, consistent scale and line weight.

## Map Set Rules

- Keep all maps north-up and top-down.
- Use the same cyan line color, label font, marker shape, and grayscale treatment.
- Show room boundaries and navigable corridors, but do not expose hidden puzzle solutions or enemy sensory ranges.
- Mark inaccessible areas as dark filled shapes with a cyan boundary and a label such as `SEALED`, `FLOODED`, or `NO ENTRY`.
- Show doors, vents, stair transitions, and major route connectors as small breaks or cyan chevrons.
- Place the yellow player marker only where stated in the individual prompt. It may be omitted for a clean map version.
- Do not add unimplemented rooms, weapons, NPCs, cars, modern signs, or unrelated buildings.

---

## 1. Cold Foyer / Intro Map

> Tactical overhead map of the Cold Foyer and awakening area inside Hollowmere Estate. Show a compact rectangular entrance hall with a large locked Grand Foyer door at the south side, a cold tiled floor, wall paneling, a separated flashlight pickup point, the tool pouch pickup point, an awakening position near the center, and a dark passage leading toward the Ground Floor. Label exactly: `COLD FOYER`, `GRAND FOYER DOOR`, `FLASHLIGHT`, `TOOL POUCH`, `AWAKENING POSITION`, `GROUND FLOOR`. Use a sparse layout with no enemy marker and no extra rooms. Place the yellow triangular player marker at `AWAKENING POSITION`.

[Append the Shared Visual Direction.]

## 2. Ground Floor Map

> Tactical overhead map of the Ground Floor of Hollowmere Estate. Show one connected horizontal estate floor with a central Grand Foyer and clear walking lanes between rooms. Arrange these labeled regions from west to east in a believable connected layout: `GF-01 GRAND FOYER`, `GF-02 DINING HALL`, `GF-03 MUSIC ROOM`, `GF-04 SERVANT'S PANTRY`, `GF-05 SIDE CORRIDOR`, `GF-06 READING NOOK`, `GF-07 COAT ROOM`, `GF-08 TROPHY HALL`, `GF-09 UPPER STAIRWELL`, `GF-10 CELLAR STAIRS`. Show the front door in the Grand Foyer, the Hearing key seal in the Music Room, hiding furniture silhouettes in the Dining Hall and Pantry, and stair connectors toward the Upper Floor and Basement. Keep the rooms connected through corridors and doors, not isolated floating buildings. Mark the unexplored outer edge as `NO ENTRY` without inventing another exit. Place the yellow triangular player marker in `GF-01 GRAND FOYER`.

[Append the Shared Visual Direction.]

## 3. Upper Floor Map

> Tactical overhead map of the Upper Floor of Hollowmere Estate, directly above the Ground Floor. Show a long connected upper hallway with rooms branching from it. Label exactly: `UF-01 PORTRAIT GALLERY`, `UF-02 MASTER BEDROOM`, `UF-03 NURSERY`, `UF-04 LINEN HALL`, `UF-05 BATHROOM`, `UF-06 STAIRWELL DOWN`, `UF-07 VENT JUNCTION A`. Show the Sight vanity seal inside the Master Bedroom, a hiding spot in or beside the Linen Hall, a vent connector at Vent Junction A, and stair connections at Stairwell Down. Include dark blocked wall sections and narrow service passages while preserving a clear central route. Do not add a second floor, rooftop, or outdoor map. Place the yellow triangular player marker near `UF-06 STAIRWELL DOWN`.

[Append the Shared Visual Direction.]

## 4. Basement Map

> Tactical overhead map of the Basement beneath Hollowmere Estate. Show damp masonry, flooded sections, narrow cellar corridors, storage rooms, and ritual chambers in one connected but threatening layout. Label exactly: `BS-01 CELLAR STAIRS`, `BS-02 WINE CELLAR`, `BS-03 OSSUARY NOOK`, `BS-04 FLOODED CELLAR`, `BS-05 RITUAL CHAMBER`, `BS-06 ROOT CELLAR`, `BS-09 RITUAL CONDUIT`. Show the Flood Tunnel route from the Flooded Cellar, the cracked Memory seal in the Ritual Chamber, bottle racks in the Wine Cellar, and the Ritual Conduit as a sealed end chamber. Use dark water textures and cyan edge lines around flooded areas. Mark the deepest inaccessible edge as `SEALED ROOTS`. Place the yellow triangular player marker in `BS-01 CELLAR STAIRS`.

[Append the Shared Visual Direction.]

## 5. Cathedral Roots Map

> Tactical overhead map of the Cathedral Roots chapter beneath the estate. Show a large irregular underground cathedral complex with flooded stone lanes, collapsed masonry, roots, crypt-like side chambers, and long navigable corridors. Label exactly: `CR-01 ENTRY DESCENT`, `CR-02 FLOODED NAVE`, `CR-03 COLLAPSED CLOISTER`, `CR-04 ALTAR APPROACH`, `CR-05 CRYPT ROW`, `CR-06 ECHO THRESHOLD`. Show CR-01 as a quiet entry descent, CR-03 as the first dangerous live-threat area, CR-04 as a central altar route with the Vantree name carving, and CR-06 as the transition toward the Chamber of Echoes. Use broken cyan wall lines around collapsed sections, shallow water shapes, rubble blockers, and dark voids beyond the playable route. Do not show the final Nexus or any ending anchors. Place the yellow triangular player marker at `CR-01 ENTRY DESCENT`.

[Append the Shared Visual Direction.]

## 6. Chamber of Echoes Map

> Tactical overhead map of the Chamber of Echoes, a buried ritual-industrial complex connected to Cathedral Roots. Show a branching map with resonant halls, broken choir flooring, a blood-sigil forge, a whisper vault, a sunken choir, and a sealed descent route. Label exactly: `CE-01 RESONANCE HALL`, `CE-02 SIGIL FORGE`, `CE-03 VAULT OF WHISPERS`, `CE-04 SUNKEN CHOIR`, `CE-05 NEXUS DESCENT`. Show the three-use branch gate at Nexus Descent, the Sigil Forge as a marked interaction chamber, flooded gaps and rubble lanes, and a strong cyan boundary around the sealed passage to the Ley-Nexus. Include subtle clocks, ward lines, and echo chambers as environmental shapes, but no readable lore text. Do not show the three final anchors. Place the yellow triangular player marker in `CE-01 RESONANCE HALL`.

[Append the Shared Visual Direction.]

## 7. Ley-Nexus / Convergence Map

> Tactical overhead map of the final Ley-Nexus Convergence arena. Show one large circular or polygonal underground chamber with a central Ward Bell, a closed return threshold, perimeter hiding screens, ward lanterns, and three clearly separated approach lanes leading to three final anchors. Label exactly: `LN-CENTER CONVERGENCE`, `WARD BELL`, `CLOSED RETURN`, `LN-A SEVERANCE`, `LN-B CUSTODIAN'S REST`, `LN-C VESSEL`, `HIDING SCREEN`, `WARD LANTERN`. Keep all three anchors visible at the same time and make each approach navigable. Show the outer chamber as a dark void beyond the playable boundary. Do not depict the ending outcome, the Hound, or a completed ritual; this is a neutral final-choice map. Place the yellow triangular player marker beside the `WARD BELL`.

[Append the Shared Visual Direction.]

---

## Optional Clean Map Variant

For a developer map without a player position, replace the final sentence of any prompt with:

> Do not include a player marker. Keep the map neutral and suitable for a field guide or developer documentation page.

## Optional Gameplay State Variant

For a live gameplay map, replace the marker sentence with:

> Place the yellow triangular player marker at `[CURRENT ROOM]`, and show only already discovered room labels while leaving undiscovered regions darker and less distinct. Do not reveal hidden routes or enemy positions.

## Negative Prompt

> photorealistic satellite imagery, bright modern GPS interface, roads, cars, weapons, enemies, invented room names, misspelled labels, extra floors, fantasy castle layout, 3D perspective, isometric view, colorful minimap, neon colors, UI frame, legend, compass rose, quest icons, item icons, large text outside the map, cropped labels, unreadable typography, warped walls, disconnected corridors, duplicated rooms, watermarks, logos, creator signature

## Recommended Outputs

Generate at least two versions of each zone:

1. **Clean developer map:** all room labels and route connectors, no player marker.
2. **Gameplay map:** discovered labels only, current yellow player marker, no hidden route disclosure.

Suggested filenames:

- `floor_map_intro.png`
- `floor_map_ground.png`
- `floor_map_upper.png`
- `floor_map_basement.png`
- `floor_map_roots.png`
- `floor_map_echoes.png`
- `floor_map_nexus.png`
