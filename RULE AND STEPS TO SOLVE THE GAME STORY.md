# LIBERTAS VINCTA: Rules and Steps to Solve the Game Story

> **Full spoiler warning:** This guide reveals every puzzle, story discovery, route rule, Part I ending, Part II branch, and final ending in the current game.

This walkthrough describes the game as it is implemented. Story facts follow the original `LIBERTAS VINCTA.md` specification; the final interpretation section is clearly labeled. The guide can be used as a complete player reference or a checklist for testing a full playthrough.

## 1. The Goal

Els Vantree wakes inside Hollowmere Estate after accepting an appraisal job and losing six hours of memory. The estate contains three sealed keys. Each key restores one stolen sense to the Deprived One:

1. **Hearing** is sealed in the piano on the Ground Floor.
2. **Sight** is sealed in the vanity on the Upper Floor.
3. **Memory** is sealed in the Ritual Chamber in the Basement.

Taking a key makes the monster stronger. The main rule is deliberately unusual:

> **Taking every key is not the winning solution. Freedom depends on knowing when to stop.**

A successful Part I ending unlocks Part II. Part II reveals why Els's family name is tied to the prison and ends with a choice at one of three ritual anchors.

## 2. Controls

| Action | Key | Use |
| --- | --- | --- |
| Move | `WASD` or arrow keys | Walk through rooms and steer Els |
| Sprint | `Shift` | Move quickly, but create more noise and drain the flashlight faster |
| Crouch | `Ctrl` | Move slowly and quietly |
| Interact | `E` | Pick up objects, work locks, read letters, hide, use doors, and channel anchors |
| Flashlight | `F` | Toggle the flashlight |
| Hold breath | `B` | Suppress movement noise for up to 6 seconds; 15-second cooldown |
| Use gadget | `Q` | Use a battery when charge is low, otherwise throw a bottle or place a clock decoy |
| Sigil | `R` | Use Blood Magic or a partial sigil in Part II |
| Stun Rite | `T` | Vantree branch only; stun the monster at a health cost |
| Pause/back | `Esc` | Pause, close a letter, or return from a menu |

The interaction prompt appears when Els is close enough to a usable object. Face the object, move within range, and press `E`.

## 3. Rules That Decide the Endings

### Part I ending table

| Keys taken | Required exit | Extra requirement | Result |
| --- | --- | --- | --- |
| 0 | Front Door in `GF-01` | Test the door once, then interact again; no detections | **Untouched** |
| 1, Hearing only | Ritual Conduit in `BS-09` | Collect at least 4 of the 7 Part I letters | **Vantree**, the canon route |
| 2, Hearing and Sight | Flood Tunnel in `BS-04` | No letter requirement | **Partial Mercy** |
| 3 | Front Door in `GF-01` | Return after taking Memory | **Loop**, a deliberate failure ending |

The three successful Part I endings are Untouched, Vantree, and Partial Mercy. Each provides a different Part II starting state. The Loop does not unlock Part II.

### Key order is fixed

The keys must be taken in this order:

1. Hearing
2. Sight
3. Memory

A later key can be visible before it is available, but interacting with it early only reports that its seal is still holding.

### Lockpick rule

The tool pouch in the opening gives 3 lockpicks. The piano and vanity each consume one lockpick on their first successful attempt, not one per click. The cracked ritual seal is broken without a lockpick.

| Puzzle | Inputs needed | Lockpicks consumed |
| --- | --- | --- |
| Piano seal | Press `E` three times, allowing each action to finish | 1 |
| Vanity seal | Press `E` three times | 1 |
| Cracked ritual seal | Press `E` once | 0 |

There is also a spare lockpick in `GF-07`.

## 4. Recommended Complete Story Route

This is the recommended first successful route. It produces the **Vantree** Part I ending, exposes the central family mystery, unlocks Blood Magic, and follows the canonical path into Part II.

### Chapter 1: Awakening in the Cold Foyer (`GF-00`)

1. Start a new game and let the awakening sequence finish.
2. Walk to the locked Music Room door at the far right and press `E` once. Els confirms that it is locked.
3. Walk back and collect the **flashlight**.
4. Collect the **tool pouch**. It contains 3 lockpicks.
5. Return to the Music Room door and press `E` again.
6. The door opens, the dark passage appears, Els walks through it, and the door closes behind her.

Do not skip the flashlight or tool pouch. The intro door will not let Els leave without both.

