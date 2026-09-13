# LIBERTAS VINCTA: Narrative Canon

Internal spoiler reference for the current game. The supplied `LIBERTAS VINCTA.md` is the story authority. `RULE AND STEPS TO SOLVE THE GAME STORY.md` is the gameplay authority and must describe that story without replacing or extending it.

## Core premise

Els Vantree, a locksmith hired for a private appraisal, wakes in Hollowmere Estate with no memory of entering or of the previous six hours. She remembers an unusually generous offer, the contract, and failing to read its addendum.

Three seals contain Hearing, Sight, and Memory taken from the Deprived One. Opening a seal gives that sense back to the entity and removes a corresponding safety from Els. Freedom is relocated, not destroyed.

Do not invent Els's family history, the Deprived One's identity or origin, a complete explanation of the missing hours, or a final explanation of the containment ritual. The unresolved Vantree connection is intentional.

## Awakening

The opening takes place in the Cold Foyer at 2:47 AM. Els begins collapsed. Her flashlight is several feet away and points away from her. The opening dialogue is:

1. "...Where am I?"
2. "Els Vantree... Hollowmere. The appraisal."
3. "They offered too much. I signed without reading the addendum."
4. "After that... nothing. Six hours just gone."

The flashlight, tools, first locked-door response, doorway transition, and "Hello?" follow this sequence. The recovery animation is presentation only; it must not use death audio or death logic.

## Conservation of freedom

- Hearing lets the entity investigate sound. Els loses the freedom to make noise safely.
- Sight lets the entity recognize light and exposure. Els loses the freedom to move openly.
- Memory lets the entity remember hiding places and predict routes. Els loses the freedom to repeat a safe solution.
- On the Vantree Part II branch, Touch makes floor transmission dangerous. Crouching or standing still does not cancel Touch.

The recurring statement is:

> Freedom is never destroyed.
>
> It only changes hands.

## Part I outcomes

| State | Required exit | Outcome | Part II |
| --- | --- | --- | --- |
| 0 keys, front door tested, zero detections | Front Door, `GF-01` | Untouched | Seeds the gadget branch |
| Hearing only, at least 4 of 7 estate letters | Ritual Conduit, `BS-09` | Vantree | Canon route; seeds Touch and Blood Magic |
| Hearing and Sight | Flood Tunnel, `BS-04` | Partial Mercy | Seeds the Hearing/Sight and partial-sigil branch |
| Hearing, Sight, and Memory | Front Door, `GF-01` | Loop | False exit; resets Part I and does not seed Part II |

The three-key route is never a successful escape. A second completed Loop unlocks `vantree_memory_fragment_A`.

## Part II story beats

- `CR-01` is threat-free and narration-free.
- The first live threat on the Untouched route is `CR-03`.
- `CR-04` automatically reveals the Vantree name carving once per run.
- `CE-01` gives a one-time hint appropriate to the current Part I seed.
- `CE-03` contains the Deprived One's first spoken line only on the Vantree branch: "Els. You have brought your name home."
- The Nexus opens after three successful uses of the current branch mechanic.
- Detection, damage, or releasing the interaction resets an anchor's 20-second channel.

## Nexus outcomes

| Anchor | Ending | Canonical action |
| --- | --- | --- |
| `LN-A` | Severance | Destroy the Deprived One and the inherited bond |
| `LN-B` | Custodian's Rest | Els becomes the living ward |
| `LN-C` | Vessel | Bind the entity into a new key for another hand |

These are the three final outcomes. They do not replace or add to the Part I outcomes. No three-key success route exists.

## Vantree mystery

The progression from "Custodian" to "Jailer," the Vantree letters, the altar carving, and the ritual architecture imply an inherited role. The carving bears Els's full name with a date centuries before her birth. The game leaves the meaning unresolved.

The supplied story's key breadcrumb remains:

> Forgive me, if you're reading this.
>
> It has to be someone.

Interpretations may be labeled as interpretations in spoiler documentation, but they must not become new story facts or alter the implemented endings.

## Player-facing spoiler boundary

The Home and Story pages may establish the appraisal, contract/addendum, six-hour gap, three sealed keys, and the uncertainty over whose freedom is restored. They must not reveal the senses, enemy rules, full Vantree/Jailer truth, ending conditions, Loop, Nexus choices, or sequel implications.
