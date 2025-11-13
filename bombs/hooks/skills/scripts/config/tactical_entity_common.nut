local onApplyFireOld = this.Const.Tactical.Common.onApplyFire;


this.Const.Tactical.Common.onApplyFire = function( _tile, _entity ){
		if (_tile.IsOccupiedByActor){
			_tile.getEntity().checkMorale(-1, -20, this.Const.MoraleCheckType.Default);
		}
		onApplyFireOld(_tile, _entity);
}