### Chapter 2: Ground Floor and the Hearing Key

The Ground Floor runs from `GF-01` on the left to `GF-10` on the right.

```text
GF-01 -> GF-02 -> GF-03 -> GF-04 -> GF-05
      -> GF-06 -> GF-07 -> GF-08 -> GF-09 -> GF-10
```

1. In `GF-01`, read **The Note**. Its warning is the central solution: three wards hold three stolen senses, and freedom is counted by what remains sealed.
2. The Front Door is on the far left. Leave it alone on the Vantree route.
3. Cross `GF-02`. Pick up the battery if desired. The dining table is a low-priority hiding place.
4. Enter `GF-03`, the Music Room. The source-defined tension layer begins before the piano is opened.
5. Stand beside the piano and press `E` three times. Wait for each lockpicking action to finish.
6. When all three steps are complete, collect the nearby **Hearing Key**.
7. The key restores the monster's hearing. A forced sound cue plays and the monster enters Stage 1.
8. Collect **Vantree Letter I** beside the piano.
9. Continue through `GF-04`. Crouch before entering if possible; entering upright creates a loud hanging-pot noise.
10. Collect the two glass bottles in the pantry. The wardrobe is a medium-priority hiding place.
11. In `GF-05`, collect the wind-up clock and inspect the scratched nameplate.
12. In `GF-06`, collect **Vantree Letter II** and use the recharge station if needed.
13. In `GF-07`, collect the spare lockpick. The coat rack is another hiding place.
14. Cross `GF-08` while crouched. Its creaking floor becomes extremely loud when crossed normally or at a sprint.
15. Continue to `GF-09` and use the Upper Stairs. Hearing is required to open this route.

After the Hearing Key, repeated sounds within six seconds cause a fast ten-second hunt. Crouch, use carpet where possible, and avoid immediately sprinting after making a noise.

### Chapter 3: Upper Floor and the Four-Letter Requirement

For the Vantree ending, visit the Upper Floor for letters but **do not take the Sight Key**.

```text
UF-01 -> UF-02 -> UF-03 -> UF-04 -> UF-05 -> UF-06 -> UF-07
```

1. In `UF-01`, collect **Vantree Letter III**.
2. Enter `UF-02`. The bed is a high-priority hiding place.
3. The vanity contains the Sight Key, but leave it locked on this route.
4. Continue to `UF-03` and collect **Vantree Letter IV**.
5. Letter IV changes the family's title from the gentle word "Custodian" to the honest word "Jailer."
6. You now have the four letters required by the Ritual Conduit.
7. Turn back and use the Upper Stairs in `UF-06` to return to the Ground Floor.
8. On the Ground Floor, continue right to the Cellar Stairs in `GF-10`.
9. Use the Cellar Stairs. The Hearing Key unlocks the basement route.

The Upper Floor also contains a battery in `UF-04`, a recharge station in `UF-05`, a bottle near the bathroom, and a vent network. These are optional on this route.

### Chapter 4: Basement and the Vantree Ending

The implemented basement room order is:

```text
BS-01 -> BS-04 -> BS-02 -> BS-03 -> BS-05 -> BS-06 -> BS-09
```

1. Enter through `BS-01` and continue right.
2. Cross `BS-04`, the Flooded Cellar. Water creates a large hearing radius, so crouch if the monster is close.
3. Continue through `BS-02`, the Wine Cellar.
4. In `BS-03`, Els finds the remains of prior Custodians and the final three Part I letters.
5. Letters V, VI, and VII are here. They are optional because Letters I-IV already satisfy the gate, but reading them gives the clearest warning against taking every key.
6. Pass through `BS-05` without breaking the cracked seal. Do not collect Memory.
7. In `BS-06`, collect bottles and a clock if desired. Recharge near the right side before the ending.
8. Continue to `BS-09` and interact with the **Ritual Conduit**.
9. With exactly one key and at least four letters, the conduit recognizes Els's name and triggers the **Vantree** ending.
10. On the ending screen, choose **Descend** to begin Part II.

### Chapter 5: Cathedral Roots

The Vantree ending gives Part II these conditions:

- The monster does not inherit Hearing, Sight, or Memory.
- It mutates a fourth sense: **Touch**.
- Els receives **Blood Magic**.
- Els's maximum health is reduced from 100 to 80.

The Roots run from `CR-01` to `CR-06`:

