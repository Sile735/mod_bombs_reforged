::mod_bombs.HooksMod.hook("scripts/skills/actives/throw_smoke_bomb_skill", function(q) {
	q.m.FreeCounter <- 0;

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
		 	local item = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		 	if ( this.m.FreeCounter == 0 ){
		 		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		 	}
		 	else{		 		
		 		this.m.FreeCounter--;
		 	}
		}
		 	
		else{
			_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));	
		}
		
		this.Time.scheduleEvent(this.TimeUnit.Real, 250, this.onApply.bindenv(this), {
			Skill = this,
			User = _user,
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