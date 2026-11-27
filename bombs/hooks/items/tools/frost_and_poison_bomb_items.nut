// Frost Bomb and Poison Bomb (new items of this mod): Grenadier free use (see bombs/grenadier_helper.nut).
::mod_bombs.Grenadier.hookBombItem("scripts/items/tools/frost_bomb_item");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/throw_frost_bomb_skill");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/rf_sling_frost_bomb_skill_mb");

::mod_bombs.Grenadier.hookBombItem("scripts/items/tools/poison_bomb_item");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/throw_poison_bomb_skill");
::mod_bombs.Grenadier.hookBombSkill("scripts/skills/actives/rf_sling_poison_bomb_skill_mb");
