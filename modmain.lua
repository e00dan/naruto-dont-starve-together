PrefabFiles = {
	"naruto",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/naruto.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/naruto.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/naruto.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/naruto.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/naruto_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/naruto_silho.xml" ),

    Asset( "IMAGE", "bigportraits/naruto.tex" ),
    Asset( "ATLAS", "bigportraits/naruto.xml" ),
	
	Asset( "IMAGE", "images/map_icons/naruto.tex" ),
	Asset( "ATLAS", "images/map_icons/naruto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_naruto.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_naruto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_naruto.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_naruto.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.naruto = "Naruto"
STRINGS.CHARACTER_NAMES.naruto = "Naruto"
STRINGS.CHARACTER_DESCRIPTIONS.naruto = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.naruto = "\"Quote\""

-- Custom speech strings
STRINGS.CHARACTERS.NARUTO = require "speech_naruto"

-- The character's name as appears in-game 
STRINGS.NAMES.NARUTO = "Naruto"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NARUTO = 
{
	GENERIC = "It's Naruto!",
	ATTACKER = "That Naruto looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Naruto, friend of ghosts.",
	GHOST = "Naruto could use a heart.",
}


AddMinimapAtlas("images/map_icons/naruto.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("naruto", "MALE")

