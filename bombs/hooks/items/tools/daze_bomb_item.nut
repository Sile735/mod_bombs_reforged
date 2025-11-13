::mod_bombs.HooksMod.hook("scripts/items/tools/daze_bomb_item", function(q) {
	q.onPutIntoBag = @() { function onPutIntoBag()
	{
		local skill = ::new("scripts/skills/actives/rf_sling_daze_bomb_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}}.onPutIntoBag;
});
