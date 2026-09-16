# Action animation and Hound response

## Result

Els now has nine generated sprite sheets covering flashlight use and locomotion,
vent entry, door unlocking, piano work, hiding against tall cover, crawling under
furniture, lifting a tool bag, and taking a small key. The sources contain 224 poses
across four authored views; the loader maps them to all eight game directions.
Generation used OpenAI's built-in image tool. Prompts and provenance are recorded
in [the asset folder](../assets/sprites/player/actions/README.md).

## Player presentation

- Raising and lowering the flashlight take 0.42 seconds. The beam appears at the
  switch pose. Walking/running use full-body torch cycles with alternating stride
  and passing poses, and a small beam sway. Movement can interrupt the gesture.
- Vents use a 0.82-second crawl and fade; arrival reverses the crawl into a visible
  standing character. Damage, death and scene changes cancel pending traversal.
- Locks retrieve and turn a key; piano work uses both hands at keyboard height.
  The existing collision-aware door approach and planted piano interaction remain.
- Tall cover uses a tucked stance; tables/beds use a low crawl and curled hold.
  Leaving reverses the corresponding animation and restores the safe approach
  position and collision. Death cancels the cover tween.
- Tool bags have a weighted lift/check/stow sequence. Small keys are pinched,
  inspected and pocketed. Collected world objects and their markers disappear.
- Measured atlas bounds and foot offsets keep the standing character about 69
  game pixels tall. A runtime chroma key removes the generated backing. Source
  PNGs retain their backing; no pixel-processing script changed the artwork.
- Speech bubbles follow the current pose's head height while Els crouches,
  crawls or stands in cover. Table hiding sits behind the front legs.

## Hound

Contact now begins the existing attack animation. Damage occurs at its forward
snap (frame 3), after checking current reach, facing, line of sight and hiding
state. Moving away, passing behind the jaws, or stunning the Hound can avoid the
committed strike. Each attack hits once and has a recovery period.

Chase/audio pursuit accelerates into motion, refreshes obstructed routes faster,
and responds to direction changes sooner. Search/growl cues have cooldowns. The
story's sealed senses, harmless initial stage, remembered cover and Part II damage
rules remain in effect.

## Validation

Checks use isolated saves in `build/`. The dedicated suite verifies every frame's
atlas bounds/ground contact plus torch input, hiding, vent recovery, strike timing,
evasion, stun cancellation, wall blocking and movement response. Native previews
use Godot's Compatibility renderer on Intel Arc graphics.

| Suite | Passed checks |
| --- | ---: |
| Dedicated actions and native rendered previews | 1,653 |
| Gameplay polish / repeated puzzles / input | 139 |
| Smooth gameplay / pickup removal / sight | 60 |
| Hound presentation | 136 |
| Survival / death versus pending travel | 20 |
| Game systems / senses / resources | 67 |
| Native door alignment | 25 |
| Live AI finale routes | 41 |
| Campaign routes / capture / checkpoint recovery | 150 |

Total: **2,291 passed checks** across these suites. The action suite also passed
headlessly during implementation.

All three Part II finale routes completed with live AI. The campaign suite also
completed its alternate routes and three-key loop with capture/recovery. Older
expectations for the shared bag gesture and instant hiding/toggling were updated
to assert the requested distinct behavior. The sight-range test now uses an open
corridor, because added furniture obstructs its previous fixed position.

Normal rendered action previews are saved as `build/actions_e.png`,
`build/actions_n.png`, and `build/actions_gaits.png`. In-room captures cover torch
walking, table cover, tall cover and vent emergence; door key/opening captures
remain in `build/door_key_aligned.png` and `build/door_open_from_key.png`.

The Windows certificate-store warning is present in this environment. One
headless finale run also reported resources retained at shutdown after passing;
it exited successfully. Native action and door runs exited normally. These checks
cover the tested flows and do not substitute for a full manual playtest on every
target machine.