```text
CR-01 -> CR-02 -> CR-03 -> CR-04 -> CR-05 -> CR-06
```

1. Move through `CR-01`, the threat-free, narration-free entry descent.
2. In the water of `CR-02`, collect **Vantree Letter VIII** and the battery.
3. Cross the rubble maze in `CR-03`. Rubble transmits less vibration than bare stone.
4. Enter `CR-04`; the **Vantree Altar** name-carving reveal triggers automatically and only once.
5. Els finds the names "Custodian," "Jailer," and "Vantree," followed by her own full name carved with a date centuries before her birth.
6. Continue to `CR-05`. Letters IX, X, and XI are optional here.
7. Four crypt alcoves provide hiding places. Avoid relying on only one if the monster has Memory on another branch.
8. Collect the two bottles near the end if desired.
9. Use the Echo Threshold in `CR-06` to enter the Chamber of Echoes.

### Chapter 6: Chamber of Echoes and the Three-Use Gate

The Chamber runs from `CE-01` to `CE-05`:

```text
CE-01 -> CE-02 -> CE-03 -> CE-04 -> CE-05
```

The door to the Nexus opens only after **three successful uses of the current Part II branch mechanic**.

For the Vantree route, use this exact sequence:

1. Enter `CE-01` and read the one-time branch hint. On Vantree it explains that rubble softens Touch and that the forge can buy twelve seconds of silence.
2. Reach the **Sigil Forge** in `CE-02` and interact once.
3. The forge unlocks Blood Magic, costs 8% of maximum health, and counts as use 1 of 3.
4. Press `R` to cast a Blood Sigil. This costs another 8% of maximum health and counts as use 2.
5. Wait for the 20-second sigil cooldown to end.
6. Press `R` again. This counts as use 3.
7. A Blood Sigil suppresses the monster's active senses within a 192-pixel area for 12 seconds.
8. `T` performs the Stun Rite only if the monster is within 192 pixels. A successful rite costs 20% of maximum health, stuns for 6 seconds, and has a 60-second cooldown. An out-of-range attempt spends nothing. Stun Rite does not count toward the three-use gate.
9. In `CE-03`, collect Letters XII and XIII if desired.
10. The Deprived One speaks for the first time: "Els. You have brought your name home."
11. In `CE-04`, collect the three clocks if needed.
12. Reach the Nexus Descent in `CE-05`. Once the counter has reached 3, the door opens.

Alternative Vantree method: movement over the rubble in `CE-04` while the Touch-mutated monster is within 520 pixels counts as a successful Touch evasion. There is a two-second cooldown between counted evasions. Three evasions can open the gate without three forge/sigil actions.

### Chapter 7: Ley-Nexus Finale

`LN-CENTER` is a single locked arena. There is no retreat door. All three anchors are visible at the same time:

```text
LN-A: Destroy       LN-B: Seal Els       LN-C: Bind New Vessel
```

To complete an anchor:

1. Decide which ending you want before starting.
2. Lure the monster away from the chosen anchor.
3. Use a bottle or clock if the monster can hear, or a Blood Sigil/Stun Rite on the Vantree branch.
4. Reach the anchor and hold `E` continuously for 20 seconds.
5. Do not release `E` after the channel begins.
6. Detection or damage resets the channel to zero.
7. Touch is based on floor transmission; crouching and standing still do not make Els undetectable. Move the entity outside the stone transmission radius or suppress it before channeling.

The anchors produce these endings:

| Anchor | Prompt | Ending | Meaning |
| --- | --- | --- | --- |
| `LN-A` | Destroy - Hold E | **Severance** | Els breaks the final bond and permanently destroys the Deprived One |
| `LN-B` | Seal Els - Hold E | **Custodian's Rest** | Els takes the empty place and becomes the living ward |
| `LN-C` | Bind New Vessel - Hold E | **Vessel** | The prison closes around a new key, which an unseen hand carries away |

For the strongest closure, select `LN-A` and complete **Severance**. For the tragic self-sacrifice ending, choose `LN-B`. For the sequel-hook ending, choose `LN-C`.

## 5. Alternate Part I Solutions

### Untouched ending: zero keys

This is the zero-key restraint route. The original design defines it as the hardest Part I ending because it requires zero detections, while its Part II starting state is the safest.

