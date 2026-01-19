this.poison_bomb_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		UsedThisTurn = false
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.poison_bomb";
		this.m.Name = "Poison Bomb";
		this.m.Description = "A pot filled with highly toxic goblin poison that will poison an area when thrown.";
		this.m.IconLarge = "consumables/poison_01.png";
		this.m.Icon = "consumables/poison_01.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "skills/status_effect_66.png";
		this.m.Value = 600;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
		this.m.UsedThisTurn = false;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		result.push({
			id = 64,
			type = "text",
			text = "Worn in Offhand"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] tiles"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Will set [color=" + this.Const.UI.Color.DamageValue + "]7[/color] tiles with poison for 3 rounds"
		});
		if( this.m.Container != null && this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier") && this.m.UsedThisTurn == false){			
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A " + ::MSU.Text.colorPositive("Grenadier") + " character can use this once per combat without destroying it."
			});
		}
		else {
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is destroyed on use"
			});
		}
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_poison_bomb_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

	function onPutIntoBag(){
		local skill = ::new("scripts/skills/actives/rf_sling_poison_bomb_skill_mb");
		skill.setItem(this);
		this.addSkill(skill);
	}

	function onCombatFinished()
	{
		if( this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier"))
		{
			this.m.UsedThisTurn = false;
		};		
	}

	function onCombatStarted()
	{
		if( this.m.Container.getActor().getSkills().hasSkill("perk.rf_grenadier"))
		{
			this.m.UsedThisTurn = false;
		};
	}

});

