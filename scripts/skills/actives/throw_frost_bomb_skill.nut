this.throw_frost_bomb_skill <- this.inherit("scripts/skills/skill", {
	m = 
	{
		SnowTiles = []
	},
	function create()
	{
		this.m.ID = "actives.throw_frost_bomb";
		this.m.Name = "Throw Frost Bomb";
		this.m.Description = "Throw a flask of liquid frost towards a target, where it will shatter and spray its contents.";
		this.m.Icon = "skills/active_96.png";
		this.m.IconDisabled = "skills/active_96_sw.png";
		this.m.Overlay = "active_96";
		this.m.SoundOnUse = [
			"sounds/combat/throw_ball_01.wav",
			"sounds/combat/throw_ball_02.wav",
			"sounds/combat/throw_ball_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/ghastly_touch_01.wav"			
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
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
		this.m.ProjectileType = this.Const.ProjectileType.Flask;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;

		for( local i = 1; i <= 3; i = ++i )
		{
			this.m.SnowTiles.push(this.MapGen.get("tactical.tile.snow" + i));
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Freezes the target area and chills enemies for 3 turns"
		});		
		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		local affectedTiles = [];
		affectedTiles.push(_targetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				affectedTiles.push(tile);
			}
		}

		foreach( t in affectedTiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function applyFrost( _target )
	{
		local frost = _target.getSkills().getSkillByID("scripts/skills/effects/chilled_effect");

		if (frost == null)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
		}
		else
		{
			frost.resetTime();
		}

		this.spawnIcon("status_effect_109", _target.getTile());
	}

	function onVerifyTarget( _originTile, _targetTile )
	{	

		return true;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInBombs)
		{
			local weapon = this.getContainer().getActor().getMainhandItem();
			if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
			{
				this.m.MinRange = weapon.getRangeMin();
				this.m.MaxRange = weapon.getRangeMax() + (_properties.IsSpecializedInBombs ? 1 : 0);;
			} else {
				this.m.MaxRange = this.m.Item.getRangeMax() + (_properties.IsSpecializedInBombs ? 1 : 0);	
			}
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
			this.m.ActionPointCost = 4;
		}
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;

			if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		if (_user.getSkills().hasSkill("perk.rf_grenadier")){
			local item = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		 	if ( item.m.UsedThisTurn ){
		 		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		 	}
		 	else{
		 		::logInfo("first time bomb is used this combat, not consuming it")
		 		item.m.UsedThisTurn = true;
		 	}
		}
		else{
			_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));	
		}
		this.Time.scheduleEvent(this.TimeUnit.Real, 200, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile
		});
	}

	function onApply( _data )
	{	

		local targets = [];
		targets.push(_data.TargetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_data.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _data.TargetTile.getNextTile(i);
				targets.push(tile);
			}
		}

		foreach (nextTile in targets){
			if (nextTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && nextTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, function ( _data )
					{
						_data.Tile.clear();
						_data.Tile.Type = 0;
						_data.Skill.m.SnowTiles[this.Math.rand(0, _data.Skill.m.SnowTiles.len() - 1)].onFirstPass({
							X = _data.Tile.SquareCoords.X,
							Y = _data.Tile.SquareCoords.Y,
							W = 1,
							H = 1,
							IsEmpty = true,
							SpawnObjects = false
						});
					}, {
						Tile = nextTile,
						Skill = this
					});
				}
		}

		if (_data.Skill.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(_data.Skill.m.SoundOnHit[this.Math.rand(0, _data.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _data.TargetTile.Pos);
		}
	

		foreach( tile in targets ){
			if (tile.IsOccupiedByActor){
					_data.Skill.applyFrost(tile.getEntity());
			}	
		}	
	}

});

