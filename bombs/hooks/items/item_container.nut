// Vanilla consumes a thrown bomb by unequipping it from the offhand.
// Skip that single unequip while a Grenadier free use is in progress (see bombs/grenadier_helper.nut).
::mod_bombs.HooksMod.hook("scripts/items/item_container", function(q) {
	q.unequip = @(__original) { function unequip( _item )
	{
		if (::mod_bombs.Grenadier.consumeSkipFlag(_item))
			return false;
		return __original(_item);
	}}.unequip;
});