1. Complete the Cold Foyer introduction and enter `GF-01`.
2. Do not unlock the piano and do not take any key.
3. Interact with the Front Door once. This records that Els tested the sealed exit.
4. Interact with the Front Door a second time.
5. If no detection has been recorded and the monster remains at Stage 0, the door opens.
6. The ending states that Els escapes before the house learns her shape and every stolen sense remains sealed.
7. Choose **Descend**.

Untouched Part II state:

- The monster begins with no active senses.
- Els receives at least 3 batteries, 3 bottles, and 3 clocks.
- Els keeps 100 maximum health.
- This is the easiest Nexus difficulty.

Untouched Echo gate solution:

1. Reach the Chamber of Echoes.
2. Keep flashlight charge at 50 or higher so `Q` selects a noise gadget instead of a battery.
3. Press `Q` three times to use three bottles/clocks.
4. Each successful noise-gadget resonance counts toward the gate.
5. Enter `CE-05` and use the Nexus Descent.

### Partial Mercy ending: two keys

1. Complete the piano and collect Hearing.
2. Use the Upper Stairs in `GF-09`.
3. In `UF-02`, press `E` three times at the vanity.
4. Collect the **Sight Key** beside it.
5. The monster now sees in a 110-degree cone and can begin a full chase after 0.6 seconds of confirmed vision.
6. Return to the Ground Floor through `UF-06`.
7. Use the Cellar Stairs at `GF-10`.
8. In the early Basement, reach the Flooded Cellar at `BS-04`.
9. Interact with the **Maintenance Exit / Flood Tunnel**.
10. With exactly two keys, this triggers **Partial Mercy**.
11. Do not take Memory first. Three keys would invalidate this exit.

Partial Mercy Part II state:

- The monster keeps Hearing and Sight.
- Memory remains dormant.
- Els has 100 maximum health.
- Entering `CE-01` unlocks partial sigils.
- A partial sigil costs 4% of maximum health and counts toward the Echo gate.

Partial Mercy Echo gate solution:

1. Enter `CE-01` to unlock the branch ability.
2. Cast `R` three times, waiting for the 20-second cooldown after each cast.
3. After the third successful cast, use the Nexus Descent in `CE-05`.
4. The monster still has Hearing and Sight, so use shadows, crouching, corners, and decoys while waiting for cooldowns.

### Loop ending: all three keys

The Loop is intentional. It demonstrates that collecting everything is another form of imprisonment.

1. Take Hearing from the piano.
2. Take Sight from the Upper Floor vanity.
3. Enter the Basement and reach `BS-05`.
4. Press `E` once at the cracked ritual seal.
5. Collect the **Memory Key**.
6. The monster reaches Stage 3, remembers previously used hiding places, predicts movement, and attempts exit ambushes.
7. Return left through the Basement to the Ground Stairs in `BS-01`.
8. On the Ground Floor, travel all the way left to the Front Door in `GF-01`.
9. Interact with the Front Door.
10. The apparent escape sends Els back to the Grand Foyer instead.
11. Keys, letters, ordinary inventory, hiding history, and monster stage reset. The loop counter increases.
12. The Loop does not unlock Part II.
13. Completing a second Loop unlocks `vantree_memory_fragment_A` in the persistent story flags.

## 6. Complete Room and Pickup Reference

### Cold Foyer

| Room | Required/story objects |
| --- | --- |
| `GF-00` | Flashlight, tool pouch with 3 lockpicks, locked exit to Ground Floor |

### Ground Floor

| Room | Important contents |
| --- | --- |
| `GF-01` Grand Foyer | Front Door, The Note, sabotage-able grandfather clock |
| `GF-02` Dining Hall | Battery, dining-table hiding place |
| `GF-03` Music Room | Piano seal, Hearing Key, Letter I |
| `GF-04` Servant's Pantry | Two bottles, noisy pots, wardrobe hiding place |
| `GF-05` Side Corridor | Clock, scratched nameplate |
| `GF-06` Reading Nook | Letter II, recharge station |
| `GF-07` Coat Room | Spare lockpick, coat-rack hiding place |
| `GF-08` Trophy Hall | Creaking floor, vent route |
| `GF-09` Upper Stairwell | Door to Upper Floor |
| `GF-10` Cellar Stairs | Door to Basement; requires Hearing |

### Upper Floor

