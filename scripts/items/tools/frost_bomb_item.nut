// Frost Bomb: chills an area of 7 tiles and covers it in snow (base: mb_bomb_item).
this.frost_bomb_item <- ::inherit("scripts/items/tools/mb_bomb_item", {
	m = {},
	function create()
	{
		this.mb_bomb_item.create();
		this.m.ID = "weapon.frost_bomb";
		this.m.Name = "Frost Bomb";
		this.m.Description = "A pot filled with highly liquid frost that will chill an area when thrown.";
		this.m.IconLarge = "tools/frost_bomb_01.png";
		this.m.Icon = "tools/frost_bomb_01_70x70.png";
		this.m.ArmamentIcon = "icon_frost_bomb_01";
		this.m.ThrowSkill = "scripts/skills/actives/throw_frost_bomb_skill";
		this.m.SlingSkill = "scripts/skills/actives/rf_sling_frost_bomb_skill_mb";
		this.m.EffectText = "Will cover " + ::MSU.Text.colorDamage("7") + " tiles with frost and chill everyone in them for 3 rounds";
	}
});
