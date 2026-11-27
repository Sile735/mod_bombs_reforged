// Throw Holy Water: splashes the target tile AND the 6 surrounding tiles (vanilla: target tile only),
// can target any tile (also empty ones), plus Grenadier / bomb specialization support.
::mod_bombs.HooksMod.hook("scripts/skills/actives/throw_holy_water", function(q) {
	// Returns the target tile plus all existing neighbours
	q.mb_getAffectedTiles <- function( _targetTile )
	{
		local ret = [_targetTile];
		for (local i = 0; i < 6; i++)
		{
			if (_targetTile.hasNextTile(i))
				ret.push(_targetTile.getNextTile(i));
		}
		return ret;
	}

	// Highlight the whole area while aiming
	q.onTargetSelected = @() { function onTargetSelected( _targetTile )
	{
		foreach (t in this.mb_getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}}.onTargetSelected;

	// Any tile in range is a valid target, it does not need to contain an enemy
	q.onVerifyTarget = @() { function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}}.onVerifyTarget;

	// Scheduled by vanilla onUse after the projectile lands
	q.onApplyEffect = @() { function onApplyEffect( _data )
	{
		local skill = _data.Skill;
		if (skill.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(skill.m.SoundOnHit), ::Const.Sound.Volume.Skill, _data.TargetTile.Pos);
		}

		foreach (tile in skill.mb_getAffectedTiles(_data.TargetTile))
		{
			if (tile.IsOccupiedByActor)
				skill.applyEffect(tile.getEntity());
		}
	}}.onApplyEffect;

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
