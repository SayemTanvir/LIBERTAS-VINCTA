# AI disclosure

The project contains AI-generated raster artwork.

- `assets/sprites/player/actions/piano_seated/rejected/*.png`: two seated-piano drafts generated with OpenAI's built-in image generation on 2026-09-16 using Els's supplied idle sheet and the existing piano as references. Both failed alpha/grid validation and are excluded from runtime use; see the adjacent README and prompts.json.

- `assets/sprites/player/actions/*.png`: nine dedicated action sheets generated with OpenAI's built-in image generation on 2026-09-16. They cover torch use and locomotion, vents, door unlocking, piano work, tall/low cover, bag pickup and key pickup. The supplied Els idle sheet was the identity reference. Adjacent README and `prompts.json` record generation, corrections, atlas alignment and runtime chroma keying.

- `assets/ui/menu/hollowmere_dark_menu.png`: generated with OpenAI's built-in image generation on 2026-09-16 for the dark Gothic main menu. The adjacent README records the full prompt; source PNG unchanged.

- `assets/environment/props/estate_front/furniture_front.png`: generated with OpenAI's built-in image generation on 2026-09-16 for front-facing manor furniture; references, prompt brief and runtime masking are recorded in its adjacent README.

- `assets/BG/11_intro/05_house_hd.png`: generated with OpenAI's built-in image generation on 2026-09-15 from the supplied house contact sheet; native resolution 1254 x 1254. See the adjacent README.

- `assets/environment/props/estate_essentials/estate_essentials.png`: generated for this project on 2026-09-12. The adjacent README records its prompt and atlas use.
- `assets/environment/props/cathedral/cathedral_props.png`: generated with OpenAI's built-in image generation tool on 2026-09-13 for the cathedral rubble, sarcophagus, altar, forge, Nexus anchor, and ritual seal.
- `assets/environment/props/cathedral/survival_pickups.png`: generated with OpenAI's built-in image generation tool on 2026-09-13 for battery, bottle, clock, and lockpick pickups.
- `assets/environment/props/estate_domestic/estate_domestic_props_alpha.png`: generated with OpenAI's built-in image generation tool on 2026-09-13 for the upper-floor bed, toy chest, washstand, and bathtub. The adjacent README records the prompt and alpha cleanup.
- `assets/sprites/player/*.png`: supplied by the project owner with AI-generation provenance in that folder's README and prompt files.
- `assets/sprites/player/crouch/els_crouch_sheet.png`: generated with OpenAI's built-in image generation on 2026-09-15 for visible crouching, sneaking and shelter poses. Its adjacent README records the reference, prompt and runtime background masking.

The cathedral prompts and their project use are recorded in `assets/environment/props/cathedral/README.md`; the domestic prompt set is recorded in `assets/environment/props/estate_domestic/README.md`. Gameplay code, collision, room data, AI rules, and atlas slicing remain editable project source.
