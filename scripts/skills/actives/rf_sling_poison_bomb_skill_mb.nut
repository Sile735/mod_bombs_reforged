// Sling Poison Bomb: slings a Poison Bomb from the bag (requires a sling in the main hand).
// Built with Reforged's sling helper exactly like Reforged's own sling bomb skills; the onUse comes from
// that helper, and Grenadier's free use is added by a hook (bombs/hooks/items/tools/frost_and_poison_bomb_items.nut).
local obj = ::Reforged.InheritHelper.slingItemSkill("throw_poison_bomb_skill");

// Use MSU.Table.merge to overwrite functions so that function names are preserved in stackinfos
local create = obj.create;
::MSU.Table.merge(obj, {
	function create()
	{
		create();
		// There is no dedicated sling icon for poison bombs yet, so the acid flask one is used
		this.m.Icon = "skills/rf_sling_acid_flask_skill.png";
		this.m.IconDisabled = "skills/rf_sling_acid_flask_skill_sw.png";
		this.m.Overlay = "rf_sling_acid_flask_skill";
	}
});

this.rf_sling_poison_bomb_skill_mb <- ::inherit("scripts/skills/actives/throw_poison_bomb_skill", obj);