| Room | Important contents |
| --- | --- |
| `UF-01` Portrait Gallery | Letter III, long lit sightline |
| `UF-02` Master Bedroom | Bed hiding place, vanity puzzle, Sight Key |
| `UF-03` Nursery | Toybox hiding place, Letter IV, lit exposure area |
| `UF-04` Linen Hall | Vent, battery |
| `UF-05` Bathroom | Recharge station, bottle |
| `UF-06` Stairwell Down | Door back to Ground Floor |
| `UF-07` Vent Junction | Vents to Ground Floor and Basement |

### Basement

| Room | Important contents |
| --- | --- |
| `BS-01` Cellar Stairs | Return door to Ground Floor |
| `BS-04` Flooded Cellar | Loud water floor, two-key Partial Mercy exit |
| `BS-02` Wine Cellar | Vent to Upper Floor |
| `BS-03` Ossuary Nook | Letters V, VI, and VII; Custodian remains |
| `BS-05` Ritual Chamber | Cracked seal and Memory Key |
| `BS-06` Root Cellar | Two bottles, clock, recharge station |
| `BS-09` Ritual Conduit | One-key/four-letter Vantree exit |

### Cathedral Roots

| Room | Important contents |
| --- | --- |
| `CR-01` Entry Descent | Part II entry |
| `CR-02` Flooded Nave | Letter VIII, battery, loud water |
| `CR-03` Collapsed Cloister | Rubble routes and reduced Touch transmission |
| `CR-04` Altar Approach | Vantree name-carving reveal |
| `CR-05` Crypt Row | Letters IX-XI, four hiding alcoves, two bottles |
| `CR-06` Echo Threshold | Door to Chamber of Echoes |

### Chamber of Echoes

| Room | Important contents |
| --- | --- |
| `CE-01` Resonance Hall | Branch mechanic introduction |
| `CE-02` Sigil Forge | Vantree Blood Magic unlock; counts as one mechanic use |
| `CE-03` Vault of Whispers | Letters XII-XIII and the Deprived One's first spoken line |
| `CE-04` Sunken Choir | Rubble Touch-evasion lane and three clocks |
| `CE-05` Nexus Descent | Opens after 3 successful branch-mechanic uses |

### Ley-Nexus

| Room | Important contents |
| --- | --- |
| `LN-CENTER` Convergence | Sealed return threshold and anchors `LN-A`, `LN-B`, `LN-C` |

## 7. All Letter Locations and Story Meaning

| Letter | Location | Revelation |
| --- | --- | --- |
| I | `GF-03` Music Room | Hearing was removed to make the prisoner seem gentle |
| II | `GF-06` Reading Nook | A custodian guards; a jailer decides who is allowed freedom |
| III | `UF-01` Portrait Gallery | The entity watched portraits before it watched people |
| IV | `UF-03` Nursery | "Custodian" was a comforting lie; "Jailer" was honest |
| V | `BS-03` Ossuary Nook | Memory turns every refuge into evidence |
| VI | `BS-03` Ossuary Nook | The roots beneath the house carry an older sentence |
| VII | `BS-03` Ossuary Nook | Leave one ward closed; freedom is not completion |
| VIII | `CR-02` Flooded Nave | The Vantrees inherited the prison rather than building it |
| IX | `CR-05` Crypt Row | Every keeper thought the family name belonged to somebody else |
| X | `CR-05` Crypt Row | The ward passed from hand to hand, each transfer called freedom |
| XI | `CR-05` Crypt Row | The ritual never counted the empty hand |
| XII | `CE-03` Vault of Whispers | The prisoner learned voices from the shape of fear |
| XIII | `CE-03` Vault of Whispers | The entity speaks using the voice of the next keeper |

Only the Vantree ending has a letter requirement: collect any 4 Part I letters. Letters I-IV form the quickest valid set.

## 8. Monster Strength and How to Survive

### Stage 0: Blind

- Speed: 115 pixels per second.
- No hearing or vision detection.
- Contact causes a stumble and a noise, not a lethal chase.
- This stage remains active until Hearing is taken.

### Stage 1: Hearing

- Patrol speed: 142 pixels per second.
- Two audible pings within 6 seconds trigger `HUNT_AUDIO`.
- Hunt speed: 216 pixels per second.
- A hunt lasts 10 seconds without another noise.
- Every new audible noise redirects the monster and restarts the ten-second timer.

Best response: stop creating sound, change direction after the last ping, and crouch across noisy material.

### Stage 2: Sight

