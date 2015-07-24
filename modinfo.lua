-- This information tells other players more about the mod
name = "Naruto"
description = "One day I'll become Hokage!"
author = "Kuzirashi & Shikate"
version = "0.0.2" -- This is the version of the template. Change it to your own number.

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = "http://kuzirashi.github.io"


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false

-- Character mods need this set to true
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
	"character",
	"naruto"
}

--configuration_options = {}
configuration_options =
{
	{
		name = "clone_health_cost",
		label = "Clone health cost",
		options = {
			{ data = 0, description = "0" },
			{ data = 10, description = "10" },
			{ data = 20, description = "20" },
			{ data = 30, description = "30" },
			{ data = 40, description = "40" },
			{ data = 50, description = "50" },
			{ data = 60, description = "60" },
			{ data = 70, description = "70" },
			{ data = 80, description = "80" },
			{ data = 90, description = "90" },
			{ data = 100, description = "100" },
			{ data = 110, description = "110" }
		}, default = 20
	},
	{
		name = "clone_health",
		label = "Clone health",
		options = {
			{ data = 0, description = "0" },
			{ data = 10, description = "10" },
			{ data = 20, description = "20" },
			{ data = 30, description = "30" },
			{ data = 40, description = "40" },
			{ data = 50, description = "50" },
			{ data = 60, description = "60" },
			{ data = 70, description = "70" },
			{ data = 80, description = "80" },
			{ data = 90, description = "90" },
			{ data = 100, description = "100" },
			{ data = 110, description = "110" }
		}, default = 20
	},
	{
		name = "clone_damage",
		label = "Clone damage",
		options = {
			{ data = 0, description = "0" },
			{ data = 10, description = "10" },
			{ data = 20, description = "20" },
			{ data = 30, description = "30" },
			{ data = 40, description = "40" },
			{ data = 50, description = "50" },
			{ data = 60, description = "60" },
			{ data = 70, description = "70" },
			{ data = 80, description = "80" },
			{ data = 90, description = "90" },
			{ data = 100, description = "100" },
			{ data = 110, description = "110" }
		}, default = 20
	}
}