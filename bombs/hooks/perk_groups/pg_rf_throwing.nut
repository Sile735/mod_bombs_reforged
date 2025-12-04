::mod_bombs.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_throwing", function(q) {
	q.create = @() function()
	{
		this.m.ID = "pg.rf_throwing";
		this.m.Name = "Throwing";
		this.m.Icon = "ui/perk_groups/rf_throwing.png";
		this.m.Tree = [
			[],
			[],
			["perk.rf_hybridization"],
			["perk.mastery.throwing"],
			["perk.rf_opportunist"],
			[],
			["perk.rf_grenadier"]
		];		
	}
});