// Base class for the bomb items added by this mod (Frost Bomb, Poison Bomb).
// Works like a vanilla bomb: equipped in the offhand it grants the throw skill, carried in the bag it grants
// the sling skill (usable with a sling in the main hand, same as Reforged's slung bombs).
// Child classes set the item data in create() plus:
//   m.ThrowSkill  - script of the skill granted while equipped
//   m.SlingSkill  - script of the skill granted while in the bag
//   m.EffectText  - tooltip line describing the effect
// Grenadier's free use is added by a hook (bombs/hooks/items/tools/frost_and_poison_bomb_items.nut).
this.mb_bomb_item <- ::inherit("scripts/items/weapons/weapon", {
	m = {
		ThrowSkill = null,
		SlingSkill = null,
		EffectText = "",
		InventorySound = "sounds/bottle_01.wav"
	},
	function create()
	{
		this.weapon.create();
		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 600;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
	}

	// Same layout as the vanilla bomb tooltips
	function getTooltip()
	{
		local ret = [
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
			ret.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			ret.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		ret.extend([
			{
				id = 66,
				type = "text",
				text = this.getValueString()
			},
			{
				id = 64,
				type = "text",
				text = "Worn in Offhand"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Range of " + ::MSU.Text.colorPositive(this.m.RangeMax) + " tiles"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = this.m.EffectText
			},
			{
				// Replaced by the Grenadier text while the free use is available (bombs/grenadier_helper.nut)
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is destroyed on use"
			}
		]);

		return ret;
	}

	function playInventorySound( _eventType )
	{
		::Sound.play(this.m.InventorySound, ::Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new(this.m.ThrowSkill));
	}

	function onPutIntoBag()
	{
		this.addSkill(::new(this.m.SlingSkill));
	}
});
