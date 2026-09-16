# LIBERTAS VINCTA — Final Horror Game Content Bible

**Hollowmere Estate · Complete spoiler edition · 16 September 2026**

This document answers the supplied eight-part content-generation brief. It combines the existing story and playable routes with newly authored room descriptions, complete letters, inspection copy, and ending presentation. It is a narrative and environmental design deliverable; writing this file does not install its new prose or cinematics in the game.

**Reading key:** **Established** means supported by the current canon or runtime data. **Authored expansion** means final proposed writing or visual direction created for this document. **Implementation gap** identifies a difference that must be resolved before the corresponding proposed experience can ship. Throughout the object catalog, detailed wear, ownership interpretations, and suggested inspection lines are authored expansions unless explicitly identified as existing text. Actual item quantities, coordinates, gates, and state changes come from the current project.

The story deliberately withholds Els's ancestry, the entity's origin, the full six missing hours, and the ultimate origin of the ritual. Those unknowns remain unknown. The document supplies a complete playable narrative without presenting invented answers as canon.

**Source basis:** [Story canon](STORY_CANON.md), [existing walkthrough](../RULE%20AND%20STEPS%20TO%20SOLVE%20THE%20GAME%20STORY.md), [room layout](../data/estate_layout.json), [estate art](../data/estate_art.json), [room dressing](../data/room_dressing.json), and the ledger, interactable, player, enemy, room, atmosphere, and field-guide scripts. Where prose guidance differs from code, this document calls out the difference. The original `LIBERTAS VINCTA.md` cited by the canon reference was not found in the workspace; this document uses the available canon reference.

### Document navigation

**37 rooms · 610 catalog entries · 13 complete letter expansions · 80 walkthrough steps**

