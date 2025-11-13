::mod_bombs.HooksMod.hook("scripts/items/tools/acid_flask_item", function(q) {
	q.onPutIntoBag = @() { function onPutIntoBag()
	{
		local skill = ::new("scripts/skills/actives/rf_sling_acid_flask_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}}.onPutIntoBag;
});
