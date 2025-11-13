this.poison_bomb_item_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.poison_bomb_item";
		this.m.PreviewCraftable = this.new("scripts/items/tools/poison_bomb_item");
		this.m.Cost = 50;
		local ingredients = [
			{
				Script = "scripts/items/accessory/poison_item",
				Num = 2
			},			
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/tools/poison_bomb_item"));		
	}

});