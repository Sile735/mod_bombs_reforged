::mod_bombs.HooksMod.hook("scripts/skills/actives/throw_acid_flask", function(q) {
	q.m.FreeCounter <- 0;	
	q.onTargetSelected = @(__original) function( _targetTile )
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

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return true;
	}

	q.onApplyAcid = @(__original) function( _data )
	{
		local targetEntity = _data.TargetTile.getEntity();

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

		//_data.Skill.applyEffect(targetEntity);

		foreach( tile in targets ){
			if (tile.IsOccupiedByActor){
					_data.Skill.applyAcid(tile.getEntity());
			}	
		}			
		
	}

	q.onUse = @(__original) function( _user, _targetTile ){

		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;

			if (_user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		if (_user.getSkills().hasSkill("perk.rf_grenadier")){		 	
		 	if ( this.m.FreeCounter == 0 ){
		 		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		 	}
		 	else{		 		
		 		this.m.FreeCounter--;
		 	}
	 	}		 	
		else{
			_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));	
		};
		
		this.Time.scheduleEvent(this.TimeUnit.Real, 200, this.onApplyAcid.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile
		});
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		if (_properties.IsSpecializedInBombs)
		{
			local weapon = this.getContainer().getActor().getMainhandItem();
			if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
			{
				this.m.MinRange = weapon.getRangeMin();
				this.m.MaxRange = weapon.getRangeMax() + (_properties.IsSpecializedInBombs ? 1 : 0);;
			} else {
				this.m.MaxRange = this.m.MaxRange + (_properties.IsSpecializedInBombs ? 1 : 0);	
			}
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
			// this.m.ActionPointCost = 4;
		}
	}

	q.getTooltip = @(__original) function()
	{
		local tooltip = __original();

		tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Free Charges Remaining: " + (this.m.FreeCounter>0 ? ::MSU.Text.colorPositive(this.m.FreeCounter) : ::MSU.Text.colorNegative(this.m.FreeCounter))
			});

		return tooltip;
	}
	
})