this.frost_bomb_item_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.poison_bomb_item";
		this.m.PreviewCraftable = this.new("scripts/items/tools/frost_bomb_item");
		this.m.Cost = 50;
		local ingredients = [
			{
				Script = "scripts/items/misc/frost_unhold_fur_item",
				Num = 1
			},
			{
				Script = "scripts/items/misc/serpent_skin_item",
				Num = 1
			},			
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/tools/frost_bomb_item"));		
	}

});