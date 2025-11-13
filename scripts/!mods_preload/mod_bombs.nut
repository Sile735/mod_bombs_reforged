::mod_bombs <- {
	ID = "mod_bombs",
	Name = "Bombs Reforged",
	Version = "0.1.0",
	// GitHubURL = "https://github.com/YOURNAME/mod_MODID",
}

local requiredMods = [
    "mod_dynamic_perks",
    "mod_reforged",
    "mod_stack_based_skills"    
];
::mod_bombs.HooksMod <- ::Hooks.register(::mod_bombs.ID, ::mod_bombs.Version, ::mod_bombs.Name);
::mod_bombs.HooksMod.require(requiredMods);
local queueLoadOrder = [];
foreach (requirement in requiredMods)
{
	local idx = requirement.find(" ");
	queueLoadOrder.push("<" + (idx == null ? requirement : requirement.slice(0, idx)));
}
::mod_bombs.HooksMod.queue(queueLoadOrder, function() {
	::mod_bombs.Mod <- ::MSU.Class.Mod(::mod_bombs.ID, ::mod_bombs.Version, ::mod_bombs.Name);
});

::mod_bombs.HooksMod.queue(queueLoadOrder, function() {
    ::include("bombs/load.nut");
}, ::Hooks.QueueBucket.Late);
