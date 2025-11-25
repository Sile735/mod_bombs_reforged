this.perk_rf_grenadier <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_grenadier";
		this.m.Name = "Grenadier";
		this.m.Description = "Grenadier";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;		
	}

	function getChance()
	{
		return 75;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInBombs = true;
	}
});
