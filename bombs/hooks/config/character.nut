// New character property, set by the Grenadier perk and read by every bomb skill
// (see ::mod_bombs.applyBombSpecialization in bombs/grenadier_helper.nut).
::MSU.Table.merge(::Const.CharacterProperties, {
	IsSpecializedInBombs = false
});
