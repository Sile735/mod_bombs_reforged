// Grenadier perk: name, UPD description and registration with Dynamic Perks.
::MSU.Table.merge(::Const.Strings.PerkName, {
	RF_Grenadier = "Grenadier"
});

::MSU.Table.merge(::Const.Strings.PerkDescription, {
	RF_Grenadier = ::UPD.getDescription({
		Fluff = "This brother is very versed with Bombs and Explosives of all Kinds.",
		Effects = [
			{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Increases the range of your Throw Bomb or Flask by " + ::MSU.Text.colorPositive("+1") + ".",
					"The fatigue cost of your Throw Bomb or Flask are reduced by " + ::MSU.Text.colorPositive("25%") + ".",
					"The first use of each of your Bombs in each combat does not consume the bomb item."
				]
			}
		]
	})
});

::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.rf_grenadier",
		Script = "scripts/skills/perks/perk_rf_grenadier",
		Name = ::Const.Strings.PerkName.RF_Grenadier,
		Tooltip = ::Const.Strings.PerkDescription.RF_Grenadier,
		Icon = "ui/perks/perk_32.png",
		IconDisabled = "ui/perks/perk_32_sw.png"
	}
]);
