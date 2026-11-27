// Base class for the area bombs added by this mod (Frost Bomb, Poison Bomb).
// Thrown from the offhand like vanilla bombs; hits the target tile plus the 6 surrounding tiles.
// Child classes fill in create() and implement applyToTarget( _target ) and optionally applyToTile( _tile ).
this.mb_aoe_bomb_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.SoundOnUse = [
			"sounds/combat/throw_ball_01.wav",
			"sounds/combat/throw_ball_02.wav",
			"sounds/combat/throw_ball_03.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsOffensiveToolSkill = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = ::Const.ProjectileType.Flask;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;
	}

	// Override in child classes: effect on an actor standing in the area
	function applyToTarget( _target )
	{
	}

	// Override in child classes: effect on every tile of the area (occupied or not)
	function applyToTile( _tile )
	{
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		::mod_bombs.Grenadier.addSkillTooltip(this, ret);
		return ret;
	}

	// Target tile plus all existing neighbours
	function getAffectedTiles( _targetTile )
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
	function onTargetSelected( _targetTile )
	{
		foreach (t in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	// Any tile in range is a valid target, it does not need to contain an enemy
	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onAfterUpdate( _properties )
	{
		// Same as vanilla bombs: Throwing Mastery reduces the fatigue cost
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
		// Grenadier: +1 range, reduced fatigue, sling range (see bombs/grenadier_helper.nut)
		::mod_bombs.applyBombSpecialization(this, _properties);
	}

	// Same as vanilla bombs: consumes the offhand item (Grenadier may skip that, see bombs/grenadier_helper.nut)
	function onUse( _user, _targetTile )
	{
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
			if (_user.getTile().getDistanceTo(_targetTile) >= ::Const.Combat.SpawnProjectileMinDist)
			{
				::Tactical.spawnProjectileEffect(::Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		_user.getItems().unequip(_user.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));

		::Time.scheduleEvent(::TimeUnit.Real, 200, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile
		});
		return true;
	}

	// Scheduled by onUse once the projectile lands (the sling version schedules it too)
	function onApply( _data )
	{
		local skill = _data.Skill;
		if (skill.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(skill.m.SoundOnHit), ::Const.Sound.Volume.Skill, _data.TargetTile.Pos);
		}

		foreach (tile in skill.getAffectedTiles(_data.TargetTile))
		{
			skill.applyToTile(tile);
			if (tile.IsOccupiedByActor)
				skill.applyToTarget(tile.getEntity());
		}
	}
});
