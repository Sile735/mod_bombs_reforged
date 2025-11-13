::Reforged.HooksMod.hook("scripts/items/tools/fire_bomb_item", function(q) {
	q.onPutIntoBag = @() { function onPutIntoBag()
	{
		local skill = ::new("scripts/skills/actives/rf_sling_fire_bomb_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}}.onPutIntoBag;
});
