::mod_bombs.HooksMod.hook("scripts/items/tools/fire_bomb_item", function(q) {
	q.m.UsedThisTurn <- false;
	q.onPutIntoBag = @() { function onPutIntoBag()
	{
		local skill = ::new("scripts/skills/actives/rf_sling_fire_bomb_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}}.onPutIntoBag;

	q.onCombatFinished = @(__original) function()
	{
		if( this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier")){
			this.m.UsedThisTurn = false;
		};
		return __original();
	}

	q.onCombatStarted = @(__original) function()
	{
		if( this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier")){
			this.m.UsedThisTurn = false;
		};
		return __original();
	}

	q.getTooltip = @(__original) function()
	{
		local tooltip = __original();

		if( this.m.Container != null && this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier") && this.m.UsedThisTurn == false){
			for (local i = 0; i < tooltip.len(); ++i)
			{
    			if (tooltip[i].id == 6)
    			{
        			tooltip.remove(i);
        			break;
    			}
			}

			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A " + ::MSU.Text.colorPositive("Grenadier") + " character can use this once per combat without destroying it."
			})
		}

		return tooltip;
	}
});
