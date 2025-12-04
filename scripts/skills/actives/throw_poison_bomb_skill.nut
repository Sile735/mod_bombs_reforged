this.throw_poison_bomb_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.throw_poison_bomb";
		this.m.Name = "Throw Poison Bomb";
		this.m.Description = "Throw a flask of poison towards a target, where it will shatter and spray its contents.";
		this.m.Icon = "skills/active_95.png";
		this.m.IconDisabled = "skills/active_95_sw.png";
		this.m.Overlay = "active_95";
		this.m.SoundOnUse = [
			"sounds/combat/throw_ball_01.wav",
			"sounds/combat/throw_ball_02.wav",
			"sounds/combat/throw_ball_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/acid_flask_impact_01.wav",
			"sounds/combat/acid_flask_impact_02.wav",
			"sounds/combat/acid_flask_impact_03.wav",
			"sounds/combat/acid_flask_impact_04.wav"
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
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the target\'s AP and Vision for 3 Turn"
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

	function applyPoison( _target )
	{
		if (_target.getFlags().has("lindwurm"))
		{
			return;
		}

		if ((_target.getFlags().has("body_immune_to_acid") || _target.getArmor(this.Const.BodyPart.Body) <= 0) && (_target.getFlags().has("head_immune_to_acid") || _target.getArmor(this.Const.BodyPart.Head) <= 0))
		{
			return;
		}

		local poison = _target.getSkills().getSkillByID("effects.goblin_poison_effect");
		local poison2 = _target.getSkills().getSkillByID("effects.spider_poison_effect");

		if (poison == null)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/goblin_poison_effect"));
			_target.getSkills().add(this.new("scripts/skills/effects/spider_poison_effect"));			
		else
		{
			poison.resetTime();
			poison2.resetTime();
		}

		this.spawnIcon("status_effect_54", _target.getTile());
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
			local chance = _user.getSkills().getAllSkillsByID("perk.rf_grenadier")[0].getChance();
		 	if(this.Math.rand(1, 100) > chance){		 				
		 		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));	
		 	}
		 	else{		 
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

		if (_data.Skill.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(_data.Skill.m.SoundOnHit[this.Math.rand(0, _data.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _data.TargetTile.Pos);
		}
	

		foreach( tile in targets ){
			if (tile.IsOccupiedByActor){
					_data.Skill.applyPoison(tile.getEntity());
			}	
		}	
	}

});

