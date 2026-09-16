# Asset credits

Environment dressing now uses the supplied Food & Drink 2D Mega Props Pack and piano sheet. Physics geometry remains generated independently of artwork. UI uses a project-authored native Godot Theme with system-font placeholders (Georgia/Times New Roman and Segoe UI/Arial, with engine fallback); no font files are bundled. Character and footstep integration uses the supplied assets listed below.

The existing `icon.svg` came with the repository. Confirm its provenance and release suitability before using it as the final game icon.

Add a row for every third-party asset before release. Keep original license files alongside the imported assets where required.

| Asset / file path | Creator | Original source URL | License / version | Modifications | Required credit text |
| --- | --- | --- | --- | --- | --- |
| `assets/ui/menu/hollowmere_dark_menu.png` | OpenAI image generation, 2026-09-16 | Generated for this project; full prompt in adjacent README | Generated output | Uniform cover scaling; source PNG unchanged | AI provenance recorded |
| `assets/environment/props/estate_front/furniture_front.png` | OpenAI image generation, 2026-09-16 | Generated for this project from supplied bench and domestic references; adjacent README | Generated output | Nine front-facing crops, cached background masking, grounded shadows | AI provenance recorded |
| `assets/environment/props/estate_essentials/powerstation.jpg` | Not identified in supplied file | Supplied by project owner, 2026-09-15 | Not supplied | Runtime state crops and checkerboard masking; source unchanged | Not supplied |
| `assets/BG/11_intro/01_house_animation.png` through `04_storm_rain_mist.png` | Not identified in supplied folder | Supplied by project owner | Not supplied | House reference and animated effect crops; original PNGs unchanged | Not supplied |
| `assets/BG/11_intro/05_house_hd.png` | OpenAI image generation, 2026-09-15 | Supplied house sheet used as reference; adjacent README | Generated output | Complete 1254 x 1254 background, lossless import | AI provenance recorded |
| `assets/environment/props/food_drink_2d_mega_props/Tiles/` | nacl1234; pack README discloses AI-assisted artwork | Food & Drink 2D Mega Props Pack v1.0, supplied by project owner; source URL not supplied | Supplied commercial license, retained at `assets/environment/props/food_drink_2d_mega_props/LICENSE.txt` | Selection of 39 PNGs for estate dressing; Godot atlas regions, scaling and tint; source files unchanged | No specific credit wording required in supplied license; original copyright is 2026 nacl1234 |
| `assets/environment/props/music_room/piano1.png` | Not identified in supplied image | Supplied by project owner | Not supplied | Godot atlas region selects grand piano and bench; source PNG unchanged | Team to confirm provenance and required attribution |
| `assets/environment/props/estate_essentials/estate_essentials.png` | OpenAI image generation, generated for this project on 2026-09-12 | Built-in imagegen; prompt and provenance in adjacent README | Generated output, not part of the commercial props pack | Six cached Godot atlas regions with transparent-margin trimming; source PNG unchanged | AI provenance recorded; no third-party attribution supplied |
| `assets/environment/props/cathedral/cathedral_props.png` | OpenAI image generation, generated for this project on 2026-09-13 | Built-in imagegen; prompt and provenance in adjacent README | Generated output | Six atlas slices with transparent-margin trimming | AI provenance recorded; no third-party attribution supplied |
| `assets/environment/props/cathedral/survival_pickups.png` | OpenAI image generation, generated for this project on 2026-09-13 | Built-in imagegen; prompt and provenance in adjacent README | Generated output | Four atlas slices with transparent-margin trimming | AI provenance recorded; no third-party attribution supplied |
| `assets/environment/props/estate_domestic/estate_domestic_props_alpha.png` | OpenAI image generation, generated for this project on 2026-09-13 | Built-in imagegen; prompt and provenance in adjacent README | Generated output | Four atlas slices; edge-connected checker background converted to alpha after the built-in transparency retry remained opaque | AI provenance recorded; no third-party attribution supplied |
| `assets/sprites/player/*.png` | AI-generated; supplied by project owner | See `assets/sprites/player/prompts.json` and README | See supplied asset provenance | Godot atlas regions, animation mapping and scene scaling; original PNGs unchanged | See supplied provenance |
| `assets/sprites/player/crouch/els_crouch_sheet.png` | OpenAI image generation, 2026-09-15 | Generated for this project using supplied Els artwork as reference; adjacent README | Generated output | Atlas alignment and runtime masking of neutral backing | AI provenance recorded |
| `assets/sprites/player/actions/*.png` | OpenAI built-in image generation, 2026-09-16 | Nine dedicated sheets using supplied Els idle artwork as identity reference; adjacent README and prompts.json | Generated output | Built-in background/gait corrections, measured atlas bounds, foot alignment and runtime chroma key | AI provenance recorded |
| `assets/sprites/zombie/Skin2_x256_Spritesheets/` | Not identified in supplied folder | Supplied by project owner | Not supplied | Godot atlas regions, animation mapping and scene scaling; original PNGs unchanged | Not supplied |
| `assets/BG/02_Enemy/blood_hound_horror_monster_animation_sprite_sheet.png` | Not identified in supplied folder | Supplied by project owner | Not supplied | Current main enemy; aligned atlas regions, vector clipping masks, mirrored facing and animation mapping; original PNG unchanged | Not supplied |

| `assets/audio/Footsteps/Antons_Footsteps_FS_Wood_Walk_01.wav` through `_07.wav` | Not identified; filename prefix is Antons_Footsteps | Supplied by project owner | Not supplied in folder | Playback cadence, gain and restrained pitch variation; original WAVs unchanged | Team to confirm license and required attribution |

Do not list planned assets as installed. Team-created final assets should be identified separately with their creator's preferred credit.

Seated-piano drafts under `assets/sprites/player/actions/piano_seated/rejected/`
were generated with OpenAI's built-in image generation on 2026-09-16. These are
rejected review artifacts, not installed game artwork; their README records the
failed transparency/grid checks and reference sources.

The props pack license permits use in games and distribution embedded in an end
product; it does not permit distributing the standalone source assets. The local
integration does not publish or redistribute the pack.