- Vision cone: 110 degrees.
- Lit range: 384 pixels.
- Shadow range: 128 pixels.
- An active flashlight increases the monster's effective visual reach by 1.5 times.
- The monster confirms sight after 0.6 continuous seconds.
- Chase speed: 282 pixels per second, faster than Els's 256-pixel sprint.
- A lost chase continues for 5-8 seconds before the monster investigates the last seen position.

Best response: do not try to win a long straight race. Break line of sight around furniture, turn off the flashlight, change vertical lane, and use a decoy after the monster loses sight.

### Stage 3: Memory

- Prediction speed: 238 pixels per second.
- Remembers the last five confirmed player positions.
- Previously used hiding spots are preloaded into its search memory.
- Repeatedly using one hiding place raises its search priority, capped at High.
- Every 2.5 seconds it has a 55% chance to intercept a known exit that Els is moving toward.
- An exit ambush remains active for 10 seconds.

Best response: feint toward one exit, change direction, avoid familiar hiding spots, and keep a bottle or clock for the return to `GF-01`.

### Part II Touch mutation

- Bare stone carries Touch transmission up to 480 pixels.
- Rubble carries vibration up to 160 pixels.
- The elevated Choir lane carries vibration up to 96 pixels.
- Crouching and stillness do not reduce Touch detection.
- Once Touch begins a hunt, the monster uses its 238-pixel true-form speed.

Best response: run over soft debris, avoid bare stone when the entity is close, use the elevated Choir lane, and begin anchor channels only after redirecting or suppressing it beyond transmission range.

### Damage

- In Part I, contact after Hearing is restored causes capture and checkpoint restart.
- In Part II, ordinary contact deals 30 damage.
- A successful remembered-hiding-place check deals 45 damage.
- The Vantree branch begins Part II with only 80 maximum health.

## 9. Noise, Light, Hiding, and Resource Rules

### Noise radius by surface

| Surface | Base hearing radius |
| --- | ---: |
| Carpet | 64 |
| Rubble | 160 |
| Wood | 256 |
| Stone | 320 |
| Water | 448 |
| Glass/creaking floor | 576 |

Sprinting adds more noise. Crouching sharply reduces it. The `GF-08` creaking floor behaves like glass unless Els crouches.

### Flashlight

- Full charge: 90 seconds.
- Normal drain: 1 second of charge per second.
- Sprinting drain: 3 seconds of charge per second.
- Recharge station: hold still through a 12-second interaction.
- A battery adds 45 seconds when charge is below 50.
- The flashlight makes Els easier to see at Stage 2.

### Gadgets

Pressing `Q` chooses automatically:

1. If flashlight charge is below 50 and a battery is available, consume a battery.
2. Otherwise, use a bottle if one is available.
3. If no bottle remains, use a clock.

A bottle creates a 576-pixel noise ping 260 pixels ahead of Els. A clock creates a 384-pixel ping 180 pixels ahead. Face away from the route you want to take before pressing `Q`.

### Hiding

Press `E` at a hiding place to enter it and `E` again to leave. The flashlight turns off automatically. Sight cannot see Els inside an unwitnessed hiding place, but Stage 3 can remember and check locations used before. Rotate between hiding places instead of treating one as permanently safe.

## 10. Checkpoints and Recovery

- The game saves after successful room transitions.
- A recovered sense creates a checkpoint at the key location.
- Capture or death restarts from the latest checkpoint and restores the saved ledger state.
- Capture plays the collapse animation; checkpoint recovery fades in while that animation reverses back to the standing pose. The entity remains inactive until control returns.
- Checkpoint recovery does not replay the doorway arrival or door-closing animation. The saved door is already closed when Els fades back in.
- Continue from the main menu loads the saved zone, position, inventory, keys, letters, monster stage, health, and Part II state.
- Recharge use and ordinary pickups are safest after a recent transition/key checkpoint.

## 11. Story Interpretation

The following reading connects the source-defined events without adding new canon. The appraisal contract draws Els to a place tied to her family. The missing six hours and the ancient carving of her full name suggest that "Els Vantree" may be more than one person's identity, or that the role repeats across the prison's history. The game deliberately leaves that implication unresolved.

The Deprived One is controlled by three stolen senses. Returning Hearing, Sight, and Memory appears merciful, but each act also restores its ability to hunt. The family called themselves Custodians to make the duty sound protective. The letters reveal that they were Jailers who passed responsibility from one hand to the next while calling each transfer freedom.

