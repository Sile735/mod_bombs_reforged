// Throw Daze Bomb: Grenadier / bomb specialization support.
// Thrown and slung versions both inherit these functions.
::mod_bombs.HooksMod.hook("scripts/skills/actives/throw_daze_bomb_skill", function(q) {
	// +1 range, reduced fatigue and sling range when specialized in bombs (see bombs/grenadier_helper.nut)
	q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
	{
		__original(_properties);
		::mod_bombs.applyBombSpecialization(this, _properties);
	}}.onAfterUpdate;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		::mod_bombs.Grenadier.addSkillTooltip(this, ret);
		return ret;
	}}.getTooltip;
});
