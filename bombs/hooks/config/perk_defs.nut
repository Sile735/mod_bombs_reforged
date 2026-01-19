::MSU.Table.merge(::Const.Strings.PerkName, {
	RF_Grenadier = "Grenadier"
});

::MSU.Table.merge( ::Const.Strings.PerkDescription, {
	RF_Grenadier = ::UPD.getDescription({
		Fluff = "This brother is very versed with Bombs and Explosives of all Kinds.",		
		Effects = [
			{
				Type = ::UPD.EffectType.Passive,
				Description = [
					// "Throwing a Bomb or Flask costs [color=" + this.Const.UI.Color.PositiveValue + "]1ap[/color] less to use.",
					"Increases the range of your Throw Bomb or Flask by [color=" + this.Const.UI.Color.PositiveValue + "]+1[/color].",
					"The fatigue cost of your Throw Bomb or Flask are reduced by [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color].",
					"The first time use of each of your Bombs in each combat, does not consume the bomb item",					
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