1. [CORE GAME CONCEPT](#concept)
2. [FULL BACKGROUND STORY (LORE)](#lore)
3. [MAIN GAME STORY (PLAYER-FACING NARRATIVE)](#narrative)
4. [ROOM-BY-ROOM / AREA-BY-AREA BREAKDOWN](#rooms)
5. [EVERY OBJECT — FULL DETAIL (this is the most important section)](#objects)
6. [PUZZLES AND HINTS](#puzzles)
7. [SCARES AND EVENTS](#events)
8. [FULL STEP-BY-STEP WALKTHROUGH GUIDE](#walkthrough)

The catalog is intentionally exhaustive. For a direct playing route, start with Section 8; for object-level implementation, use Section 5.

<a id="concept"></a>

## 1. CORE GAME CONCEPT

### Title, genre, and tone

**LIBERTAS VINCTA.** A two-part, 2D psychological survival-horror game about a locksmith who mistakes opening locks for becoming free. Quiet exploration becomes sound-sensitive pursuit, then exposure-sensitive pursuit, then a struggle against a creature that remembers the player's solutions. The central terror is a rule the player understands too late: each apparent gain grants the prisoner something it lacked.

The tone is restrained, intimate, and physical: cloth brushing wood, a key resisting a lock, footsteps becoming suddenly consequential. Large scares punctuate irreversible choices. Routine movement, menus, and readable instructions remain dependable so uncertainty belongs to the house and its story.

### Setting

**Hollowmere Estate**, an isolated private residence built over Cathedral Roots, the Chamber of Echoes, and the Ley-Nexus. The country, calendar year, and construction dates are unspecified. The playable night begins at **2:47 AM**. The visible design language combines an old paneled estate, domestic service corridors, brick cellars, buried ecclesiastical stone, and later electrical equipment. These materials suggest successive occupation; they do not establish a precise historical period.

Authored art direction: upper rooms retain tarnished brass and faded plum upholstery; the lower house moves toward damp green-black masonry; buried spaces introduce cold cyan wards and restrained blood-red ritual light. Keep silhouettes, exits, and cyan power-station markers legible within the darker theme. Flickering lamps are local, eased brownouts. They do not secretly alter the enemy's detection rules.

### Protagonist

- **Name:** Els Vantree.
- **Age:** adult; exact age is not established and should remain unspecified in published biography.
- **Occupation:** locksmith, hired for a private appraisal.
- **Personality — authored characterization:** professionally patient, observant with her hands, skeptical of spectacle, uncomfortable admitting that an attractive fee overrode her judgment. Under pressure she describes concrete facts before naming her fear.
- **Reason for coming:** an unusually generous appraisal offer at Hollowmere. She signed the contract without reading its addendum.
- **What she knows:** her name, profession, destination, the offer, and her signature.
- **What she does not know:** how she entered, what happened during the previous six hours, why the house contains her name, or whose freedom its keys restore.
- **Immediate desire:** recover her tools and leave. Her later decision concerns who must carry the prison after her departure.

### Threat

**The Deprived One**, represented in play by the **Blood Hound**, is the imprisoned entity. Its original identity, species, creator, and ultimate intentions are unconfirmed. Its observed behavior is to investigate, pursue, remember, and exploit faculties returned to it. Recovery of agency is a supported dramatic interpretation of that behavior; a secret human identity is not established.

| State | What the Hound can do | What Els must change |
| --- | --- | --- |
| No restored senses | Wander without hearing or sight; a blind physical bump staggers Els but is not a lethal capture | Learn movement and approach; do not mistake this behavior for the later pursuit rules |
| Hearing restored | Investigate a heard sound; two heard sounds within six seconds or a glass event initiate an audio hunt | Crouch, choose quieter surfaces, and place distractions away from the intended route |
| Sight restored | Detect exposure, facing, line of sight, and the flashlight; hearing remains active | Lower the light, use actual cover, and leave the viewing cone |
| Memory restored | Revisit used hides and predict travel, in addition to Hearing and Sight | Change hiding places and routes; repeating a refuge is evidence |
| Vantree Part II | Ordinary senses are dormant; mutated Touch tracks nearby floor transmission, including a stationary or crouched Els | Use separation, rubble, blood circles, and timed stuns |
| Partial Mercy Part II | Hearing and Sight remain active; Memory remains sealed | A partial circle blocks Hearing only; cover still matters |
| Untouched Part II | All three ordinary senses remain dormant | Use the gadget route; do not describe an unsupported sensory awakening |

The current Untouched Hound first becomes an active encounter at CR-03, but its stage-zero contact remains a nonlethal stagger. A lethal Untouched chase would require a separately approved mechanics change; this bible does not quietly grant it Touch or Sight.

In Part I, a committed successful attack causes capture. In Part II, attacks reduce HP. The attack winds up and checks reach, facing, cover, and hiding state again at its strike frame. Blood circles suppress senses while the Hound is inside their area; they do not make Els immune to contact. Doors and furniture are spatial constraints, not universal sanctuaries. There is no salt, firearm, spoken exorcism, or piano melody that defeats the entity.

### Theme and victory

> Freedom is never destroyed.
>
> It only changes hands.

The principal theme is the responsibility hidden inside relief: removing one's burden can transfer it to somebody else. Collecting everything is deliberately not the optimal solution.

Part I has three successful chapter outcomes, each leading into Part II: Untouched, Vantree, and Partial Mercy. Taking all three keys and using the front door causes the **Loop**, a false escape. Part II ends by completing **one** of three 20-second anchors: Severance, Custodian's Rest, or Vessel. Capture/depleted HP ends an attempt and offers checkpoint recovery. A locked passage, exhausted battery, interrupted charge, or canceled anchor is recoverable rather than a separate ending.

### Presentation standard for the whole game

Authored final direction: use a consistent dark paper-and-brass interface with clear typography, generous spacing, visible keyboard focus, and one primary action per menu panel. Character speech uses a softly outlined bubble anchored to the speaker's actual head; its width, height, and pagination adapt to the text and viewport. Narration uses a separate restrained title-card treatment with no cloud shape. Letter reading pauses play and uses full-page copy with readable pagination. Do not place narrative text over the action's hands or interaction target.

Torch raise and lower, torch walk and run, vent entry and emergence, door unlocking, piano work, table concealment, wall concealment, bag pickup, and key pickup have distinct physical actions. Hands approach the object, feet stay planted during work, and the body returns smoothly to locomotion. The piano's progress must remain usable from either valid approach without teleporting Els. Loose keys, clocks, batteries, and the bag stay at believable hand scale and disappear after acquisition; their pickup animation must not leave a second floor copy. Decorative furniture does not inherit an E prompt merely because it resembles an interactive hide or charger.

<a id="lore"></a>

## 2. FULL BACKGROUND STORY (LORE)

### Chronology of what can actually be established

| Time | Event | Evidence and limit |
| --- | --- | --- |
| Before the present house | A containment structure exists in the roots and older stone | Letters VI and VIII; its builder and original purpose are unknown |
| An undated earlier custodial period | The imprisoned being is deprived of Hearing, Sight, and Memory, held in three wards | The seals and letters; the exact original rite is withheld |
| Successive periods of occupation | People maintain and transfer the burden, calling the office Custodian and later Jailer | Letters II, IV, IX, and X; no reliable named family tree survives |
| An impossible inscription date | A carving records Els Vantree with a date centuries before her birth | CR-04; no exact year or explanation is supplied by canon |
| Before this night | Els accepts a lucrative appraisal and signs without reading the addendum | Her remembered opening dialogue; the signatory offering the work is unidentified |
| Six hours before awakening through 2:47 AM | Els has no accessible memory of this interval | Approximately 8:47 PM to 2:47 AM if interpreted as a continuous six-hour interval; that start time is a calculation, not a second recorded clock |
| 2:47 AM | Els wakes collapsed in the Cold Foyer, separated from her flashlight | Fixed opening beat |
| The playable night | Els opens or refuses wards, reads evidence, chooses an exit, and faces the consequences below | Player action determines the chapter route and final anchor |

No supernatural claim about every clock stopping simultaneously is needed. The foyer time establishes the opening; the missing hours establish vulnerability. Neither is a numeric combination puzzle.

### The people behind the evidence

**Els Vantree:** the only fully named present protagonist. The letters and altar connect her name to a custodial role, but kinship, reincarnation, fabrication, and temporal repetition remain interpretations. Her fate is determined at the Nexus.

**The earlier custodians/jailers:** unnamed predecessors whose surviving papers describe the ward system and its moral evasions. The thirteen letters below use an anonymous first-person custodial voice as authored presentation. They do not establish that all thirteen share one author or that any author is Els's ancestor. Their individual deaths, dates, and personal relationships are not known.

**The appraisal's contracting party:** the unidentified source of the offer. Their relationship to the estate and their fate are unknown. The signed addendum matters because Els consented without understanding; its full legal language has not survived in the available canon and is not fabricated here.

**The Deprived One:** a captive with recovering capacities and, on one route, a voice. The evidence establishes confinement and successive transfers, not innocence, benevolence, or an original crime.

### What caused the horror

The remote inciting incident—the first imprisonment—is intentionally unrecorded. The immediate inciting incident is clear: Els accepts the appraisal, loses six hours, and wakes within a mechanism that makes her professional habit of opening locks dangerous. The first key does not create the creature. It returns Hearing to something already present.

The estate makes the older prison look domestic. A piano disguises a ward as intricate hardware; a vanity turns exposure into a private-room puzzle; a cracked ritual stone abandons that disguise. Service furniture, chargers, and supplies suggest repeated maintenance. That last implication is authored environmental interpretation, not proof of a named perpetrator.

### Reveal ladder

1. The opening establishes a contract and a missing interval without naming a villain.
2. The foyer note says that the keys concern stolen senses.
3. Hearing's acquisition immediately demonstrates who receives the benefit.
4. Letters II and IV strip the respectable title Custodian down to Jailer.
5. Letters V–VII explain remembered refuge, older stone, and the danger of completion.
6. Letter VIII places the buried structure before the house.
7. CR-04 places Els's full name inside an impossible chronology.
8. Letters IX–XI turn individual escape into a sequence of transfers.
9. On Vantree alone, the entity speaks Els's name in CE-03.
10. The Nexus makes the transfer explicit: destroy the bond, become its ward, or carry it forward in another key.

### The fullest reveal and the meaning of “true ending”

**Vantree is the canon Part I route, not a fourth final ending.** A Vantree run with all accessible letters delivers the fullest supported reveal before any final choice: the appraisal has brought Els into an inherited custodial structure; recovering the keys returns faculties to the prisoner; the house repeatedly mistakes the movement of captivity for its abolition; and Els's name is already present in a history she cannot explain.

The game does not resolve the missing six hours, identify the first jailer, or prove how the ancient carving was made. Severance destroys the entity and inherited bond; Custodian's Rest makes Els the living ward; Vessel binds the entity into a new key for another hand. None retrospectively provides an unsupported origin story. The canon breadcrumb remains:

> Forgive me, if you're reading this.
>
> It has to be someone.

That plea is evidence of rationalization, not evidence that a particular relative wrote it.

<a id="narrative"></a>

## 3. MAIN GAME STORY (PLAYER-FACING NARRATIVE)

### Act 1 – Setup

Black resolves into the Cold Foyer at 2:47 AM. Els is on the floor; her dropped flashlight illuminates a place she cannot yet reach. Recovery is a waking movement, without death audio. Her exact opening lines are:

> ...Where am I?
>
> Els Vantree... Hollowmere. The appraisal.
>
> They offered too much. I signed without reading the addendum.
>
> After that... nothing. Six hours just gone.

She tests the locked Music Room-labeled door: “Locked.” Then: “Of course.” The naming is an existing presentation quirk: this door loads the Ground Floor at the Grand Foyer rather than directly placing her beside the piano. She recovers the flashlight—“Mine...” / “How did it get over there?”—and the tool pouch—“At least I came prepared.” Her hands make a competent unlocking movement. The door opens, the building creaks, and she calls “Hello?” No reply identifies the creature.

The Grand Foyer offers a front door and a note. The quiet route is already possible: test the front door, then use it again without taking a key or being detected. Most players instead interpret the house as a collection of tasks and move toward the Music Room. The first piano seal rewards patience; its key rewards the wrong participant. The resulting screech and Els's “Something heard that.” transform the preceding footsteps into a new threat.

### Act 2 – Escalation

The player crosses service rooms and learns that haste has an acoustic cost. A pantry entry can strike hanging cookware. Carpet, deliberate crouching, and distractions matter after Hearing. The upper floor recasts private comfort as evidence: covered painted eyes in the letter, a bedroom refuge, a vanity ward, a nursery letter that uses the word Jailer.

At the midpoint, the task changes from collecting keys to choosing which ward to leave closed. The cellar does not reward blind completion. Its letters make the warning explicit. A player with Hearing and sufficient evidence can use the Ritual Conduit; one with Hearing and Sight can take the Flood Tunnel; one with all three is led back to the front door and repetition.

The successful chapter card offers Continue to Part II. Cathedral Roots begins with a narration-free, threat-free descent. The first encounter follows that rest. Flooded stone and rubble give the altered rules physical form. CR-04 reveals the name carving automatically, without demanding an E interaction from a player passing through. Els does not solve her genealogy; she realizes the role may already include her.

### Act 3 – Climax

The Chamber of Echoes teaches the consequence of the chosen exit. Vantree uses Touch and Blood Magic; Partial Mercy retains Hearing and Sight with a cheaper partial sigil; Untouched uses clockwork and glass. Three successful branch uses open the descent. The count is a mechanical demonstration, not a concealed numeric riddle.

On Vantree, CE-03 gives the Deprived One its first spoken line:

> Els. You have brought your name home.

The two other branches do not receive this line. At Convergence the return is sealed. The player sees three clearly named anchors and a Ward Bell that grants enough time for one uninterrupted choice. The horror is no longer which key fits. It is what Els will make the next person inherit.

### Every outcome and trigger

| Outcome | Exact trigger | Narrative result |
| --- | --- | --- |
| Untouched | Part I, zero keys, zero detections; test and then reuse the Front Door in GF-01 | Els refuses the first transfer; Part II supplies a gadget kit with at least three batteries, three bottles, and three clocks |
| Vantree | Part I, Hearing only and at least four of seven estate letters; Ritual Conduit in BS-09 | Els follows the custodial evidence; Part II has 80 maximum HP, Touch, and unlockable Blood Magic |
| Partial Mercy | Part I, Hearing and Sight, no Memory; Flood Tunnel in BS-04 | Els preserves one ward; Part II has 100 maximum HP, Hearing/Sight, and the partial sigil |
| Loop | Part I, all three keys; Front Door in GF-01 | Apparent completion returns Els to the Grand Foyer; keys, ordinary inventory, letters, and hiding history reset |
| Severance | Part II, complete LN-A for 20 continuous seconds | Destroy the Deprived One and inherited bond |
| Custodian's Rest | Part II, complete LN-B for 20 continuous seconds | Els becomes the living ward |
| Vessel | Part II, complete LN-C for 20 continuous seconds | Bind the entity into a new key for another hand |

Authored ending presentation, preserving those actions:

- **Severance:** the chosen anchor fractures inward; the Hound's outline and the lines of the ward fail together. Hold on an empty space where pursuit used to be. Els: “No next keeper.” End card: “The captive and the bond are destroyed.” Do not imply that the entity survives elsewhere.
- **Custodian's Rest:** the ward's light resolves around Els's standing silhouette. Her hand closes as the outer architecture settles. Els: “Then the door stays with me.” End card: “Els Vantree becomes the living ward.” The scene is acceptance with a cost, not a reward for suffering.
- **Vessel:** the converging lines contract into a key. Els lifts it with the same deliberate pickup movement used earlier, now understood differently. Els: “Small enough to carry. Heavy enough to pass on.” End card: “The prison waits in another key.” Do not introduce a named sequel protagonist or show the transfer as already completed.
- **Loop:** the apparent exit gives way to the Grand Foyer recovery. Use recognition, a brief interruption in sound, and the restored starting condition. Do not play a conventional victory card or unlock Part II.

### Emotional purpose

The player should finish remembering an action they performed confidently before understanding its beneficiary. The final choice should feel informed and personally owned. Restraint is allowed to count as skill; completion is allowed to be a trap. The unresolved name should remain troubling after the mechanical rules have become clear.

<a id="rooms"></a>

## 4. ROOM-BY-ROOM / AREA-BY-AREA BREAKDOWN

The current map contains **37 named rooms across seven zones**. Rooms within a zone are contiguous horizontal spaces; moving east or west crosses an open room boundary. Only explicitly cataloged doors and vents perform scene travel. Coordinates below are internal zone coordinates, supplied for unambiguous placement rather than intended HUD text. The normal walkable depth is approximately y=354–634.

Room lighting descriptions are art direction. Current Sight exposure is determined by configured x-ranges and line of sight, not the brightness of an individual flickering sprite. Likewise, the painted pantry bypass and upper shadow lane do not independently supply their implied mechanical protection in the current implementation.

### Intro

#### GF-00 — Cold Foyer

- **Physical layout:** A long paneled waiting foyer, cold tile under a collapsed body, seats along the margins, and a flashlight beam facing away from Els. The far door is the first clear vertical landmark.
- **Narrative purpose:** The estate first treats Els like an expected visitor who has missed the beginning of her own appointment.
- **Gameplay:** Wake, test the locked exit, retrieve flashlight and pouch, then unlock. No monster is instantiated here.
- **Map placement:** intro, x=0–1800; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** none; use the designated exit or final interaction. Travel doors and vents are listed individually below.

### Ground

#### GF-01 — Grand Foyer

- **Physical layout:** A carpeted reception span between the left front door and the eastward domestic rooms. The note and clock interrupt the formal symmetry; a cyan service marker remains readable in the gloom.
- **Narrative purpose:** Place refusal within reach before the player learns to equate progress with keys.
- **Gameplay:** Read the note, optionally sabotage the clock, test the front door, or continue. This is both the Untouched exit and the later Loop exit.
- **Map placement:** ground, x=0–720; configured floor types: WOOD, CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** east to GF-02. Travel doors and vents are listed individually below.

#### GF-02 — Dining Hall

- **Physical layout:** A long dining space with an actual under-table hide, displaced seating, a battery near the east end, and eleven warm bulbs sagging overhead.
- **Narrative purpose:** A room arranged for company now teaches the difference between a human gathering and a noise source.
- **Gameplay:** Collect the battery; use the marked table hide. After Hearing, an ambient noise source near the dining area can attract investigation.
- **Map placement:** ground, x=720–1440; configured floor types: WOOD, CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-01; east to GF-03. Travel doors and vents are listed individually below.

#### GF-03 — Music Room

- **Physical layout:** The piano occupies the central work zone. Its small separate key and letter sit farther east, bracketed by weak candlelight and a sideboard.
- **Narrative purpose:** A locksmith sees a tractable mechanism before realizing she has serviced a prison.
- **Gameplay:** Complete three piano interactions, take Hearing separately, read Letter I. Allow space for planted piano work and a readable key pickup.
- **Map placement:** ground, x=1440–2160; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-02; east to GF-04. Travel doors and vents are listed individually below.

#### GF-04 — Servant's Pantry

- **Physical layout:** A service pantry crowded at the rear with cookware and shelving. A screen-like wardrobe provides concealment; bottles lie farther east. Broken-glass dressing leads toward the corridor.
- **Narrative purpose:** Routine domestic work becomes a sound hazard as soon as Hearing returns.
- **Gameplay:** Enter crouched to avoid the cookware event; take two bottles and learn the marked hide. The decorative glass is not a separately implemented GLASS surface here.
- **Map placement:** ground, x=2160–2880; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-03; east to GF-05. Travel doors and vents are listed individually below.

#### GF-05 — Side Corridor

- **Physical layout:** A narrow-feeling side passage built from benches, a service sideboard, a loose clock, and a scratched nameplate. The lower lane leaves room to pass the rear furniture.
- **Narrative purpose:** Absence becomes evidence: a name has been removed more carefully than the rest of the room was maintained.
- **Gameplay:** Collect the wind-up clock, examine the nameplate, and continue quietly. The painted lower bypass does not itself override WOOD to CARPET in current code.
- **Map placement:** ground, x=2880–3600; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-04; east to GF-06. Travel doors and vents are listed individually below.

#### GF-06 — Reading Nook

- **Physical layout:** A reading recess with shelves, a low table, a surviving letter, and a conspicuous power station. The overhead darkness makes the page and service marker the focal points.
- **Narrative purpose:** The first linguistic distinction between keeping a door and deciding who needs one enters play here.
- **Gameplay:** Read Letter II; charge if needed while watching the approach.
- **Map placement:** ground, x=3600–4320; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-05; east to GF-07. Travel doors and vents are listed individually below.

#### GF-07 — Coat Room

- **Physical layout:** A coat room of empty stands, a cart, and waiting furniture. A small spare lockpick lies near the eastward ordinary table.
- **Narrative purpose:** Tools and garments outlast the people who were meant to collect them.
- **Gameplay:** Take the spare lockpick; use the specifically marked coat-rack hide, not every decorative stand.
- **Map placement:** ground, x=4320–5040; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-06; east to GF-08. Travel doors and vents are listed individually below.

#### GF-08 — Trophy Hall

- **Physical layout:** The Trophy Hall is currently dressed mainly with service furniture, a hatch, cookware, and two ordinary tables; its room name survives more grandly than its contents.
- **Narrative purpose:** An impressive household label conceals functional back-of-house space. Do not invent collectible trophy heads to match the name.
- **Gameplay:** Crouch over the creaking surface. A vent connects to UF-04. There is no active charger in this room.
- **Map placement:** ground, x=5040–5760; configured floor types: WOOD, CREAK; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-07; east to GF-09. Travel doors and vents are listed individually below.

#### GF-09 — Upper Stairwell

- **Physical layout:** A stairwell landing with a bench, shelves, an ordinary table, and a vertical passage marker. The approach has fewer competing objects than the service corridor.
- **Narrative purpose:** The house first permits vertical progress after Els has restored Hearing.
- **Gameplay:** Use the Hearing-gated Upper Floor passage; optional charge before ascent.
- **Map placement:** ground, x=5760–6480; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-08; east to GF-10. Travel doors and vents are listed individually below.

#### GF-10 — Cellar Stairs

- **Physical layout:** A cellar access room with crates, washing vessels, a candle table, and the descent at the far end. Darker masonry is suggested beyond the door frame.
- **Narrative purpose:** Domestic storage points toward the more explicit prison below.
- **Gameplay:** Use the Hearing-gated cellar passage; charge before entering the basement if required.
- **Map placement:** ground, x=6480–7200; configured floor types: WOOD; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to GF-09. Travel doors and vents are listed individually below.

### Upper

#### UF-01 — Portrait Gallery

- **Physical layout:** An upper gallery with carpet, shelves, seating, and Letter III near the east end. The authored portrait motif belongs to the letter; placed collectible photographs are absent.
- **Narrative purpose:** The statement about covered painted eyes anticipates Sight without proving that portraits are alive.
- **Gameplay:** Read Letter III; approach the bedroom quietly; recharge if needed.
- **Map placement:** upper, x=0–1000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** east to UF-02. Travel doors and vents are listed individually below.

#### UF-02 — Master Bedroom

- **Physical layout:** A bedroom with a bed large enough for a marked under-bed refuge and a vanity assembled from a sideboard, mirror frame, and vase. Faded upholstery absorbs the torch beam.
- **Narrative purpose:** A private room turns visibility into the next transferable freedom.
- **Gameplay:** Three vanity interactions can release the Sight Key after Hearing. Leave it sealed on Vantree. The bed is a high-priority remembered refuge after Memory.
- **Map placement:** upper, x=1000–2000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-01; east to UF-03. Travel doors and vents are listed individually below.

#### UF-03 — Nursery

- **Physical layout:** A nursery of low furniture, a toy chest, a high chair, screens, and a water set. No child appears or speaks. The letter lies toward the far side.
- **Narrative purpose:** Familiar care objects frame the explicit word Jailer without inventing a child victim.
- **Gameplay:** Read Letter IV; use only the marked toy-box hide. Do not search decorative toys for an invented combination.
- **Map placement:** upper, x=2000–3000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-02; east to UF-04. Travel doors and vents are listed individually below.

#### UF-04 — Linen Hall

- **Physical layout:** A linen passage with chairs, shelves, a sideboard book, and a vent near its western side. A battery sits farther east.
- **Narrative purpose:** The estate has a service circulation system that can be learned and revisited.
- **Gameplay:** Collect the battery; the vent returns to the ground-floor Trophy Hall. Use cover rather than relying on painted shadow alone.
- **Map placement:** upper, x=3000–4000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-03; east to UF-05. Travel doors and vents are listed individually below.

#### UF-05 — Bathroom

- **Physical layout:** A bathroom with a washstand, screen, tub, water vessels, a loose bottle, and a charger. Cold highlights replace the warmth of the bedroom.
- **Narrative purpose:** A place for washing cannot cleanse the consequences of the seals.
- **Gameplay:** Collect the bottle and recharge. The bathtub and decorative screen are not extra hiding interactions.
- **Map placement:** upper, x=4000–5000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-04; east to UF-06. Travel doors and vents are listed individually below.

#### UF-06 — Stairwell Down

- **Physical layout:** A descending landing with seats and ordinary tables; the ground-return door is the central functional landmark.
- **Narrative purpose:** A reliable return route allows the player to act on what the letters revealed.
- **Gameplay:** Return to GF-09. Both tables are ordinary; use UF-05 or UF-07 for charging.
- **Map placement:** upper, x=5000–6000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-05; east to UF-07. Travel doors and vents are listed individually below.

#### UF-07 — Vent Junction A

- **Physical layout:** The ventilation junction has shelves, a bench, small candle furniture, and two separate vent mouths. The usable floor ends at the zone boundary.
- **Narrative purpose:** Service shortcuts connect grand architecture to the cellar it conceals.
- **Gameplay:** Choose the ground vent or the basement vent by its prompt. A legacy candle table beyond x=7000 is unreachable dressing, flagged for removal rather than a hidden room.
- **Map placement:** upper, x=6000–7000; configured floor types: CARPET; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to UF-06. Travel doors and vents are listed individually below.

### Basement

#### BS-01 — Cellar Stairs

- **Physical layout:** Stone stairs open into a cellar landing with crates and a pot. The return door stays near the western end.
- **Narrative purpose:** The cellar remains part of a working house before its prison function becomes unmistakable.
- **Gameplay:** Remember the route back to GF-10; charge before crossing water.
- **Map placement:** basement, x=0–800; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** east to BS-04. Travel doors and vents are listed individually below.

#### BS-04 — Flooded Cellar

- **Physical layout:** A flooded span interrupts the basement before the wine cellar. Floating-looking highlights, wet masonry, bottle storage, and a maintenance exit frame the crossing.
- **Narrative purpose:** An escape route is present before its precise moral condition is understood.
- **Gameplay:** Water carries loud footsteps. The Flood Tunnel accepts exactly Hearing and Sight. The station restores charge, not silence.
- **Map placement:** basement, x=800–2000; configured floor types: STONE, WATER; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-01; east to BS-02. Travel doors and vents are listed individually below.

#### BS-02 — Wine Cellar

- **Physical layout:** Wine shelves, racks, sideboards, and a service vent divide a long stretch of stone. Candlelight catches bottle shoulders more readily than the floor.
- **Narrative purpose:** Preservation and storage provide the domestic vocabulary for keeping something indefinitely.
- **Gameplay:** Use the upper vent if useful; navigate around actual shelf footprints. Decorative bottles are not unlimited throwable inventory.
- **Map placement:** basement, x=2000–3200; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-04; east to BS-03. Travel doors and vents are listed individually below.

#### BS-03 — Ossuary Nook

- **Physical layout:** An ossuary recess puts sarcophagi beside repurposed wine storage and three separate pages. Each letter has its own pickup position along the room.
- **Narrative purpose:** The papers shift the story from a house with a monster to a sequence of keepers beneath a house.
- **Gameplay:** Read Letters V, VI, and VII. The crypt furniture here is not a registered hide.
- **Map placement:** basement, x=3200–4300; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-02; east to BS-05. Travel doors and vents are listed individually below.

#### BS-05 — Ritual Chamber

- **Physical layout:** A lit ritual chamber exposes a cracked stone seal and a separate Memory Key. A book-and-candle sideboard still echoes the estate above.
- **Narrative purpose:** The last lock has abandoned domestic camouflage; completion is visibly a ritual act.
- **Gameplay:** Sight permits one 1.25-second seal break without a lockpick. Taking Memory commits the three-key state; skip it for successful Part I exits.
- **Map placement:** basement, x=4300–5400; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-03; east to BS-06. Travel doors and vents are listed individually below.

#### BS-06 — Root Cellar

- **Physical layout:** Root storage combines shelving, a lectern, crates, candles, two bottles, and a loose clock. A power station stands close to the east end.
- **Narrative purpose:** Supplies suggest somebody expected movement through this place to continue.
- **Gameplay:** Collect the bottles and clock; recharge; choose whether to continue toward the conduit or return toward the appropriate exit.
- **Map placement:** basement, x=5400–6400; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-05; east to BS-09. Travel doors and vents are listed individually below.

#### BS-09 — Ritual Conduit

- **Physical layout:** A final cellar span opens around the Ritual Conduit. A screen and narrow tables mark the sides, while the door-shaped threshold dominates the eastern end.
- **Narrative purpose:** The house offers descent only to a player who has limited acquisition and gathered evidence.
- **Gameplay:** Use the conduit with Hearing only and at least four estate letters. No power station is installed here.
- **Map placement:** basement, x=6400–7200; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to BS-06. Travel doors and vents are listed individually below.

### Roots

#### CR-01 — Entry Descent

- **Physical layout:** An entry descent of bare buried stone, benches, rubble, a candle, and a recovery station. The room leaves deliberate visual and acoustic space around Els.
- **Narrative purpose:** Give the player time to feel the cost of the chapter outcome before introducing another rule.
- **Gameplay:** Threat-free and narration-free. Walk and recover without a compulsory monologue or scare.
- **Map placement:** roots, x=0–1000; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** east to CR-02. Travel doors and vents are listed individually below.

#### CR-02 — Flooded Nave

- **Physical layout:** Water fills the nave beneath an architecture older than the house. A letter and battery lie toward the far side; the ordinary tables do not offer power.
- **Narrative purpose:** Letter VIII makes the inherited prison older than its domestic facade.
- **Gameplay:** Collect Letter VIII and the battery. On the first forward visit before CR-03, threat suppression still applies; later return travel can be dangerous.
- **Map placement:** roots, x=1000–2000; configured floor types: STONE, WATER; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CR-01; east to CR-03. Travel doors and vents are listed individually below.

#### CR-03 — Collapsed Cloister

- **Physical layout:** Collapsed cloister masonry breaks the floor into rubble, benches, and a narrow-feeling passage. The charger stands near the western side.
- **Narrative purpose:** The altered enemy rules become physical before they are explained in text.
- **Gameplay:** First active encounter, including Untouched. Rubble reduces Touch transmission compared with intact stone; keep distance and recover only when an approach is clear.
- **Map placement:** roots, x=2000–3000; configured floor types: STONE, RUBBLE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CR-02; east to CR-04. Travel doors and vents are listed individually below.

#### CR-04 — Altar Approach

- **Physical layout:** The altar approach opens into a lit expanse with a blood-toned altar, candles, and names cut into stone. The composition makes the inscription the unavoidable focal point.
- **Narrative purpose:** Els’s name becomes part of the architecture rather than an answer provided by another character.
- **Gameplay:** Automatically reveal the impossible carving once. No charging station is installed here.
- **Map placement:** roots, x=3000–4000; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CR-03; east to CR-05. Travel doors and vents are listed individually below.

#### CR-05 — Crypt Row

- **Physical layout:** A long crypt row alternates sarcophagi and four marked alcoves. Three letters and a pair of bottles draw a path through the recesses.
- **Narrative purpose:** The succession of individual containers makes the transfer of a burden tangible.
- **Gameplay:** Collect Letters IX–XI, use the marked alcoves carefully, take the bottles, and recharge. Touch is not defeated merely by entering a hide.
- **Map placement:** roots, x=4000–5200; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CR-04; east to CR-06. Travel doors and vents are listed individually below.

#### CR-06 — Echo Threshold

- **Physical layout:** A short threshold space of stone and ordinary tables leads to the Chamber of Echoes. Its doorway is the only progression interaction.
- **Narrative purpose:** Transition from evidence to practiced consequence.
- **Gameplay:** Use the Echo Threshold. Return through the corresponding CE-01 door remains possible before the Nexus.
- **Map placement:** roots, x=5200–6000; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CR-05. Travel doors and vents are listed individually below.

### Echoes

#### CE-01 — Resonance Hall

- **Physical layout:** Resonance Hall is lit against otherwise dark stone. A return door and inscribed stone provide a clear arrival orientation.
- **Narrative purpose:** Translate the chapter choice into one immediate instruction Els can act upon.
- **Gameplay:** Receive one branch-specific tutorial. Partial Mercy unlocks its ability on entry. Ordinary tables here cannot heal.
- **Map placement:** echoes, x=0–1100; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** east to CE-02. Travel doors and vents are listed individually below.

#### CE-02 — Sigil Forge

- **Physical layout:** A low forge glows red between candle points and heavy stone. A cyan recovery station offers a separate, clearly readable function.
- **Narrative purpose:** Vantree power demands a measured bodily cost rather than another collectible key.
- **Gameplay:** Vantree alone activates the forge; other branches pass without it. Cast and recover here when space permits.
- **Map placement:** echoes, x=1100–2200; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CE-01; east to CE-03. Travel doors and vents are listed individually below.

#### CE-03 — Vault of Whispers

- **Physical layout:** A lit vault contains two letters and a sarcophagus associated with the voice beat. The far end brings the player close to the next floor change.
- **Narrative purpose:** The prisoner moves from a thing described by letters to a presence that addresses Els.
- **Gameplay:** Read Letters XII and XIII. Only Vantree hears the first spoken entity line. The visible light remains dangerous on Partial Mercy.
- **Map placement:** echoes, x=2200–3300; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CE-02; east to CE-04. Travel doors and vents are listed individually below.

#### CE-04 — Sunken Choir

- **Physical layout:** The Sunken Choir is a rubble field with a lowered-looking rear floor strip and three collectible clocks farther east. Broken stone frames the passage.
- **Narrative purpose:** Broken architecture supplies a practical countermeasure to an inherited sensory rule.
- **Gameplay:** Collect three clocks. Vantree can earn Touch-evasion uses on rubble near the Hound; the rear strip below y=470 reduces transmission further.
- **Map placement:** echoes, x=3300–4400; configured floor types: STONE, RUBBLE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CE-03; east to CE-05. Travel doors and vents are listed individually below.

#### CE-05 — Nexus Descent

- **Physical layout:** Nexus Descent places a replenishing crate, ordinary table, marked alcove, and recovery station before the final door.
- **Narrative purpose:** The last staging area gives the player a chance to understand and afford the finale.
- **Gameplay:** Complete three branch uses, recover, then enter the Nexus. The cache replenishes clocks when total bottles plus clocks falls below three.
- **Map placement:** echoes, x=4400–5500; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** west to CE-04. Travel doors and vents are listed individually below.

### Nexus

#### LN-CENTER — Convergence

- **Physical layout:** One enclosed stone arena holds west, center, and east anchors, a golden bell behind the center anchor, two ward screens, a charger, and a closed return marker.
- **Narrative purpose:** A single readable space replaces route-finding with a decision about the next keeper.
- **Gameplay:** Ring the bell for 32 seconds of protection and channel one anchor for 20 uninterrupted seconds. There is no return passage and no need to complete all three anchors.
- **Map placement:** nexus, x=0–1800; configured floor types: STONE; individual dressing rugs override their own footprints to carpet.
- **Open boundaries:** none; use the designated exit or final interaction. Travel doors and vents are listed individually below.

<a id="objects"></a>

## 5. EVERY OBJECT — FULL DETAIL (this is the most important section)

### Catalog rules and completeness

Every placed gameplay prop, base furniture instance, estate decoration, room-dressing furniture instance, ordinary table, tabletop component, rug, and generated estate window receives its own entry. Eleven dining bulbs are listed individually with their support assembly. A shard field, continuous water region, light band, or floor treatment is an environmental assembly; individual particles and repeated wall/floor texture tiles are not additional interactable objects.

The support table and machine at each charger form one functional assembly. Furniture used by an interactable is cataloged with that interaction, avoiding a duplicate pretend item. The four crypt hides, for example, are distinct from nearby decorative sarcophagi. Stable IDs preserve identity even where two pieces use the same artwork. Detailed appearance, anonymous ownership interpretation, and optional inspection copy are authored design content; the current game does not provide an examine prompt for every chair or book.

There are thirteen numbered letters. Their **current complete runtime text** is preserved separately from the **authored complete first-person letter** intended for expanded reading. Closed decorative books have no readable pages and therefore do not conceal unwritten diaries. No placed radio, newspaper clipping, collectible photograph, named child’s toy puzzle, or extra watch puzzle appears in the current manifests. Do not add them by implication.

**Clock policy:** the opening time 2:47 AM is established. The repeated 2:47 dial styling for portable clocks is an authored motif; it grants no combination, countdown, or time-travel rule. Portable clocks are consumed as sound gadgets. The foyer sabotage clock has its own existing noise interaction.

| Catalog category | Entries |
| --- | ---: |
| Functional | 101 |
| Base Furniture | 19 |
| Estate Decoration | 93 |
| Tabletop Component | 123 |
| Ordinary Table | 46 |
| Room Furnishing | 178 |
| Rug | 9 |
| Window | 15 |
| Light Fixture | 12 |
| Environment Assembly | 12 |
| Story Record | 2 |
| **Total** | **610** |

### GF-00 — Cold Foyer

OBJECT NAME: Els's dropped flashlight [`intro/flashlight`]

- Location: GF-00 — Cold Foyer; intro x=430, y=480.
- Appearance: A compact hand torch lies at floor level, its beam pointing away from the waking character. Worn grip ridges distinguish it from the cyan charging equipment.
- Lore/backstory tied to this object: Established: Els recognizes it as hers, but cannot explain how it came to rest away from her.
- In-game purpose: Recover personal light and satisfy the introduction exit requirement.
- Player interaction: E collects it, removes the floor sprite, restores charge to 90 seconds, and enables the light. Existing speech: “Mine...” and “How did it get over there?” F subsequently raises or lowers the torch. Q uses a carried battery only below 50 seconds of charge.
- Connection to other objects/clues: The pouch and intro_exit complete the first recovery sequence; all cyan stations service this same torch.

OBJECT NAME: Els's tool pouch [`intro/lockpick_tool`]

- Location: GF-00 — Cold Foyer; intro x=900, y=430.
- Appearance: A compact worn leather tool bag with a folded flap, a short strap, and three slender picks visible in its organized interior.
- Lore/backstory tied to this object: Established: Els calls the tools her own preparation; the appraisal explains why she brought them.
- In-game purpose: Supply three lockpicks and satisfy the introduction exit requirement.
- Player interaction: E performs the bag pickup, removes the floor bag, grants three lockpicks, and sets the tool-pouch flag. Existing line: “At least I came prepared.”
- Connection to other objects/clues: Piano and vanity each spend one pick on first work; the introductory unlock requires possession of the pouch but does not deduct a pick.

OBJECT NAME: Music Room — intro_exit [`intro/intro_exit`]

- Location: GF-00 — Cold Foyer; intro x=1590, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Music Room-labeled introductory lock; actually loads Ground Floor at GF-01. Requires a prior door test, the flashlight, and the tool-pouch flag.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els. The successful introductory unlock takes 1.2 seconds before opening and the “Hello?” beat; it does not spend a pouch pick.
- Connection to other objects/clues: Destination `ground` / `start`; GF-01. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — gf_00_charge_1 [`intro/gf_00_charge_1`]

- Location: GF-00 — Cold Foyer; intro x=520, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `flashlight` in GF-00; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bench — intro/BrokenTable [`intro/BrokenTable`]

- Location: GF-00 — Cold Foyer; intro x=990, y=408.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 152 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Coat Stand — intro/decoration-01 [`intro/decoration-01`]

- Location: GF-00 — Cold Foyer; intro x=160, y=392.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. A dark moisture line remains close to its lower edge. Art width specification: 42 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Bench — intro/decoration-02 [`intro/decoration-02`]

- Location: GF-00 — Cold Foyer; intro x=380, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 125 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Side Table — intro/decoration-03 [`intro/decoration-03`]

- Location: GF-00 — Cold Foyer; intro x=730, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 66 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Vase — intro/decoration-03/detail-1 [`intro/decoration-03/detail-1`]

- Location: GF-00 — Cold Foyer; intro x=730, y=392. Detail on `intro/decoration-03`, local offset [0, -47]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. The highlight breaks across a small chip on the front edge. Art width specification: 16 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `intro/decoration-03`; Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Screen — intro/decoration-04 [`intro/decoration-04`]

- Location: GF-00 — Cold Foyer; intro x=1120, y=392.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. A pale scrape marks the near-left edge. Art width specification: 96 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Side Table — intro/decoration-05 [`intro/decoration-05`]

- Location: GF-00 — Cold Foyer; intro x=1330, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Candle — intro/decoration-05/detail-1 [`intro/decoration-05/detail-1`]

- Location: GF-00 — Cold Foyer; intro x=1330, y=392. Detail on `intro/decoration-05`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 21 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `intro/decoration-05`; Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Side Table — intro/decoration-06 [`intro/decoration-06`]

- Location: GF-00 — Cold Foyer; intro x=1470, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Candle — intro/decoration-06/detail-1 [`intro/decoration-06/detail-1`]

- Location: GF-00 — Cold Foyer; intro x=1470, y=392. Detail on `intro/decoration-06`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 21 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `intro/decoration-06`; Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Bench — intro/decoration-07 [`intro/decoration-07`]

- Location: GF-00 — Cold Foyer; intro x=1730, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 90 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Ordinary table — gf_00_charge_2 [`gf_00_charge_2`]

- Location: GF-00 — Cold Foyer; intro x=1360, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Book — gf_00_charge_2/tabletop [`gf_00_charge_2/tabletop`]

- Location: GF-00 — Cold Foyer; intro x=1360, y=590. Detail on `gf_00_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_00_charge_2`; Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Sideboard — GF-00/dressing-01 [`GF-00/dressing-01`]

- Location: GF-00 — Cold Foyer; intro x=249, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Book — GF-00/dressing-01/detail-1 [`GF-00/dressing-01/detail-1`]

- Location: GF-00 — Cold Foyer; intro x=249, y=395. Detail on `GF-00/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `GF-00/dressing-01`; Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Vase — GF-00/dressing-01/detail-2 [`GF-00/dressing-01/detail-2`]

- Location: GF-00 — Cold Foyer; intro x=249, y=395. Detail on `GF-00/dressing-01`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. A dark moisture line remains close to its lower edge. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `GF-00/dressing-01`; Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Bookshelf — GF-00/dressing-02 [`GF-00/dressing-02`]

- Location: GF-00 — Cold Foyer; intro x=637, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A dark moisture line remains close to its lower edge. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Coat Stand — GF-00/dressing-03 [`GF-00/dressing-03`]

- Location: GF-00 — Cold Foyer; intro x=793, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. One exposed corner is blunted by repeated contact. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Bench — GF-00/dressing-04 [`GF-00/dressing-04`]

- Location: GF-00 — Cold Foyer; intro x=651, y=590.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: Settee — GF-00/dressing-05 [`GF-00/dressing-05`]

- Location: GF-00 — Cold Foyer; intro x=814, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. A pale scrape marks the near-left edge. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Bench — GF-00/dressing-06 [`GF-00/dressing-06`]

- Location: GF-00 — Cold Foyer; intro x=981, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Sideboard — GF-00/dressing-07 [`GF-00/dressing-07`]

- Location: GF-00 — Cold Foyer; intro x=1213, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 100 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `lockpick_tool` in GF-00.

OBJECT NAME: Wood Chair — GF-00/dressing-08 [`GF-00/dressing-08`]

- Location: GF-00 — Cold Foyer; intro x=1276, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Bench — GF-00/dressing-09 [`GF-00/dressing-09`]

- Location: GF-00 — Cold Foyer; intro x=1641, y=590.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `intro_exit` in GF-00.

OBJECT NAME: Woven rug — GF-00/rug-1 [`GF-00/rug-1`]

- Location: GF-00; intro x=828, y=566; footprint 270 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #392c30; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the waiting foyer; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `lockpick_tool` in GF-00; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — intro/window-500 [`intro/window-500`]

- Location: GF-00 — Cold Foyer; intro x=545, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: waiting foyer.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `flashlight` in GF-00.

OBJECT NAME: The remembered appraisal contract and unread addendum [`story/contract`]

- Location: Els's opening recollection; no physical contract pickup is currently placed.
- Appearance: Authored memory image: a signed lower edge and a second sheet partly covered by the first. Keep names other than Els's and exact legal terms unreadable.
- Lore/backstory tied to this object: Established: Els accepted an unusually generous offer and signed without reading the addendum. The contracting party and full terms are unknown.
- In-game purpose: Motivation and uncertainty, not an inventory gate or a collectible legal document.
- Player interaction: The exact remembered line is “They offered too much. I signed without reading the addendum.” No full contract transcription is available; inventing one as recovered fact would resolve evidence the game withholds.
- Connection to other objects/clues: The six-hour gap, tool pouch, and inherited custodial role.

### GF-01 — Grand Foyer

OBJECT NAME: Front Door — front_door [`ground/front_door`]

- Location: GF-01 — Grand Foyer; ground x=180, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Part I branch exit. At zero keys, test once, then use again with zero detections for Untouched. At three keys, use for Loop. One or two keys cannot use this exit.
- Player interaction: E checks the current state. A valid state plays departure and selects the chapter outcome; an invalid state provides a sealed-passage hint. The first zero-key front-door test only knocks and sets door_tested.
- Connection to other objects/clues: GF-01 and all three keys; valid Untouched offers Part II, while Loop returns to GF-01.

OBJECT NAME: The foyer note [`ground/the_note`]

- Location: GF-01 — Grand Foyer; ground x=430, y=485.
- Appearance: A small surviving written page presented by the current book-shaped lore prop; its edge is darkened where hands would lift it.
- Lore/backstory tied to this object: The author is unidentified. This is the first direct statement of the ward system.
- In-game purpose: Optional lore hint; it is not one of the seven counted estate letters.
- Player interaction: E reveals the existing text: “Three wards. Three stolen senses. Freedom is counted by what remains sealed.”

  **Authored complete first-person note:**

  > I have counted three wards and three stolen senses. I leave the count here because I once mistook it for an instruction to finish. Freedom is counted by what remains sealed. Before you turn a key, ask whose freedom your hand is returning.
- Connection to other objects/clues: Piano, vanity, ritual stone, all Part I exit conditions, and Letter VII.

OBJECT NAME: Foyer clock / Sabotage Clock [`ground/grandfather_clock`]

- Location: GF-01 — Grand Foyer; ground x=620, y=430.
- Appearance: A tarnished clock-shaped mechanism, currently rendered using the small clock asset rather than a full-height grandfather-clock cabinet. Authored dial: stopped at 2:47; oxidized hands remain readable.
- Lore/backstory tied to this object: The wrong-hour cue is established; the exact dial is authored. Showing the awakening time echoes Els's lost interval without proving that time itself has stopped.
- In-game purpose: Optional noise lure and temporal motif, not a combination lock.
- Player interaction: E triggers a 576-radius GENERIC noise and displays the complete existing line: “The clock begins striking the wrong hour.” It sets its lore flag; do not treat it as a reusable inventory clock. The hands need no adjustment and the time unlocks nothing.
- Connection to other objects/clues: The opening time, side_clock, root_clock, echo_clock, and Hearing investigation. GENERIC noise is not automatically the same trigger as a GLASS event.

OBJECT NAME: Power station and support table — gf_01_charge_1 [`ground/gf_01_charge_1`]

- Location: GF-01 — Grand Foyer; ground x=275, y=430.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `front_door` in GF-01; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Coat Stand — ground/decoration-03 [`ground/decoration-03`]

- Location: GF-01 — Grand Foyer; ground x=350, y=392.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 43 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `the_note` in GF-01.

OBJECT NAME: Ordinary table — gf_01_charge_2 [`gf_01_charge_2`]

- Location: GF-01 — Grand Foyer; ground x=555, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `grandfather_clock` in GF-01.

OBJECT NAME: Book — gf_01_charge_2/tabletop [`gf_01_charge_2/tabletop`]

- Location: GF-01 — Grand Foyer; ground x=555, y=590. Detail on `gf_01_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_01_charge_2`; Nearest functional landmark: `grandfather_clock` in GF-01.

OBJECT NAME: Bench — GF-01/dressing-01 [`GF-01/dressing-01`]

- Location: GF-01 — Grand Foyer; ground x=291, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `front_door` in GF-01.

OBJECT NAME: Coat Stand — GF-01/dressing-02 [`GF-01/dressing-02`]

- Location: GF-01 — Grand Foyer; ground x=523, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. One exposed corner is blunted by repeated contact. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `the_note` in GF-01.

OBJECT NAME: Settee — GF-01/dressing-03 [`GF-01/dressing-03`]

- Location: GF-01 — Grand Foyer; ground x=434, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. The highlight breaks across a small chip on the front edge. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `the_note` in GF-01.

OBJECT NAME: Woven rug — GF-01/rug-1 [`GF-01/rug-1`]

- Location: GF-01; ground x=331, y=566; footprint 230 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #392c30; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the formal entrance and waiting area; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `the_note` in GF-01; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — ground/window-500 [`ground/window-500`]

- Location: GF-01 — Grand Foyer; ground x=545, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: formal entrance and waiting area.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `grandfather_clock` in GF-01.

OBJECT NAME: Memory fragment A — the second Loop [`vantree_memory_fragment_A`]

- Location: Persistent story flag after a second completed Loop; no separate floor pickup or reader page currently exists.
- Appearance: Authored future presentation: a brief imperfect memory-card treatment with the same paper grain as letters. Do not render it as a physical object to collect.
- Lore/backstory tied to this object: Established: the second Loop sets this flag. Its full content and on-screen reveal are not implemented in the examined scripts.
- In-game purpose: Secret recognition of repetition. Implementation gap: the reset run lacks enough reachable lockpicks to complete both required lock-work puzzles.
- Player interaction: Current behavior is a flag assignment only if a second Loop occurs. Authored first-person fragment: “I remember the relief before the doorway. I remember believing that a full hand meant an open road. I do not remember leaving. The room remembers how to receive me.” This is proposed narrative copy, not recovered canon.
- Connection to other objects/clues: Loop outcome, piano and vanity lockpick costs, and the GF-07 spare. The intended repeat route needs a supply correction before it is ordinarily finishable.

### GF-02 — Dining Hall

OBJECT NAME: Hide under table — dining_table_hide [`ground/dining_table_hide`]

- Location: GF-02 — Dining Hall; ground x=1050, y=565.
- Appearance: A full dining table with an accessible low space beneath the top and a clear floor-level entry.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `ground_battery` in GF-02; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Flashlight Battery [`ground/ground_battery`]

- Location: GF-02 — Dining Hall; ground x=1280, y=470.
- Appearance: A short practical flashlight cell with dulled metal ends and a worn wrapper; keep it smaller than Els's hand span. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A practical supply compatible with Els's own light; its original purchaser is unknown.
- In-game purpose: Restore 45 seconds of charge, capped at 90, when Q selects a battery.
- Player interaction: E takes the bundle, adds 1 battery, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `dining_table_hide` in GF-02; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — gf_02_charge_1 [`ground/gf_02_charge_1`]

- Location: GF-02 — Dining Hall; ground x=890, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `dining_table_hide` in GF-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Settee — ground/Furniture1 [`ground/Furniture1`]

- Location: GF-02 — Dining Hall; ground x=1070, y=432.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. The highlight breaks across a small chip on the front edge. Art width specification: 162 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `dining_table_hide` in GF-02.

OBJECT NAME: Bookshelf — ground/decoration-04 [`ground/decoration-04`]

- Location: GF-02 — Dining Hall; ground x=780, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A dark moisture line remains close to its lower edge. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `grandfather_clock` in GF-01.

OBJECT NAME: Side Table — ground/decoration-05 [`ground/decoration-05`]

- Location: GF-02 — Dining Hall; ground x=1190, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ground_battery` in GF-02.

OBJECT NAME: Book — ground/decoration-05/detail-1 [`ground/decoration-05/detail-1`]

- Location: GF-02 — Dining Hall; ground x=1190, y=392. Detail on `ground/decoration-05`, local offset [0, -43]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 29 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ground/decoration-05`; Nearest functional landmark: `ground_battery` in GF-02.

OBJECT NAME: Dining Chair — ground/decoration-06 [`ground/decoration-06`]

- Location: GF-02 — Dining Hall; ground x=1420, y=392.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. The highlight breaks across a small chip on the front edge. Art width specification: 50 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `ground_battery` in GF-02.

OBJECT NAME: Ordinary table — gf_02_charge_2 [`gf_02_charge_2`]

- Location: GF-02 — Dining Hall; ground x=1275, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ground_battery` in GF-02.

OBJECT NAME: Plates — gf_02_charge_2/tabletop [`gf_02_charge_2/tabletop`]

- Location: GF-02 — Dining Hall; ground x=1275, y=590. Detail on `gf_02_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: Stacked pale plates with uneven rims and a dull ring where the upper dish has been moved repeatedly. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: A meal can remain implied without inventing diners or a poisoned-food puzzle. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Set out, then left.”
- Connection to other objects/clues: Mounted on `gf_02_charge_2`; Nearest functional landmark: `ground_battery` in GF-02.

OBJECT NAME: Dining Chair — GF-02/dressing-01 [`GF-02/dressing-01`]

- Location: GF-02 — Dining Hall; ground x=956, y=605.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. One exposed corner is blunted by repeated contact. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `dining_table_hide` in GF-02.

OBJECT NAME: Dining Chair — GF-02/dressing-02 [`GF-02/dressing-02`]

- Location: GF-02 — Dining Hall; ground x=1156, y=605.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. The highlight breaks across a small chip on the front edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `dining_table_hide` in GF-02.

OBJECT NAME: Serving Cart — GF-02/dressing-03 [`GF-02/dressing-03`]

- Location: GF-02 — Dining Hall; ground x=886, y=590.
- Appearance: A two-tier service cart with small dark wheels, a raised handle, and stained shelf surfaces. A pale scrape marks the near-left edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: Food and equipment once moved through these service routes. Here its placement supports the room’s role: dining and serving.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It was meant to make carrying things easier.”
- Connection to other objects/clues: Nearest functional landmark: `dining_table_hide` in GF-02.

OBJECT NAME: Woven rug — GF-02/rug-1 [`GF-02/rug-1`]

- Location: GF-02; ground x=1051, y=566; footprint 230 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #392c30; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the dining and serving; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `dining_table_hide` in GF-02; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Dining string-light bulb 01 [`GF-02/string-bulb-01`]

- Location: GF-02 Dining Hall; bulb 1 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 02 [`GF-02/string-bulb-02`]

- Location: GF-02 Dining Hall; bulb 2 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 03 [`GF-02/string-bulb-03`]

- Location: GF-02 Dining Hall; bulb 3 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 04 [`GF-02/string-bulb-04`]

- Location: GF-02 Dining Hall; bulb 4 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 05 [`GF-02/string-bulb-05`]

- Location: GF-02 Dining Hall; bulb 5 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 06 [`GF-02/string-bulb-06`]

- Location: GF-02 Dining Hall; bulb 6 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 07 [`GF-02/string-bulb-07`]

- Location: GF-02 Dining Hall; bulb 7 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 08 [`GF-02/string-bulb-08`]

- Location: GF-02 Dining Hall; bulb 8 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 09 [`GF-02/string-bulb-09`]

- Location: GF-02 Dining Hall; bulb 9 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 10 [`GF-02/string-bulb-10`]

- Location: GF-02 Dining Hall; bulb 10 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining string-light bulb 11 [`GF-02/string-bulb-11`]

- Location: GF-02 Dining Hall; bulb 11 of 11 along the overhead sagging cable, ordered west to east.
- Appearance: A small warm bulb hanging from a short dark socket, with an individual halo that dims and recovers out of phase with its neighbors.
- Lore/backstory tied to this object: The estate combines later electrical lighting with old domestic furniture; no supernatural message is encoded in the flashes.
- In-game purpose: Local horror atmosphere and ceiling depth.
- Player interaction: No E prompt. Each lamp eases through its own repeating brownout; the base cycle is 5.8 seconds with phase offsets. It never grants a momentary mechanical invisibility window.
- Connection to other objects/clues: GF-02 ceiling cable assembly, dining_table_hide, and the common sense-restoration lighting disturbance.

OBJECT NAME: Dining light cable and sockets [`GF-02/string-cable`]

- Location: GF-02, ceiling; spans the room above the dining furniture.
- Appearance: A dark sagging cable with eleven spaced sockets; its silhouette frames the usable floor instead of hanging over Els's face.
- Lore/backstory tied to this object: A maintained domestic installation contrasts with the empty dining arrangement.
- In-game purpose: Support assembly for the individually cataloged bulbs.
- Player interaction: No E interaction or climb action; bulbs flicker independently.
- Connection to other objects/clues: GF-02/string-bulb-01 through GF-02/string-bulb-11.

### GF-03 — Music Room

OBJECT NAME: The piano ward [`ground/piano_seal`]

- Location: GF-03 — Music Room; ground x=1780, y=438.
- Appearance: A dark upright piano with dulled ivory keys, exposed lock hardware near the working edge, and a closed ward fitted into its timber housing.
- Lore/backstory tied to this object: Established: this seal holds the entity's Hearing. Authored dressing makes it look like appraisal work that Els can confidently recognize.
- In-game purpose: First three-step lock-work puzzle; it enables the separate Hearing Key pickup.
- Player interaction: E three times, allowing each 1.1-second work action to complete. One lockpick is consumed when starting at zero progress. Each completed step emits 300-radius GENERIC noise; completion says “The seal gives.” Progress survives a room revisit within the run. No melody, score, button sequence, or position reset is required.
- Connection to other objects/clues: hearing_key, vantree_01, the tool pouch, and the Hearing-gated stairs. The action points are approach affordances; they must not teleport Els.

OBJECT NAME: Hearing Key [`ground/hearing_key`]

- Location: GF-03 — Music Room; ground x=1960, y=478.
- Appearance: A hand-sized worn brass key with a resonant-looking hollow bow, kept physically separate from the piano mechanism.
- Lore/backstory tied to this object: Established: collecting this key restores Hearing to the Deprived One. It does not grant Els that faculty. Ornament is authored visual direction, not a second puzzle.
- In-game purpose: Advance the fixed Hearing → Sight → Memory sequence; requires `piano_seal`.
- Player interaction: E after the piano seal opens takes the key with its own pickup action, removes it, triggers a screech, and enables sound investigation. Els: “Something heard that.” A checkpoint is saved at successful acquisition. A sealed or out-of-order attempt gives a hint and grants nothing.
- Connection to other objects/clues: Piano, both ground-floor stairs, Vantree conduit, and the next vanity ward.

OBJECT NAME: Vantree - I [`ground/vantree_01`]

- Location: GF-03 — Music Room; ground x=2070, y=455.
- Appearance: A separate folded page, numbered 1, with a readable central text block and frayed handling edges. In Music Room, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The first ward took hearing. Silence made the prisoner gentle, or seemed to.”

  **Authored complete first-person letter:**

  > I kept my hands on the piano after the first ward closed. The wood still trembled, but the thing beyond it no longer turned toward the sound. I mistook that small relief for kindness.
  >
  > I wrote the result plainly: the first ward took hearing. Silence made the prisoner gentle, or seemed to. I could cross a room without announcing myself. I could shut a drawer. I began to think of those ordinary freedoms as mine.
  >
  > If you are working the lock, remember that a lock keeps something on both sides. I cannot tell you what the prisoner deserves. I can tell you that opening this one will give it back what I have learned to live without considering.
- Connection to other objects/clues: Piano ward and Hearing.

OBJECT NAME: Power station and support table — gf_03_charge_1 [`ground/gf_03_charge_1`]

- Location: GF-03 — Music Room; ground x=1610, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `piano_seal` in GF-03; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — ground/Furniture2 [`ground/Furniture2`]

- Location: GF-03 — Music Room; ground x=2130, y=412.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A pale scrape marks the near-left edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_01` in GF-03.

OBJECT NAME: Book — ground/Furniture2/detail-1 [`ground/Furniture2/detail-1`]

- Location: GF-03 — Music Room; ground x=2130, y=412. Detail on `ground/Furniture2`, local offset [-31, -85]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 32 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: music and listening.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ground/Furniture2`; Nearest functional landmark: `vantree_01` in GF-03.

OBJECT NAME: Candle — ground/Furniture2/detail-2 [`ground/Furniture2/detail-2`]

- Location: GF-03 — Music Room; ground x=2130, y=412. Detail on `ground/Furniture2`, local offset [34, -105]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 19 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: music and listening.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ground/Furniture2`; Nearest functional landmark: `vantree_01` in GF-03.

OBJECT NAME: Side Table — ground/decoration-07 [`ground/decoration-07`]

- Location: GF-03 — Music Room; ground x=1640, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `piano_seal` in GF-03.

OBJECT NAME: Candle — ground/decoration-07/detail-1 [`ground/decoration-07/detail-1`]

- Location: GF-03 — Music Room; ground x=1640, y=392. Detail on `ground/decoration-07`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A pale scrape marks the near-left edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: music and listening.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ground/decoration-07`; Nearest functional landmark: `piano_seal` in GF-03.

OBJECT NAME: Side Table — ground/decoration-08 [`ground/decoration-08`]

- Location: GF-03 — Music Room; ground x=1960, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `hearing_key` in GF-03.

OBJECT NAME: Candle — ground/decoration-08/detail-1 [`ground/decoration-08/detail-1`]

- Location: GF-03 — Music Room; ground x=1960, y=392. Detail on `ground/decoration-08`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: music and listening.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ground/decoration-08`; Nearest functional landmark: `hearing_key` in GF-03.

OBJECT NAME: Ordinary table — gf_03_charge_2 [`gf_03_charge_2`]

- Location: GF-03 — Music Room; ground x=1995, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: music and listening.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `hearing_key` in GF-03.

OBJECT NAME: Book — gf_03_charge_2/tabletop [`gf_03_charge_2/tabletop`]

- Location: GF-03 — Music Room; ground x=1995, y=590. Detail on `gf_03_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: music and listening.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_03_charge_2`; Nearest functional landmark: `hearing_key` in GF-03.

OBJECT NAME: Wood Chair — GF-03/dressing-01 [`GF-03/dressing-01`]

- Location: GF-03 — Music Room; ground x=1726, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. The highlight breaks across a small chip on the front edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `piano_seal` in GF-03.

OBJECT NAME: Bench — GF-03/dressing-02 [`GF-03/dressing-02`]

- Location: GF-03 — Music Room; ground x=1871, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `hearing_key` in GF-03.

OBJECT NAME: Settee — GF-03/dressing-03 [`GF-03/dressing-03`]

- Location: GF-03 — Music Room; ground x=1624, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. Dust remains in the far corner where a hand would not easily reach. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: music and listening.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `piano_seal` in GF-03.

OBJECT NAME: Woven rug — GF-03/rug-1 [`GF-03/rug-1`]

- Location: GF-03; ground x=1771, y=566; footprint 230 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #392c30; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the music and listening; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `piano_seal` in GF-03; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — ground/window-1460 [`ground/window-1460`]

- Location: GF-03 — Music Room; ground x=1505, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: music and listening.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `ground_battery` in GF-02.

### GF-04 — Servant's Pantry

OBJECT NAME: Hide in wardrobe — pantry_wardrobe [`ground/pantry_wardrobe`]

- Location: GF-04 — Servant's Pantry; ground x=2380, y=430.
- Appearance: A screen-like wardrobe enclosure with an opaque upright face and a narrow entry edge.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `medium` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vantree_01` in GF-03; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Glass Bottles x2 [`ground/pantry_bottles`]

- Location: GF-04 — Servant's Pantry; ground x=2710, y=474.
- Appearance: A usable dark glass bottle with a clear neck silhouette and a small floor contact shadow. This pickup grants 2; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A household supply repurposed into a deliberate sound source. Decorative bottles elsewhere remain separate.
- In-game purpose: Q places a GLASS noise 260 units ahead, radius 576; counts toward the Echoes gate only on Untouched.
- Player interaction: E takes the bundle, adds 2 bottles, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `pantry_wardrobe` in GF-04; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — gf_04_charge_1 [`ground/gf_04_charge_1`]

- Location: GF-04 — Servant's Pantry; ground x=2260, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `pantry_wardrobe` in GF-04; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Pans — ground/decoration-01 [`ground/decoration-01`]

- Location: GF-04 — Servant's Pantry; ground x=2460, y=305.
- Appearance: Hanging metal pans with dark bowls and bright rims, close enough for one to strike another. A pale scrape marks the near-left edge. Art width specification: 62 units before its parent/asset scale.
- Lore/backstory tied to this object: Cookware provides a credible cause for an alarmingly loud domestic sound. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I should keep my shoulder clear of those.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Stock Pot — ground/decoration-02 [`ground/decoration-02`]

- Location: GF-04 — Servant's Pantry; ground x=2590, y=305.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. Dust remains in the far corner where a hand would not easily reach. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_bottles` in GF-04.

OBJECT NAME: Bookshelf — ground/decoration-09 [`ground/decoration-09`]

- Location: GF-04 — Servant's Pantry; ground x=2240, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 88 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Serving Cart — ground/decoration-10 [`ground/decoration-10`]

- Location: GF-04 — Servant's Pantry; ground x=2650, y=392.
- Appearance: A two-tier service cart with small dark wheels, a raised handle, and stained shelf surfaces. A pale scrape marks the near-left edge. Art width specification: 71 units before its parent/asset scale.
- Lore/backstory tied to this object: Food and equipment once moved through these service routes. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It was meant to make carrying things easier.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_bottles` in GF-04.

OBJECT NAME: Ordinary table — gf_04_charge_2 [`gf_04_charge_2`]

- Location: GF-04 — Servant's Pantry; ground x=2715, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_bottles` in GF-04.

OBJECT NAME: Plates — gf_04_charge_2/tabletop [`gf_04_charge_2/tabletop`]

- Location: GF-04 — Servant's Pantry; ground x=2715, y=590. Detail on `gf_04_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: Stacked pale plates with uneven rims and a dull ring where the upper dish has been moved repeatedly. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: A meal can remain implied without inventing diners or a poisoned-food puzzle. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Set out, then left.”
- Connection to other objects/clues: Mounted on `gf_04_charge_2`; Nearest functional landmark: `pantry_bottles` in GF-04.

OBJECT NAME: Sideboard — GF-04/dressing-01 [`GF-04/dressing-01`]

- Location: GF-04 — Servant's Pantry; ground x=2509, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A pale scrape marks the near-left edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Plates — GF-04/dressing-01/detail-1 [`GF-04/dressing-01/detail-1`]

- Location: GF-04 — Servant's Pantry; ground x=2509, y=395. Detail on `GF-04/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: Stacked pale plates with uneven rims and a dull ring where the upper dish has been moved repeatedly. A pale scrape marks the near-left edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: A meal can remain implied without inventing diners or a poisoned-food puzzle. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Set out, then left.”
- Connection to other objects/clues: Mounted on `GF-04/dressing-01`; Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Vase — GF-04/dressing-01/detail-2 [`GF-04/dressing-01/detail-2`]

- Location: GF-04 — Servant's Pantry; ground x=2509, y=395. Detail on `GF-04/dressing-01`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. Dust remains in the far corner where a hand would not easily reach. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `GF-04/dressing-01`; Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Wine Rack — GF-04/dressing-02 [`GF-04/dressing-02`]

- Location: GF-04 — Servant's Pantry; ground x=2401, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. Dust remains in the far corner where a hand would not easily reach. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Bottle Crate — GF-04/dressing-03 [`GF-04/dressing-03`]

- Location: GF-04 — Servant's Pantry; ground x=2521, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Bottle Crate — GF-04/dressing-04 [`GF-04/dressing-04`]

- Location: GF-04 — Servant's Pantry; ground x=2631, y=590.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A dark moisture line remains close to its lower edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_bottles` in GF-04.

OBJECT NAME: Serving Cart — GF-04/dressing-05 [`GF-04/dressing-05`]

- Location: GF-04 — Servant's Pantry; ground x=2316, y=605.
- Appearance: A two-tier service cart with small dark wheels, a raised handle, and stained shelf surfaces. One exposed corner is blunted by repeated contact. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: Food and equipment once moved through these service routes. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It was meant to make carrying things easier.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Window — ground/window-2420 [`ground/window-2420`]

- Location: GF-04 — Servant's Pantry; ground x=2465, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: pantry and service storage.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `pantry_wardrobe` in GF-04.

OBJECT NAME: Broken-glass field [`ground/glass-field`]

- Location: GF-04 into GF-05; visual shard scatter x=2390–3570, y=363–533.
- Appearance: Ninety-five small angular shards catch isolated highlights; the field is one environmental assembly, not ninety-five collectible items.
- Lore/backstory tied to this object: Broken service glass supports the scene of disrupted domestic work; who broke it is unknown.
- In-game purpose: Visual hazard hint. Implementation gap: this field currently does not override the underlying WOOD surface to GLASS.
- Player interaction: No E interaction. Current footsteps follow the underlying configured surface; do not promise an automatic glass-triggered hunt merely from crossing the artwork.
- Connection to other objects/clues: Actual GLASS noise comes from thrown bottles or an uncrouched creaking-floor step.

OBJECT NAME: Painted pantry lower bypass [`ground/pantry-bypass`]

- Location: GF-04 into GF-05; x=2380–3580, y=550–624.
- Appearance: A dark bordered lower strip separates the approach lane from the visual shard field.
- Lore/backstory tied to this object: A service route should allow careful passage around clutter.
- In-game purpose: Visual route cue. Implementation gap: the strip alone does not create CARPET noise behavior.
- Player interaction: Move around footprints and crouch for quieter steps. Actual dressing rugs provide carpet where their footprints overlap.
- Connection to other objects/clues: Cookware entry event, glass-field assembly, and surface_at.

### GF-05 — Side Corridor

OBJECT NAME: Wind-Up Clock [`ground/side_clock`]

- Location: GF-05 — Side Corridor; ground x=3070, y=470.
- Appearance: A palm-sized wind-up clock/watch with a brass rim, dark dial, and short winding crown. Authored dial rests at 2:47 before use; it is a visual echo, not a time-setting puzzle. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A portable mechanism turns a domestic measure of time into a sound lure. Its hands do not establish elapsed world time.
- In-game purpose: Q places a GENERIC noise 180 units ahead, radius 384; counts toward the Echoes gate only on Untouched. The current implementation emits a single noise event, not a persistent ticking actor.
- Player interaction: E takes the bundle, adds 1 clock, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `scratched_nameplate` in GF-05; the inventory count confirms acquisition.

OBJECT NAME: The removed family name [`ground/scratched_nameplate`]

- Location: GF-05 — Side Corridor; ground x=3420, y=420.
- Appearance: A metal nameplate with deliberate scoring across its identifying letters; a pale outline marks where a name should be legible.
- Lore/backstory tied to this object: Established: the removal is more careful than the surrounding portrait treatment. No readable surname is recovered here.
- In-game purpose: Environmental identity clue; no item or gate flag requirement depends on reading it.
- Player interaction: E reveals: “A family name has been cut away more carefully than the portrait above it.” Proposed Els inspection: “Someone wanted the name gone. Not the place where it belonged.”
- Connection to other objects/clues: The Vantree letters and the complete name at CR-04. The nearby portrait is described by lore; there is no separate placed collectible photograph in the current data.

OBJECT NAME: Power station and support table — gf_05_charge_1 [`ground/gf_05_charge_1`]

- Location: GF-05 — Side Corridor; ground x=2980, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `side_clock` in GF-05; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bench — ground/Furniture3 [`ground/Furniture3`]

- Location: GF-05 — Side Corridor; ground x=3230, y=432.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `side_clock` in GF-05.

OBJECT NAME: Dining Chair — ground/decoration-11 [`ground/decoration-11`]

- Location: GF-05 — Side Corridor; ground x=3160, y=392.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. Dust remains in the far corner where a hand would not easily reach. Art width specification: 51 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `side_clock` in GF-05.

OBJECT NAME: Sideboard — ground/decoration-12 [`ground/decoration-12`]

- Location: GF-05 — Side Corridor; ground x=3470, y=392.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 136 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Tray — ground/decoration-12/detail-1 [`ground/decoration-12/detail-1`]

- Location: GF-05 — Side Corridor; ground x=3470, y=392. Detail on `ground/decoration-12`, local offset [-24, -74]; parent coordinates shown.
- Appearance: A shallow metal tray with a rubbed rim and dark center reflecting a faint oval of light. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 34 units before its parent/asset scale.
- Lore/backstory tied to this object: The tray belongs to service rather than ritual; resemblance to a basin is not a puzzle hint. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Ordinary work left an ordinary mark.”
- Connection to other objects/clues: Mounted on `ground/decoration-12`; Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Creamer — ground/decoration-12/detail-2 [`ground/decoration-12/detail-2`]

- Location: GF-05 — Side Corridor; ground x=3470, y=392. Detail on `ground/decoration-12`, local offset [23, -89]; parent coordinates shown.
- Appearance: A small pale pouring vessel with a short spout and a curved handle darkened at its inner edge. A dark moisture line remains close to its lower edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: A remnant of table service makes the house feel interrupted rather than purpose-built as a dungeon. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A careful little thing in a careless room.”
- Connection to other objects/clues: Mounted on `ground/decoration-12`; Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Ordinary table — gf_05_charge_2 [`gf_05_charge_2`]

- Location: GF-05 — Side Corridor; ground x=3435, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Book — gf_05_charge_2/tabletop [`gf_05_charge_2/tabletop`]

- Location: GF-05 — Side Corridor; ground x=3435, y=590. Detail on `gf_05_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_05_charge_2`; Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Coat Stand — GF-05/dressing-01 [`GF-05/dressing-01`]

- Location: GF-05 — Side Corridor; ground x=3323, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. Dust remains in the far corner where a hand would not easily reach. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Bench — GF-05/dressing-02 [`GF-05/dressing-02`]

- Location: GF-05 — Side Corridor; ground x=3311, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Wood Chair — GF-05/dressing-03 [`GF-05/dressing-03`]

- Location: GF-05 — Side Corridor; ground x=3516, y=590.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

OBJECT NAME: Window — ground/window-3380 [`ground/window-3380`]

- Location: GF-05 — Side Corridor; ground x=3425, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: quiet passage seating.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `scratched_nameplate` in GF-05.

### GF-06 — Reading Nook

OBJECT NAME: Vantree - II [`ground/vantree_02`]

- Location: GF-06 — Reading Nook; ground x=3850, y=460.
- Appearance: A separate folded page, numbered 2, with a readable central text block and frayed handling edges. In Reading Nook, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “A custodian keeps a door. A jailer decides who is permitted to need one.”

  **Authored complete first-person letter:**

  > I used the word custodian because it sounded like work a decent person could accept. I kept the rooms in order. I kept the door. I kept telling myself that keeping was different from choosing.
  >
  > Then I noticed how often my instructions concerned somebody else’s movements. A custodian keeps a door. A jailer decides who is permitted to need one. I had written rules for leaving while arranging that another hand would have to remain.
  >
  > I have left this page among the reading things because I want the distinction to be read before another lock is opened. I do not ask you to trust my title. I ask you to look at what the title allowed me to do.
- Connection to other objects/clues: Letter IV and the distinction between Custodian and Jailer.

OBJECT NAME: Power station and support table — ground_recharge [`ground/ground_recharge`]

- Location: GF-06 — Reading Nook; ground x=4170, y=430.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `vantree_02` in GF-06; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bookshelf — ground/Furniture4 [`ground/Furniture4`]

- Location: GF-06 — Reading Nook; ground x=3740, y=410.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Side Table — ground/decoration-13 [`ground/decoration-13`]

- Location: GF-06 — Reading Nook; ground x=4060, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Book — ground/decoration-13/detail-1 [`ground/decoration-13/detail-1`]

- Location: GF-06 — Reading Nook; ground x=4060, y=392. Detail on `ground/decoration-13`, local offset [0, -45]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 29 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: private reading library.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ground/decoration-13`; Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Dining Chair — ground/decoration-14 [`ground/decoration-14`]

- Location: GF-06 — Reading Nook; ground x=4260, y=392.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. One exposed corner is blunted by repeated contact. Art width specification: 51 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `coat_rack_hide` in GF-07.

OBJECT NAME: Ordinary table — gf_06_charge_2 [`gf_06_charge_2`]

- Location: GF-06 — Reading Nook; ground x=4155, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: private reading library.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Book — gf_06_charge_2/tabletop [`gf_06_charge_2/tabletop`]

- Location: GF-06 — Reading Nook; ground x=4155, y=590. Detail on `gf_06_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: private reading library.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_06_charge_2`; Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Bookshelf — GF-06/dressing-01 [`GF-06/dressing-01`]

- Location: GF-06 — Reading Nook; ground x=3967, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Wood Chair — GF-06/dressing-02 [`GF-06/dressing-02`]

- Location: GF-06 — Reading Nook; ground x=3956, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Settee — GF-06/dressing-03 [`GF-06/dressing-03`]

- Location: GF-06 — Reading Nook; ground x=3854, y=590.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. One exposed corner is blunted by repeated contact. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Bench — GF-06/dressing-04 [`GF-06/dressing-04`]

- Location: GF-06 — Reading Nook; ground x=3721, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: private reading library.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_02` in GF-06.

OBJECT NAME: Woven rug — GF-06/rug-1 [`GF-06/rug-1`]

- Location: GF-06; ground x=3931, y=566; footprint 230 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #392c30; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the private reading library; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `vantree_02` in GF-06; NoiseModel uses CARPET for the actual rug footprint.

### GF-07 — Coat Room

OBJECT NAME: Hide among coats — coat_rack_hide [`ground/coat_rack_hide`]

- Location: GF-07 — Coat Room; ground x=4520, y=430.
- Appearance: A substantial coat-stand grouping with a marked concealment position behind its hanging silhouette.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `coat_lockpick` in GF-07; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Lockpick [`ground/coat_lockpick`]

- Location: GF-07 — Coat Room; ground x=4870, y=470.
- Appearance: A slender metal spare pick with a narrow hooked end and a flattened grip, clearly smaller than a key. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A spare tool left among service belongings; it provides a limited replacement for lost or spent picks.
- In-game purpose: One additional unit for beginning piano or vanity work.
- Player interaction: E takes the bundle, adds 1 lockpick, and removes the floor sprite for the run. The first step of a seal puzzle consumes one pick automatically when required.
- Connection to other objects/clues: `coat_rack_hide` in GF-07; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — gf_07_charge_1 [`ground/gf_07_charge_1`]

- Location: GF-07 — Coat Room; ground x=4630, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `coat_rack_hide` in GF-07; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Serving Cart — ground/decoration-15 [`ground/decoration-15`]

- Location: GF-07 — Coat Room; ground x=4650, y=392.
- Appearance: A two-tier service cart with small dark wheels, a raised handle, and stained shelf surfaces. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Food and equipment once moved through these service routes. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It was meant to make carrying things easier.”
- Connection to other objects/clues: Nearest functional landmark: `coat_rack_hide` in GF-07.

OBJECT NAME: Ordinary table — gf_07_charge_2 [`gf_07_charge_2`]

- Location: GF-07 — Coat Room; ground x=4875, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Book — gf_07_charge_2/tabletop [`gf_07_charge_2/tabletop`]

- Location: GF-07 — Coat Room; ground x=4875, y=590. Detail on `gf_07_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_07_charge_2`; Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Coat Stand — GF-07/dressing-01 [`GF-07/dressing-01`]

- Location: GF-07 — Coat Room; ground x=4433, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. A dark moisture line remains close to its lower edge. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `coat_rack_hide` in GF-07.

OBJECT NAME: Screen — GF-07/dressing-02 [`GF-07/dressing-02`]

- Location: GF-07 — Coat Room; ground x=4746, y=395.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. One exposed corner is blunted by repeated contact. Art width specification: 108 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Bench — GF-07/dressing-03 [`GF-07/dressing-03`]

- Location: GF-07 — Coat Room; ground x=4761, y=590.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Bench — GF-07/dressing-04 [`GF-07/dressing-04`]

- Location: GF-07 — Coat Room; ground x=4643, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 100 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `coat_rack_hide` in GF-07.

OBJECT NAME: Window — ground/window-4340 [`ground/window-4340`]

- Location: GF-07 — Coat Room; ground x=4385, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: coats and waiting.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `coat_rack_hide` in GF-07.

### GF-08 — Trophy Hall

OBJECT NAME: Ground Vent — ground_vent [`ground/ground_vent`]

- Location: GF-08 — Trophy Hall; ground x=5480, y=405.
- Appearance: A low metal service vent with a dark interior, readable rim, and enough open floor for a crouch-to-crawl transition.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to UF-04 in upper, arrival `upper_vent`. Requirement: none.
- Player interaction: E performs a separate vent-entry crawl, fades through the transition, and plays an emergence action at the linked vent.
- Connection to other objects/clues: Destination `upper` / `upper_vent`; UF-04. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Sideboard — ground/Furniture5 [`ground/Furniture5`]

- Location: GF-08 — Trophy Hall; ground x=5090, y=432.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A dark moisture line remains close to its lower edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Plates — ground/Furniture5/detail-1 [`ground/Furniture5/detail-1`]

- Location: GF-08 — Trophy Hall; ground x=5090, y=432. Detail on `ground/Furniture5`, local offset [-33, -85]; parent coordinates shown.
- Appearance: Stacked pale plates with uneven rims and a dull ring where the upper dish has been moved repeatedly. A dark moisture line remains close to its lower edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: A meal can remain implied without inventing diners or a poisoned-food puzzle. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Set out, then left.”
- Connection to other objects/clues: Mounted on `ground/Furniture5`; Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Stock Pot — ground/Furniture5/detail-2 [`ground/Furniture5/detail-2`]

- Location: GF-08 — Trophy Hall; ground x=5090, y=432. Detail on `ground/Furniture5`, local offset [24, -102]; parent coordinates shown.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. One exposed corner is blunted by repeated contact. Art width specification: 36 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Mounted on `ground/Furniture5`; Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Serving Hatch — ground/decoration-16 [`ground/decoration-16`]

- Location: GF-08 — Trophy Hall; ground x=5170, y=295.
- Appearance: A broad framed hatch in the rear wall, its service opening dark and its sill worn at hand height. A pale scrape marks the near-left edge. Art width specification: 173 units before its parent/asset scale.
- Lore/backstory tied to this object: The opening belongs to household circulation; it is not a traversable vent. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A hatch for plates. The marked vent is somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `coat_lockpick` in GF-07.

OBJECT NAME: Sideboard — ground/decoration-17 [`ground/decoration-17`]

- Location: GF-08 — Trophy Hall; ground x=5200, y=392.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. Dust remains in the far corner where a hand would not easily reach. Art width specification: 136 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Pans — ground/decoration-17/detail-1 [`ground/decoration-17/detail-1`]

- Location: GF-08 — Trophy Hall; ground x=5200, y=392. Detail on `ground/decoration-17`, local offset [-23, -75]; parent coordinates shown.
- Appearance: Hanging metal pans with dark bowls and bright rims, close enough for one to strike another. Dust remains in the far corner where a hand would not easily reach. Art width specification: 35 units before its parent/asset scale.
- Lore/backstory tied to this object: Cookware provides a credible cause for an alarmingly loud domestic sound. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I should keep my shoulder clear of those.”
- Connection to other objects/clues: Mounted on `ground/decoration-17`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Plates — ground/decoration-17/detail-2 [`ground/decoration-17/detail-2`]

- Location: GF-08 — Trophy Hall; ground x=5200, y=392. Detail on `ground/decoration-17`, local offset [31, -91]; parent coordinates shown.
- Appearance: Stacked pale plates with uneven rims and a dull ring where the upper dish has been moved repeatedly. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: A meal can remain implied without inventing diners or a poisoned-food puzzle. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Set out, then left.”
- Connection to other objects/clues: Mounted on `ground/decoration-17`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Sideboard — ground/decoration-18 [`ground/decoration-18`]

- Location: GF-08 — Trophy Hall; ground x=5680, y=392.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 136 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Stock Pot — ground/decoration-18/detail-1 [`ground/decoration-18/detail-1`]

- Location: GF-08 — Trophy Hall; ground x=5680, y=392. Detail on `ground/decoration-18`, local offset [-26, -74]; parent coordinates shown.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 37 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Mounted on `ground/decoration-18`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Tray — ground/decoration-18/detail-2 [`ground/decoration-18/detail-2`]

- Location: GF-08 — Trophy Hall; ground x=5680, y=392. Detail on `ground/decoration-18`, local offset [30, -91]; parent coordinates shown.
- Appearance: A shallow metal tray with a rubbed rim and dark center reflecting a faint oval of light. A dark moisture line remains close to its lower edge. Art width specification: 33 units before its parent/asset scale.
- Lore/backstory tied to this object: The tray belongs to service rather than ritual; resemblance to a basin is not a puzzle hint. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Ordinary work left an ordinary mark.”
- Connection to other objects/clues: Mounted on `ground/decoration-18`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Ordinary table — gf_08_charge_1 [`gf_08_charge_1`]

- Location: GF-08 — Trophy Hall; ground x=5210, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Book — gf_08_charge_1/tabletop [`gf_08_charge_1/tabletop`]

- Location: GF-08 — Trophy Hall; ground x=5210, y=405. Detail on `gf_08_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_08_charge_1`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Ordinary table — gf_08_charge_2 [`gf_08_charge_2`]

- Location: GF-08 — Trophy Hall; ground x=5595, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Book — gf_08_charge_2/tabletop [`gf_08_charge_2/tabletop`]

- Location: GF-08 — Trophy Hall; ground x=5595, y=590. Detail on `gf_08_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_08_charge_2`; Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Bookshelf — GF-08/dressing-01 [`GF-08/dressing-01`]

- Location: GF-08 — Trophy Hall; ground x=5317, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. One exposed corner is blunted by repeated contact. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Bench — GF-08/dressing-02 [`GF-08/dressing-02`]

- Location: GF-08 — Trophy Hall; ground x=5471, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Wood Chair — GF-08/dressing-03 [`GF-08/dressing-03`]

- Location: GF-08 — Trophy Hall; ground x=5676, y=590.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A pale scrape marks the near-left edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Window — ground/window-5300 [`ground/window-5300`]

- Location: GF-08 — Trophy Hall; ground x=5345, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: display cabinets and gallery seating.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `ground_vent` in GF-08.

OBJECT NAME: Trophy Hall creaking boards [`ground/creak-floor`]

- Location: GF-08; x=5040–5760 except actual rug overrides.
- Appearance: Long worn boards suggested beneath service furniture, with thin broken seams at the crossing.
- Lore/backstory tied to this object: Repeated service traffic has loosened this stretch of floor; this cause is authored environmental interpretation.
- In-game purpose: Implemented noise hazard.
- Player interaction: Walking or sprinting emits a GLASS-class step; crouching maps the step to CARPET. After Hearing, an audible GLASS event initiates a hunt.
- Connection to other objects/clues: ground_vent and the approach to Upper Stairwell.

### GF-09 — Upper Stairwell

OBJECT NAME: Upper Floor — upper_stairs [`ground/upper_stairs`]

- Location: GF-09 — Upper Stairwell; ground x=6140, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to UF-06 in upper, arrival `upper_stairs`. Requirement: hearing.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `upper` / `upper_stairs`; UF-06. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — gf_09_charge_1 [`ground/gf_09_charge_1`]

- Location: GF-09 — Upper Stairwell; ground x=6035, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `upper_stairs` in GF-09; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bench — ground/Furniture6 [`ground/Furniture6`]

- Location: GF-09 — Upper Stairwell; ground x=5900, y=430.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Bookshelf — ground/decoration-19 [`ground/decoration-19`]

- Location: GF-09 — Upper Stairwell; ground x=6280, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A dark moisture line remains close to its lower edge. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Bottle Crate — ground/decoration-20 [`ground/decoration-20`]

- Location: GF-09 — Upper Stairwell; ground x=6450, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. Dust remains in the far corner where a hand would not easily reach. Art width specification: 51 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Ordinary table — gf_09_charge_2 [`gf_09_charge_2`]

- Location: GF-09 — Upper Stairwell; ground x=6315, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: upper landing.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Book — gf_09_charge_2/tabletop [`gf_09_charge_2/tabletop`]

- Location: GF-09 — Upper Stairwell; ground x=6315, y=590. Detail on `gf_09_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: upper landing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_09_charge_2`; Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Coat Stand — GF-09/dressing-01 [`GF-09/dressing-01`]

- Location: GF-09 — Upper Stairwell; ground x=6353, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. The highlight breaks across a small chip on the front edge. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Bench — GF-09/dressing-02 [`GF-09/dressing-02`]

- Location: GF-09 — Upper Stairwell; ground x=6191, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Wood Chair — GF-09/dressing-03 [`GF-09/dressing-03`]

- Location: GF-09 — Upper Stairwell; ground x=6396, y=590.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. Dust remains in the far corner where a hand would not easily reach. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: upper landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

OBJECT NAME: Window — ground/window-6260 [`ground/window-6260`]

- Location: GF-09 — Upper Stairwell; ground x=6305, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: upper landing.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in GF-09.

### GF-10 — Cellar Stairs

OBJECT NAME: Cellar — basement_stairs [`ground/basement_stairs`]

- Location: GF-10 — Cellar Stairs; ground x=6980, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to BS-01 in basement, arrival `ground_stairs`. Requirement: hearing.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `basement` / `ground_stairs`; BS-01. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — gf_10_charge_1 [`ground/gf_10_charge_1`]

- Location: GF-10 — Cellar Stairs; ground x=6650, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `basement_stairs` in GF-10; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — ground/decoration-21 [`ground/decoration-21`]

- Location: GF-10 — Cellar Stairs; ground x=6660, y=392.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 136 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Water Set — ground/decoration-21/detail-1 [`ground/decoration-21/detail-1`]

- Location: GF-10 — Cellar Stairs; ground x=6660, y=392. Detail on `ground/decoration-21`, local offset [-22, -75]; parent coordinates shown.
- Appearance: A pale water vessel and smaller matching cup grouped on a tray-like surface. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 27 units before its parent/asset scale.
- Lore/backstory tied to this object: A small hospitality arrangement contrasts with the isolation of the present night. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone arranged this for a person who needed it.”
- Connection to other objects/clues: Mounted on `ground/decoration-21`; Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Dish Tub — ground/decoration-21/detail-2 [`ground/decoration-21/detail-2`]

- Location: GF-10 — Cellar Stairs; ground x=6660, y=392. Detail on `ground/decoration-21`, local offset [28, -90]; parent coordinates shown.
- Appearance: A broad utilitarian washing tub, stained inside and worn pale around the rim. A dark moisture line remains close to its lower edge. Art width specification: 37 units before its parent/asset scale.
- Lore/backstory tied to this object: The cellar access still carries the equipment of maintaining an occupied estate. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Keeping a house takes work. So does keeping anything.”
- Connection to other objects/clues: Mounted on `ground/decoration-21`; Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Side Table — ground/decoration-22 [`ground/decoration-22`]

- Location: GF-10 — Cellar Stairs; ground x=6860, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Candle — ground/decoration-22/detail-1 [`ground/decoration-22/detail-1`]

- Location: GF-10 — Cellar Stairs; ground x=6860, y=392. Detail on `ground/decoration-22`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ground/decoration-22`; Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Bench — ground/decoration-23 [`ground/decoration-23`]

- Location: GF-10 — Cellar Stairs; ground x=7130, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 90 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Ordinary table — gf_10_charge_2 [`gf_10_charge_2`]

- Location: GF-10 — Cellar Stairs; ground x=7035, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Book — gf_10_charge_2/tabletop [`gf_10_charge_2/tabletop`]

- Location: GF-10 — Cellar Stairs; ground x=7035, y=590. Detail on `gf_10_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `gf_10_charge_2`; Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Wine Rack — GF-10/dressing-01 [`GF-10/dressing-01`]

- Location: GF-10 — Cellar Stairs; ground x=6771, y=395.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. A dark moisture line remains close to its lower edge. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Bottle Crate — GF-10/dressing-02 [`GF-10/dressing-02`]

- Location: GF-10 — Cellar Stairs; ground x=6771, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. One exposed corner is blunted by repeated contact. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Bench — GF-10/dressing-03 [`GF-10/dressing-03`]

- Location: GF-10 — Cellar Stairs; ground x=6911, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

OBJECT NAME: Stock Pot — GF-10/dressing-04 [`GF-10/dressing-04`]

- Location: GF-10 — Cellar Stairs; ground x=7113, y=590.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. A pale scrape marks the near-left edge. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: cellar service landing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Nearest functional landmark: `basement_stairs` in GF-10.

### UF-01 — Portrait Gallery

OBJECT NAME: Vantree - III [`upper/vantree_03`]

- Location: UF-01 — Portrait Gallery; upper x=700, y=455.
- Appearance: A separate folded page, numbered 3, with a readable central text block and frayed handling edges. In Portrait Gallery, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “It watched the portraits before it watched us. We covered every painted eye.”

  **Authored complete first-person letter:**

  > I thought the portraits would offer witnesses. I stood beneath those painted faces and felt, for a little while, that a house with so many eyes could not lose another person unnoticed.
  >
  > It watched the portraits before it watched us. We covered every painted eye. I do not know whether the cloth changed anything in the prisoner or only made it easier for me to pass the walls.
  >
  > I know what happened when sight returned: the light I carried stopped belonging only to me. It became a way of finding me. If you open the second ward, learn the difference between a dim room and a place the thing cannot see. I learned it while running.
- Connection to other objects/clues: Vanity ward, Sight, and line-of-sight cover.

OBJECT NAME: Power station and support table — uf_01_charge_1 [`upper/uf_01_charge_1`]

- Location: UF-01 — Portrait Gallery; upper x=240, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `vantree_03` in UF-01; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bench — upper/decoration-01 [`upper/decoration-01`]

- Location: UF-01 — Portrait Gallery; upper x=420, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 124 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Bookshelf — upper/decoration-02 [`upper/decoration-02`]

- Location: UF-01 — Portrait Gallery; upper x=710, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. One exposed corner is blunted by repeated contact. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Ordinary table — uf_01_charge_2 [`uf_01_charge_2`]

- Location: UF-01 — Portrait Gallery; upper x=765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Book — uf_01_charge_2/tabletop [`uf_01_charge_2/tabletop`]

- Location: UF-01 — Portrait Gallery; upper x=765, y=590. Detail on `uf_01_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_01_charge_2`; Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Sideboard — UF-01/dressing-01 [`UF-01/dressing-01`]

- Location: UF-01 — Portrait Gallery; upper x=119, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The highlight breaks across a small chip on the front edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Book — UF-01/dressing-01/detail-1 [`UF-01/dressing-01/detail-1`]

- Location: UF-01 — Portrait Gallery; upper x=119, y=395. Detail on `UF-01/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `UF-01/dressing-01`; Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Vase — UF-01/dressing-01/detail-2 [`UF-01/dressing-01/detail-2`]

- Location: UF-01 — Portrait Gallery; upper x=119, y=395. Detail on `UF-01/dressing-01`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. A pale scrape marks the near-left edge. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `UF-01/dressing-01`; Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Bench — UF-01/dressing-02 [`UF-01/dressing-02`]

- Location: UF-01 — Portrait Gallery; upper x=281, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Bench — UF-01/dressing-03 [`UF-01/dressing-03`]

- Location: UF-01 — Portrait Gallery; upper x=431, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Bookshelf — UF-01/dressing-04 [`UF-01/dressing-04`]

- Location: UF-01 — Portrait Gallery; upper x=567, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Wood Chair — UF-01/dressing-05 [`UF-01/dressing-05`]

- Location: UF-01 — Portrait Gallery; upper x=686, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Settee — UF-01/dressing-06 [`UF-01/dressing-06`]

- Location: UF-01 — Portrait Gallery; upper x=884, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. One exposed corner is blunted by repeated contact. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

OBJECT NAME: Woven rug — UF-01/rug-1 [`UF-01/rug-1`]

- Location: UF-01; upper x=460, y=566; footprint 270 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #302e3b; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the portrait viewing gallery; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `vantree_03` in UF-01; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — upper/window-500 [`upper/window-500`]

- Location: UF-01 — Portrait Gallery; upper x=545, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: portrait viewing gallery.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_03` in UF-01.

### UF-02 — Master Bedroom

OBJECT NAME: Hide under bed — upper_hide_01 [`upper/upper_hide_01`]

- Location: UF-02 — Master Bedroom; upper x=1420, y=570.
- Appearance: The bedroom bed with a low, dark gap underneath and room for a full crouch-and-slide entry.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `high` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vanity_seal` in UF-02; the Memory Key changes the value of reusing this same position.

OBJECT NAME: The mirrored vanity ward [`upper/vanity_seal`]

- Location: UF-02 — Master Bedroom; upper x=1740, y=440.
- Appearance: A narrow sideboard supports a small tarnished mirror and vase; the second seal sits within its working surface.
- Lore/backstory tied to this object: Established: Hearing must already be restored; the second ward contains Sight.
- In-game purpose: Second three-step lock-work puzzle, optional for Vantree and required for Partial Mercy or Loop.
- Player interaction: With Hearing, press E three times and allow each 1.1-second action to finish. The first step costs one lockpick; each completed step emits 300-radius GENERIC noise. The resulting Sight Key remains a separate pickup.
- Connection to other objects/clues: sight_key, upper_hide_01, Letter III, and the Blood Hound's exposure rules. The mirror is not a secret-code display.

OBJECT NAME: Sight Key [`upper/sight_key`]

- Location: UF-02 — Master Bedroom; upper x=1910, y=480.
- Appearance: A slender tarnished key with a pale highlight on its bow, resting beside the completed vanity rather than floating above Els.
- Lore/backstory tied to this object: Established: collecting this key restores Sight to the Deprived One. It does not grant Els that faculty. Ornament is authored visual direction, not a second puzzle.
- In-game purpose: Advance the fixed Hearing → Sight → Memory sequence; requires `vanity_seal`.
- Player interaction: E after the vanity seal opens takes and removes the key, enabling Sight while Hearing remains. Els: “It turned toward the light.” A checkpoint is saved at successful acquisition. A sealed or out-of-order attempt gives a hint and grants nothing.
- Connection to other objects/clues: Vanity, Flood Tunnel, ritual seal, and the deliberate decision to keep Memory closed.

OBJECT NAME: Power station and support table — uf_02_charge_1 [`upper/uf_02_charge_1`]

- Location: UF-02 — Master Bedroom; upper x=1240, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `upper_hide_01` in UF-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bench — upper/Furniture1 [`upper/Furniture1`]

- Location: UF-02 — Master Bedroom; upper x=1080, y=434.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Side Table — upper/decoration-03 [`upper/decoration-03`]

- Location: UF-02 — Master Bedroom; upper x=1210, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Candle — upper/decoration-03/detail-1 [`upper/decoration-03/detail-1`]

- Location: UF-02 — Master Bedroom; upper x=1210, y=392. Detail on `upper/decoration-03`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The highlight breaks across a small chip on the front edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `upper/decoration-03`; Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Bookshelf — upper/decoration-04 [`upper/decoration-04`]

- Location: UF-02 — Master Bedroom; upper x=1460, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A pale scrape marks the near-left edge. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Wood Chair — upper/decoration-05 [`upper/decoration-05`]

- Location: UF-02 — Master Bedroom; upper x=1890, y=392.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. Dust remains in the far corner where a hand would not easily reach. Art width specification: 51 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `sight_key` in UF-02.

OBJECT NAME: Mirror Frame — vanity_seal/detail-1 [`vanity_seal/detail-1`]

- Location: UF-02 — Master Bedroom; upper x=1740, y=440. Detail on `vanity_seal`, local offset [0, -80]; parent coordinates shown.
- Appearance: A small upright mirror frame with tarnished ornament and a dim central reflective plane. Dust remains in the far corner where a hand would not easily reach. Art width specification: 55 units before its parent/asset scale.
- Lore/backstory tied to this object: The vanity’s mirror expresses Sight as exposure; it contains no coded reflection or extra figure. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It gives the light back. That is enough to worry about.”
- Connection to other objects/clues: Mounted on `vanity_seal`; Nearest functional landmark: `vanity_seal` in UF-02.

OBJECT NAME: Vase — vanity_seal/detail-2 [`vanity_seal/detail-2`]

- Location: UF-02 — Master Bedroom; upper x=1740, y=440. Detail on `vanity_seal`, local offset [43, -92]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 16 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `vanity_seal`; Nearest functional landmark: `vanity_seal` in UF-02.

OBJECT NAME: Ordinary table — uf_02_charge_2 [`uf_02_charge_2`]

- Location: UF-02 — Master Bedroom; upper x=1765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vanity_seal` in UF-02.

OBJECT NAME: Book — uf_02_charge_2/tabletop [`uf_02_charge_2/tabletop`]

- Location: UF-02 — Master Bedroom; upper x=1765, y=590. Detail on `uf_02_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_02_charge_2`; Nearest functional landmark: `vanity_seal` in UF-02.

OBJECT NAME: Sideboard — UF-02/dressing-01 [`UF-02/dressing-01`]

- Location: UF-02 — Master Bedroom; upper x=1569, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A pale scrape marks the near-left edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Book — UF-02/dressing-01/detail-1 [`UF-02/dressing-01/detail-1`]

- Location: UF-02 — Master Bedroom; upper x=1569, y=395. Detail on `UF-02/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `UF-02/dressing-01`; Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Vase — UF-02/dressing-01/detail-2 [`UF-02/dressing-01/detail-2`]

- Location: UF-02 — Master Bedroom; upper x=1569, y=395. Detail on `UF-02/dressing-01`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. Dust remains in the far corner where a hand would not easily reach. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `UF-02/dressing-01`; Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Screen — UF-02/dressing-02 [`UF-02/dressing-02`]

- Location: UF-02 — Master Bedroom; upper x=1356, y=395.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. Dust remains in the far corner where a hand would not easily reach. Art width specification: 108 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Settee — UF-02/dressing-03 [`UF-02/dressing-03`]

- Location: UF-02 — Master Bedroom; upper x=1554, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

OBJECT NAME: Wood Chair — UF-02/dressing-04 [`UF-02/dressing-04`]

- Location: UF-02 — Master Bedroom; upper x=1673, y=590.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `vanity_seal` in UF-02.

OBJECT NAME: Wood Chair — UF-02/dressing-05 [`UF-02/dressing-05`]

- Location: UF-02 — Master Bedroom; upper x=1846, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. One exposed corner is blunted by repeated contact. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `sight_key` in UF-02.

OBJECT NAME: Woven rug — UF-02/rug-1 [`UF-02/rug-1`]

- Location: UF-02; upper x=1460, y=566; footprint 270 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #302e3b; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the private bedchamber; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `upper_hide_01` in UF-02; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — upper/window-1460 [`upper/window-1460`]

- Location: UF-02 — Master Bedroom; upper x=1505, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: private bedchamber.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_01` in UF-02.

### UF-03 — Nursery

OBJECT NAME: Hide in toybox — upper_hide_02 [`upper/upper_hide_02`]

- Location: UF-03 — Nursery; upper x=2390, y=570.
- Appearance: A nursery toy chest with a designated concealed pocket beside its substantial body.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `medium` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vantree_04` in UF-03; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Vantree - IV [`upper/vantree_04`]

- Location: UF-03 — Nursery; upper x=2780, y=450.
- Appearance: A separate folded page, numbered 4, with a readable central text block and frayed handling edges. In Nursery, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The Custodian was a kinder word. Jailer was the honest one.”

  **Authored complete first-person letter:**

  > I found the older title in papers that had been handled so often the fold had become a hole. Custodian. I liked its promise of temporary responsibility. I could imagine handing over a key and leaving with clean hands.
  >
  > The Custodian was a kinder word. Jailer was the honest one. I write the honest word here because I have run out of kinder ones that do not hide somebody.
  >
  > I cannot tell you whose room this was. I will not invent a child to make my own conduct easier to condemn. I can tell you that these small furnishings made every instruction to remain sound worse. If you take my place, at least know what the place is called.
- Connection to other objects/clues: The scratched nameplate and CR-04 title sequence; collecting this letter also records the Jailer lore hint.

OBJECT NAME: Power station and support table — uf_03_charge_1 [`upper/uf_03_charge_1`]

- Location: UF-03 — Nursery; upper x=2240, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `upper_hide_02` in UF-03; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Settee — upper/Furniture3 [`upper/Furniture3`]

- Location: UF-03 — Nursery; upper x=2940, y=457.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. One exposed corner is blunted by repeated contact. Art width specification: 164 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: Side Table — upper/decoration-06 [`upper/decoration-06`]

- Location: UF-03 — Nursery; upper x=2330, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Candle — upper/decoration-06/detail-1 [`upper/decoration-06/detail-1`]

- Location: UF-03 — Nursery; upper x=2330, y=392. Detail on `upper/decoration-06`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `upper/decoration-06`; Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Screen — upper/decoration-07 [`upper/decoration-07`]

- Location: UF-03 — Nursery; upper x=2570, y=392.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. A dark moisture line remains close to its lower edge. Art width specification: 102 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Side Table — upper/decoration-08 [`upper/decoration-08`]

- Location: UF-03 — Nursery; upper x=2840, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: Water Set — upper/decoration-08/detail-1 [`upper/decoration-08/detail-1`]

- Location: UF-03 — Nursery; upper x=2840, y=392. Detail on `upper/decoration-08`, local offset [0, -47]; parent coordinates shown.
- Appearance: A pale water vessel and smaller matching cup grouped on a tray-like surface. One exposed corner is blunted by repeated contact. Art width specification: 26 units before its parent/asset scale.
- Lore/backstory tied to this object: A small hospitality arrangement contrasts with the isolation of the present night. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone arranged this for a person who needed it.”
- Connection to other objects/clues: Mounted on `upper/decoration-08`; Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: High Chair — upper/decoration-13 [`upper/decoration-13`]

- Location: UF-03 — Nursery; upper x=2190, y=392.
- Appearance: A tall small-seat chair with narrow legs, a raised support, and softened paint at the edges. A pale scrape marks the near-left edge. Art width specification: 58 units before its parent/asset scale.
- Lore/backstory tied to this object: Its presence supplies a domestic scale; it does not establish a named child or a death. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I cannot tell who sat here from a chair.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Ordinary table — uf_03_charge_2 [`uf_03_charge_2`]

- Location: UF-03 — Nursery; upper x=2765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: Book — uf_03_charge_2/tabletop [`uf_03_charge_2/tabletop`]

- Location: UF-03 — Nursery; upper x=2765, y=590. Detail on `uf_03_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_03_charge_2`; Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: Bookshelf — UF-03/dressing-01 [`UF-03/dressing-01`]

- Location: UF-03 — Nursery; upper x=2107, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. Dust remains in the far corner where a hand would not easily reach. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `sight_key` in UF-02.

OBJECT NAME: Toy Chest — UF-03/dressing-02 [`UF-03/dressing-02`]

- Location: UF-03 — Nursery; upper x=2283, y=605.
- Appearance: A squat wooden chest with a rounded-looking lid, scuffed corners, and a dark interior seam. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 100 units before its parent/asset scale.
- Lore/backstory tied to this object: The furnishing evokes storage and childhood scale without adding an undocumented child character. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A small place for things somebody meant to keep.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Wood Chair — UF-03/dressing-03 [`UF-03/dressing-03`]

- Location: UF-03 — Nursery; upper x=2496, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Bench — UF-03/dressing-04 [`UF-03/dressing-04`]

- Location: UF-03 — Nursery; upper x=2451, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Bed — UF-03/dressing-05 [`UF-03/dressing-05`]

- Location: UF-03 — Nursery; upper x=2900, y=605.
- Appearance: A heavy timber bed with a low mattress, faded cover, and a narrow shadow beneath its frame. The highlight breaks across a small chip on the front edge. Art width specification: 100 units before its parent/asset scale.
- Lore/backstory tied to this object: The familiar shape of rest becomes a spatial question about concealment. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “There is room beneath it. There is no promise attached.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_04` in UF-03.

OBJECT NAME: Woven rug — UF-03/rug-1 [`UF-03/rug-1`]

- Location: UF-03; upper x=2460, y=566; footprint 270 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #302e3b; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the nursery storage and family seating; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `upper_hide_02` in UF-03; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — upper/window-2420 [`upper/window-2420`]

- Location: UF-03 — Nursery; upper x=2465, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: nursery storage and family seating.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `upper_hide_02` in UF-03.

OBJECT NAME: Upper lower shadow lane [`upper/shadow-lane`]

- Location: UF-03 through UF-07; visual strip x=2700–6300, y=550–624.
- Appearance: A subdued bordered lower lane offers a visual path under the pale upper-floor light bands.
- Lore/backstory tied to this object: A service-like edge contrasts with the formal rooms.
- In-game purpose: Visual cue only: current exposure uses x-ranges, so walking lower does not automatically remove exposure.
- Player interaction: Turn off the torch, crouch, and use actual opaque furniture/line-of-sight cover. Do not rely on this painted strip alone.
- Connection to other objects/clues: Sight Key, vanity, and configured light_regions.

OBJECT NAME: Upper moonlight band 1 [`upper/moon-band-1`]

- Location: Upper zone x=2650–3300, y=355–535; may span the next room boundary.
- Appearance: A shader-softened pale diagonal-looking floor light band with a cold edge and a subdued interior.
- Lore/backstory tied to this object: Windows suggest an outside that is visible but unreachable.
- In-game purpose: Presentation lighting; the authored light_regions remain the mechanical exposure authority.
- Player interaction: No switch, collection, or timed safe gap. Furniture can still break the enemy's line of sight.
- Connection to other objects/clues: Upper windows, upper/shadow-lane, and the Sight Key.

### UF-04 — Linen Hall

OBJECT NAME: Upper Vent — upper_vent [`upper/upper_vent`]

- Location: UF-04 — Linen Hall; upper x=3240, y=410.
- Appearance: A low metal service vent with a dark interior, readable rim, and enough open floor for a crouch-to-crawl transition.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to GF-08 in ground, arrival `ground_vent`. Requirement: none.
- Player interaction: E performs a separate vent-entry crawl, fades through the transition, and plays an emergence action at the linked vent.
- Connection to other objects/clues: Destination `ground` / `ground_vent`; GF-08. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Flashlight Battery [`upper/upper_battery`]

- Location: UF-04 — Linen Hall; upper x=3770, y=470.
- Appearance: A short practical flashlight cell with dulled metal ends and a worn wrapper; keep it smaller than Els's hand span. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A practical supply compatible with Els's own light; its original purchaser is unknown.
- In-game purpose: Restore 45 seconds of charge, capped at 90, when Q selects a battery.
- Player interaction: E takes the bundle, adds 1 battery, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `upper_vent` in UF-04; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — uf_04_charge_1 [`upper/uf_04_charge_1`]

- Location: UF-04 — Linen Hall; upper x=3345, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `upper_vent` in UF-04; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — upper/Furniture2 [`upper/Furniture2`]

- Location: UF-04 — Linen Hall; upper x=3500, y=425.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A dark moisture line remains close to its lower edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `upper_vent` in UF-04.

OBJECT NAME: Book — upper/Furniture2/detail-1 [`upper/Furniture2/detail-1`]

- Location: UF-04 — Linen Hall; upper x=3500, y=425. Detail on `upper/Furniture2`, local offset [0, -95]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 33 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `upper/Furniture2`; Nearest functional landmark: `upper_vent` in UF-04.

OBJECT NAME: Dining Chair — upper/decoration-09 [`upper/decoration-09`]

- Location: UF-04 — Linen Hall; upper x=3200, y=392.
- Appearance: A dining chair with a shaped back, dulled finish, and thin edges catching the lamp light. The highlight breaks across a small chip on the front edge. Art width specification: 52 units before its parent/asset scale.
- Lore/backstory tied to this object: Its form belongs to shared meals, now reduced to an obstacle around an empty table. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “One place at a table nobody has cleared.”
- Connection to other objects/clues: Nearest functional landmark: `upper_vent` in UF-04.

OBJECT NAME: Bookshelf — upper/decoration-10 [`upper/decoration-10`]

- Location: UF-04 — Linen Hall; upper x=3760, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A dark moisture line remains close to its lower edge. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Ordinary table — uf_04_charge_2 [`uf_04_charge_2`]

- Location: UF-04 — Linen Hall; upper x=3765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Book — uf_04_charge_2/tabletop [`uf_04_charge_2/tabletop`]

- Location: UF-04 — Linen Hall; upper x=3765, y=590. Detail on `uf_04_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_04_charge_2`; Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Sideboard — UF-04/dressing-01 [`UF-04/dressing-01`]

- Location: UF-04 — Linen Hall; upper x=3629, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Book — UF-04/dressing-01/detail-1 [`UF-04/dressing-01/detail-1`]

- Location: UF-04 — Linen Hall; upper x=3629, y=395. Detail on `UF-04/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `UF-04/dressing-01`; Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Vase — UF-04/dressing-01/detail-2 [`UF-04/dressing-01/detail-2`]

- Location: UF-04 — Linen Hall; upper x=3629, y=395. Detail on `UF-04/dressing-01`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. A dark moisture line remains close to its lower edge. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `UF-04/dressing-01`; Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Sideboard — UF-04/dressing-02 [`UF-04/dressing-02`]

- Location: UF-04 — Linen Hall; upper x=3899, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A dark moisture line remains close to its lower edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Book — UF-04/dressing-02/detail-1 [`UF-04/dressing-02/detail-1`]

- Location: UF-04 — Linen Hall; upper x=3899, y=395. Detail on `UF-04/dressing-02`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `UF-04/dressing-02`; Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Vase — UF-04/dressing-02/detail-2 [`UF-04/dressing-02/detail-2`]

- Location: UF-04 — Linen Hall; upper x=3899, y=395. Detail on `UF-04/dressing-02`, local offset [34, -98]; parent coordinates shown.
- Appearance: A narrow ceramic vessel with a dark mouth, faded glaze, and a thin highlight down one side. One exposed corner is blunted by repeated contact. Art width specification: 18 units before its parent/asset scale.
- Lore/backstory tied to this object: The vessel preserves a gesture of display after flowers and their caretaker are absent. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The container stayed after its purpose dried out.”
- Connection to other objects/clues: Mounted on `UF-04/dressing-02`; Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Serving Cart — UF-04/dressing-03 [`UF-04/dressing-03`]

- Location: UF-04 — Linen Hall; upper x=3496, y=605.
- Appearance: A two-tier service cart with small dark wheels, a raised handle, and stained shelf surfaces. One exposed corner is blunted by repeated contact. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: Food and equipment once moved through these service routes. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It was meant to make carrying things easier.”
- Connection to other objects/clues: Nearest functional landmark: `upper_vent` in UF-04.

OBJECT NAME: Sideboard — UF-04/dressing-04 [`UF-04/dressing-04`]

- Location: UF-04 — Linen Hall; upper x=3663, y=590.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The highlight breaks across a small chip on the front edge. Art width specification: 100 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Bench — UF-04/dressing-05 [`UF-04/dressing-05`]

- Location: UF-04 — Linen Hall; upper x=3881, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Window — upper/window-3380 [`upper/window-3380`]

- Location: UF-04 — Linen Hall; upper x=3425, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: linen storage and folding.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `upper_vent` in UF-04.

### UF-05 — Bathroom

OBJECT NAME: Power station and support table — upper_recharge [`upper/upper_recharge`]

- Location: UF-05 — Bathroom; upper x=4380, y=430.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `bathroom_bottle` in UF-05; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Glass Bottle [`upper/bathroom_bottle`]

- Location: UF-05 — Bathroom; upper x=4880, y=535.
- Appearance: A usable dark glass bottle with a clear neck silhouette and a small floor contact shadow. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A household supply repurposed into a deliberate sound source. Decorative bottles elsewhere remain separate.
- In-game purpose: Q places a GLASS noise 260 units ahead, radius 576; counts toward the Echoes gate only on Untouched.
- Player interaction: E takes the bundle, adds 1 bottle, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `upper_stairs` in UF-06; the inventory count confirms acquisition.

OBJECT NAME: Washstand — upper/Furniture4 [`upper/Furniture4`]

- Location: UF-05 — Bathroom; upper x=4140, y=430.
- Appearance: A waist-high washing stand with a stained top, pale basin shape, and darkened supports. The highlight breaks across a small chip on the front edge. Art width specification: 170 units before its parent/asset scale.
- Lore/backstory tied to this object: Cleaning belonged to this room’s ordinary routine; it cannot wash away a restored sense. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Water would clean my hands. It would not undo a key.”
- Connection to other objects/clues: Nearest functional landmark: `upper_battery` in UF-04.

OBJECT NAME: Screen — upper/decoration-11 [`upper/decoration-11`]

- Location: UF-05 — Bathroom; upper x=4540, y=392.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. One exposed corner is blunted by repeated contact. Art width specification: 102 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Bathtub — upper/decoration-12 [`upper/decoration-12`]

- Location: UF-05 — Bathroom; upper x=4780, y=438.
- Appearance: A deep pale tub with a chipped rim, dark feet, and a dull gray interior catching the narrow light. The highlight breaks across a small chip on the front edge. Art width specification: 170 units before its parent/asset scale.
- Lore/backstory tied to this object: A domestic fixture makes the upper floor inhabitable without becoming an invented escape duct. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “No drain large enough for an explanation.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Ordinary table — uf_05_charge_2 [`uf_05_charge_2`]

- Location: UF-05 — Bathroom; upper x=4765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Water Set — uf_05_charge_2/tabletop [`uf_05_charge_2/tabletop`]

- Location: UF-05 — Bathroom; upper x=4765, y=590. Detail on `uf_05_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A pale water vessel and smaller matching cup grouped on a tray-like surface. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: A small hospitality arrangement contrasts with the isolation of the present night. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone arranged this for a person who needed it.”
- Connection to other objects/clues: Mounted on `uf_05_charge_2`; Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Wood Chair — UF-05/dressing-01 [`UF-05/dressing-01`]

- Location: UF-05 — Bathroom; upper x=4396, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Bench — UF-05/dressing-02 [`UF-05/dressing-02`]

- Location: UF-05 — Bathroom; upper x=4601, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Wood Chair — UF-05/dressing-03 [`UF-05/dressing-03`]

- Location: UF-05 — Bathroom; upper x=4903, y=395.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. The highlight breaks across a small chip on the front edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Window — upper/window-4340 [`upper/window-4340`]

- Location: UF-05 — Bathroom; upper x=4385, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: washroom and dressing.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Upper moonlight band 2 [`upper/moon-band-2`]

- Location: Upper zone x=4300–4950, y=355–535; may span the next room boundary.
- Appearance: A shader-softened pale diagonal-looking floor light band with a cold edge and a subdued interior.
- Lore/backstory tied to this object: Windows suggest an outside that is visible but unreachable.
- In-game purpose: Presentation lighting; the authored light_regions remain the mechanical exposure authority.
- Player interaction: No switch, collection, or timed safe gap. Furniture can still break the enemy's line of sight.
- Connection to other objects/clues: Upper windows, upper/shadow-lane, and the Sight Key.

### UF-06 — Stairwell Down

OBJECT NAME: Ground Floor — upper_stairs [`upper/upper_stairs`]

- Location: UF-06 — Stairwell Down; upper x=5560, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to GF-09 in ground, arrival `upper_stairs`. Requirement: none.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `ground` / `upper_stairs`; GF-09. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Bench — upper/Furniture5 [`upper/Furniture5`]

- Location: UF-06 — Stairwell Down; upper x=5310, y=430.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Wood Chair — upper/decoration-14 [`upper/decoration-14`]

- Location: UF-06 — Stairwell Down; upper x=5810, y=392.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. Dust remains in the far corner where a hand would not easily reach. Art width specification: 51 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Ordinary table — uf_06_charge_1 [`uf_06_charge_1`]

- Location: UF-06 — Stairwell Down; upper x=5170, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Book — uf_06_charge_1/tabletop [`uf_06_charge_1/tabletop`]

- Location: UF-06 — Stairwell Down; upper x=5170, y=405. Detail on `uf_06_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_06_charge_1`; Nearest functional landmark: `bathroom_bottle` in UF-05.

OBJECT NAME: Ordinary table — uf_06_charge_2 [`uf_06_charge_2`]

- Location: UF-06 — Stairwell Down; upper x=5765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Book — uf_06_charge_2/tabletop [`uf_06_charge_2/tabletop`]

- Location: UF-06 — Stairwell Down; upper x=5765, y=590. Detail on `uf_06_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_06_charge_2`; Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Bookshelf — UF-06/dressing-01 [`UF-06/dressing-01`]

- Location: UF-06 — Stairwell Down; upper x=5697, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. One exposed corner is blunted by repeated contact. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Coat Stand — UF-06/dressing-02 [`UF-06/dressing-02`]

- Location: UF-06 — Stairwell Down; upper x=5433, y=395.
- Appearance: A narrow coat stand on splayed feet, its hooks catching small pale highlights above an empty trunk. The highlight breaks across a small chip on the front edge. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: The stand assumes a visitor will return for what they leave behind. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Built for people who expected to leave again.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Bench — UF-06/dressing-03 [`UF-06/dressing-03`]

- Location: UF-06 — Stairwell Down; upper x=5571, y=590.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Settee — UF-06/dressing-04 [`UF-06/dressing-04`]

- Location: UF-06 — Stairwell Down; upper x=5884, y=605.
- Appearance: A low upholstered settee, faded plum cloth stretched over a timber frame, with a sagging middle and bright worn arm ends. Dust remains in the far corner where a hand would not easily reach. Art width specification: 156 units before its parent/asset scale.
- Lore/backstory tied to this object: Comfort survives as a shape after its assurance has gone. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The seat remembers more use than the room admits.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Wood Chair — UF-06/dressing-05 [`UF-06/dressing-05`]

- Location: UF-06 — Stairwell Down; upper x=5686, y=605.
- Appearance: A straight-backed wooden chair with a worn front rung and a seat polished in a shallow oval. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: A movable seat suggests work or waiting; no named owner’s history is established. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Turned toward the room, as if something needed watching.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Woven rug — UF-06/rug-1 [`UF-06/rug-1`]

- Location: UF-06; upper x=5460, y=566; footprint 270 by 62.
- Appearance: A flat woven rug with a narrow double border, repeated diamonds, and frayed short edges. Authored base color #302e3b; its margins remain visible below furniture.
- Lore/backstory tied to this object: Soft footing belongs to the stair landing and reading seat; wear implies use without assigning an owner.
- In-game purpose: Actual carpet surface inside this footprint; quieter footsteps, not immunity to Touch.
- Player interaction: Walk or crouch across it; no E prompt. It remains on the floor and cannot be collected.
- Connection to other objects/clues: `upper_stairs` in UF-06; NoiseModel uses CARPET for the actual rug footprint.

OBJECT NAME: Window — upper/window-5300 [`upper/window-5300`]

- Location: UF-06 — Stairwell Down; upper x=5345, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: stair landing and reading seat.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `upper_stairs` in UF-06.

OBJECT NAME: Upper moonlight band 3 [`upper/moon-band-3`]

- Location: Upper zone x=5950–6600, y=355–535; may span the next room boundary.
- Appearance: A shader-softened pale diagonal-looking floor light band with a cold edge and a subdued interior.
- Lore/backstory tied to this object: Windows suggest an outside that is visible but unreachable.
- In-game purpose: Presentation lighting; the authored light_regions remain the mechanical exposure authority.
- Player interaction: No switch, collection, or timed safe gap. Furniture can still break the enemy's line of sight.
- Connection to other objects/clues: Upper windows, upper/shadow-lane, and the Sight Key.

### UF-07 — Vent Junction A

OBJECT NAME: Vent To Ground — vent_to_ground [`upper/vent_to_ground`]

- Location: UF-07 — Vent Junction A; upper x=6300, y=410.
- Appearance: A low metal service vent with a dark interior, readable rim, and enough open floor for a crouch-to-crawl transition.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to GF-08 in ground, arrival `ground_vent`. Requirement: none.
- Player interaction: E performs a separate vent-entry crawl, fades through the transition, and plays an emergence action at the linked vent.
- Connection to other objects/clues: Destination `ground` / `ground_vent`; GF-08. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Vent To Basement — vent_to_basement [`upper/vent_to_basement`]

- Location: UF-07 — Vent Junction A; upper x=6750, y=410.
- Appearance: A low metal service vent with a dark interior, readable rim, and enough open floor for a crouch-to-crawl transition.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to BS-02 in basement, arrival `basement_vent`. Requirement: none.
- Player interaction: E performs a separate vent-entry crawl, fades through the transition, and plays an emergence action at the linked vent.
- Connection to other objects/clues: Destination `basement` / `basement_vent`; BS-02. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — uf_07_charge_1 [`upper/uf_07_charge_1`]

- Location: UF-07 — Vent Junction A; upper x=6170, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `vent_to_ground` in UF-07; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — upper/Furniture6 [`upper/Furniture6`]

- Location: UF-07 — Vent Junction A; upper x=6040, y=422.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. Dust remains in the far corner where a hand would not easily reach. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_ground` in UF-07.

OBJECT NAME: Creamer — upper/Furniture6/detail-1 [`upper/Furniture6/detail-1`]

- Location: UF-07 — Vent Junction A; upper x=6040, y=422. Detail on `upper/Furniture6`, local offset [0, -95]; parent coordinates shown.
- Appearance: A small pale pouring vessel with a short spout and a curved handle darkened at its inner edge. Dust remains in the far corner where a hand would not easily reach. Art width specification: 31 units before its parent/asset scale.
- Lore/backstory tied to this object: A remnant of table service makes the house feel interrupted rather than purpose-built as a dungeon. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A careful little thing in a careless room.”
- Connection to other objects/clues: Mounted on `upper/Furniture6`; Nearest functional landmark: `vent_to_ground` in UF-07.

OBJECT NAME: Bookshelf — upper/decoration-15 [`upper/decoration-15`]

- Location: UF-07 — Vent Junction A; upper x=6190, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 91 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_ground` in UF-07.

OBJECT NAME: Bench — upper/decoration-16 [`upper/decoration-16`]

- Location: UF-07 — Vent Junction A; upper x=6510, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 124 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_ground` in UF-07.

OBJECT NAME: Side Table — upper/decoration-17 [`upper/decoration-17`]

- Location: UF-07 — Vent Junction A; upper x=6630, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Candle — upper/decoration-17/detail-1 [`upper/decoration-17/detail-1`]

- Location: UF-07 — Vent Junction A; upper x=6630, y=392. Detail on `upper/decoration-17`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. One exposed corner is blunted by repeated contact. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `upper/decoration-17`; Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Bookshelf — upper/decoration-18 [`upper/decoration-18`]

- Location: UF-07 — Vent Junction A; upper x=6860, y=392.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The highlight breaks across a small chip on the front edge. Art width specification: 75 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Side Table — upper/decoration-19 [`upper/decoration-19`]

- Location: UF-07 — Vent Junction A; upper x=7130, y=392. Beyond the playable eastern boundary.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Legacy out-of-bounds dressing: remove or move inside a deliberate layout pass; it is not a secret reachable object.
- Player interaction: Unreachable in ordinary play; no pickup or clue depends on it.
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Candle — upper/decoration-19/detail-1 [`upper/decoration-19/detail-1`]

- Location: UF-07 — Vent Junction A; upper x=7130, y=392. Detail on `upper/decoration-19`, local offset [0, -39]; parent coordinates shown. Beyond the playable eastern boundary.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A pale scrape marks the near-left edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Legacy out-of-bounds dressing: remove or move inside a deliberate layout pass; it is not a secret reachable object.
- Player interaction: Unreachable in ordinary play; no pickup or clue depends on it.
- Connection to other objects/clues: Mounted on `upper/decoration-19`; Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Ordinary table — uf_07_charge_2 [`uf_07_charge_2`]

- Location: UF-07 — Vent Junction A; upper x=6765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Book — uf_07_charge_2/tabletop [`uf_07_charge_2/tabletop`]

- Location: UF-07 — Vent Junction A; upper x=6765, y=590. Detail on `uf_07_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `uf_07_charge_2`; Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Bottle Crate — UF-07/dressing-01 [`UF-07/dressing-01`]

- Location: UF-07 — Vent Junction A; upper x=6401, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. The highlight breaks across a small chip on the front edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_ground` in UF-07.

OBJECT NAME: Bottle Crate — UF-07/dressing-02 [`UF-07/dressing-02`]

- Location: UF-07 — Vent Junction A; upper x=6603, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A pale scrape marks the near-left edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Bench — UF-07/dressing-03 [`UF-07/dressing-03`]

- Location: UF-07 — Vent Junction A; upper x=6881, y=590.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_basement` in UF-07.

OBJECT NAME: Window — upper/window-6260 [`upper/window-6260`]

- Location: UF-07 — Vent Junction A; upper x=6305, y=297.
- Appearance: A tall narrow estate window with dark mullions, desaturated glass, and cold moon-colored light. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: The outside can be visible without being reachable; these windows do not offer alternative exits. Here its placement supports the room’s role: service junction storage.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I can see beyond it. I cannot get through it.”
- Connection to other objects/clues: Nearest functional landmark: `vent_to_ground` in UF-07.

### BS-01 — Cellar Stairs

OBJECT NAME: Ground Floor — ground_stairs [`basement/ground_stairs`]

- Location: BS-01 — Cellar Stairs; basement x=180, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to GF-10 in ground, arrival `basement_stairs`. Requirement: none.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `ground` / `basement_stairs`; GF-10. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — bs_01_charge_1 [`basement/bs_01_charge_1`]

- Location: BS-01 — Cellar Stairs; basement x=275, y=430.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `ground_stairs` in BS-01; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Bottle Crate — basement/decoration-01 [`basement/decoration-01`]

- Location: BS-01 — Cellar Stairs; basement x=360, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A pale scrape marks the near-left edge. Art width specification: 53 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Stock Pot — basement/decoration-02 [`basement/decoration-02`]

- Location: BS-01 — Cellar Stairs; basement x=790, y=392.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. Dust remains in the far corner where a hand would not easily reach. Art width specification: 41 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Ordinary table — bs_01_charge_2 [`bs_01_charge_2`]

- Location: BS-01 — Cellar Stairs; basement x=590, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Bottles — bs_01_charge_2/tabletop [`bs_01_charge_2/tabletop`]

- Location: BS-01 — Cellar Stairs; basement x=590, y=590. Detail on `bs_01_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_01_charge_2`; Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Sideboard — BS-01/dressing-01 [`BS-01/dressing-01`]

- Location: BS-01 — Cellar Stairs; basement x=459, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The highlight breaks across a small chip on the front edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Bottles — BS-01/dressing-01/detail-1 [`BS-01/dressing-01/detail-1`]

- Location: BS-01 — Cellar Stairs; basement x=459, y=395. Detail on `BS-01/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. The highlight breaks across a small chip on the front edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `BS-01/dressing-01`; Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Book — BS-01/dressing-01/detail-2 [`BS-01/dressing-01/detail-2`]

- Location: BS-01 — Cellar Stairs; basement x=459, y=395. Detail on `BS-01/dressing-01`, local offset [30, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `BS-01/dressing-01`; Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Wine Rack — BS-01/dressing-02 [`BS-01/dressing-02`]

- Location: BS-01 — Cellar Stairs; basement x=271, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. A pale scrape marks the near-left edge. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Bottle Crate — BS-01/dressing-03 [`BS-01/dressing-03`]

- Location: BS-01 — Cellar Stairs; basement x=401, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. Dust remains in the far corner where a hand would not easily reach. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Bench — BS-01/dressing-04 [`BS-01/dressing-04`]

- Location: BS-01 — Cellar Stairs; basement x=591, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

OBJECT NAME: Bottle Crate — BS-01/dressing-05 [`BS-01/dressing-05`]

- Location: BS-01 — Cellar Stairs; basement x=671, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A dark moisture line remains close to its lower edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: cellar receiving area.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `ground_stairs` in BS-01.

### BS-04 — Flooded Cellar

OBJECT NAME: Maintenance Exit — maintenance_exit [`basement/maintenance_exit`]

- Location: BS-04 — Flooded Cellar; basement x=1500, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Part I branch exit. Exactly Hearing and Sight, with no Memory, yields Partial Mercy.
- Player interaction: E checks the current state. A valid state plays departure and selects the chapter outcome; an invalid state provides a sealed-passage hint.
- Connection to other objects/clues: BS-04, Sight Key, and Partial Mercy Part II in CR-01.

OBJECT NAME: Power station and support table — bs_04_charge_1 [`basement/bs_04_charge_1`]

- Location: BS-04 — Flooded Cellar; basement x=1145, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `maintenance_exit` in BS-04; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — basement/Furniture1 [`basement/Furniture1`]

- Location: BS-04 — Flooded Cellar; basement x=1010, y=435.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. The highlight breaks across a small chip on the front edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottle Crate — basement/Furniture1/detail-1 [`basement/Furniture1/detail-1`]

- Location: BS-04 — Flooded Cellar; basement x=1010, y=435. Detail on `basement/Furniture1`, local offset [0, -95]; parent coordinates shown.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. The highlight breaks across a small chip on the front edge. Art width specification: 47 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Mounted on `basement/Furniture1`; Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottle Crate — basement/decoration-03 [`basement/decoration-03`]

- Location: BS-04 — Flooded Cellar; basement x=1270, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 53 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottle Crate — basement/decoration-04 [`basement/decoration-04`]

- Location: BS-04 — Flooded Cellar; basement x=1340, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A dark moisture line remains close to its lower edge. Art width specification: 53 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Wine Rack — basement/decoration-05 [`basement/decoration-05`]

- Location: BS-04 — Flooded Cellar; basement x=1620, y=392.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. One exposed corner is blunted by repeated contact. Art width specification: 77 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Ordinary table — bs_04_charge_2 [`bs_04_charge_2`]

- Location: BS-04 — Flooded Cellar; basement x=1705, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottles — bs_04_charge_2/tabletop [`bs_04_charge_2/tabletop`]

- Location: BS-04 — Flooded Cellar; basement x=1705, y=590. Detail on `bs_04_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. A pale scrape marks the near-left edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_04_charge_2`; Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Wine Shelf — BS-04/dressing-01 [`BS-04/dressing-01`]

- Location: BS-04 — Flooded Cellar; basement x=1724, y=395.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 130 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Wine Rack — BS-04/dressing-02 [`BS-04/dressing-02`]

- Location: BS-04 — Flooded Cellar; basement x=1141, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. A dark moisture line remains close to its lower edge. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottle Crate — BS-04/dressing-03 [`BS-04/dressing-03`]

- Location: BS-04 — Flooded Cellar; basement x=1311, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. One exposed corner is blunted by repeated contact. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottle Crate — BS-04/dressing-04 [`BS-04/dressing-04`]

- Location: BS-04 — Flooded Cellar; basement x=1821, y=395.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. The highlight breaks across a small chip on the front edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bench — BS-04/dressing-05 [`BS-04/dressing-05`]

- Location: BS-04 — Flooded Cellar; basement x=1591, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Stock Pot — BS-04/dressing-06 [`BS-04/dressing-06`]

- Location: BS-04 — Flooded Cellar; basement x=1833, y=605.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. Dust remains in the far corner where a hand would not easily reach. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: damp stores above the flood.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Flooded cellar water [`basement/flood-water`]

- Location: BS-04; mechanical water x=800–2000; visible water begins near x=900.
- Appearance: A shallow dark water plane with sparse horizontal reflection strokes and a thin far waterline.
- Lore/backstory tied to this object: Water has entered the occupied storage level; no drowned individual is established.
- In-game purpose: Implemented WATER footstep region.
- Player interaction: Crossing creates louder steps than stone. There is no swimming, oxygen meter, or drain-valve puzzle.
- Connection to other objects/clues: maintenance_exit and the charge station in BS-04.

### BS-02 — Wine Cellar

OBJECT NAME: Basement Vent — basement_vent [`basement/basement_vent`]

- Location: BS-02 — Wine Cellar; basement x=2740, y=410.
- Appearance: A low metal service vent with a dark interior, readable rim, and enough open floor for a crouch-to-crawl transition.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to UF-07 in upper, arrival `vent_to_basement`. Requirement: none.
- Player interaction: E performs a separate vent-entry crawl, fades through the transition, and plays an emergence action at the linked vent.
- Connection to other objects/clues: Destination `upper` / `vent_to_basement`; UF-07. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Power station and support table — bs_02_charge_1 [`basement/bs_02_charge_1`]

- Location: BS-02 — Wine Cellar; basement x=2310, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `basement_vent` in BS-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — basement/Furniture2 [`basement/Furniture2`]

- Location: BS-02 — Wine Cellar; basement x=2070, y=440.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A pale scrape marks the near-left edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Stock Pot — basement/Furniture2/detail-1 [`basement/Furniture2/detail-1`]

- Location: BS-02 — Wine Cellar; basement x=2070, y=440. Detail on `basement/Furniture2`, local offset [-26, -87]; parent coordinates shown.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. A pale scrape marks the near-left edge. Art width specification: 35 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Mounted on `basement/Furniture2`; Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Bottles — basement/Furniture2/detail-2 [`basement/Furniture2/detail-2`]

- Location: BS-02 — Wine Cellar; basement x=2070, y=440. Detail on `basement/Furniture2`, local offset [32, -104]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. Dust remains in the far corner where a hand would not easily reach. Art width specification: 33 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `basement/Furniture2`; Nearest functional landmark: `maintenance_exit` in BS-04.

OBJECT NAME: Sideboard — basement/Furniture3 [`basement/Furniture3`]

- Location: BS-02 — Wine Cellar; basement x=3060, y=452.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. Dust remains in the far corner where a hand would not easily reach. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bottles — basement/Furniture3/detail-1 [`basement/Furniture3/detail-1`]

- Location: BS-02 — Wine Cellar; basement x=3060, y=452. Detail on `basement/Furniture3`, local offset [-25, -87]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. Dust remains in the far corner where a hand would not easily reach. Art width specification: 33 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `basement/Furniture3`; Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bottles — basement/Furniture3/detail-2 [`basement/Furniture3/detail-2`]

- Location: BS-02 — Wine Cellar; basement x=3060, y=452. Detail on `basement/Furniture3`, local offset [25, -102]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 33 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `basement/Furniture3`; Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Side Table — basement/decoration-06 [`basement/decoration-06`]

- Location: BS-02 — Wine Cellar; basement x=2240, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Candle — basement/decoration-06/detail-1 [`basement/decoration-06/detail-1`]

- Location: BS-02 — Wine Cellar; basement x=2240, y=392. Detail on `basement/decoration-06`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The highlight breaks across a small chip on the front edge. Art width specification: 22 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-06`; Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Wine Shelf — basement/decoration-07 [`basement/decoration-07`]

- Location: BS-02 — Wine Cellar; basement x=2500, y=392.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. A pale scrape marks the near-left edge. Art width specification: 104 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Wine Rack — basement/decoration-08 [`basement/decoration-08`]

- Location: BS-02 — Wine Cellar; basement x=2710, y=392.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. Dust remains in the far corner where a hand would not easily reach. Art width specification: 77 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Ordinary table — bs_02_charge_2 [`bs_02_charge_2`]

- Location: BS-02 — Wine Cellar; basement x=2905, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bottles — bs_02_charge_2/tabletop [`bs_02_charge_2/tabletop`]

- Location: BS-02 — Wine Cellar; basement x=2905, y=590. Detail on `bs_02_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_02_charge_2`; Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Wine Shelf — BS-02/dressing-01 [`BS-02/dressing-01`]

- Location: BS-02 — Wine Cellar; basement x=2884, y=395.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. A pale scrape marks the near-left edge. Art width specification: 130 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Wine Rack — BS-02/dressing-02 [`BS-02/dressing-02`]

- Location: BS-02 — Wine Cellar; basement x=2341, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. Dust remains in the far corner where a hand would not easily reach. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Wine Rack — BS-02/dressing-03 [`BS-02/dressing-03`]

- Location: BS-02 — Wine Cellar; basement x=2511, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bottle Crate — BS-02/dressing-04 [`BS-02/dressing-04`]

- Location: BS-02 — Wine Cellar; basement x=2621, y=395.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A dark moisture line remains close to its lower edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bottle Crate — BS-02/dressing-05 [`BS-02/dressing-05`]

- Location: BS-02 — Wine Cellar; basement x=2821, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. One exposed corner is blunted by repeated contact. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

OBJECT NAME: Bench — BS-02/dressing-06 [`BS-02/dressing-06`]

- Location: BS-02 — Wine Cellar; basement x=3031, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: wine storage and bottling.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `basement_vent` in BS-02.

### BS-03 — Ossuary Nook

OBJECT NAME: Vantree - V [`basement/vantree_05`]

- Location: BS-03 — Ossuary Nook; basement x=3460, y=450.
- Appearance: A separate folded page, numbered 5, with a readable central text block and frayed handling edges. In Ossuary Nook, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “Memory made refuge into evidence. Every hiding place became a confession.”

  **Authored complete first-person letter:**

  > I returned to the refuge that had saved me before. I knew its angle, its depth, the moment to lower myself. Familiarity felt like preparation.
  >
  > Memory made refuge into evidence. Every hiding place became a confession. The thing did not need to discover my cleverness again. I had already taught it where I went when I was afraid.
  >
  > I am writing this away from the place I used. I do not know whether that matters. If the last ward is still closed, leave this warning where you can find it before you touch the key. If it is open, change your route. Do not turn one successful escape into a promise the house never made.
- Connection to other objects/clues: Memory Key and remembered hiding places.

OBJECT NAME: Vantree - VI [`basement/vantree_06`]

- Location: BS-03 — Ossuary Nook; basement x=3780, y=470.
- Appearance: A separate folded page, numbered 6, with a readable central text block and frayed handling edges. In Ossuary Nook, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “Below the house, the roots carry an older sentence into older stone.”

  **Authored complete first-person letter:**

  > I followed the roots because I had exhausted the rooms. I expected a foundation: the lowest point of something built from above. Instead I found stone that made the house feel like a recent covering.
  >
  > Below the house, the roots carry an older sentence into older stone. I could read enough to recognize continuation, not enough to discover who began it. I refuse to give that absence a convenient name.
  >
  > I have left this page near the others so you will know that the cellar is not the end of the structure. If you find a way below, do not assume that going deeper means going backward toward an answer. It may only mean reaching the next place where somebody agreed to remain.
- Connection to other objects/clues: Ritual Conduit and Cathedral Roots.

OBJECT NAME: Vantree - VII [`basement/vantree_07`]

- Location: BS-03 — Ossuary Nook; basement x=4120, y=450.
- Appearance: A separate folded page, numbered 7, with a readable central text block and frayed handling edges. In Ossuary Nook, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Counted estate letter toward the four-of-seven Vantree gate.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “Leave one ward closed. Freedom is not the same thing as completion.”

  **Authored complete first-person letter:**

  > I counted the wards as though they were unfinished work. One, then another, then the last. My hands understood the order more quickly than my conscience understood the result.
  >
  > Leave one ward closed. Freedom is not the same thing as completion. I wish I had written that sentence before I called the final lock a problem to solve.
  >
  > I cannot promise that leaving a ward closed will spare you every cost. I can promise that possessing all the keys is not the same as being outside the prison. Read what you have found. Choose the exit that belongs to the condition you have made. Do not let an empty checklist make the choice for you.
- Connection to other objects/clues: The foyer note and every Part I ending condition.

OBJECT NAME: Power station and support table — bs_03_charge_1 [`basement/bs_03_charge_1`]

- Location: BS-03 — Ossuary Nook; basement x=3580, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `vantree_05` in BS-03; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Wine Shelf — basement/Furniture4 [`basement/Furniture4`]

- Location: BS-03 — Ossuary Nook; basement x=3880, y=435.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 154 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_06` in BS-03.

OBJECT NAME: Wine Shelf — basement/decoration-09 [`basement/decoration-09`]

- Location: BS-03 — Ossuary Nook; basement x=3200, y=392.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 104 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Wine Shelf — basement/decoration-10 [`basement/decoration-10`]

- Location: BS-03 — Ossuary Nook; basement x=3390, y=392.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. A pale scrape marks the near-left edge. Art width specification: 104 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Bottle Crate — basement/decoration-11 [`basement/decoration-11`]

- Location: BS-03 — Ossuary Nook; basement x=3530, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. Dust remains in the far corner where a hand would not easily reach. Art width specification: 53 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Wine Rack — basement/decoration-12 [`basement/decoration-12`]

- Location: BS-03 — Ossuary Nook; basement x=3840, y=392.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 77 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_06` in BS-03.

OBJECT NAME: Sarcophagus — basement/decoration-13 [`basement/decoration-13`]

- Location: BS-03 — Ossuary Nook; basement x=3460, y=392.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A dark moisture line remains close to its lower edge. Art width specification: 125 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Sarcophagus — basement/decoration-14 [`basement/decoration-14`]

- Location: BS-03 — Ossuary Nook; basement x=4050, y=392.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. One exposed corner is blunted by repeated contact. Art width specification: 125 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_07` in BS-03.

OBJECT NAME: Ordinary table — bs_03_charge_2 [`bs_03_charge_2`]

- Location: BS-03 — Ossuary Nook; basement x=4035, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_07` in BS-03.

OBJECT NAME: Bottles — bs_03_charge_2/tabletop [`bs_03_charge_2/tabletop`]

- Location: BS-03 — Ossuary Nook; basement x=4035, y=590. Detail on `bs_03_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_03_charge_2`; Nearest functional landmark: `vantree_07` in BS-03.

OBJECT NAME: Lectern — BS-03/dressing-01 [`BS-03/dressing-01`]

- Location: BS-03 — Ossuary Nook; basement x=3296, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. Dust remains in the far corner where a hand would not easily reach. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Book — BS-03/dressing-01/detail-1 [`BS-03/dressing-01/detail-1`]

- Location: BS-03 — Ossuary Nook; basement x=3296, y=395. Detail on `BS-03/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `BS-03/dressing-01`; Nearest functional landmark: `vantree_05` in BS-03.

OBJECT NAME: Sarcophagus — BS-03/dressing-02 [`BS-03/dressing-02`]

- Location: BS-03 — Ossuary Nook; basement x=3750, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_06` in BS-03.

OBJECT NAME: Cat Rubble — BS-03/dressing-03 [`BS-03/dressing-03`]

- Location: BS-03 — Ossuary Nook; basement x=3922, y=590.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_06` in BS-03.

OBJECT NAME: Bench — BS-03/dressing-04 [`BS-03/dressing-04`]

- Location: BS-03 — Ossuary Nook; basement x=4151, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ossuary archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_07` in BS-03.

### BS-05 — Ritual Chamber

OBJECT NAME: The cracked ritual ward [`basement/ritual_seal`]

- Location: BS-05 — Ritual Chamber; basement x=4720, y=435.
- Appearance: A low fractured engraved stone, with a key placed separately beyond its working edge. The exposed cuts have none of the domestic camouflage of the piano or vanity.
- Lore/backstory tied to this object: Established: this is the final seal, containing Memory.
- In-game purpose: One-step final seal puzzle; taking its key creates the all-three-key state.
- Player interaction: With Sight restored, E completes a 1.25-second channel/break action. It consumes no lockpick and emits the normal puzzle-work noise on completion. Leaving without collecting the key preserves the two-key state.
- Connection to other objects/clues: memory_key, Letter V's remembered-hide warning, Letter VII, and the Loop at the Front Door.

OBJECT NAME: Memory Key [`basement/memory_key`]

- Location: BS-05 — Ritual Chamber; basement x=5000, y=480.
- Appearance: A dark key with shallow layered scratches along its bow, placed beyond the cracked ritual stone.
- Lore/backstory tied to this object: Established: collecting this key restores Memory to the Deprived One. It does not grant Els that faculty. Ornament is authored visual direction, not a second puzzle.
- In-game purpose: Advance the fixed Hearing → Sight → Memory sequence; requires `ritual_seal`.
- Player interaction: E after the ritual seal opens takes and removes the key, enables Memory, and records the true-form flag. Els: “It knows this place now.” A checkpoint is saved at successful acquisition. A sealed or out-of-order attempt gives a hint and grants nothing.
- Connection to other objects/clues: Ritual seal, remembered hides, predicted exits, and the Loop-only three-key Front Door.

OBJECT NAME: Power station and support table — bs_05_charge_1 [`basement/bs_05_charge_1`]

- Location: BS-05 — Ritual Chamber; basement x=4575, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `ritual_seal` in BS-05; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sideboard — basement/Furniture5 [`basement/Furniture5`]

- Location: BS-05 — Ritual Chamber; basement x=5330, y=432.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A dark moisture line remains close to its lower edge. Art width specification: 158 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Book — basement/Furniture5/detail-1 [`basement/Furniture5/detail-1`]

- Location: BS-05 — Ritual Chamber; basement x=5330, y=432. Detail on `basement/Furniture5`, local offset [0, -95]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 34 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `basement/Furniture5`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Candle — basement/Furniture5/detail-2 [`basement/Furniture5/detail-2`]

- Location: BS-05 — Ritual Chamber; basement x=5330, y=432. Detail on `basement/Furniture5`, local offset [-47, -81]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. One exposed corner is blunted by repeated contact. Art width specification: 21 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/Furniture5`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Candle — basement/Furniture5/detail-3 [`basement/Furniture5/detail-3`]

- Location: BS-05 — Ritual Chamber; basement x=5330, y=432. Detail on `basement/Furniture5`, local offset [43, -108]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The highlight breaks across a small chip on the front edge. Art width specification: 21 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/Furniture5`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Wine Shelf — basement/decoration-15 [`basement/decoration-15`]

- Location: BS-05 — Ritual Chamber; basement x=4490, y=392.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. The highlight breaks across a small chip on the front edge. Art width specification: 104 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_seal` in BS-05.

OBJECT NAME: Bottle Crate — basement/decoration-16 [`basement/decoration-16`]

- Location: BS-05 — Ritual Chamber; basement x=4680, y=392.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A pale scrape marks the near-left edge. Art width specification: 53 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_seal` in BS-05.

OBJECT NAME: Side Table — basement/decoration-17 [`basement/decoration-17`]

- Location: BS-05 — Ritual Chamber; basement x=5280, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `memory_key` in BS-05.

OBJECT NAME: Candle — basement/decoration-17/detail-1 [`basement/decoration-17/detail-1`]

- Location: BS-05 — Ritual Chamber; basement x=5280, y=392. Detail on `basement/decoration-17`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-17`; Nearest functional landmark: `memory_key` in BS-05.

OBJECT NAME: Ordinary table — bs_05_charge_2 [`bs_05_charge_2`]

- Location: BS-05 — Ritual Chamber; basement x=5135, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `memory_key` in BS-05.

OBJECT NAME: Bottles — bs_05_charge_2/tabletop [`bs_05_charge_2/tabletop`]

- Location: BS-05 — Ritual Chamber; basement x=5135, y=590. Detail on `bs_05_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_05_charge_2`; Nearest functional landmark: `memory_key` in BS-05.

OBJECT NAME: Lectern — BS-05/dressing-01 [`BS-05/dressing-01`]

- Location: BS-05 — Ritual Chamber; basement x=4396, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_07` in BS-03.

OBJECT NAME: Book — BS-05/dressing-01/detail-1 [`BS-05/dressing-01/detail-1`]

- Location: BS-05 — Ritual Chamber; basement x=4396, y=395. Detail on `BS-05/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `BS-05/dressing-01`; Nearest functional landmark: `vantree_07` in BS-03.

OBJECT NAME: Bookshelf — BS-05/dressing-02 [`BS-05/dressing-02`]

- Location: BS-05 — Ritual Chamber; basement x=4837, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. One exposed corner is blunted by repeated contact. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_seal` in BS-05.

OBJECT NAME: Bench — BS-05/dressing-03 [`BS-05/dressing-03`]

- Location: BS-05 — Ritual Chamber; basement x=4851, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_seal` in BS-05.

OBJECT NAME: Sarcophagus — BS-05/dressing-04 [`BS-05/dressing-04`]

- Location: BS-05 — Ritual Chamber; basement x=5130, y=395.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A pale scrape marks the near-left edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `memory_key` in BS-05.

OBJECT NAME: Cat Rubble — BS-05/dressing-05 [`BS-05/dressing-05`]

- Location: BS-05 — Ritual Chamber; basement x=5252, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. Dust remains in the far corner where a hand would not easily reach. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: ritual preparation chamber.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `memory_key` in BS-05.

### BS-06 — Root Cellar

OBJECT NAME: Glass Bottles x2 [`basement/root_bottles`]

- Location: BS-06 — Root Cellar; basement x=5650, y=475.
- Appearance: A usable dark glass bottle with a clear neck silhouette and a small floor contact shadow. This pickup grants 2; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A household supply repurposed into a deliberate sound source. Decorative bottles elsewhere remain separate.
- In-game purpose: Q places a GLASS noise 260 units ahead, radius 576; counts toward the Echoes gate only on Untouched.
- Player interaction: E takes the bundle, adds 2 bottles, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `root_clock` in BS-06; the inventory count confirms acquisition.

OBJECT NAME: Wind-Up Clock [`basement/root_clock`]

- Location: BS-06 — Root Cellar; basement x=6050, y=475.
- Appearance: A palm-sized wind-up clock/watch with a brass rim, dark dial, and short winding crown. Authored dial rests at 2:47 before use; it is a visual echo, not a time-setting puzzle. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A portable mechanism turns a domestic measure of time into a sound lure. Its hands do not establish elapsed world time.
- In-game purpose: Q places a GENERIC noise 180 units ahead, radius 384; counts toward the Echoes gate only on Untouched. The current implementation emits a single noise event, not a persistent ticking actor.
- Player interaction: E takes the bundle, adds 1 clock, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `root_bottles` in BS-06; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — basement_recharge [`basement/basement_recharge`]

- Location: BS-06 — Root Cellar; basement x=6240, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. Part I stations do not heal or protect Els from capture. It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `root_clock` in BS-06; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Wine Shelf — basement/Furniture6 [`basement/Furniture6`]

- Location: BS-06 — Root Cellar; basement x=5960, y=428.
- Appearance: A broad storage shelf holding dark bottle silhouettes, with worn horizontal rails and damp-darkened feet. One exposed corner is blunted by repeated contact. Art width specification: 142 units before its parent/asset scale.
- Lore/backstory tied to this object: Keeping provisions indefinitely mirrors the cellar’s other kind of keeping. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Everything here was arranged to last.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Side Table — basement/decoration-18 [`basement/decoration-18`]

- Location: BS-06 — Root Cellar; basement x=5560, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Candle — basement/decoration-18/detail-1 [`basement/decoration-18/detail-1`]

- Location: BS-06 — Root Cellar; basement x=5560, y=392. Detail on `basement/decoration-18`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-18`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Lectern — basement/decoration-19 [`basement/decoration-19`]

- Location: BS-06 — Root Cellar; basement x=5710, y=392.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 73 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Book — basement/decoration-19/detail-1 [`basement/decoration-19/detail-1`]

- Location: BS-06 — Root Cellar; basement x=5710, y=392. Detail on `basement/decoration-19`, local offset [0, -75]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 35 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `basement/decoration-19`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Side Table — basement/decoration-20 [`basement/decoration-20`]

- Location: BS-06 — Root Cellar; basement x=6180, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Candle — basement/decoration-20/detail-1 [`basement/decoration-20/detail-1`]

- Location: BS-06 — Root Cellar; basement x=6180, y=392. Detail on `basement/decoration-20`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-20`; Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Ordinary table — bs_06_charge_2 [`bs_06_charge_2`]

- Location: BS-06 — Root Cellar; basement x=6165, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Bottles — bs_06_charge_2/tabletop [`bs_06_charge_2/tabletop`]

- Location: BS-06 — Root Cellar; basement x=6165, y=590. Detail on `bs_06_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_06_charge_2`; Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Sideboard — BS-06/dressing-01 [`BS-06/dressing-01`]

- Location: BS-06 — Root Cellar; basement x=5819, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. One exposed corner is blunted by repeated contact. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Bottles — BS-06/dressing-01/detail-1 [`BS-06/dressing-01/detail-1`]

- Location: BS-06 — Root Cellar; basement x=5819, y=395. Detail on `BS-06/dressing-01`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. One exposed corner is blunted by repeated contact. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `BS-06/dressing-01`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Book — BS-06/dressing-01/detail-2 [`BS-06/dressing-01/detail-2`]

- Location: BS-06 — Root Cellar; basement x=5819, y=395. Detail on `BS-06/dressing-01`, local offset [30, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `BS-06/dressing-01`; Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Wine Rack — BS-06/dressing-02 [`BS-06/dressing-02`]

- Location: BS-06 — Root Cellar; basement x=5681, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. The highlight breaks across a small chip on the front edge. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Bottle Crate — BS-06/dressing-03 [`BS-06/dressing-03`]

- Location: BS-06 — Root Cellar; basement x=5831, y=605.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. A pale scrape marks the near-left edge. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `root_bottles` in BS-06.

OBJECT NAME: Bottle Crate — BS-06/dressing-04 [`BS-06/dressing-04`]

- Location: BS-06 — Root Cellar; basement x=5971, y=590.
- Appearance: A slatted wooden crate with dark glass necks visible between the upper rails. Dust remains in the far corner where a hand would not easily reach. Art width specification: 68 units before its parent/asset scale.
- Lore/backstory tied to this object: Supplies imply maintenance, but decorative crates do not establish who stocked them. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A crate is not a promise that I can use what is inside.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Stock Pot — BS-06/dressing-05 [`BS-06/dressing-05`]

- Location: BS-06 — Root Cellar; basement x=6093, y=605.
- Appearance: A blackened metal cooking pot with a broad rim and handles worn brighter than its sides. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 48 units before its parent/asset scale.
- Lore/backstory tied to this object: Ordinary cookware contributes credible service-room noise and neglect. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Empty metal. It would carry a sound.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Bench — BS-06/dressing-06 [`BS-06/dressing-06`]

- Location: BS-06 — Root Cellar; basement x=6281, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: root cellar provisions.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

### BS-09 — Ritual Conduit

OBJECT NAME: Cathedral Roots — ritual_conduit [`basement/ritual_conduit`]

- Location: BS-09 — Ritual Conduit; basement x=6900, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Part I branch exit. Hearing only plus at least four of the seven Part I letters yields Vantree.
- Player interaction: E checks the current state. A valid state plays departure and selects the chapter outcome; an invalid state provides a sealed-passage hint.
- Connection to other objects/clues: BS-09, Letters I–VII, and Vantree Part II in CR-01.

OBJECT NAME: Screen — basement/decoration-21 [`basement/decoration-21`]

- Location: BS-09 — Ritual Conduit; basement x=6450, y=392.
- Appearance: A folded standing screen with dark framing, tired opaque panels, and a narrow band of light at its foot. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 99 units before its parent/asset scale.
- Lore/backstory tied to this object: Privacy is a domestic promise that only becomes protection when the game explicitly registers the place as a hide. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “It hides a shape. That is not the same as keeping it safe.”
- Connection to other objects/clues: Nearest functional landmark: `root_clock` in BS-06.

OBJECT NAME: Side Table — basement/decoration-22 [`basement/decoration-22`]

- Location: BS-09 — Ritual Conduit; basement x=6680, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Candle — basement/decoration-22/detail-1 [`basement/decoration-22/detail-1`]

- Location: BS-09 — Ritual Conduit; basement x=6680, y=392. Detail on `basement/decoration-22`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-22`; Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Wine Rack — basement/decoration-23 [`basement/decoration-23`]

- Location: BS-09 — Ritual Conduit; basement x=6770, y=392.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. One exposed corner is blunted by repeated contact. Art width specification: 65 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Bench — basement/decoration-24 [`basement/decoration-24`]

- Location: BS-09 — Ritual Conduit; basement x=7040, y=392.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 90 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Side Table — basement/decoration-25 [`basement/decoration-25`]

- Location: BS-09 — Ritual Conduit; basement x=7150, y=392.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 54 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Candle — basement/decoration-25/detail-1 [`basement/decoration-25/detail-1`]

- Location: BS-09 — Ritual Conduit; basement x=7150, y=392. Detail on `basement/decoration-25`, local offset [0, -39]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A pale scrape marks the near-left edge. Art width specification: 23 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `basement/decoration-25`; Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Ordinary table — bs_09_charge_1 [`bs_09_charge_1`]

- Location: BS-09 — Ritual Conduit; basement x=6605, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Bottles — bs_09_charge_1/tabletop [`bs_09_charge_1/tabletop`]

- Location: BS-09 — Ritual Conduit; basement x=6605, y=405. Detail on `bs_09_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_09_charge_1`; Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Ordinary table — bs_09_charge_2 [`bs_09_charge_2`]

- Location: BS-09 — Ritual Conduit; basement x=6990, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Bottles — bs_09_charge_2/tabletop [`bs_09_charge_2/tabletop`]

- Location: BS-09 — Ritual Conduit; basement x=6990, y=590. Detail on `bs_09_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A small group of dark glass bottles, their shoulders reflecting pinpoints of warm light. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: Tabletop bottles are retained provisions or service clutter; ownership is unknown. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Glass, kept whole. I have other bottles to break.”
- Connection to other objects/clues: Mounted on `bs_09_charge_2`; Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Cat Rubble — BS-09/dressing-01 [`BS-09/dressing-01`]

- Location: BS-09 — Ritual Conduit; basement x=6722, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. Dust remains in the far corner where a hand would not easily reach. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Bench — BS-09/dressing-02 [`BS-09/dressing-02`]

- Location: BS-09 — Ritual Conduit; basement x=6871, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

OBJECT NAME: Sarcophagus — BS-09/dressing-03 [`BS-09/dressing-03`]

- Location: BS-09 — Ritual Conduit; basement x=6590, y=590.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A dark moisture line remains close to its lower edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: threshold shrine.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `ritual_conduit` in BS-09.

### CR-01 — Entry Descent

OBJECT NAME: Power station and support table — cr_01_charge_1 [`roots/cr_01_charge_1`]

- Location: CR-01 — Entry Descent; roots x=240, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `vantree_08` in CR-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Cat Rubble — roots/decoration-01 [`roots/decoration-01`]

- Location: CR-01 — Entry Descent; roots x=430, y=405.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 120 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Candle — roots/decoration-02 [`roots/decoration-02`]

- Location: CR-01 — Entry Descent; roots x=760, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Ordinary table — cr_01_charge_2 [`cr_01_charge_2`]

- Location: CR-01 — Entry Descent; roots x=765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Candle — cr_01_charge_2/tabletop [`cr_01_charge_2/tabletop`]

- Location: CR-01 — Entry Descent; roots x=765, y=590. Detail on `cr_01_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `cr_01_charge_2`; Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Lectern — CR-01/dressing-01 [`CR-01/dressing-01`]

- Location: CR-01 — Entry Descent; roots x=136, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. The highlight breaks across a small chip on the front edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Book — CR-01/dressing-01/detail-1 [`CR-01/dressing-01/detail-1`]

- Location: CR-01 — Entry Descent; roots x=136, y=395. Detail on `CR-01/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-01/dressing-01`; Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Bench — CR-01/dressing-02 [`CR-01/dressing-02`]

- Location: CR-01 — Entry Descent; roots x=331, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Bench — CR-01/dressing-03 [`CR-01/dressing-03`]

- Location: CR-01 — Entry Descent; roots x=501, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Cat Rubble — CR-01/dressing-04 [`CR-01/dressing-04`]

- Location: CR-01 — Entry Descent; roots x=662, y=395.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Sarcophagus — CR-01/dressing-05 [`CR-01/dressing-05`]

- Location: CR-01 — Entry Descent; roots x=880, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A dark moisture line remains close to its lower edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: abandoned cathedral entrance.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

### CR-02 — Flooded Nave

OBJECT NAME: Vantree - VIII [`roots/vantree_08`]

- Location: CR-02 — Flooded Nave; roots x=1550, y=465.
- Appearance: A separate folded page, numbered 8, with a readable central text block and frayed handling edges. In Flooded Nave, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The roots predate the house. We did not build a prison. We inherited one.”

  **Authored complete first-person letter:**

  > I came below expecting to discover what the house concealed. The longer I looked, the less I believed the house had been the first thing here.
  >
  > The roots predate the house. We did not build a prison. We inherited one. I can read that inheritance in the way newer work stops at older stone, as though the builders were careful not to interrupt a sentence they did not understand.
  >
  > I do not know who first closed it. I do not know what was promised. I have only the place, the wards, and the habit of giving the next person a smaller explanation than the one I needed. I am trying, with this page, to leave a little less out.
- Connection to other objects/clues: The older stone and the name carving in the next area.

OBJECT NAME: Flashlight Battery [`roots/roots_battery`]

- Location: CR-02 — Flooded Nave; roots x=1880, y=485.
- Appearance: A short practical flashlight cell with dulled metal ends and a worn wrapper; keep it smaller than Els's hand span. This pickup grants 1; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A practical supply compatible with Els's own light; its original purchaser is unknown.
- In-game purpose: Restore 45 seconds of charge, capped at 90, when Q selects a battery.
- Player interaction: E takes the bundle, adds 1 battery, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `vantree_08` in CR-02; the inventory count confirms acquisition.

OBJECT NAME: Ordinary table — cr_02_charge_1 [`cr_02_charge_1`]

- Location: CR-02 — Flooded Nave; roots x=1240, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Book — cr_02_charge_1/tabletop [`cr_02_charge_1/tabletop`]

- Location: CR-02 — Flooded Nave; roots x=1240, y=405. Detail on `cr_02_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_02_charge_1`; Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Ordinary table — cr_02_charge_2 [`cr_02_charge_2`]

- Location: CR-02 — Flooded Nave; roots x=1765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Book — cr_02_charge_2/tabletop [`cr_02_charge_2/tabletop`]

- Location: CR-02 — Flooded Nave; roots x=1765, y=590. Detail on `cr_02_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_02_charge_2`; Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Bench — CR-02/dressing-01 [`CR-02/dressing-01`]

- Location: CR-02 — Flooded Nave; roots x=1121, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Bench — CR-02/dressing-02 [`CR-02/dressing-02`]

- Location: CR-02 — Flooded Nave; roots x=1281, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Bench — CR-02/dressing-03 [`CR-02/dressing-03`]

- Location: CR-02 — Flooded Nave; roots x=1431, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Lectern — CR-02/dressing-04 [`CR-02/dressing-04`]

- Location: CR-02 — Flooded Nave; roots x=1656, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Book — CR-02/dressing-04/detail-1 [`CR-02/dressing-04/detail-1`]

- Location: CR-02 — Flooded Nave; roots x=1656, y=395. Detail on `CR-02/dressing-04`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-02/dressing-04`; Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Cat Rubble — CR-02/dressing-05 [`CR-02/dressing-05`]

- Location: CR-02 — Flooded Nave; roots x=1652, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. One exposed corner is blunted by repeated contact. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_08` in CR-02.

OBJECT NAME: Sarcophagus — CR-02/dressing-06 [`CR-02/dressing-06`]

- Location: CR-02 — Flooded Nave; roots x=1880, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The highlight breaks across a small chip on the front edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: flooded nave with surviving pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Flooded nave water [`roots/nave-water`]

- Location: CR-02; x=1000–2000.
- Appearance: Cold shallow water spreads beneath the buried nave and interrupts the stone route.
- Lore/backstory tied to this object: The older space has endured water and neglect longer than the house can explain.
- In-game purpose: WATER movement surface and narrative threshold.
- Player interaction: Cross to Letter VIII and the battery. First entry before CR-03 is threat-suppressed; do not assume this remains a permanent safe room on return.
- Connection to other objects/clues: roots_battery, vantree_08, and CR-03 encounter activation.

### CR-03 — Collapsed Cloister

OBJECT NAME: Power station and support table — cr_03_charge_1 [`roots/cr_03_charge_1`]

- Location: CR-03 — Collapsed Cloister; roots x=2240, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `roots_battery` in CR-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Cat Rubble — roots/decoration-03 [`roots/decoration-03`]

- Location: CR-03 — Collapsed Cloister; roots x=2240, y=405.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. One exposed corner is blunted by repeated contact. Art width specification: 185 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Cat Rubble — roots/decoration-04 [`roots/decoration-04`]

- Location: CR-03 — Collapsed Cloister; roots x=2710, y=575.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The highlight breaks across a small chip on the front edge. Art width specification: 155 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Ordinary table — cr_03_charge_2 [`cr_03_charge_2`]

- Location: CR-03 — Collapsed Cloister; roots x=2765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Book — cr_03_charge_2/tabletop [`cr_03_charge_2/tabletop`]

- Location: CR-03 — Collapsed Cloister; roots x=2765, y=590. Detail on `cr_03_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_03_charge_2`; Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Bench — CR-03/dressing-01 [`CR-03/dressing-01`]

- Location: CR-03 — Collapsed Cloister; roots x=2391, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Lectern — CR-03/dressing-02 [`CR-03/dressing-02`]

- Location: CR-03 — Collapsed Cloister; roots x=2496, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Book — CR-03/dressing-02/detail-1 [`CR-03/dressing-02/detail-1`]

- Location: CR-03 — Collapsed Cloister; roots x=2496, y=395. Detail on `CR-03/dressing-02`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-03/dressing-02`; Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Cat Rubble — CR-03/dressing-03 [`CR-03/dressing-03`]

- Location: CR-03 — Collapsed Cloister; roots x=2502, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Sarcophagus — CR-03/dressing-04 [`CR-03/dressing-04`]

- Location: CR-03 — Collapsed Cloister; roots x=2670, y=395.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. One exposed corner is blunted by repeated contact. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `roots_battery` in CR-02.

OBJECT NAME: Bench — CR-03/dressing-05 [`CR-03/dressing-05`]

- Location: CR-03 — Collapsed Cloister; roots x=2881, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: cloister remnants.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Collapsed cloister floor [`roots/cloister-rubble`]

- Location: CR-03; x=2000–3000, except rug overrides.
- Appearance: A continuous rubble region beneath separately cataloged masonry heaps.
- Lore/backstory tied to this object: The older architecture has broken without erasing its route.
- In-game purpose: RUBBLE floor: ordinary noise radius 160; Touch transmission 160 versus 480 on intact floor.
- Player interaction: Keep moving with distance. Standing on rubble is not absolute protection inside its reduced Touch range.
- Connection to other objects/clues: CR-03 individual rubble props and the later Sunken Choir.

### CR-04 — Altar Approach

OBJECT NAME: The impossible Vantree carving [`roots/vantree_altar`]

- Location: CR-04 — Altar Approach; roots x=3550, y=430.
- Appearance: A blood-toned altar surface and inscribed names, culminating in Els Vantree with a date centuries older than her birth. Do not fabricate an exact year.
- Lore/backstory tied to this object: Established: the full name and impossible relative date are canon. Their cause is deliberately unresolved.
- In-game purpose: Automatic major story reveal, once per run.
- Player interaction: Entering CR-04 displays: “Custodian. Jailer. Vantree. Els Vantree - the final carving bears a date centuries old.” The lore interaction is suppressed after that reveal, avoiding a repeated compulsory beat.
- Connection to other objects/clues: Letters VIII–XI, the nameplate, the role of Jailer, and the Vantree-only spoken line.

OBJECT NAME: Candle — roots/decoration-07 [`roots/decoration-07`]

- Location: CR-04 — Altar Approach; roots x=3380, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Candle — roots/decoration-08 [`roots/decoration-08`]

- Location: CR-04 — Altar Approach; roots x=3730, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Ordinary table — cr_04_charge_1 [`cr_04_charge_1`]

- Location: CR-04 — Altar Approach; roots x=3240, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Candle — cr_04_charge_1/tabletop [`cr_04_charge_1/tabletop`]

- Location: CR-04 — Altar Approach; roots x=3240, y=405. Detail on `cr_04_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The highlight breaks across a small chip on the front edge. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `cr_04_charge_1`; Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Ordinary table — cr_04_charge_2 [`cr_04_charge_2`]

- Location: CR-04 — Altar Approach; roots x=3765, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Candle — cr_04_charge_2/tabletop [`cr_04_charge_2/tabletop`]

- Location: CR-04 — Altar Approach; roots x=3765, y=590. Detail on `cr_04_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A pale scrape marks the near-left edge. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `cr_04_charge_2`; Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Lectern — CR-04/dressing-01 [`CR-04/dressing-01`]

- Location: CR-04 — Altar Approach; roots x=3146, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Book — CR-04/dressing-01/detail-1 [`CR-04/dressing-01/detail-1`]

- Location: CR-04 — Altar Approach; roots x=3146, y=395. Detail on `CR-04/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-04/dressing-01`; Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Bench — CR-04/dressing-02 [`CR-04/dressing-02`]

- Location: CR-04 — Altar Approach; roots x=3281, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Bench — CR-04/dressing-03 [`CR-04/dressing-03`]

- Location: CR-04 — Altar Approach; roots x=3431, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Sarcophagus — CR-04/dressing-04 [`CR-04/dressing-04`]

- Location: CR-04 — Altar Approach; roots x=3820, y=395.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The highlight breaks across a small chip on the front edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Cat Rubble — CR-04/dressing-05 [`CR-04/dressing-05`]

- Location: CR-04 — Altar Approach; roots x=3652, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. A pale scrape marks the near-left edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_altar` in CR-04.

OBJECT NAME: Bench — CR-04/dressing-06 [`CR-04/dressing-06`]

- Location: CR-04 — Altar Approach; roots x=3881, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: processional altar approach.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `crypt_alcove_01` in CR-05.

### CR-05 — Crypt Row

OBJECT NAME: Vantree - IX [`roots/vantree_09`]

- Location: CR-05 — Crypt Row; roots x=4170, y=450.
- Appearance: A separate folded page, numbered 9, with a readable central text block and frayed handling edges. In Crypt Row, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “Each keeper arrived believing the name belonged to somebody else.”

  **Authored complete first-person letter:**

  > I arrived believing the name belonged to somebody else. Even after I saw it repeated, I looked for a distinction: an older spelling, a title, an error in the stone.
  >
  > Each keeper arrived believing the name belonged to somebody else. I cannot prove that every hand before mine felt what I felt, but the papers preserve the same careful distance from the role.
  >
  > I am not giving you a family tree. I do not have one that explains this place. If you recognize yourself in an inscription, keep what you saw separate from what fear tells you it must mean. I failed to keep them separate for a long time. The name is evidence. Its explanation is still missing.
- Connection to other objects/clues: CR-04 name carving; no ancestry claim is established.

OBJECT NAME: Vantree - X [`roots/vantree_10`]

- Location: CR-05 — Crypt Row; roots x=4470, y=470.
- Appearance: A separate folded page, numbered 10, with a readable central text block and frayed handling edges. In Crypt Row, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The ward moved from hand to hand, and every hand called that movement freedom.”

  **Authored complete first-person letter:**

  > I watched a burden become portable and heard it called release. Nothing in its movement proved that it had ended. The ward moved from hand to hand, and every hand called that movement freedom.
  >
  > I was most willing to believe the word when the next hand was not mine. That is the part I must write plainly. I did not need a false account of the mechanism. I needed only to stop looking at the person who would carry it after me.
  >
  > If you reach a choice that fits inside your palm, turn it over before you call it an escape. Ask what has become smaller, what has become lighter, and what has merely become easier to give away.
- Connection to other objects/clues: The Vessel anchor and recurring freedom statement.

OBJECT NAME: Vantree - XI [`roots/vantree_11`]

- Location: CR-05 — Crypt Row; roots x=4770, y=450.
- Appearance: A separate folded page, numbered 11, with a readable central text block and frayed handling edges. In Crypt Row, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The empty hand was never counted. That omission became the ritual.”

  **Authored complete first-person letter:**

  > I found accounts of every hand that held the ward. I found instructions for receiving it, keeping it, and making it ready to pass. I found very little about the hand that would receive nothing.
  >
  > The empty hand was never counted. That omission became the ritual. I do not know whether it began as an error, a convenience, or a refusal. I know how easily I repeated it once the instructions had the appearance of age.
  >
  > I leave this beside the other pages because a missing entry can seem too small to matter. I have begun to think that the most consequential thing in a record is sometimes the person its columns leave no room to describe.
- Connection to other objects/clues: The three Nexus choices; this is thematic evidence, not a fourth empty-hand anchor.

OBJECT NAME: Hide in alcove — crypt_alcove_01 [`roots/crypt_alcove_01`]

- Location: CR-05 — Crypt Row; roots x=4110, y=585.
- Appearance: A marked stone alcove beside a sarcophagus.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vantree_09` in CR-05; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Hide in alcove — crypt_alcove_02 [`roots/crypt_alcove_02`]

- Location: CR-05 — Crypt Row; roots x=4400, y=585.
- Appearance: A marked stone alcove beside a sarcophagus.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vantree_10` in CR-05; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Hide in alcove — crypt_alcove_03 [`roots/crypt_alcove_03`]

- Location: CR-05 — Crypt Row; roots x=4690, y=585.
- Appearance: A marked stone alcove beside a sarcophagus.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `medium` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `vantree_11` in CR-05; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Hide in alcove — crypt_alcove_04 [`roots/crypt_alcove_04`]

- Location: CR-05 — Crypt Row; roots x=4980, y=585.
- Appearance: A marked stone alcove beside a sarcophagus.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `medium` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `roots_bottles` in CR-05; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Glass Bottles x2 [`roots/roots_bottles`]

- Location: CR-05 — Crypt Row; roots x=5050, y=470.
- Appearance: A usable dark glass bottle with a clear neck silhouette and a small floor contact shadow. This pickup grants 2; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A household supply repurposed into a deliberate sound source. Decorative bottles elsewhere remain separate.
- In-game purpose: Q places a GLASS noise 260 units ahead, radius 576; counts toward the Echoes gate only on Untouched.
- Player interaction: E takes the bundle, adds 2 bottles, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `crypt_alcove_04` in CR-05; the inventory count confirms acquisition.

OBJECT NAME: Power station and support table — cr_05_charge_1 [`roots/cr_05_charge_1`]

- Location: CR-05 — Crypt Row; roots x=4310, y=495.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `crypt_alcove_02` in CR-05; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Sarcophagus — roots/decoration-05 [`roots/decoration-05`]

- Location: CR-05 — Crypt Row; roots x=4250, y=405.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A pale scrape marks the near-left edge. Art width specification: 135 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_09` in CR-05.

OBJECT NAME: Sarcophagus — roots/decoration-06 [`roots/decoration-06`]

- Location: CR-05 — Crypt Row; roots x=4860, y=405.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. Dust remains in the far corner where a hand would not easily reach. Art width specification: 135 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_11` in CR-05.

OBJECT NAME: Ordinary table — cr_05_charge_2 [`cr_05_charge_2`]

- Location: CR-05 — Crypt Row; roots x=4870, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_11` in CR-05.

OBJECT NAME: Book — cr_05_charge_2/tabletop [`cr_05_charge_2/tabletop`]

- Location: CR-05 — Crypt Row; roots x=4870, y=590. Detail on `cr_05_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_05_charge_2`; Nearest functional landmark: `vantree_11` in CR-05.

OBJECT NAME: Lectern — CR-05/dressing-01 [`CR-05/dressing-01`]

- Location: CR-05 — Crypt Row; roots x=4576, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_10` in CR-05.

OBJECT NAME: Book — CR-05/dressing-01/detail-1 [`CR-05/dressing-01/detail-1`]

- Location: CR-05 — Crypt Row; roots x=4576, y=395. Detail on `CR-05/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-05/dressing-01`; Nearest functional landmark: `vantree_10` in CR-05.

OBJECT NAME: Sarcophagus — CR-05/dressing-02 [`CR-05/dressing-02`]

- Location: CR-05 — Crypt Row; roots x=4530, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. One exposed corner is blunted by repeated contact. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_10` in CR-05.

OBJECT NAME: Sarcophagus — CR-05/dressing-03 [`CR-05/dressing-03`]

- Location: CR-05 — Crypt Row; roots x=4270, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The highlight breaks across a small chip on the front edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: crypt memorial aisle.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_09` in CR-05.

### CR-06 — Echo Threshold

OBJECT NAME: Chamber of Echoes — echo_threshold [`roots/echo_threshold`]

- Location: CR-06 — Echo Threshold; roots x=5800, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to CE-01 in echoes, arrival `roots_return`. Requirement: none.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `echoes` / `roots_return`; CE-01. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: Ordinary table — cr_06_charge_1 [`cr_06_charge_1`]

- Location: CR-06 — Echo Threshold; roots x=5405, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `roots_bottles` in CR-05.

OBJECT NAME: Book — cr_06_charge_1/tabletop [`cr_06_charge_1/tabletop`]

- Location: CR-06 — Echo Threshold; roots x=5405, y=405. Detail on `cr_06_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_06_charge_1`; Nearest functional landmark: `roots_bottles` in CR-05.

OBJECT NAME: Ordinary table — cr_06_charge_2 [`cr_06_charge_2`]

- Location: CR-06 — Echo Threshold; roots x=5790, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `echo_threshold` in CR-06.

OBJECT NAME: Book — cr_06_charge_2/tabletop [`cr_06_charge_2/tabletop`]

- Location: CR-06 — Echo Threshold; roots x=5790, y=590. Detail on `cr_06_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `cr_06_charge_2`; Nearest functional landmark: `echo_threshold` in CR-06.

OBJECT NAME: Lectern — CR-06/dressing-01 [`CR-06/dressing-01`]

- Location: CR-06 — Echo Threshold; roots x=5316, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. One exposed corner is blunted by repeated contact. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `roots_bottles` in CR-05.

OBJECT NAME: Book — CR-06/dressing-01/detail-1 [`CR-06/dressing-01/detail-1`]

- Location: CR-06 — Echo Threshold; roots x=5316, y=395. Detail on `CR-06/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CR-06/dressing-01`; Nearest functional landmark: `roots_bottles` in CR-05.

OBJECT NAME: Bench — CR-06/dressing-02 [`CR-06/dressing-02`]

- Location: CR-06 — Echo Threshold; roots x=5471, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_threshold` in CR-06.

OBJECT NAME: Bench — CR-06/dressing-03 [`CR-06/dressing-03`]

- Location: CR-06 — Echo Threshold; roots x=5601, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_threshold` in CR-06.

OBJECT NAME: Cat Rubble — CR-06/dressing-04 [`CR-06/dressing-04`]

- Location: CR-06 — Echo Threshold; roots x=5642, y=395.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. Dust remains in the far corner where a hand would not easily reach. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `echo_threshold` in CR-06.

OBJECT NAME: Sarcophagus — CR-06/dressing-05 [`CR-06/dressing-05`]

- Location: CR-06 — Echo Threshold; roots x=5340, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: echo threshold pews.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `roots_bottles` in CR-05.

### CE-01 — Resonance Hall

OBJECT NAME: Cathedral Roots — roots_return [`echoes/roots_return`]

- Location: CE-01 — Resonance Hall; echoes x=180, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to CR-06 in roots, arrival `echo_threshold`. Requirement: none.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `roots` / `echo_threshold`; CR-06. Only the requirement explicitly stated for this passage gates travel.

OBJECT NAME: The resonance instruction stone [`echoes/mechanic_intro`]

- Location: CE-01 — Resonance Hall; echoes x=650, y=445.
- Appearance: A low engraved stone in the lit arrival hall, distinct from the return doorway and ordinary tables.
- Lore/backstory tied to this object: The older architecture tests the kind of agency Els retained after Part I.
- In-game purpose: Branch-specific tutorial; the literal stored fallback text is replaced by the active branch tutorial.
- Player interaction: On first CE-01 entry, Els receives the current branch hint. The automatic reveal suppresses the lore prompt afterward, preventing a repeated tutorial. Untouched: “Press Q to throw bottles or set clocks. Three uses open Nexus Descent. H opens my field guide.” Partial Mercy: “R draws a quiet circle. It blocks Hearing, but the Hound can still see. Three casts open Nexus Descent. H explains the rite.” Vantree: “Find the Sigil Forge and press E to awaken my blood rites. Then R draws a silencing circle. H opens my field guide.”
- Connection to other objects/clues: sigil_forge, echo_supply_cache, CE-04 rubble, and nexus_descent.

OBJECT NAME: Ritual Stone — echoes/decoration-01 [`echoes/decoration-01`]

- Location: CE-01 — Resonance Hall; echoes x=620, y=575.
- Appearance: A squat engraved stone with worn angular grooves, a chipped rim, and a faint cold reflection in its cuts. A pale scrape marks the near-left edge. Art width specification: 125 units before its parent/asset scale.
- Lore/backstory tied to this object: The estate’s practical language of locks gives way to an older architecture of wards. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The cuts look deliberate. That does not tell me who made them.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Ordinary table — ce_01_charge_1 [`ce_01_charge_1`]

- Location: CE-01 — Resonance Hall; echoes x=275, y=430.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. Dust remains in the far corner where a hand would not easily reach. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `roots_return` in CE-01.

OBJECT NAME: Candle — ce_01_charge_1/tabletop [`ce_01_charge_1/tabletop`]

- Location: CE-01 — Resonance Hall; echoes x=275, y=430. Detail on `ce_01_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ce_01_charge_1`; Nearest functional landmark: `roots_return` in CE-01.

OBJECT NAME: Ordinary table — ce_01_charge_2 [`ce_01_charge_2`]

- Location: CE-01 — Resonance Hall; echoes x=835, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Candle — ce_01_charge_2/tabletop [`ce_01_charge_2/tabletop`]

- Location: CE-01 — Resonance Hall; echoes x=835, y=590. Detail on `ce_01_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ce_01_charge_2`; Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Lectern — CE-01/dressing-01 [`CE-01/dressing-01`]

- Location: CE-01 — Resonance Hall; echoes x=366, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. One exposed corner is blunted by repeated contact. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `roots_return` in CE-01.

OBJECT NAME: Book — CE-01/dressing-01/detail-1 [`CE-01/dressing-01/detail-1`]

- Location: CE-01 — Resonance Hall; echoes x=366, y=395. Detail on `CE-01/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-01/dressing-01`; Nearest functional landmark: `roots_return` in CE-01.

OBJECT NAME: Bench — CE-01/dressing-02 [`CE-01/dressing-02`]

- Location: CE-01 — Resonance Hall; echoes x=311, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The highlight breaks across a small chip on the front edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `roots_return` in CE-01.

OBJECT NAME: Bench — CE-01/dressing-03 [`CE-01/dressing-03`]

- Location: CE-01 — Resonance Hall; echoes x=471, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Cat Rubble — CE-01/dressing-04 [`CE-01/dressing-04`]

- Location: CE-01 — Resonance Hall; echoes x=522, y=395.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. Dust remains in the far corner where a hand would not easily reach. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Sarcophagus — CE-01/dressing-05 [`CE-01/dressing-05`]

- Location: CE-01 — Resonance Hall; echoes x=950, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

OBJECT NAME: Bench — CE-01/dressing-06 [`CE-01/dressing-06`]

- Location: CE-01 — Resonance Hall; echoes x=941, y=420.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: resonance chamber seating.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `mechanic_intro` in CE-01.

### CE-02 — Sigil Forge

OBJECT NAME: The Sigil Forge [`echoes/sigil_forge`]

- Location: CE-02 — Sigil Forge; echoes x=1680, y=440.
- Appearance: A compact ritual forge with cut channels and a subdued red pulse; its silhouette and red light remain distinct from the cyan recovery station.
- Lore/backstory tied to this object: The Vantree route turns the burden into an ability paid for from Els's body.
- In-game purpose: Vantree-only one-time unlock and first resonance.
- Player interaction: E on Vantree with more than 6.4 HP costs 6.4 HP, awakens R and T, and adds one mechanic use. Insufficient HP gives a recovery hint. Other branches cannot activate it. Existing line: “Blood rites awakened. R: silencing circle. T: close-range stun. H: field guide.”
- Connection to other objects/clues: R costs 6.4 HP and counts in Echoes; T costs 16 HP and does not count; ce_02_charge_1 restores up to the branch cap.

OBJECT NAME: Power station and support table — ce_02_charge_1 [`echoes/ce_02_charge_1`]

- Location: CE-02 — Sigil Forge; echoes x=1375, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `sigil_forge` in CE-02; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Candle — echoes/decoration-05 [`echoes/decoration-05`]

- Location: CE-02 — Sigil Forge; echoes x=1450, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Candle — echoes/decoration-06 [`echoes/decoration-06`]

- Location: CE-02 — Sigil Forge; echoes x=1910, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Ordinary table — ce_02_charge_2 [`ce_02_charge_2`]

- Location: CE-02 — Sigil Forge; echoes x=1935, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Book — ce_02_charge_2/tabletop [`ce_02_charge_2/tabletop`]

- Location: CE-02 — Sigil Forge; echoes x=1935, y=590. Detail on `ce_02_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ce_02_charge_2`; Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Bookshelf — CE-02/dressing-01 [`CE-02/dressing-01`]

- Location: CE-02 — Sigil Forge; echoes x=1257, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. The highlight breaks across a small chip on the front edge. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Sideboard — CE-02/dressing-02 [`CE-02/dressing-02`]

- Location: CE-02 — Sigil Forge; echoes x=1539, y=395.
- Appearance: A waist-high sideboard with uneven drawer fronts, tarnished handles, and a broad top worn lighter at its working edge. A pale scrape marks the near-left edge. Art width specification: 144 units before its parent/asset scale.
- Lore/backstory tied to this object: Storage remained useful through successive occupations; its wear is evidence of use, not proof of a hidden compartment. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone kept using this after the room stopped feeling lived in.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Book — CE-02/dressing-02/detail-1 [`CE-02/dressing-02/detail-1`]

- Location: CE-02 — Sigil Forge; echoes x=1539, y=395. Detail on `CE-02/dressing-02`, local offset [-28, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-02/dressing-02`; Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Book — CE-02/dressing-02/detail-2 [`CE-02/dressing-02/detail-2`]

- Location: CE-02 — Sigil Forge; echoes x=1539, y=395. Detail on `CE-02/dressing-02`, local offset [30, -98]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 28 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-02/dressing-02`; Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Lectern — CE-02/dressing-03 [`CE-02/dressing-03`]

- Location: CE-02 — Sigil Forge; echoes x=1786, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. Dust remains in the far corner where a hand would not easily reach. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Book — CE-02/dressing-03/detail-1 [`CE-02/dressing-03/detail-1`]

- Location: CE-02 — Sigil Forge; echoes x=1786, y=395. Detail on `CE-02/dressing-03`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-02/dressing-03`; Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Cat Rubble — CE-02/dressing-04 [`CE-02/dressing-04`]

- Location: CE-02 — Sigil Forge; echoes x=2002, y=395.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Bench — CE-02/dressing-05 [`CE-02/dressing-05`]

- Location: CE-02 — Sigil Forge; echoes x=1821, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

OBJECT NAME: Wine Rack — CE-02/dressing-06 [`CE-02/dressing-06`]

- Location: CE-02 — Sigil Forge; echoes x=2041, y=605.
- Appearance: An open timber rack of diagonal bottle slots, chipped at the exposed corners and darker near the floor. One exposed corner is blunted by repeated contact. Art width specification: 94 units before its parent/asset scale.
- Lore/backstory tied to this object: Wine storage gives the prison level a plausible household use without creating an inventory source. Here its placement supports the room’s role: sigil workshop.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Most of the weight is in what is still being kept.”
- Connection to other objects/clues: Nearest functional landmark: `sigil_forge` in CE-02.

### CE-03 — Vault of Whispers

OBJECT NAME: Vantree - XII [`echoes/vantree_12`]

- Location: CE-03 — Vault of Whispers; echoes x=2480, y=450.
- Appearance: A separate folded page, numbered 12, with a readable central text block and frayed handling edges. In Vault of Whispers, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “The prisoner learned our voices by listening to the shape of our fear.”

  **Authored complete first-person letter:**

  > I used to measure its approach in footsteps and pauses. I listened for the moment a sound became intention. I did not ask what my own listening gave away.
  >
  > The prisoner learned our voices by listening to the shape of our fear. I write that as the closest description I have, not as an account of how a body learns to speak. I do not understand its body.
  >
  > If it addresses you, do not confuse recognition with explanation. A thing may know the sound of a name without answering why that name is here. I wanted a voice because I thought a voice could settle the question. I was less certain after the silence ended.
- Connection to other objects/clues: The Vantree voice event in this room.

OBJECT NAME: Vantree - XIII [`echoes/vantree_13`]

- Location: CE-03 — Vault of Whispers; echoes x=3020, y=470.
- Appearance: A separate folded page, numbered 13, with a readable central text block and frayed handling edges. In Vault of Whispers, keep its small warm pickup highlight distinct from the closed decorative books.
- Lore/backstory tied to this object: Established excerpt from the anonymous Vantree papers; individual author, date, and kinship are unknown. The complete first-person body below is authored expansion for this document.
- In-game purpose: Optional Part II lore collectible; it does not add a new key or replace a branch-use requirement.
- Player interaction: E collects the page, removes its floor representation, and opens the paused reader. Current complete runtime text: “When it finally spoke, it used the voice of the next keeper.”

  **Authored complete first-person letter:**

  > I waited for a confession, an accusation, anything that would turn the prisoner into a story I could finish telling. I thought its first words might explain the stone.
  >
  > When it finally spoke, it used the voice of the next keeper. I cannot tell you what that means about the speaker, the keeper, or the years between them. I can tell you that hearing it did not return the hours I had lost.
  >
  > I have no final instruction that makes this clean. I can leave you the words I keep trying to forgive in myself:
  >
  > Forgive me, if you’re reading this.
  >
  > It has to be someone.
  >
  > I am no longer certain that the second sentence is true.
- Connection to other objects/clues: First voice, the canonical apology breadcrumb, and the final burden decision.

OBJECT NAME: The voice-bearing sarcophagus [`echoes/first_voice`]

- Location: CE-03 — Vault of Whispers; echoes x=3200, y=430.
- Appearance: A stone sarcophagus near the east side of the Vault of Whispers; the sound should be spatially associated with the chamber without proving that a human body inside is speaking.
- Lore/backstory tied to this object: Established: the Deprived One addresses Els for the first time on the Vantree route. The nature of the voice remains unknown.
- In-game purpose: One-time branch story event, not a new sense pickup.
- Player interaction: First CE-03 entry on Vantree triggers breathing and “Els. You have brought your name home.” This automatic beat takes precedence over the optional lore interaction. Untouched and Partial Mercy receive no entity dialogue here.
- Connection to other objects/clues: Letters XII and XIII, the name carving, and the final transfer choices.

OBJECT NAME: Sarcophagus — echoes/decoration-04 [`echoes/decoration-04`]

- Location: CE-03 — Vault of Whispers; echoes x=2580, y=405.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A dark moisture line remains close to its lower edge. Art width specification: 125 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_12` in CE-03.

OBJECT NAME: Ordinary table — ce_03_charge_1 [`ce_03_charge_1`]

- Location: CE-03 — Vault of Whispers; echoes x=2370, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A dark moisture line remains close to its lower edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_12` in CE-03.

OBJECT NAME: Candle — ce_03_charge_1/tabletop [`ce_03_charge_1/tabletop`]

- Location: CE-03 — Vault of Whispers; echoes x=2370, y=405. Detail on `ce_03_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A dark moisture line remains close to its lower edge. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ce_03_charge_1`; Nearest functional landmark: `vantree_12` in CE-03.

OBJECT NAME: Ordinary table — ce_03_charge_2 [`ce_03_charge_2`]

- Location: CE-03 — Vault of Whispers; echoes x=3035, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Candle — ce_03_charge_2/tabletop [`ce_03_charge_2/tabletop`]

- Location: CE-03 — Vault of Whispers; echoes x=3035, y=590. Detail on `ce_03_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. One exposed corner is blunted by repeated contact. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ce_03_charge_2`; Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Bookshelf — CE-03/dressing-01 [`CE-03/dressing-01`]

- Location: CE-03 — Vault of Whispers; echoes x=2687, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. A pale scrape marks the near-left edge. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_12` in CE-03.

OBJECT NAME: Bookshelf — CE-03/dressing-02 [`CE-03/dressing-02`]

- Location: CE-03 — Vault of Whispers; echoes x=2797, y=395.
- Appearance: A tall dark shelf with bowed boards, irregular closed spines, and dust gathering where volumes are absent. Dust remains in the far corner where a hand would not easily reach. Art width specification: 110 units before its parent/asset scale.
- Lore/backstory tied to this object: The house preserves records as furniture even where no readable testimony survives. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The useful page would have to be somewhere else.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Lectern — CE-03/dressing-03 [`CE-03/dressing-03`]

- Location: CE-03 — Vault of Whispers; echoes x=2896, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Book — CE-03/dressing-03/detail-1 [`CE-03/dressing-03/detail-1`]

- Location: CE-03 — Vault of Whispers; echoes x=2896, y=395. Detail on `CE-03/dressing-03`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-03/dressing-03`; Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Sarcophagus — CE-03/dressing-04 [`CE-03/dressing-04`]

- Location: CE-03 — Vault of Whispers; echoes x=2830, y=590.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A dark moisture line remains close to its lower edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_13` in CE-03.

OBJECT NAME: Bench — CE-03/dressing-05 [`CE-03/dressing-05`]

- Location: CE-03 — Vault of Whispers; echoes x=3151, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `first_voice` in CE-03.

OBJECT NAME: Cat Rubble — CE-03/dressing-06 [`CE-03/dressing-06`]

- Location: CE-03 — Vault of Whispers; echoes x=2692, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The highlight breaks across a small chip on the front edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: whisper archive.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `vantree_12` in CE-03.

### CE-04 — Sunken Choir

OBJECT NAME: Wind-Up Clock x3 [`echoes/echo_clock`]

- Location: CE-04 — Sunken Choir; echoes x=4050, y=475.
- Appearance: A palm-sized wind-up clock/watch with a brass rim, dark dial, and short winding crown. Authored dial rests at 2:47 before use; it is a visual echo, not a time-setting puzzle. This pickup grants 3; a multi-item pickup is one placed bundle.
- Lore/backstory tied to this object: A portable mechanism turns a domestic measure of time into a sound lure. Its hands do not establish elapsed world time.
- In-game purpose: Q places a GENERIC noise 180 units ahead, radius 384; counts toward the Echoes gate only on Untouched. The current implementation emits a single noise event, not a persistent ticking actor.
- Player interaction: E takes the bundle, adds 3 clocks, and removes the floor sprite for the run. Q chooses a battery first only below 50 seconds charge, otherwise bottles before clocks; it consumes one selected item.
- Connection to other objects/clues: `echo_supply_cache` in CE-05; the inventory count confirms acquisition.

OBJECT NAME: Cat Rubble — echoes/decoration-02 [`echoes/decoration-02`]

- Location: CE-04 — Sunken Choir; echoes x=3480, y=405.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. Dust remains in the far corner where a hand would not easily reach. Art width specification: 155 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `first_voice` in CE-03.

OBJECT NAME: Cat Rubble — echoes/decoration-03 [`echoes/decoration-03`]

- Location: CE-04 — Sunken Choir; echoes x=4210, y=575.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 140 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Ordinary table — ce_04_charge_1 [`ce_04_charge_1`]

- Location: CE-04 — Sunken Choir; echoes x=3575, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. One exposed corner is blunted by repeated contact. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `first_voice` in CE-03.

OBJECT NAME: Book — ce_04_charge_1/tabletop [`ce_04_charge_1/tabletop`]

- Location: CE-04 — Sunken Choir; echoes x=3575, y=405. Detail on `ce_04_charge_1`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. One exposed corner is blunted by repeated contact. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ce_04_charge_1`; Nearest functional landmark: `first_voice` in CE-03.

OBJECT NAME: Ordinary table — ce_04_charge_2 [`ce_04_charge_2`]

- Location: CE-04 — Sunken Choir; echoes x=4135, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. The highlight breaks across a small chip on the front edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Book — ce_04_charge_2/tabletop [`ce_04_charge_2/tabletop`]

- Location: CE-04 — Sunken Choir; echoes x=4135, y=590. Detail on `ce_04_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The highlight breaks across a small chip on the front edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ce_04_charge_2`; Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Bench — CE-04/dressing-01 [`CE-04/dressing-01`]

- Location: CE-04 — Sunken Choir; echoes x=3691, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. Dust remains in the far corner where a hand would not easily reach. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Bench — CE-04/dressing-02 [`CE-04/dressing-02`]

- Location: CE-04 — Sunken Choir; echoes x=3611, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `first_voice` in CE-03.

OBJECT NAME: Lectern — CE-04/dressing-03 [`CE-04/dressing-03`]

- Location: CE-04 — Sunken Choir; echoes x=3796, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Book — CE-04/dressing-03/detail-1 [`CE-04/dressing-03/detail-1`]

- Location: CE-04 — Sunken Choir; echoes x=3796, y=395. Detail on `CE-04/dressing-03`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-04/dressing-03`; Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Bench — CE-04/dressing-04 [`CE-04/dressing-04`]

- Location: CE-04 — Sunken Choir; echoes x=3921, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Cat Rubble — CE-04/dressing-05 [`CE-04/dressing-05`]

- Location: CE-04 — Sunken Choir; echoes x=4022, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The highlight breaks across a small chip on the front edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Bench — CE-04/dressing-06 [`CE-04/dressing-06`]

- Location: CE-04 — Sunken Choir; echoes x=4241, y=420.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: ruined choir stalls.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_clock` in CE-04.

OBJECT NAME: Sunken Choir transmission break [`echoes/choir-floor`]

- Location: CE-04; x=3300–4400. Rear strip y<470.
- Appearance: Broken masonry drops visually into a darker rear band; the readable walking plane continues around the placed rubble.
- Lore/backstory tied to this object: Structural discontinuity supplies an observable limit to Touch.
- In-game purpose: RUBBLE floor; rear strip reduces Touch transmission to 96, otherwise rubble gives 160.
- Player interaction: On Vantree in Echoes, move faster than 20 units/second on RUBBLE within 520 units of the Hound to count a Touch evasion, with a two-second counting cooldown. Remain beyond the actual transmission radius when possible.
- Connection to other objects/clues: Three-use gate, blood sigils, and echo_clock. Rugs can override the surface and should not be used for this check.

### CE-05 — Nexus Descent

OBJECT NAME: Ley-Nexus — nexus_descent [`echoes/nexus_descent`]

- Location: CE-05 — Nexus Descent; echoes x=5320, y=362.
- Appearance: A tall dark passage frame with a clearly placed handle, a restrained destination marker, and an unobstructed approach for the door action.
- Lore/backstory tied to this object: The opening connects established parts of Hollowmere or its buried prison. Its label expresses function; it does not establish a separate unseen room.
- In-game purpose: Travel to LN-CENTER in nexus, arrival `nexus_gate`. Requirement: part2_mechanic_3.
- Player interaction: E checks requirements, plays the planted unlock/open/departure action, and loads the linked arrival. A denied requirement gives a hint without moving Els.
- Connection to other objects/clues: Destination `nexus` / `nexus_gate`; LN-CENTER. The route is one-way into Convergence; nexus_gate cannot return to CE-05.

OBJECT NAME: Hide in descent alcove — nexus_descent_alcove [`echoes/nexus_descent_alcove`]

- Location: CE-05 — Nexus Descent; echoes x=4830, y=575.
- Appearance: A marked stone alcove beside a sarcophagus.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `echo_supply_cache` in CE-05; the Memory Key changes the value of reusing this same position.

OBJECT NAME: The descent distraction cache [`echoes/echo_supply_cache`]

- Location: CE-05 — Nexus Descent; echoes x=4580, y=420.
- Appearance: A small slatted crate with usable wind-up mechanisms among its stored glass. Its prompt clearly distinguishes it from decorative bottle crates.
- Lore/backstory tied to this object: Authored interpretation: recurring maintenance supplies remain where the descent tests preparedness. The supplier is not identified.
- In-game purpose: Renewable anti-softlock supply for the gadget route.
- Player interaction: E checks carried bottles plus clocks. If that total is below three, add three clocks; otherwise explain that enough distractions are already carried. This is additive, not a reset to exactly three. No unique floor pickup is left behind.
- Connection to other objects/clues: Q gadget uses in Echoes, echo_clock, and the three-use descent gate.

OBJECT NAME: Power station and support table — ce_05_charge_1 [`echoes/ce_05_charge_1`]

- Location: CE-05 — Nexus Descent; echoes x=5235, y=590.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `nexus_descent` in CE-05; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Ritual Stone — echoes/decoration-07 [`echoes/decoration-07`]

- Location: CE-05 — Nexus Descent; echoes x=4740, y=405.
- Appearance: A squat engraved stone with worn angular grooves, a chipped rim, and a faint cold reflection in its cuts. A pale scrape marks the near-left edge. Art width specification: 105 units before its parent/asset scale.
- Lore/backstory tied to this object: The estate’s practical language of locks gives way to an older architecture of wards. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The cuts look deliberate. That does not tell me who made them.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent_alcove` in CE-05.

OBJECT NAME: Candle — echoes/decoration-08 [`echoes/decoration-08`]

- Location: CE-05 — Nexus Descent; echoes x=4960, y=392.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. Dust remains in the far corner where a hand would not easily reach. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Local atmospheric light and orientation; no independent switch or hidden detection modifier.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent_alcove` in CE-05.

OBJECT NAME: Ordinary table — ce_05_charge_2 [`ce_05_charge_2`]

- Location: CE-05 — Nexus Descent; echoes x=4710, y=405.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent_alcove` in CE-05.

OBJECT NAME: Candle — ce_05_charge_2/tabletop [`ce_05_charge_2/tabletop`]

- Location: CE-05 — Nexus Descent; echoes x=4710, y=405. Detail on `ce_05_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A short wax candle with a blackened wick, uneven rim, and a localized warm halo. A pale scrape marks the near-left edge. Art width specification: 20 units before its parent/asset scale.
- Lore/backstory tied to this object: The light suggests continuing maintenance but does not prove a recent visitor. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Enough light to see the edge of the room.”
- Connection to other objects/clues: Mounted on `ce_05_charge_2`; Nearest functional landmark: `nexus_descent_alcove` in CE-05.

OBJECT NAME: Lectern — CE-05/dressing-01 [`CE-05/dressing-01`]

- Location: CE-05 — Nexus Descent; echoes x=4476, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `echo_supply_cache` in CE-05.

OBJECT NAME: Book — CE-05/dressing-01/detail-1 [`CE-05/dressing-01/detail-1`]

- Location: CE-05 — Nexus Descent; echoes x=4476, y=395. Detail on `CE-05/dressing-01`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `CE-05/dressing-01`; Nearest functional landmark: `echo_supply_cache` in CE-05.

OBJECT NAME: Bench — CE-05/dressing-02 [`CE-05/dressing-02`]

- Location: CE-05 — Nexus Descent; echoes x=4630, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A dark moisture line remains close to its lower edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `echo_supply_cache` in CE-05.

OBJECT NAME: Cat Rubble — CE-05/dressing-03 [`CE-05/dressing-03`]

- Location: CE-05 — Nexus Descent; echoes x=5040, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. One exposed corner is blunted by repeated contact. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent_alcove` in CE-05.

OBJECT NAME: Sarcophagus — CE-05/dressing-04 [`CE-05/dressing-04`]

- Location: CE-05 — Nexus Descent; echoes x=5130, y=395.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The highlight breaks across a small chip on the front edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent` in CE-05.

OBJECT NAME: Bench — CE-05/dressing-05 [`CE-05/dressing-05`]

- Location: CE-05 — Nexus Descent; echoes x=5361, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. A pale scrape marks the near-left edge. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: final descent antechamber.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_descent` in CE-05.

### LN-CENTER — Convergence

OBJECT NAME: The sealed return threshold [`nexus/nexus_gate`]

- Location: LN-CENTER — Convergence; nexus x=180, y=430.
- Appearance: A low ward stone at the western side of Convergence marks where arrival ended; it offers a reading prompt rather than a usable return door.
- Lore/backstory tied to this object: Established: the finale has begun and the way back is closed.
- In-game purpose: Explain the one-way final arena boundary.
- Player interaction: E reveals: “The way back has closed.” It does not travel or require another key.
- Connection to other objects/clues: nexus_descent is the incoming passage; the Ward Bell and three anchors are the remaining solution.

OBJECT NAME: Severance anchor [`nexus/LN-A`]

- Location: LN-CENTER — Convergence; nexus x=520, y=500.
- Appearance: An engraved Nexus anchor with a localized cyan pulse and a brass-toned, clearly named choice marker. West position; authored motif: a split bond.
- Lore/backstory tied to this object: Established action: destroy the entity and the inherited bond.
- In-game purpose: One of three mutually exclusive final outcomes; completing any one finishes the story.
- Player interaction: Hold E for 20 uninterrupted seconds while undetected. Movement, releasing E, damage, or detection resets progress. Pausing freezes the ritual and ward timers. Completion records this anchor and triggers its ending; the other two are alternatives rather than unfinished objectives.
- Connection to other objects/clues: nexus_bell provides 32 seconds for movement and the 20-second hold; both ward screens and ln_center_charge_1 allow preparation.

OBJECT NAME: Custodian’s Rest anchor [`nexus/LN-B`]

- Location: LN-CENTER — Convergence; nexus x=900, y=500.
- Appearance: An engraved Nexus anchor with a localized cyan pulse and a brass-toned, clearly named choice marker. Center position; authored motif: a standing human ward.
- Lore/backstory tied to this object: Established action: Els becomes the living ward.
- In-game purpose: One of three mutually exclusive final outcomes; completing any one finishes the story.
- Player interaction: Hold E for 20 uninterrupted seconds while undetected. Movement, releasing E, damage, or detection resets progress. Pausing freezes the ritual and ward timers. Completion records this anchor and triggers its ending; the other two are alternatives rather than unfinished objectives.
- Connection to other objects/clues: nexus_bell provides 32 seconds for movement and the 20-second hold; both ward screens and ln_center_charge_1 allow preparation.

OBJECT NAME: Vessel anchor [`nexus/LN-C`]

- Location: LN-CENTER — Convergence; nexus x=1280, y=500.
- Appearance: An engraved Nexus anchor with a localized cyan pulse and a brass-toned, clearly named choice marker. East position; authored motif: a closed key bow.
- Lore/backstory tied to this object: Established action: bind the entity into a new key for another hand.
- In-game purpose: One of three mutually exclusive final outcomes; completing any one finishes the story.
- Player interaction: Hold E for 20 uninterrupted seconds while undetected. Movement, releasing E, damage, or detection resets progress. Pausing freezes the ritual and ward timers. Completion records this anchor and triggers its ending; the other two are alternatives rather than unfinished objectives.
- Connection to other objects/clues: nexus_bell provides 32 seconds for movement and the 20-second hold; both ward screens and ln_center_charge_1 allow preparation.

OBJECT NAME: The golden Ward Bell [`nexus/nexus_bell`]

- Location: LN-CENTER — Convergence; nexus x=900, y=395.
- Appearance: A compact golden bell with a clearly readable 32-second protection marker, positioned behind the center anchor so that the two E targets remain distinguishable.
- Lore/backstory tied to this object: The established ward temporarily binds the entity; its original maker and ritual origin are not explained.
- In-game purpose: Reusable common countermeasure that makes all three final choices achievable on every branch.
- Player interaction: E while no ward is active binds/stuns the Hound for 32 seconds and clears detection. Existing Els line: “The bell binds it for 32 seconds. One anchor. One choice. Hold E for twenty.” During an active ward, another use does not extend it; after expiry it can be rung again.
- Connection to other objects/clues: LN-A, LN-B, LN-C, both ward screens, and the recovery station. The bell is not a kill action or a fourth ending.

OBJECT NAME: Hide behind ward screen — nexus_hide_west [`nexus/nexus_hide_west`]

- Location: LN-CENTER — Convergence; nexus x=345, y=580.
- Appearance: An opaque ward screen with a marked cover point and a narrow return lane.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `nexus_gate` in LN-CENTER; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Hide behind ward screen — nexus_hide_east [`nexus/nexus_hide_east`]

- Location: LN-CENTER — Convergence; nexus x=1490, y=580.
- Appearance: An opaque ward screen with a marked cover point and a narrow return lane.
- Lore/backstory tied to this object: A practical refuge arises from this room's furnishing; it becomes an entry in the Hound's history if Memory is restored. No individual former occupant is identified.
- In-game purpose: Registered hiding place with `low` priority. It can conceal Els under the applicable sense rules; it is not invulnerability.
- Player interaction: E enters using the appropriate table/low or upright-cover animation and records use. E leaves with a separate exit movement. A witnessed hide can be attacked; Memory can revisit a used hide; Vantree Touch can still locate Els through transmitting floor. Other look-alike furniture has no hiding interaction.
- Connection to other objects/clues: `LN-C` in LN-CENTER; the Memory Key changes the value of reusing this same position.

OBJECT NAME: Power station and support table — ln_center_charge_1 [`nexus/ln_center_charge_1`]

- Location: LN-CENTER — Convergence; nexus x=450, y=405.
- Appearance: A compact teal electrical unit with a cable and cyan CHARGE marker on its dedicated support table. Its tabletop footprint remains readable; it is visually distinct from the ordinary side tables.
- Lore/backstory tied to this object: Established function: restore Els's flashlight and health. Authored interpretation: practical equipment has been maintained within the old structure; its installer is unidentified.
- In-game purpose: Reusable resource recovery; at most one active station per named room.
- Player interaction: E starts a gradual 12-second charge up to 90 seconds. Movement or damage interrupts while preserving charge gained. In Part II it also restores HP gradually up to the branch maximum (80 Vantree, 100 otherwise). It is not consumed and creates no additional battery item.
- Connection to other objects/clues: `LN-A` in LN-CENTER; distinguish this marker from unpowered nearby tables.

OBJECT NAME: Ritual Stone — nexus/decoration-01 [`nexus/decoration-01`]

- Location: LN-CENTER — Convergence; nexus x=900, y=340.
- Appearance: A squat engraved stone with worn angular grooves, a chipped rim, and a faint cold reflection in its cuts. One exposed corner is blunted by repeated contact. Art width specification: 230 units before its parent/asset scale.
- Lore/backstory tied to this object: The estate’s practical language of locks gives way to an older architecture of wards. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “The cuts look deliberate. That does not tell me who made them.”
- Connection to other objects/clues: Nearest functional landmark: `LN-B` in LN-CENTER.

OBJECT NAME: Cat Rubble — nexus/decoration-02 [`nexus/decoration-02`]

- Location: LN-CENTER — Convergence; nexus x=250, y=405.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The highlight breaks across a small chip on the front edge. Art width specification: 120 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_gate` in LN-CENTER.

OBJECT NAME: Cat Rubble — nexus/decoration-03 [`nexus/decoration-03`]

- Location: LN-CENTER — Convergence; nexus x=1550, y=405.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. A pale scrape marks the near-left edge. Art width specification: 120 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_hide_east` in LN-CENTER.

OBJECT NAME: Ordinary table — ln_center_charge_2 [`ln_center_charge_2`]

- Location: LN-CENTER — Convergence; nexus x=1360, y=590.
- Appearance: A compact dark-wood table with a narrow apron, four visible feet, and a dull circular mark on its top. A pale scrape marks the near-left edge. Art width specification: 72 units before its parent/asset scale.
- Lore/backstory tied to this object: Small domestic surfaces kept ordinary tasks within reach of the larger work of the room. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Ordinary table with no CHARGE marker and no E interaction. Its legacy ID includes charge, but it is not a power station.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A place to put something down, not a way out.”
- Connection to other objects/clues: Nearest functional landmark: `LN-C` in LN-CENTER.

OBJECT NAME: Book — ln_center_charge_2/tabletop [`ln_center_charge_2/tabletop`]

- Location: LN-CENTER — Convergence; nexus x=1360, y=590. Detail on `ln_center_charge_2`, local offset [0, -47]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A pale scrape marks the near-left edge. Art width specification: 24 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `ln_center_charge_2`; Nearest functional landmark: `LN-C` in LN-CENTER.

OBJECT NAME: Sarcophagus — LN-CENTER/dressing-01 [`LN-CENTER/dressing-01`]

- Location: LN-CENTER — Convergence; nexus x=200, y=590.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_gate` in LN-CENTER.

OBJECT NAME: Lectern — LN-CENTER/dressing-02 [`LN-CENTER/dressing-02`]

- Location: LN-CENTER — Convergence; nexus x=346, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. A dark moisture line remains close to its lower edge. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_hide_west` in LN-CENTER.

OBJECT NAME: Book — LN-CENTER/dressing-02/detail-1 [`LN-CENTER/dressing-02/detail-1`]

- Location: LN-CENTER — Convergence; nexus x=346, y=395. Detail on `LN-CENTER/dressing-02`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. A dark moisture line remains close to its lower edge. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `LN-CENTER/dressing-02`; Nearest functional landmark: `nexus_hide_west` in LN-CENTER.

OBJECT NAME: Bench — LN-CENTER/dressing-03 [`LN-CENTER/dressing-03`]

- Location: LN-CENTER — Convergence; nexus x=651, y=605.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. One exposed corner is blunted by repeated contact. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `LN-A` in LN-CENTER.

OBJECT NAME: Cat Rubble — LN-CENTER/dressing-04 [`LN-CENTER/dressing-04`]

- Location: LN-CENTER — Convergence; nexus x=772, y=395.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. The highlight breaks across a small chip on the front edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `LN-B` in LN-CENTER.

OBJECT NAME: Sarcophagus — LN-CENTER/dressing-05 [`LN-CENTER/dressing-05`]

- Location: LN-CENTER — Convergence; nexus x=1030, y=605.
- Appearance: A long stone container with a heavy lid, abraded edges, and a shallow recess in the masonry around it. A pale scrape marks the near-left edge. Art width specification: 146 units before its parent/asset scale.
- Lore/backstory tied to this object: The container suggests the architecture of keeping bodies or burdens; its individual occupant is unknown. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A space made to keep something where it was put.”
- Connection to other objects/clues: Nearest functional landmark: `LN-B` in LN-CENTER.

OBJECT NAME: Lectern — LN-CENTER/dressing-06 [`LN-CENTER/dressing-06`]

- Location: LN-CENTER — Convergence; nexus x=1176, y=395.
- Appearance: A sloped wooden reading stand with a narrow ledge, a rubbed upper edge, and a heavy foot. Dust remains in the far corner where a hand would not easily reach. Art width specification: 82 units before its parent/asset scale.
- Lore/backstory tied to this object: A document was meant to be read while someone remained standing; the room makes instruction feel procedural. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Someone wanted a page kept open here.”
- Connection to other objects/clues: Nearest functional landmark: `LN-C` in LN-CENTER.

OBJECT NAME: Book — LN-CENTER/dressing-06/detail-1 [`LN-CENTER/dressing-06/detail-1`]

- Location: LN-CENTER — Convergence; nexus x=1176, y=395. Detail on `LN-CENTER/dressing-06`, local offset [0, -82]; parent coordinates shown.
- Appearance: A closed, clothbound volume with softened corners and an uneven block of yellowed page edges. Dust remains in the far corner where a hand would not easily reach. Art width specification: 30 units before its parent/asset scale.
- Lore/backstory tied to this object: This is unreadable background print, distinct from the numbered Vantree letters. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible component of the supporting object; no separate pickup or readable text.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “A closed book. No legible page here.” This closed background volume has no legible page; it is not an omitted diary collectible.
- Connection to other objects/clues: Mounted on `LN-CENTER/dressing-06`; Nearest functional landmark: `LN-C` in LN-CENTER.

OBJECT NAME: Bench — LN-CENTER/dressing-07 [`LN-CENTER/dressing-07`]

- Location: LN-CENTER — Convergence; nexus x=1411, y=395.
- Appearance: A low timber bench with a bowed seat, rubbed front edge, and dark joints where polish has worn away. The side toward the passage is rubbed lighter than the side toward the wall. Art width specification: 148 units before its parent/asset scale.
- Lore/backstory tied to this object: Waiting was built into this room; repeated occupation is suggested by the polished seat, without identifying a particular sitter. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Environmental furnishing and spatial orientation; no inventory, code, or additional gate.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “I could sit here. I would still be waiting.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_hide_east` in LN-CENTER.

OBJECT NAME: Cat Rubble — LN-CENTER/dressing-08 [`LN-CENTER/dressing-08`]

- Location: LN-CENTER — Convergence; nexus x=1622, y=605.
- Appearance: Broken gray-green masonry in angular overlapping pieces, pale fractures exposed against damp older faces. A dark moisture line remains close to its lower edge. Art width specification: 150 units before its parent/asset scale.
- Lore/backstory tied to this object: Collapse interrupts the continuity of the older stone and visually supports the reduced-transmission rubble regions. Here its placement supports the room’s role: convergence perimeter memorials.
- In-game purpose: Visible broken masonry. The configured floor region, rather than touching this individual sprite, determines vibration and footstep rules.
- Player interaction: Current behavior: no E interaction. Authored inspection copy, if an examine system is later added: “Broken stone does not carry the floor the same way.”
- Connection to other objects/clues: Nearest functional landmark: `nexus_hide_east` in LN-CENTER.

OBJECT NAME: Convergence ward floor [`nexus/ring`]

- Location: LN-CENTER; around the three anchors and central bell.
- Appearance: A restrained cyan-green ward pattern spans the arena, intensifying locally around the selected anchor.
- Lore/backstory tied to this object: The final spatial diagram makes the three ways of retaining or ending captivity visible.
- In-game purpose: Finale composition; the bell supplies actual timed protection.
- Player interaction: Walk to one anchor after ringing the bell. The painted ring is not an always-safe area.
- Connection to other objects/clues: LN-A, LN-B, LN-C, and nexus_bell.

<a id="puzzles"></a>

## 6. PUZZLES AND HINTS

### P01 — Recover the locksmith's working kit

**Location:** GF-00. **Solution:** test `intro_exit` once, collect the flashlight at (430,480) and tool pouch at (900,430), then return to the door at (1590,362) and press E. The pouch grants three picks; this introductory unlock consumes none.

**Hint order:** (1) the visible dropped flashlight and Els's appraisal recollection; (2) the first door response, “Locked.” / “Of course.”; (3) “I need my tools.” if the pouch is absent; (4) “I should take my flashlight.” if the light is absent; (5) the two recognizable pickup prompts. The player may physically collect the kit before testing the door, but the required door-test flag still needs one interaction.

**Failure:** a missing prerequisite produces a hint and no travel. **Success:** an unlock/open action, “Hello?”, and travel to the Ground Floor. The Music Room label on this introductory door does not indicate direct placement at the piano.

### P02 — Piano ward / Hearing

**Location:** GF-03. **Solution:** with at least one lockpick, stand at a valid piano interaction point and complete three E actions of 1.1 seconds each. Take `hearing_key` separately. The first work action spends one pick; the next two do not.

**Hint order:** (1) foyer note on three wards and senses; (2) piano work prompt; (3) a missing-pick hint if needed; (4) step completion feedback and “The seal gives.”; (5) the newly available key; (6) the screech, Els's “Something heard that.”, and Letter I explaining the consequence. Letter I can be collected before taking the key if the player chooses to inspect that side of the room first.

**Failure:** an absent pick prevents starting; the key remains unavailable while its seal holds. The work emits noise, so later interactions may draw the Hound. **Success:** only acquisition of the key restores Hearing. Moving away and returning does not require resetting Els to one special coordinate. No sheet-music transcription, chord, or numeral is required.

### P03 — Vanity ward / Sight

**Location:** UF-02. **Solution:** restore Hearing first, bring one pick, complete three 1.1-second E actions at `vanity_seal`, then collect `sight_key` separately.

**Hint order:** (1) Letter III describes covered painted eyes; (2) vanity prompt; (3) “Not yet.” if Hearing is missing; (4) pick requirement and repeated mechanical feedback; (5) “The seal gives.”; (6) “It turned toward the light.” on acquisition. The mirror is a thematic object, not a reflection puzzle.

**Failure:** wrong sense order or missing pick leaves the ward closed. **Success:** Hearing and Sight are active, enabling the Flood Tunnel and the next ritual seal. Taking Sight makes the Hearing-only Vantree route unavailable for that run. Opening the vanity but leaving its key uncollected does not restore Sight.

### P04 — Cracked ritual ward / Memory

**Location:** BS-05. **Solution:** with Sight, complete one 1.25-second E action at the cracked seal and then collect Memory. No lockpick is spent.

**Hint order:** (1) Letters V and VII warn about remembered refuge and completion; (2) the explicitly cracked ritual stone; (3) “Not yet.” before Sight; (4) completion feedback; (5) “It knows this place now.” on collection.

**Failure:** no Sight, no release. **Success:** the all-three-key state enables only the Loop exit in Part I. This is an optional deliberate failure route, not the required route to the final act.

### P05 — Select an exit that matches the remaining wards

**Solution and ordered clues:**

1. The foyer note introduces restraint; the first front-door test introduces a possible refusal. With no keys and no detections, a second use gives **Untouched**.
2. Hearing's consequence and Letters II/IV introduce custodianship. The conduit says it is not ready until Els has **Hearing only and four estate letters**. Matching that state gives **Vantree**.
3. The flood exit states that it opens while **two senses** are restored. With Hearing and Sight, leaving Memory closed gives **Partial Mercy**.
4. Letter VII warns that completion is not freedom. With all three keys, the Front Door gives **Loop**.

**Failure:** an incompatible exit remains sealed without consuming keys. **Success:** a valid successful chapter exit offers Part II, while Loop resets Part I. The initial note is not a counted letter. There are seven counted estate letters before descent; the six lower letters are optional story content rather than an early substitute for the gate.

### P06 — Vertical passage and vent navigation

**Solution:** Hearing opens the GF-09 Upper Floor stairs and GF-10 cellar stairs. Their return doors do not add another key requirement. Vents follow their explicitly linked destinations, with no additional key gate in current data. Ground `ground_vent` leads to UF-04 `upper_vent`; that vent returns to GF-08. UF-07 `vent_to_ground` also returns to GF-08. UF-07 `vent_to_basement` links to BS-02 `basement_vent`, which returns to UF-07.

**Hint order:** (1) destination marker; (2) sealed-passage feedback for gated stairs; (3) Hearing's acquisition; (4) the same marker now accepts E. **Failure:** no travel on unmet stairs requirement. **Success:** entry and emergence at the paired passage. Open borders between rooms do not need E. A decorative serving hatch does not share vent behavior.

### P07 — Resource and stealth discipline

This is a recurring survival problem rather than a hidden code. The flashlight holds **90 seconds**, draining **one second per second during ordinary lit play** and **three per second while sprinting with it on**. A battery adds **45 seconds** up to the cap. A cyan station restores charge gradually over **12 seconds**; movement or damage stops charging while keeping the amount restored. In Part II it also restores HP to the branch maximum. An ordinary table supplies no recharge.

**Hint order:** (1) recovered flashlight and F feedback; (2) cyan CHARGE markers; (3) remaining-charge HUD and inventory; (4) station prompt and move-to-stop instruction; (5) H field guide. Q selects a battery first if charge is below 50 and one is carried; otherwise a bottle, then a clock. Empty or ineligible inventory produces feedback without creating an item.

**Stealth solution:** crouch before pantry entry to avoid the hanging-pot event; crouch through GF-08 to convert creaking steps to CARPET-class noise; break actual line of sight after Sight; avoid repeated marked hides after Memory. Breath-hold lasts up to six seconds with a 15-second cooldown; it is not a Touch countermeasure. Use doors and furniture as geometry rather than invulnerability.

Normal footstep noise radii are CARPET 64, WOOD 256, STONE 320, RUBBLE 160, WATER 448, and GLASS 576. Sprint adds 128 to the base radius; quiet crouching multiplies it by 0.45. A heard GLASS-class event still has its immediate-hunt classification even at reduced radius. Visual shards and shadow bands have the specific implementation limits listed in Section 5.

### P08 — Vantree resonance trial

**Location:** CE-01–05. **Solution:** enter with 80 maximum HP; find the CE-02 forge; press E to pay **6.4 HP** and gain use 1; cast R for **6.4 HP** and use 2; wait for the **20-second** R cooldown; cast R again for use 3. The total nominal cost is **19.2 HP** if no other damage occurs. A full-health Els ends that sequence at 60.8 HP before recovery. Heal at a station whenever needed.

**Hint order:** (1) reduced maximum HP and Touch behavior in Roots; (2) CE-01's forge instruction; (3) forge's explicit R/T explanation; (4) HUD resonance count and cooldown; (5) gate text asking for three successful resonances; (6) H field guide explaining the full rule. A cast counts when it succeeds in Echoes; it need not strike the Hound.

The R circle lasts **12 seconds**, radius **192**, and suppresses all senses including Touch while the Hound is inside. It is not a shield against contact. T affects a Hound within **192**, costs **16 HP**, stuns for **six seconds**, and has a **60-second** cooldown. T does not count toward the gate; an out-of-range attempt spends nothing.

**Alternative:** on CE-04 RUBBLE, move faster than 20 units/second within 520 of the Hound; each eligible event counts, at most once every two seconds. Keep beyond the local Touch transmission radius: 96 in the rear strip y<470, 160 on other rubble, ordinarily 480 on intact floor. Actual rug footprints override rubble and do not satisfy this evasion check. Three evasion counts can open the door without forge use, but the recommended route also obtains blood rites for the finale.

**Failure:** missing unlock, cooldown, insufficient HP, or an attempt outside the permitted ability zones gives feedback and no successful cast. Insufficient health is recoverable at a station. **Success:** the gate in CE-05 becomes usable at three total successful branch uses, including supported combinations of forge, R, and Touch evasion.

### P09 — Partial Mercy resonance trial

**Solution:** entering CE-01 unlocks the partial sigil automatically. Cast R three times in Echoes, waiting 20 seconds between casts. Each costs **4 HP**, total **12 HP**, and creates a 12-second, radius-192 circle. Keep the torch lowered and use cover: this circle suppresses **Hearing only**, and only while the Hound is inside it. Sight remains active.

**Hint order:** (1) inherited Hearing/Sight in the branch state; (2) CE-01's explicit partial-sigil instruction; (3) HUD cast count and cooldown; (4) the descent's three-use message; (5) H for detailed limitations. The Vantree forge is not a prerequisite and cannot be used by this branch.

**Failure:** cooldown or insufficient HP produces feedback without a use; stepping into a lit, visible position can still trigger pursuit. **Success:** the third cast opens CE-05's Nexus door. Charge/recover before entering it.

### P10 — Untouched resonance trial

**Solution:** use Q three times in Echoes when it selects a bottle or clock. At the start of Part II, this branch receives at least three of each battery, bottle, and clock. A Q battery use does **not** count. To ensure distraction selection, charge above 50 seconds or turn the torch off after charging. Bottles are selected before clocks. The CE-05 supply cache adds three clocks whenever the combined bottle-and-clock count is below three.

**Hint order:** (1) supplied kit and inventory counts; (2) CE-01 gadget instruction; (3) HUD resonance counter; (4) gate text; (5) supply-cache message and H explanation of battery priority.

**Failure:** no usable distraction yields feedback, and spending a battery produces no resonance. **Success:** three accepted bottle/clock uses unlock the descent. The Hound's senses remain dormant; these uses demonstrate the branch mechanic and are not proof it has secretly regained Hearing.

### P11 — One anchor, one ending

**Location:** LN-CENTER. **Solution:** recover and choose the desired anchor before committing. Ring the golden bell with E for **32 seconds** of binding; move to LN-A, LN-B, or LN-C and hold E for **20 continuous seconds**. This leaves 12 seconds for travel and settling into the interaction. Ring again after expiry if the attempt is interrupted.

**Hint order:** (1) sealed return marker; (2) all three named anchor labels; (3) golden bell's 32-second label; (4) Els's spoken one-choice/twenty-second instruction; (5) progress bar and ward countdown; (6) H field guide. Current short labels saying “Free the captive” or “release its captive” at LN-A are less precise than canon; final copy should explicitly say **destroy the entity and break the inherited bond** so the choice is accurately informed.

**Failure:** detection at the start refuses the channel; detection, damage, movement, or releasing E during the channel resets progress. Pausing does not consume the protection window. **Success:** the chosen anchor triggers its one final ending immediately. There is no three-anchor completion reward and no retreat door to search for.

### P12 — Second-Loop memory fragment

**Intended solution:** complete the three-key Front Door Loop twice in the same continuing run. A second completion sets `vantree_memory_fragment_A`. The first Loop already communicates the puzzle's warning; the second acknowledges that the player deliberately tested it.

**Current implementation gap:** Loop resets lockpicks to zero and returns to GF-01, while the three-pick pouch remains in the inaccessible introductory scene. The reachable GF-07 spare supplies only one pick; piano and vanity require two in total. Consequently, the intended second Loop cannot be promised as an ordinarily finishable route in the current build. The flag also has no implemented reader presentation.

**Concrete proposed completion requirement:** supply at least two reachable picks after a Loop without clearing its counter, then surface the authored fragment on the second Loop recovery. This proposal is documentation only. Until implemented, list the secret as blocked rather than telling a player to keep searching for an undocumented tool source.

<a id="events"></a>

## 7. SCARES AND EVENTS

### Established authored triggers and systemic events

These entries distinguish a deliberate story trigger from a repeatable AI consequence. Ambient creaks, visual pulses, and inherited rules do not automatically imply a hallucination or a second monster.

| ID | Trigger / repeat policy | Exact event | Narrative meaning |
| --- | --- | --- | --- |
| EV-01 | New game awakening in GF-00 | Els recovers from the floor; the dropped beam points away; the four canon lines establish name, contract, and lost hours | Immediate disorientation with a competent protagonist; recovery is not death |
| EV-02 | First introductory door test | Knock and “Locked.” / “Of course.”; door remains shut | Establish ordinary physical resistance before supernatural consequence |
| EV-03 | Flashlight pickup | Remove dropped torch and beam, enable hand light, play recognition lines | Familiar ownership cannot explain the missing interval |
| EV-04 | Tool-pouch pickup | Bag-specific pickup, three picks gained, “At least I came prepared.” | Recover professional agency |
| EV-05 | Successful introductory exit | Planted unlock, opening, building creak, “Hello?”, transition | Els addresses an apparently empty house |
| EV-06 | First zero-key Front Door test | Knock only; record that the door was tested | Refusal is a deliberate second action rather than an accidental instant chapter exit |
| EV-07 | Enter GF-03 | Music/tension state changes to SEARCHING | The piano becomes a focus before its consequence is known |
| EV-08 | Each completed seal-work step | Unlock/work sound, 300-radius GENERIC noise, progress increment; final step says “The seal gives.” | Els's useful work has an audible cost |
| EV-09 | Hearing Key acquired once | Key pickup, monster screech, search tension, brief red transaction pulse, local light disturbance, “Something heard that.” | First undeniable transfer of freedom |
| EV-10 | Enter GF-04 while not crouched | Cookware position emits a 420-radius GENERIC noise | An ordinary shoulder-level hazard becomes dangerous when Hearing is available; entry trigger itself is not a supernatural attack |
| EV-11 | Ground Floor after Hearing, initial timer about 14 seconds, then every 12–20 seconds | A 260-radius GENERIC false-noise event occurs near (1100,300), potentially redirecting the Hound | The house complicates listening; this is an AI noise event, not proof of an unseen person |
| EV-12 | Enter UF-02 | Set vision_vfx_primed | Preparation flag only; the examined implementation does not establish a separate apparition or mirror jump scare |
| EV-13 | Sight Key acquired once | Transaction pulse and light disturbance; Sight becomes active; “It turned toward the light.” | The player's light becomes an exposure cost |
| EV-14 | Enter BS-05 | Set ritual_chamber_seen | A location/story milestone, without an extra mandatory scare |
| EV-15 | Memory Key acquired once | Set true_form_revealed; update Hound appearance/behavior and remembered hides; pulse and “It knows this place now.” | Previous safety becomes learned evidence |
| EV-16 | A qualifying sound is heard | First isolated sound invites investigation; second within six seconds or GLASS begins an audio hunt | A learnable consequence rather than a randomly scheduled pursuit |
| EV-17 | Sight confirms an exposed visible Els | Hound turns and chases after a brief confirmation; lost sight leads to investigation | The monster responds to what it can perceive |
| EV-18 | Memory encounters prior hiding evidence or predicts a route | Investigate remembered refuge or attempt an exit ambush under its current AI rules | The entity learns the player's habits; it does not teleport through a wall |
| EV-19 | Hound reaches contact range in an active sense/Touch state | Distinct windup, forward strike at attack frame 3, new reach/facing/line-of-sight check; capture in Part I or HP damage in Part II | Responsive, readable violence with an opportunity to evade or stun |
| EV-20 | Blind stage-zero contact without Touch | Els staggers and creates a noise; no lethal strike | Deprivation has a visible behavioral meaning; applies to Untouched's unchanged stage too |
| EV-21 | Valid Part I exit | Outcome card identifies Untouched, Vantree, or Partial Mercy; Continue offers the lower journey | Escape has consequences that determine the next act |
| EV-22 | Three-key Front Door use | Brief transition and Grand Foyer recovery; reset ordinary run state, increment Loop counter | Completion repeats captivity |
| EV-23 | Second Loop, if made reachable | Set memory-fragment flag | Recognition of repetition; visible fragment presentation is proposed, not implemented |
| EV-24 | Entry to CR-01 | Threat suppression and no narration | Deliberate rest; do not insert an explanatory monologue or forced scare |
| EV-25 | First entry to CR-03 | Enable the first lower active encounter; later Roots travel can also be threatened outside CR-01 | Reintroduce danger through the branch's actual rules |
| EV-26 | Vantree Touch within local transmission range | The Hound tracks Els's floor position even when she crouches or stops; a nearby stone cue supports the mechanic | Stillness is no longer an adequate safety strategy |
| EV-27 | First CR-04 entry per run | Automatically display the Custodian/Jailer/Vantree/Els inscription and impossible relative date | Recognition without a fabricated explanation |
| EV-28 | First CE-01 entry | One branch tutorial; Partial Mercy's ability unlocks here | Turn uncertainty into an actionable rule |
| EV-29 | Vantree forge activation | Deduct 6.4 HP, awaken abilities, increment resonance count, show R/T instruction | Power has a visible bodily price |
| EV-30 | First CE-03 entry on Vantree only | Monster breathing and “Els. You have brought your name home.”; mark entity_spoke | First direct address; no equivalent speech on other branches |
| EV-31 | Successful R / T / gadget action | Distinct action feedback and applicable resource/cooldown change; only qualifying branch actions in Echoes increment the gate | Maintain a consistent cause-and-effect language |
| EV-32 | Third qualifying Echoes use | Gate requirement becomes true; HUD directs the player toward CE-05 | The trial recognizes demonstrated agency |
| EV-33 | Enter LN-CENTER | Set finale_started; return marker says the way back has closed | Replace route exploration with a decision |
| EV-34 | Ring the bell while inactive | Bind the Hound for 32 seconds, clear detection, show ward and explicit 20-second instruction | Give the final choice room to be deliberate |
| EV-35 | Anchor interruption | Clear channel progress and return control; detection interruption may say “The pattern broke.” | Commitment requires a stable interval; failure is retryable |
| EV-36 | Anchor reaches 20 seconds | Record one anchor and select its associated ending | Final action determines the location or destruction of the burden |
| EV-37 | Capture / HP reaches zero | Finish the appropriate hurt/capture presentation, then show checkpoint retry UI | Death ends the attempt, not the player's ability to finish the story |
| EV-38 | Letter collected | Remove the page, play a brief discovery cue, open paused reader | Let evidence be read without simultaneous attack pressure |
| EV-39 | Foyer clock sabotage / Q distraction | Emit that object's configured noise; bottles also break audibly | Player-caused sound, not a hidden ghost acting without rules |
| EV-40 | Ongoing atmospheric lighting | Candles flutter; windows drift slowly; ritual lights pulse; the eleven dining bulbs brown out independently | A neglected, unstable visual atmosphere; it never changes AI exposure secretly |
| EV-41 | Ambient audio timer, approximately every 35–80 seconds during play | Choose a distant-event sound while avoiding the immediately previous sample when possible | Spatial unease; no automatic inventory, key, or story-state change |

### Authored final presentation additions

These are concrete proposed production beats, not claims about already installed cinematics:

1. **Hearing handoff:** keep the screech tied to the instant the key leaves its resting place; briefly let the local room tone narrow, then restore the ordinary acoustic space. Do not delay the mechanical Hearing change until after the player has already started running.
2. **Sight handoff:** emphasize a small head/eye turn and a restrained torch-light reflection on the Hound; use the existing sense pulse. Do not add a compulsory full-screen white flash or a false mirror figure that implies another entity.
3. **Memory handoff:** hold the Hound's attention on a previously useful direction before pursuit; communicate behavior rather than spawning a fake enemy at every hide.
4. **Name carving:** reveal the complete surname and given name with a measured text layout; no family photograph, voice-over genealogy, or exact invented year fills the gap.
5. **Finale:** use the three distinct ending treatments in Section 3, preserving the canonical action of each anchor. After the chosen ending, return to a readable result screen with Begin Again and Main Menu.
6. **Interaction polish:** give every requested major action its own anticipatory pose, contact pose, and recovery. The handoff frame must match the inventory change or door transition. A hit, pause, or canceled transition must not leave Els in a permanent pose or let an old callback teleport her later.

The game does not need additional unmotivated radios, spectral children, randomized portraits, or floor accessories enlarged into obstacles. Each retained prop either supports a room's use, communicates an actual mechanic, or contributes a specific clue in the catalog.

<a id="walkthrough"></a>

## 8. FULL STEP-BY-STEP WALKTHROUGH GUIDE

### Controls and route convention

WASD/arrows move, Shift sprints, Ctrl crouches, E interacts and leaves a hide, F toggles the torch, B holds breath, Q uses the inventory priority described above, R casts a sigil on eligible branches, T uses the Vantree stun, H opens the field guide, Tab opens the inventory and collected-letter count, and Esc pauses/closes the relevant panel. Read prompts before pressing E where a charger and puzzle are nearby. Wait for each work animation to finish before the next press.

The numbered route below first gives a complete Vantree run with every letter and every ordinary loose supply reachable along that branch. It then provides explicit replacement branches for Untouched, Partial Mercy, and Loop. Each successful Part I route can choose any of the three final anchors. One playthrough produces one final ending; the current result menu offers Begin Again rather than an in-place rewind to choose all three.

“Safer” means reduced exposure under the current senses, not a guarantee that a patrol will be in the same place every run. A precise timed movement script cannot guarantee every randomized patrol. Maintain spacing, use actual geometry, and inspect the HUD. CR-01 is the guaranteed lower safe room; ordinary chargers and decorative screens are not safe rooms.

### A. Shared opening

1. Start New Game and let Els recover in GF-00. Read the four opening lines. The flashlight is at x=430; the tool pouch is at x=900; the locked exit is at x=1590.
2. Walk east to the exit and press E once for the locked-door response. Return west along the open floor lane around the furniture; there is no monster in this opening room.
3. At (430,480), press E to collect the flashlight. Its floor representation and dropped beam disappear. The charge starts at 90 seconds.
4. At (900,430), press E to collect the tool pouch and gain three picks. The separate bag pickup should finish without leaving a large accessory over Els's body.
5. If needed, use the cyan station at (520,405); it is optional here because the freshly recovered torch is full. The table at (1360,590) is ordinary and cannot charge.
6. Return to the locked exit, press E, and allow the unlock, opening, “Hello?”, and transition to finish. No pouch pick is spent. Arrive on the Ground Floor near GF-01.

### B. Full Vantree route through Part I

7. In GF-01, read `the_note` at (430,485). It is lore, not letter 1 of 7. Keep zero-key Front Door interaction for the Untouched branch below; the canonical route continues east.
8. Optionally inspect/sabotage the foyer clock at (620,430). It creates a noise at its own location; the effect becomes consequential when Hearing is active. There is no time-setting puzzle. Use the GF-01 station at (275,430) only if charge requires it.
9. Enter GF-02 and collect the battery at (1280,470). Note the actual under-table hide at (1050,565) and the station at (890,405). Other dining furniture is not automatically interactive. Before Hearing, a blind bump is a stagger rather than a lethal capture.
10. Enter GF-03. Approach the piano at (1780,438). Press E, wait 1.1 seconds; press E, wait; press E, wait. This spends one pick total, leaving two from the pouch. Do not return to a distant alignment point between presses.
11. Collect the separate Hearing Key at (1960,478). The screech announces the new sound rule. Read Letter I at (2070,455). There is a station at (1610,495), but begin charging only when the approach is clear.
12. Before crossing into GF-04, crouch. Uncrouched entry creates the cookware noise at (2520,410). Collect two bottles at (2710,474). The marked pantry wardrobe at (2380,430) is available as a refuge; it is not guaranteed protection if the Hound witnessed entry. The station is (2260,495).
13. Continue through GF-05, navigating around the furniture. Collect the clock at (3070,470) and read the nameplate at (3420,420). Crouching is quieter. The painted lower bypass is useful for orientation but currently remains underlying wood except where an actual rug overlaps; the visual glass field itself is not a GLASS surface. Station: (2980,405).
14. In GF-06, read Letter II at (3850,460). Use `ground_recharge` at (4170,430) if needed. A full 12-second action fills up to the cap; moving early keeps the charge already gained.
15. In GF-07, collect the spare pick at (4870,470). Inventory should now contain three picks if only the piano has spent one. The marked coat-rack hide is (4520,430); the station is (4630,495).
16. Crouch through GF-08 to avoid the creaking boards' loud GLASS-class steps. The vent at (5480,405) goes to UF-04 and can serve as an optional shortcut, but this full letter route continues to the main stairs. Neither of the Trophy Hall's two ordinary tables charges.
17. In GF-09, use the Hearing-gated Upper Floor door at (6140,362). Charge beforehand at (6035,405) if needed. The destination is the upper return-stair area UF-06, so the next required direction is **west** toward the gallery and bedroom.
18. From the upper arrival in UF-06, travel west through UF-05. Collect the bottle at (4880,535) and use `upper_recharge` at (4380,430) if needed. Avoid treating the bathtub as a hide.
19. Continue west through UF-04. Collect the battery at (3770,470). The station is (3345,405). The vent at (3240,410) returns to GF-08; keep going west for this route.
20. In UF-03, read Letter IV at (2780,450), bringing the count to three if Letters I and II are collected. The toy-box hide at (2390,570) and station at (2240,495) are available; decorative nursery furniture adds no keys.
21. Cross UF-02 without collecting Sight. The vanity is at (1740,440), its separate key at (1910,480), the under-bed hide at (1420,570), and the station at (1240,495). On Vantree, leave the vanity and Sight Key alone. After Hearing alone, sound is the current enemy sense; do not invent Sight before taking its key.
22. Reach UF-01 and read Letter III at (700,455). You now have all four upper/ground estate letters needed for the conduit. If required, charge at (240,405).
23. Return east through UF-02, UF-03, UF-04, and UF-05 to UF-06. Use the ground-return door at (5560,362) to arrive at GF-09. Do not use a similarly shaped decorative screen as an interaction target.
24. Optional full-map detour before returning: from UF-06 continue east into UF-07. Its station is (6170,495). The vent at (6300,410) returns to GF-08; the vent at (6750,410) goes to BS-02. Neither adds a collectible. A legacy candle table beyond the x=7000 boundary is unreachable and contains no secret. Return via the stairs if following the route exactly.
25. From GF-09, go east to GF-10. Charge at (6650,495) if needed and use the cellar stairs at (6980,362). Arrive in BS-01 at the paired return stair.
26. In BS-01, note the ground-return door at (180,362) and station at (275,430). Continue east. The basement's physical order is **BS-01 → BS-04 → BS-02 → BS-03 → BS-05 → BS-06 → BS-09**. There are no playable BS-07 or BS-08 rooms.
27. Cross the water of BS-04 carefully; WATER steps are loud. The station is (1145,405). The Flood Tunnel at (1500,362) requires exactly two senses and will not accept this one-key Vantree state. Continue east.
28. Pass through BS-02 around the wine-storage footprints. The station is (2310,495), and the vent at (2740,410) leads to UF-07. Decorative bottles and crates cannot replenish the inventory.
29. In BS-03, collect Letter V at (3460,450), Letter VI at (3780,470), and Letter VII at (4120,450). All seven estate letters are now collected. Charge at (3580,495) if required. The sarcophagi in this room are decorative, not registered hiding spots.
30. Cross BS-05 without breaking the ritual ward or taking Memory. The seal at (4720,435) requires Sight, which this route has intentionally left sealed. Station: (4575,405).
31. In BS-06, collect two bottles at (5650,475) and the clock at (6050,475). Use `basement_recharge` at (6240,495) before moving farther if needed.
32. In BS-09, approach the Ritual Conduit at (6900,362) and press E. Hearing only plus at least four letters qualifies; this route has all seven. Select Continue to Part II from the Vantree chapter result. There is no BS-09 charger to search for.

### C. Full Vantree Part II route

33. Arrive in CR-01 with maximum HP 80 and the Vantree Touch branch. The ordinary Hearing, Sight, and Memory senses are dormant in this branch; Touch is the active mutation. Take time to orient without narration or threat. The station at (240,405) restores both HP and flashlight charge.
34. Go east into CR-02. Collect Letter VIII at (1550,465) and the battery at (1880,485). This first forward crossing remains threat-suppressed before CR-03 is visited; the room is not a permanent sanctuary on later returns. Both nave tables are ordinary.
35. Enter CR-03 and establish distance from the Hound. The rubble reduces Touch transmission to 160, compared with 480 on intact floor. The station at (2240,495) can restore resources when the Hound is far enough away; stopping to charge does not cancel Touch.
36. Continue into CR-04. The name carving triggers automatically once. Let the full text display: Custodian, Jailer, Vantree, Els Vantree, and the date centuries old. Do not search the altar for a numeric code or a charger.
37. In CR-05, collect Letter IX at (4170,450), Letter X at (4470,470), and Letter XI at (4770,450). The four marked alcoves are (4110,585), (4400,585), (4690,585), and (4980,585). They can conceal a silhouette but do not make stationary Els immune to Touch.
38. Use the CR-05 station at (4310,495) when separated from the Hound. Collect the two bottles at (5050,470). Proceed east through CR-06 and use the Echo Threshold at (5800,362).
39. Arrive in CE-01 and read Els's branch instruction. The return door at (180,362) leads back to CR-06 if needed; the ordinary tables do not heal. Continue east toward the Sigil Forge.
40. In CE-02, approach the actual cyan station at (1375,405) and restore HP if necessary. Move to the forge at (1680,440) and press E. With HP above 6.4, this deducts 6.4 HP, unlocks R/T, and records resonance 1 of 3.
41. In a clear part of Echoes, press R once. A successful cast costs 6.4 HP and records resonance 2. The circle stays at its cast position for 12 seconds; the Hound must be inside for suppression. Move away from contact and watch the cooldown.
42. Wait for the HUD's 20-second R cooldown to end while maintaining separation, then cast R again for resonance 3. This opens the CE-05 descent. If the Hound approaches within 192 and T is ready, a stun can create space for six seconds at a cost of 16 HP, but it does not add a gate use. Recover HP as needed.
43. Proceed through CE-03. First entry on this branch gives the Deprived One's line, “Els. You have brought your name home.” Collect Letter XII at (2480,450) and Letter XIII at (3020,470). With the preceding route, all thirteen numbered letters are collected.
44. Enter CE-04 and collect the three-clock bundle at (4050,475). If using the alternative gate solution, travel on the rear rubble strip y<470 while more than 96 but no more than 520 units from the Hound, moving above 20 units/second. Count eligible evasion feedback at least two seconds apart. Avoid rug footprints for the RUBBLE check. Three total supported uses open the same door.
45. Enter CE-05. The supply cache at (4580,420) is optional on Vantree: E adds three clocks only if total bottles plus clocks is below three. The marked descent alcove at (4830,575) offers a pause in movement, not Touch immunity.
46. Recover at the cyan station (5235,590) when the approach is clear. Confirm resonance count is at least three and that the finale instructions are understood. Use the Nexus Descent door at (5320,362). This is a one-way transition into Convergence.
47. In LN-CENTER, identify the bell at (900,395), west anchor at (520,500), center anchor at (900,500), east anchor at (1280,500), west screen at (345,580), east screen at (1490,580), and charger at (450,405). The marker at (180,430) confirms the return is closed. Choose one of the final branches in subsection G.

### D. Untouched branch — replace steps 7–32

48. After the shared opening, remain in GF-01 with **zero keys and zero detections**. Reading the note and recovering ordinary supplies are optional; they are not requirements for this route. For the shortest route, do not visit the piano.
49. Press E at the Front Door (180,362) once. This knocks and sets the door-test flag. Press E again. If the state remains zero keys and zero detections, the outcome is Untouched. This is the same Front Door, not the locked introductory exit in GF-00.
50. Choose Continue to Part II. Els has maximum HP 100, and the inventory is raised to at least three each of battery, bottle, and clock. The Hound's three senses remain dormant.
51. Follow steps 33–39 for navigation and optional Roots pickups, applying Untouched rules instead of Touch. Collect Letter VIII, the Roots battery, Letters IX–XI, and the Roots bottles if pursuing every collectible reachable after this route. CR-01 remains safe; the first active encounter is CR-03. Current blind contact is a nonlethal stagger, not an undocumented lethal awakening.
52. At CE-01, read the Q instruction. Continue to CE-02 for its station if charge is low. The forge is Vantree-only; do not search for an alternate key to activate it.
53. Raise charge above 50 seconds and lower the torch to preserve it. In Echoes, press Q three times, allowing each action to finish. Each bottle/clock use adds a resonance. If a battery was selected because charge was below 50, that use did not count; inspect the HUD and use another distraction once the priority condition is cleared.
54. Continue east through CE-03, collecting Letters XII and XIII; this branch does not receive the entity's spoken line. In CE-04, collect the three-clock bundle.
55. If distractions are exhausted before the count reaches three, go to CE-05 and use the cache at (4580,420). When bottles plus clocks total less than three, it adds three clocks. Use enough Q distractions in Echoes to reach three counted uses. A battery still does not count.
56. Recover at the CE-05 station, pass through Nexus Descent, and follow subsection G. Part I letters left above are not required and cannot be retrieved by returning through the one-way chapter outcome; this branch is not the complete thirteen-letter lore route.

### E. Partial Mercy branch — replace the Vantree key decision and exit

57. Follow the shared opening and Vantree steps 7–20. You may collect all the same supplies and letters. Keep at least one lockpick for the vanity.
58. In UF-02, complete three E work actions at (1740,440), waiting 1.1 seconds each. The first spends one pick. Collect Sight at (1910,480). Hearing and Sight are now active; Memory remains sealed. Crouching with the torch lowered and actual line-of-sight cover are now important.
59. Continue west to UF-01 for Letter III if it has not been collected. Return east to UF-06, use the ground-return door, go east to GF-10, and descend to BS-01 exactly as in the Vantree route.
60. The shortest escape crosses east into BS-04 and immediately uses the Flood Tunnel at (1500,362). Exactly two keys qualify. The three basement letters and Root Cellar supplies are optional detours, not gate requirements.
61. For all accessible Part I collectibles before this exit, first continue through BS-02 into BS-03 and collect Letters V, VI, and VII. Pass through BS-05 **without taking Memory**. In BS-06, collect two bottles and the clock and recharge. You can inspect BS-09, but its conduit rejects the two-key state.
62. Return west through BS-05, BS-03, and BS-02 to BS-04. Use the Flood Tunnel. Do not break the final ward out of habit; even if opened, leaving Memory uncollected is essential. Choose Continue after Partial Mercy.
63. In Part II, maximum HP is 100 and the Hound retains Hearing and Sight. Follow the Roots route to collect VIII, the battery, IX–XI, and the bottles. Use real cover and quiet movement. Rubble is quieter than stone, but this branch has no Touch mutation to evade.
64. Enter CE-01 to unlock the partial sigil and receive its instruction. Cast R three times in Echoes, with a 20-second cooldown between casts. Each costs four HP. The circle blocks Hearing while the Hound is inside; it does not block Sight. The Vantree forge and T stun are unavailable.
65. Read Letters XII and XIII in CE-03, with no entity voice event. Collect the three clocks in CE-04 if desired. Gadgets remain usable distractions, but this branch's gate count comes from successful R casts, not Q.
66. Recover at CE-05 once three casts have succeeded, use Nexus Descent, and follow subsection G. With the optional basement detour, this route can also collect all thirteen letters.

### F. Loop branch and second-Loop secret

67. Follow the Partial Mercy route through obtaining Hearing and Sight, but do not leave through the Flood Tunnel. Travel through BS-03, read the warnings, and continue to BS-05.
68. At (4720,435), press E once and allow the 1.25-second cracked-seal action to complete. It consumes no pick. Collect Memory at (5000,480). All three senses are active, and the Hound can use earlier hiding history.
69. Optional completionist supplies: continue to BS-06 for the two bottles, clock, and recharge. BS-09 cannot give Vantree with three keys. Return west through the basement to BS-01. Vary refuges and avoid obvious repeated exits when the Hound is nearby; the all-three-key state is deliberately more dangerous.
70. Use the BS-01 ground stairs (180,362), arriving at GF-10. Travel west across the Ground Floor. Crouch through GF-08, use cover after Sight, and direct distractions away from the intended westward route. Reusing the same hide after Memory is a risk.
71. Reach the Front Door at (180,362) in GF-01 and press E. Three keys produce the Loop. Els recovers in the Grand Foyer; there is no Part II unlock. The Loop counter increases, while ordinary inventory, letters, keys, and hiding history reset. Flashlight ownership survives the reset.
72. **Secret intent:** a second successful repetition would set `vantree_memory_fragment_A`. **Current limitation:** the reset gives zero lockpicks and only the reachable GF-07 spare replaces one; piano and vanity need two. No documented normal route returns to the intro pouch. Therefore the second completion and its proposed memory page are not a currently finishable player-facing secret route. The corrective supply requirement and authored page are specified in Sections 5–6.
73. To reach the final act from a first-Loop recovery without that missing pick supply, the zero-key Untouched Front Door route remains available: test and reuse it with zero detections. Alternatively, the one available spare can start the piano and enable the Hearing-only Vantree route after collecting four letters again. The missing second pick blocks the two-puzzle replay, not every possible continuation from Loop.

### G. Every final ending — choose one after any successful Part I branch

74. Enter Convergence and decide which outcome you want. The return marker is not an exit. If you need resources, use the station at (450,405) when it is safe to do so. The two screens are registered hides, but branch senses can still make care necessary.
75. Move to the golden Ward Bell at (900,395), read its prompt, and press E. Confirm the 32-second ward begins and detection clears. Choose the bell rather than the center anchor, which is at the same x but farther down the floor.
76. **Severance:** go west to LN-A at (520,500). Hold E continuously for 20 seconds. Do not move or release E. Completion destroys the Deprived One and the inherited bond, then shows the Severance result.
77. **Custodian's Rest:** instead choose LN-B at (900,500). Hold E continuously for 20 seconds. Completion makes Els the living ward and shows Custodian's Rest.
78. **Vessel:** instead go east to LN-C at (1280,500). Hold E continuously for 20 seconds. Completion binds the entity into a new key for another hand and shows Vessel.
79. If any channel is interrupted, progress resets. Move to a viable position, wait for the current ward to expire, ring the bell again, and retry the chosen anchor. Do not attempt to assemble three partial channel completions; only one uninterrupted 20-second hold succeeds.
80. To see another final outcome through normal menus, select Begin Again and follow any successful Part I branch back to the Nexus. Untouched is the shortest chapter route. The full Vantree route gives the fullest canon narrative context; it is not a prerequisite for selecting Severance, Custodian's Rest, or Vessel.

### H. Complete pickup and replenishment checklist

This checklist lists every collectible placement separately from the decorative catalog. Match the stable ID if two objects look similar. Optional entries are included even where a branch deliberately leaves them behind.

| Room | Pickup / stable ID | Position | Quantity or state |
| --- | --- | --- | --- |
| GF-00 | Els's dropped flashlight / `flashlight` | (430, 480) | torch ownership; 90 seconds charge |
| GF-00 | Els's tool pouch / `lockpick_tool` | (900, 430) | 3 lockpicks; tool ownership |
| GF-02 | Flashlight Battery / `ground_battery` | (1280, 470) | 1 battery |
| GF-03 | Hearing Key / `hearing_key` | (1960, 478) | hearing restored after its seal |
| GF-03 | Vantree - I / `vantree_01` | (2070, 455) | one numbered letter |
| GF-04 | Glass Bottles x2 / `pantry_bottles` | (2710, 474) | 2 bottle |
| GF-05 | Wind-Up Clock / `side_clock` | (3070, 470) | 1 clock |
| GF-06 | Vantree - II / `vantree_02` | (3850, 460) | one numbered letter |
| GF-07 | Lockpick / `coat_lockpick` | (4870, 470) | 1 lockpick |
| UF-01 | Vantree - III / `vantree_03` | (700, 455) | one numbered letter |
| UF-02 | Sight Key / `sight_key` | (1910, 480) | sight restored after its seal |
| UF-03 | Vantree - IV / `vantree_04` | (2780, 450) | one numbered letter |
| UF-04 | Flashlight Battery / `upper_battery` | (3770, 470) | 1 battery |
| UF-05 | Glass Bottle / `bathroom_bottle` | (4880, 535) | 1 bottle |
| BS-03 | Vantree - V / `vantree_05` | (3460, 450) | one numbered letter |
| BS-03 | Vantree - VI / `vantree_06` | (3780, 470) | one numbered letter |
| BS-03 | Vantree - VII / `vantree_07` | (4120, 450) | one numbered letter |
| BS-05 | Memory Key / `memory_key` | (5000, 480) | memory restored after its seal |
| BS-06 | Glass Bottles x2 / `root_bottles` | (5650, 475) | 2 bottle |
| BS-06 | Wind-Up Clock / `root_clock` | (6050, 475) | 1 clock |
| CR-02 | Vantree - VIII / `vantree_08` | (1550, 465) | one numbered letter |
| CR-02 | Flashlight Battery / `roots_battery` | (1880, 485) | 1 battery |
| CR-05 | Vantree - IX / `vantree_09` | (4170, 450) | one numbered letter |
| CR-05 | Vantree - X / `vantree_10` | (4470, 470) | one numbered letter |
| CR-05 | Vantree - XI / `vantree_11` | (4770, 450) | one numbered letter |
| CR-05 | Glass Bottles x2 / `roots_bottles` | (5050, 470) | 2 bottle |
| CE-03 | Vantree - XII / `vantree_12` | (2480, 450) | one numbered letter |
| CE-03 | Vantree - XIII / `vantree_13` | (3020, 470) | one numbered letter |
| CE-04 | Wind-Up Clock x3 / `echo_clock` | (4050, 475) | 3 clock |

Additional supplies: Untouched's Part II grant raises batteries, bottles, and clocks individually to at least three; it is a branch grant rather than another floor pickup. The CE-05 cache adds three clocks when the combined bottle/clock count falls below three. Stations create neither battery items nor extra lockpicks.

### I. Power-station route reference

Each listed ID is an actual recharge interaction. All other ordinary tables stay ordinary. Coordinates distinguish close table/puzzle targets.

| Room | Station | Position | Function |
| --- | --- | --- | --- |
| GF-00 | `gf_00_charge_1` | (520, 405) | Charge only |
| GF-01 | `gf_01_charge_1` | (275, 430) | Charge only |
| GF-02 | `gf_02_charge_1` | (890, 405) | Charge only |
| GF-03 | `gf_03_charge_1` | (1610, 495) | Charge only |
| GF-04 | `gf_04_charge_1` | (2260, 495) | Charge only |
| GF-05 | `gf_05_charge_1` | (2980, 405) | Charge only |
| GF-06 | `ground_recharge` | (4170, 430) | Charge only |
| GF-07 | `gf_07_charge_1` | (4630, 495) | Charge only |
| GF-09 | `gf_09_charge_1` | (6035, 405) | Charge only |
| GF-10 | `gf_10_charge_1` | (6650, 495) | Charge only |
| UF-01 | `uf_01_charge_1` | (240, 405) | Charge only |
| UF-02 | `uf_02_charge_1` | (1240, 495) | Charge only |
| UF-03 | `uf_03_charge_1` | (2240, 495) | Charge only |
| UF-04 | `uf_04_charge_1` | (3345, 405) | Charge only |
| UF-05 | `upper_recharge` | (4380, 430) | Charge only |
| UF-07 | `uf_07_charge_1` | (6170, 495) | Charge only |
| BS-01 | `bs_01_charge_1` | (275, 430) | Charge only |
| BS-04 | `bs_04_charge_1` | (1145, 405) | Charge only |
| BS-02 | `bs_02_charge_1` | (2310, 495) | Charge only |
| BS-03 | `bs_03_charge_1` | (3580, 495) | Charge only |
| BS-05 | `bs_05_charge_1` | (4575, 405) | Charge only |
| BS-06 | `basement_recharge` | (6240, 495) | Charge only |
| CR-01 | `cr_01_charge_1` | (240, 405) | Charge + HP |
| CR-03 | `cr_03_charge_1` | (2240, 495) | Charge + HP |
| CR-05 | `cr_05_charge_1` | (4310, 495) | Charge + HP |
| CE-02 | `ce_02_charge_1` | (1375, 405) | Charge + HP |
| CE-05 | `ce_05_charge_1` | (5235, 590) | Charge + HP |
| LN-CENTER | `ln_center_charge_1` | (450, 405) | Charge + HP |

### J. Optional discoveries, branches, and production reconciliation

**Optional content available now:** the foyer note and clock interaction; scratched nameplate; all thirteen letters across a sufficiently exploratory Vantree or Partial Mercy run; every listed loose supply; the linked vent shortcuts; the deliberate first Loop; and the alternative Vantree Touch-evasion gate solution. There is no implemented hidden BS-07/BS-08, secret attic, fourth Nexus anchor, collectible newspaper, or achievement system established by the examined data. A room's decorative book or unreachable candle table does not imply a missing quest.

**Specific changes needed before the proposed final content is fully reflected in the executable:**

1. Replace the thirteen short runtime letter strings with the authored complete bodies through a reader that supports paging, while preserving IDs and the four-of-seven gate. Place the canonical apology breadcrumb as part of the proposed final Letter XIII text without inventing a named author.
2. Implement the distinct final ending treatments and accurate LN-A choice copy. Canon says Severance destroys both entity and bond; the current “Free the captive” shorthand can mislead the player about that choice.
3. Resolve the second-Loop lockpick shortage and add an actual presentation for the memory-fragment flag. A concrete minimum is two reachable picks after reset. Retain the Loop counter through that correction.
4. Align visual hints with actual rules: either make the pantry glass/bypass and upper shadow lane mechanically truthful or revise their visual instruction and guide copy. This document's walkthrough uses current code behavior and does not promise protection those strips do not provide.
5. Resolve the introductory “Music Room” label versus its actual GF-01 destination. Rename the label for the existing route or deliberately change the map transition; do not silently describe a different arrival.
6. Remove the out-of-bounds upper candle table and its candle detail, or intentionally relocate them inside a reviewed room layout. Keep purposeful furnishings and distinguish decorative crates, tables, and screens from usable supplies, stations, and hides.
7. If Untouched is meant to offer a lethal lower pursuit, design and document that branch change explicitly. Current code keeps the three senses dormant and stage-zero contact nonlethal. Do not claim such a threat already exists or contradict the seal rules to manufacture it.

These are reviewable design requirements, not gameplay edits performed by this Markdown deliverable. The prior UI, horror-atmosphere, and action-animation work is reflected in the intended presentation language; this document does not claim that every newly authored inspection line or ending shot has been implemented.

### K. Final continuity check

- All 37 room IDs in the current layout are represented; the basement is ordered by actual map position rather than numeric room ID.
- Every manifest gameplay prop, ordinary table, base furniture instance, estate decoration, dressing piece, and nested tabletop component has an object entry. Rugs, generated windows, the dining lights, major floor clues, the remembered contract, and the second-Loop flag are also identified.
- Hearing, Sight, and Memory are restored only in that order by collecting their keys. Opening a seal alone does not silently grant its key.
- Vantree keeps Hearing only and requires four estate letters; Partial Mercy keeps Memory closed; Untouched takes no key; three-key Front Door escape always Loops.
- CR-01 remains narration-free and threat-free; CR-04's carving is automatic once; CE-03's spoken entity line is Vantree-only.
- Echoes requires three successful uses of the current branch mechanic. Partial sigils do not block Sight, full sigils do not prevent contact damage, and T does not count as a gate use.
- Each final route completes one 20-second anchor under a reusable 32-second bell ward. The three final choices retain their canonical consequences.
- Unknown ancestry, entity origin, missing hours, and ritual origin remain unresolved. The expanded first-person pages express uncertainty rather than replacing it with a fabricated definitive history.

**End of final content bible.**

