// Throw Poison Bomb: poisons everyone in 7 tiles with goblin and spider poison (base: mb_aoe_bomb_skill).
this.throw_poison_bomb_skill <- ::inherit("scripts/skills/actives/mb_aoe_bomb_skill", {
	m = {},
	function create()
	{
		this.mb_aoe_bomb_skill.create();
		this.m.ID = "actives.throw_poison_bomb";
		this.m.Name = "Throw Poison Bomb";
		this.m.Description = "Throw a flask of poison towards a target, where it will shatter and spray its contents.";
		this.m.Icon = "skills/active_95.png";
		this.m.IconDisabled = "skills/active_95_sw.png";
		this.m.Overlay = "active_95";
		this.m.SoundOnHit = [
			"sounds/combat/acid_flask_impact_01.wav",
			"sounds/combat/acid_flask_impact_02.wav",
			"sounds/combat/acid_flask_impact_03.wav",
			"sounds/combat/acid_flask_impact_04.wav"
		];
	}

	function getTooltip()
	{
		local ret = this.mb_aoe_bomb_skill.getTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Poisons everyone in the target area, reducing their Action Points and Vision for 3 turns"
		});
		return ret;
	}

	function applyToTarget( _target )
	{
		// Same immunities as vanilla poison (see goblin_ambusher_racial).
		// The old version reused the acid flask's armor checks, so unarmored targets were never poisoned.
		if (_target.getCurrentProperties().IsImmuneToPoison || _target.getFlags().has("undead"))
			return;

		local skills = _target.getSkills();
		local effects = [
			["effects.goblin_poison", "scripts/skills/effects/goblin_poison_effect"],
			["effects.spider_poison", "scripts/skills/effects/spider_poison_effect"]
		];
		foreach (effect in effects)
		{
			local poison = skills.getSkillByID(effect[0]);
			if (poison == null)
				skills.add(::new(effect[1]));
			else
				poison.resetTime();
		}

		this.spawnIcon("status_effect_54", _target.getTile());
	}
});
