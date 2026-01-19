local obj = ::Reforged.InheritHelper.slingItemSkill("throw_holy_water");

local onUse_mod_bombs = function( _user, _targetTile )
{
	if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
	{
		local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;

		if (_user.getTile().getDistanceTo(_targetTile) >= ::Const.Combat.SpawnProjectileMinDist)
		{
			::Tactical.spawnProjectileEffect(::Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		}
	}

	// this.getItem().removeSelf(); // Vanilla unequips the offhand item. But we instead need to consume the respective Item from whereever it is
	
	if (_user.getSkills().hasSkill("perk.rf_grenadier")){
			local item = this.getItem();
		 	if ( item.m.UsedThisTurn ){
		 		this.getItem().removeSelf();
		 	}
		 	else{
		 		::logInfo("first time bomb is used this combat, not consuming it")
		 		item.m.UsedThisTurn = true;
		 	}
		}
		else{
			this.getItem().removeSelf();
		}


	local delayPerDistance = 80.0;
	local tileDistance = _user.getTile().getDistanceTo(_targetTile);	// Vanilla uses a fixed
	::Time.scheduleEvent(::TimeUnit.Real, delayPerDistance * tileDistance, this.onApplyEffect.bindenv(this), {
		Skill = this,
		User = _user,
		TargetTile = _targetTile
	});
};

// Use MSU.Table.merge to overwrite functions so that function names are preserved in stackinfos
local create = obj.create;
::MSU.Table.merge(obj, {
	function create()
	{
		create();
		this.m.Icon = "skills/rf_sling_holy_water_skill.png";
		this.m.IconDisabled = "skills/rf_sling_holy_water_skill_sw.png";
		this.m.Overlay = "rf_sling_holy_water_skill";
	}

	function onUse(_user, _targetTile){		
		onUse_mod_bombs(_user, _targetTile);
	}

});

this.rf_sling_holy_water_skill_mb <- ::inherit("scripts/skills/actives/throw_holy_water", obj);