The three-key Loop is the clearest expression of that idea. Completing the collection does not free Els or the entity. It restores the prison's closed system and sends Els back to the beginning. Greed is punished by repetition rather than a normal game-over screen.

Every valid Part I ending leaves something incomplete:

- **Untouched:** Els refuses the keys and escapes before the monster learns her. The prison remains intact.
- **Vantree:** Els takes Hearing, learns enough family history, and follows the blood-bound conduit. She accepts the family connection without completing the monster.
- **Partial Mercy:** Els restores Hearing and Sight but leaves Memory sealed, escaping through the flood route with an unstable compromise.

Part II reveals that the estate was only the upper structure of a much older prison. The roots and carved names show generations repeating the same transfer. In the Vault of Whispers, the Deprived One uses Els's identity and voice, implying that the next keeper and the prisoner are being shaped into each other.

The Nexus finally gives Els three explicit choices:

- **Severance** ends the entity and the inherited bond.
- **Custodian's Rest** preserves the prison by making Els its living ward.
- **Vessel** repeats the transfer by placing the entity in a new key for another unknown hand.

All three Part II endings close with the story's central statement: freedom in Hollowmere was never simply lost. It was moved between hands, and the real question is who is left empty when the ritual finishes counting.

## 12. Fast Completion Checklists

### Canon Vantree plus Severance

- [ ] Cold Foyer: test door, take flashlight, take tools, leave
- [ ] Ground: solve piano, take Hearing, collect Letters I-II
- [ ] Upper: collect Letters III-IV, do not take Sight
- [ ] Return to Ground and enter Basement
- [ ] Basement: leave Memory sealed, use `BS-09` Ritual Conduit
- [ ] Choose Descend
- [ ] Roots: enter the Vantree Altar room for its automatic reveal, then reach Echo Threshold
- [ ] Echoes: forge once, cast two Blood Sigils, enter Nexus
- [ ] Nexus: hold `E` for 20 seconds at `LN-A`

### Untouched plus any Nexus ending

- [ ] Cold Foyer: collect required gear and leave
- [ ] Ground: test Front Door once, then use it again without taking a key
- [ ] Descend
- [ ] Echoes: use three bottle/clock resonances with `Q`
- [ ] Enter Nexus and channel the chosen anchor

### Partial Mercy plus any Nexus ending

- [ ] Take Hearing
- [ ] Solve vanity and take Sight
- [ ] Enter Basement and use Flood Tunnel in `BS-04`
- [ ] Descend
- [ ] Echoes: cast three partial sigils with `R`
- [ ] Enter Nexus and channel the chosen anchor

### Loop

- [ ] Take Hearing
- [ ] Take Sight
- [ ] Break the ritual seal and take Memory
- [ ] Return to the Ground Floor Front Door
- [ ] Enter the false exit and wake in `GF-01`

## 13. Common Problems

### "The piano/vanity is not opening"

Press `E` for every puzzle step and wait for each action to complete. The piano and vanity each require three completed interactions. Make sure at least one lockpick remains when beginning the puzzle.

The cracked ritual seal in `BS-05` requires Sight and one completed interaction, but it does not consume a lockpick.

### "The Sight or Memory Key will not collect"

Keys are sequential. Sight requires Hearing and a completed vanity. Memory requires Sight and a broken ritual seal.

### "The Ritual Conduit says it is not ready"

You need exactly one key and at least four Part I letters. The quickest set is Letters I-IV.

### "The Flood Tunnel will not open"

It requires exactly two restored senses. Do not take Memory before using it.

### "The Nexus Descent is sealed"

The branch mechanic counter is below 3. Use:

- Three bottle/clock resonances for Untouched.
- The forge plus two Blood Sigils, or three Touch evasions, for Vantree.
- Three partial sigils for Partial Mercy.

### "The anchor keeps resetting"

Detection, damage, or releasing `E` resets the 20-second channel. Redirect the monster first, wait until the chase/search pressure drops, then hold `E` continuously.

### "I took all three keys and lost everything"

That is the intended Loop ending. A real escape requires zero, one, or two keys at the matching exit.

---

**Recommended first ending path:** Vantree -> Severance  
**Most restrained Part I path:** Untouched (designed as the hardest)  
**Balanced Part II path:** Partial Mercy  
**Intentional failure/story discovery:** Loop
