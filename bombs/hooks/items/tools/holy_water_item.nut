::Reforged.HooksMod.hook("scripts/items/tools/holy_water_item", function(q) {
	q.onPutIntoBag = @() { function onPutIntoBag()
	{
		local skill = ::new("scripts/skills/actives/rf_sling_holy_water_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}}.onPutIntoBag;
});
