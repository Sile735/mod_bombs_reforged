::mod_bombs.HooksMod.hook("scripts/items/tools/fire_bomb_item", function(q) {
	
	q.onEquip = @(__original) function(){
		__original();
		local skill = this.getContainer().getActor().getSkills().getSkillByID("actives.throw_fire_bomb");
		skill.m.FreeCounter++;		
	}

	q.onUnequip = @(__original) function(){
		local skill = this.getContainer().getActor().getSkills().getSkillByID("actives.throw_fire_bomb");
		skill.m.FreeCounter--;
		__original();
	}

	q.onPutIntoBag = @() { function onPutIntoBag()
	{	
  		this.addSkill(::new("scripts/skills/actives/rf_sling_fire_bomb_skill_mb"));  		
  		this.getContainer().getActor().getSkills().getSkillByID("actives.sling_fire_bomb").m.FreeCounter++;
	}}.onPutIntoBag;

	q.onRemovedFromBag = @(__original) function()
	{
		local skill = this.getContainer().getActor().getSkills().getSkillByID("actives.sling_fire_bomb");						
		if(skill != null && skill.m.FreeCounter>0){
			skill.m.FreeCounter--;
		}		
		__original();
	}

	q.onCombatFinished = @(__original) function()
	{
		if( this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier")){
			
			local skill = this.getContainer().getActor().getSkills().getSkillByID("actives.sling_fire_bomb");
			if (skill != null){
				skill.m.FreeCounter = 0;
			}

			local skill = this.getContainer().getActor().getSkills().getSkillByID("actives.throw_fire_bomb");
			if (skill != null){
				skill.m.FreeCounter = 0;
			}

		};
		return __original();
	}

	q.onCombatStarted = @(__original) function()
	{	
		return __original();
	}

	q.getTooltip = @(__original) function()
	{
		local tooltip = __original();

		if( this.m.Container != null && this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier")){
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
