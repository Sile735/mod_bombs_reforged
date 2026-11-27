// Bombs Reforged - preload / registration
// Registers the mod with Modern Hooks and MSU, then loads every hook file in the Late bucket.

::mod_bombs <- {
	ID = "mod_bombs",
	Name = "Bombs Reforged",
	Version = "0.5.0",	// keep in sync with the GitHub release tag
	GitHubURL = "https://github.com/Sile735/mod_bombs_reforged"
};

local requiredMods = [
	"mod_msu",
	"mod_dynamic_perks",
	"mod_reforged",
	"mod_stack_based_skills"
];

::mod_bombs.HooksMod <- ::Hooks.register(::mod_bombs.ID, ::mod_bombs.Version, ::mod_bombs.Name);
::mod_bombs.HooksMod.require(requiredMods);

// ">" means "load AFTER that mod" ("<" would mean BEFORE). Version constraints are stripped down to the mod ID.
local queueLoadOrder = [];
foreach (requirement in requiredMods)
{
	local idx = requirement.find(" ");
	queueLoadOrder.push(">" + (idx == null ? requirement : requirement.slice(0, idx)));
}

::mod_bombs.HooksMod.queue(queueLoadOrder, function() {
	::mod_bombs.Mod <- ::MSU.Class.Mod(::mod_bombs.ID, ::mod_bombs.Version, ::mod_bombs.Name);

	// In-game "new version available" notification via MSU
	::mod_bombs.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::mod_bombs.GitHubURL);
	::mod_bombs.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);
});

// Hooks are registered in the Late bucket so they wrap on top of Reforged's own changes.
::mod_bombs.HooksMod.queue(queueLoadOrder, function() {
	::include("bombs/load.nut");
}, ::Hooks.QueueBucket.Late);
