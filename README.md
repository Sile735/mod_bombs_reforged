# Bombs Reforged

A **Battle Brothers** mod for **[Reforged](https://github.com/Battle-Modders/mod-reforged)**.
The weaker bombs and flasks are reworked into stronger, more useful versions, two new bombs are added,
and the new **Grenadier** perk turns a brother into a bomb specialist. Everything also works when slinging bombs with Reforged's slings.

---

## Reworked Bombs

| Bomb | Change |
|---|---|
| **Acid Flask** | Splashes a **7-tile area** (the target and all 6 neighbours), like the Fire Bomb |
| **Flask of Blessed Water** (Holy Water) | Splashes a **7-tile area**. Craft more of them with [Crafting Expansion Reforged](https://github.com/Sile735/mod_crafting_expansion_reforged) |
| **Fire Bomb** | Burning ground also triggers a **negative morale check** (-20 Resolve) on whoever stands in it – your own brothers too, don't stand in the fire! A target that takes all 3 burn ticks may rout. |

## New Bombs

| Bomb | Effect | Crafting (Taxidermist) |
|---|---|---|
| **Poison Bomb** | Poisons everyone in a **7-tile area** with Goblin and Spider poison (fewer Action Points and less Vision for 3 turns). Undead and poison-immune targets are not affected. | 2x Goblin Poison – 50 crowns |
| **Frost Bomb** | **Chills** everyone in a **7-tile area** (-2 to -4 Action Points, -30 to -70 Initiative, weakening each turn) and covers the area in **snow**, slowing movement | 1x Thick White Fur, 1x Unusually Large Wolf Pelt – 50 crowns |

Both can be thrown from the offhand or slung from the bag with a sling, like vanilla bombs under Reforged.

## New Perk: Grenadier

*Throwing perk group, tier 7*
- **+1 range** for all bombs and flasks (thrown and slung)
- Bombs cost **25% less Fatigue**
- The **first use of each bomb in each battle does not consume it** – every bomb item gets its own free use, refreshed every battle. The tooltips show whether the free use is still available.

---

## Requirements

- Reforged **0.9+** (with its requirements: MSU, Modern Hooks, Dynamic Perks, Stack Based Skills, …)

## Installation

Download the zip from the latest [release](../../releases) and put it (unextracted) into the game's `data` folder.
The mod is **safe to add to an existing savegame**.

---

## Changelog

**0.5.0**
- Grenadier rework: the free use is tracked per bomb and refreshes every battle (the old counter did not refresh for equipped bombs and could go negative)
- Throwing Mastery reduces the Fatigue cost of bombs again
- Poison Bomb: now poisons unarmored targets (it wrongly used the Acid Flask's armor checks), respects poison immunity, own icons (Frost Bomb flask with green poison) and a sprite on the character holding it
- Frost Bomb: chill refreshes correctly; its recipe no longer shares the Poison Bomb recipe's ID
- Reforged's sling skills are used again for vanilla bombs
- Fixed: the mod loaded *before* Reforged instead of after it
- In-game update notifications via MSU, code cleanup and comments

**0.4.x**
- Charge-based Grenadier, sling support for the new bombs, fixes

**Earlier versions**
- Acid Flask / Holy Water area of effect, Fire Bomb morale check, Poison Bomb, Frost Bomb, Grenadier perk
