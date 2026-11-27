// Grenadier: specialization in bombs and flasks.
// The perk only sets IsSpecializedInBombs; the actual effects live in bombs/grenadier_helper.nut:
//  - +1 range and reduced fatigue for every bomb skill (::mod_bombs.applyBombSpecialization)
//  - the first use of each bomb per combat does not consume it (::mod_bombs.Grenadier)
this.perk_rf_grenadier <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_grenadier";
		this.m.Name = ::Const.Strings.PerkName.RF_Grenadier;
		this.m.Description = ::Const.Strings.PerkDescription.RF_Grenadier;
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInBombs = true;
	}
});
