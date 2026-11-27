// Poison Bomb: poisons everyone in an area of 7 tiles (base: mb_bomb_item).
this.poison_bomb_item <- ::inherit("scripts/items/tools/mb_bomb_item", {
	m = {},
	function create()
	{
		this.mb_bomb_item.create();
		this.m.ID = "weapon.poison_bomb";
		this.m.Name = "Poison Bomb";
		this.m.Description = "A pot filled with highly toxic goblin poison that will poison an area when thrown.";
		// Art: the Frost Bomb flask with green poison inside (gfx/ui/items/tools/poison_bomb_01*.png)
		this.m.IconLarge = "tools/poison_bomb_01.png";
		this.m.Icon = "tools/poison_bomb_01_70x70.png";
		// Sprite shown on the character holding it (brushes/ok_bombs.brush); the old value was a file path, not a sprite
		this.m.ArmamentIcon = "icon_poison_bomb_01";
		this.m.ThrowSkill = "scripts/skills/actives/throw_poison_bomb_skill";
		this.m.SlingSkill = "scripts/skills/actives/rf_sling_poison_bomb_skill_mb";
		this.m.EffectText = "Will poison everyone in " + ::MSU.Text.colorDamage("7") + " tiles for 3 rounds";
	}
});
