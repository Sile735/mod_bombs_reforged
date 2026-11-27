// Fire (fire bombs, burning ground): anyone standing in fire also has to pass a negative morale check.
// ::Const.Tactical.Common.onApplyFire is a plain function in a config table (not a class), so it is wrapped
// directly instead of using HooksMod.hook.
local onApplyFire = ::Const.Tactical.Common.onApplyFire;
::Const.Tactical.Common.onApplyFire = function( _tile, _entity )
{
	if (_tile.IsOccupiedByActor)
	{
		_tile.getEntity().checkMorale(-1, -20, ::Const.MoraleCheckType.Default);
	}
	onApplyFire(_tile, _entity);
};
