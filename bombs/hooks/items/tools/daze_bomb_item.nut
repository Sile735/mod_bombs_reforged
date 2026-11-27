// Daze Bomb: Grenadier free use (see bombs/grenadier_helper.nut).
// Covers the item itself, the skill to throw it from the offhand and Reforged's skill to sling it from the bag.
// Reforged's own onPutIntoBag (which adds the sling skill) is kept as-is.
::mod_bombs.Grenadier.hookBombItem("scripts/items/tools/daze_bomb_item");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/throw_daze_bomb_skill");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/rf_sling_daze_bomb_skill");
