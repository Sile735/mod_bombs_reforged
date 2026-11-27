// Throw Frost Bomb: covers 7 tiles with snow and chills everyone standing there (base: mb_aoe_bomb_skill).
this.throw_frost_bomb_skill <- ::inherit("scripts/skills/actives/mb_aoe_bomb_skill", {
	m = {
		SnowTiles = null	// snow tile generators; created per instance in create() so the array is not shared
	},
	function create()
	{
		this.mb_aoe_bomb_skill.create();
		this.m.ID = "actives.throw_frost_bomb";
		this.m.Name = "Throw Frost Bomb";
		this.m.Description = "Throw a flask of liquid frost towards a target, where it will shatter and spray its contents.";
		this.m.Icon = "skills/active_96.png";
		this.m.IconDisabled = "skills/active_96_sw.png";
		this.m.Overlay = "active_96";
		this.m.SoundOnHit = [
			"sounds/enemies/ghastly_touch_01.wav"
		];

		this.m.SnowTiles = [];
		for (local i = 1; i <= 3; i++)
		{
			this.m.SnowTiles.push(::MapGen.get("tactical.tile.snow" + i));
		}
	}

	function getTooltip()
	{
		local ret = this.mb_aoe_bomb_skill.getTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Freezes the target area and chills everyone in it for 3 turns"
		});
		return ret;
	}

	// Turn the tile into snow (unless it already is)
	function applyToTile( _tile )
	{
		if (_tile.Subtype == ::Const.Tactical.TerrainSubtype.Snow || _tile.Subtype == ::Const.Tactical.TerrainSubtype.LightSnow)
			return;

		::Time.scheduleEvent(::TimeUnit.Virtual, 350, function( _data ) {
			_data.Tile.clear();
			_data.Tile.Type = 0;
			::MSU.Array.rand(_data.Skill.m.SnowTiles).onFirstPass({
				X = _data.Tile.SquareCoords.X,
				Y = _data.Tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = true,
				SpawnObjects = false
			});
		}, {
			Tile = _tile,
			Skill = this
		});
	}

	function applyToTarget( _target )
	{
		// The ID is "effects.chilled" (looking it up by script path never found it before)
		local chilled = _target.getSkills().getSkillByID("effects.chilled");
		if (chilled == null)
			_target.getSkills().add(::new("scripts/skills/effects/chilled_effect"));
		else
			chilled.resetTime();

		this.spawnIcon("status_effect_109", _target.getTile());
	}
});
