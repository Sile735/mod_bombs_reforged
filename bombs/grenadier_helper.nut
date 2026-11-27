// =====================================================================================================
// Shared bomb logic for Bombs Reforged
// =====================================================================================================
//
// 1) Grenadier free use
//    Perk text: "The first use of each of your Bombs in each combat does not consume the bomb item".
//
//    How it works:
//    - Every bomb item carries two flags (added in hookBombItem below):
//        MB_IsFreeUseSpent  - true once this item's free use was used in the current combat
//        MB_SkipNextConsume - set only for the duration of one onUse call
//    - Right before a bomb skill runs its normal onUse, beginUse() checks Grenadier + the item flag.
//      If the use is free, it marks the item with MB_SkipNextConsume.
//    - Vanilla consumes a thrown bomb via item_container.unequip(offhandItem) and Reforged consumes a
//      slung bomb via item.removeSelf(). Both are hooked to skip exactly one consume for a marked item.
//    - endUse() always clears the marker again, so no other unequip/removeSelf is ever affected.
//    This way the vanilla / Reforged onUse code is reused as-is instead of being copy-pasted per bomb,
//    and the free use is tracked per bomb item (two fire bombs = two free uses).
//
// 2) Bomb specialization (IsSpecializedInBombs, granted by Grenadier)
//    +1 range, weapon-mastery fatigue multiplier, and sling range when a sling is in the main hand.
// =====================================================================================================

::mod_bombs.Grenadier <- {
	PerkID = "perk.rf_grenadier",

	function hasPerk( _actor )
	{
		return !::MSU.isNull(_actor) && _actor.getSkills().hasSkill(this.PerkID);
	}

	// True if _item still has its free use for this combat and its owner has Grenadier
	function isFreeUseAvailable( _item )
	{
		if (::MSU.isNull(_item) || !("MB_IsFreeUseSpent" in _item.m) || _item.m.MB_IsFreeUseSpent)
			return false;

		local container = _item.getContainer();
		return container != null && this.hasPerk(container.getActor());
	}

	// Call right before the original onUse of a bomb skill
	function beginUse( _skill )
	{
		local item = _skill.getItem();
		if (!this.isFreeUseAvailable(item))
			return;

		item.m.MB_IsFreeUseSpent = true;
		item.m.MB_SkipNextConsume = true;
	}

	// Call right after the original onUse of a bomb skill
	function endUse( _skill )
	{
		local item = _skill.getItem();
		if (!::MSU.isNull(item) && ("MB_SkipNextConsume" in item.m))
			item.m.MB_SkipNextConsume = false;
	}

	// Used by the unequip / removeSelf hooks: returns true (once) if this consume must be skipped
	function consumeSkipFlag( _item )
	{
		if (_item == null || _item == -1)
			return false;
		if (::MSU.isNull(_item) || !("MB_SkipNextConsume" in _item.m) || !_item.m.MB_SkipNextConsume)
			return false;

		_item.m.MB_SkipNextConsume = false;
		return true;
	}

	// Item tooltip: replace vanilla's "Is destroyed on use" line (id 6) while the free use is available
	function updateItemTooltip( _item, _tooltip )
	{
		if (!this.isFreeUseAvailable(_item))
			return;

		local entry = {
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "A " + ::MSU.Text.colorPositive("Grenadier") + " can use this once per combat without destroying it"
		};

		foreach (i, line in _tooltip)
		{
			if (line.id == 6)
			{
				_tooltip[i] = entry;
				return;
			}
		}
		_tooltip.push(entry);
	}

	// Skill tooltip: show whether the free use of this bomb is still available (Grenadier only)
	function addSkillTooltip( _skill, _tooltip )
	{
		local item = _skill.getItem();
		if (::MSU.isNull(item) || !this.hasPerk(_skill.getContainer().getActor()))
			return;

		_tooltip.push({
			id = 100,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Grenadier free use: " + (this.isFreeUseAvailable(item) ? ::MSU.Text.colorPositive("available") : ::MSU.Text.colorNegative("spent"))
		});
	}

	// Adds the Grenadier flags and callbacks to a bomb item script
	function hookBombItem( _script )
	{
		::mod_bombs.HooksMod.hook(_script, function(q) {
			q.m.MB_IsFreeUseSpent <- false;
			q.m.MB_SkipNextConsume <- false;

			// Reforged consumes slung bombs with removeSelf()
			q.removeSelf = @(__original) { function removeSelf()
			{
				if (::mod_bombs.Grenadier.consumeSkipFlag(this))
					return;
				__original();
			}}.removeSelf;

			// The free use refreshes every combat
			q.onCombatStarted = @(__original) { function onCombatStarted()
			{
				__original();
				this.m.MB_IsFreeUseSpent = false;
			}}.onCombatStarted;

			q.onCombatFinished = @(__original) { function onCombatFinished()
			{
				__original();
				this.m.MB_IsFreeUseSpent = false;
			}}.onCombatFinished;

			q.getTooltip = @(__original) { function getTooltip()
			{
				local ret = __original();
				::mod_bombs.Grenadier.updateItemTooltip(this, ret);
				return ret;
			}}.getTooltip;
		});
	}

	// Wraps onUse of a bomb skill (thrown or slung) with beginUse / endUse
	function hookBombSkill( _script )
	{
		::mod_bombs.HooksMod.hook(_script, function(q) {
			q.onUse = @(__original) { function onUse( _user, _targetTile )
			{
				::mod_bombs.Grenadier.beginUse(this);
				local ret = __original(_user, _targetTile);
				::mod_bombs.Grenadier.endUse(this);
				return ret;
			}}.onUse;
		});
	}
};

// Bomb specialization: call from onAfterUpdate of every bomb skill (after __original)
::mod_bombs.applyBombSpecialization <- function( _skill, _properties )
{
	if (!_properties.IsSpecializedInBombs)
		return;

	local weapon = _skill.getContainer().getActor().getMainhandItem();
	if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
	{
		// With a sling in hand, bombs use the sling's range
		_skill.m.MinRange = weapon.getRangeMin();
		_skill.m.MaxRange = weapon.getRangeMax() + 1;
	}
	else
	{
		// MaxRange is reset to its base value by MSU before every update, so +1 does not stack
		_skill.m.MaxRange += 1;
	}
	_skill.m.FatigueCostMult = ::Const.Combat.WeaponSpecFatigueMult;
};
