PrefabFiles = {
	"naruto",
	"bunshinjutsu",
	"bunshin",
	"kunai"
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

    Asset("ATLAS", "images/inventoryimages/kunai.xml"),
    Asset("IMAGE", "images/inventoryimages/kunai.tex"),
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.naruto = "Naruto"
STRINGS.CHARACTER_NAMES.naruto = "Naruto"
STRINGS.CHARACTER_DESCRIPTIONS.naruto = "*Kage Bunshin no Jutsu"
STRINGS.CHARACTER_QUOTES.naruto = "\"One day I'll become Hokage!\""

-- Custom speech strings
STRINGS.CHARACTERS.NARUTO = require "speech_naruto"

-- The character's name as appears in-game 
STRINGS.NAMES.NARUTO = "Naruto"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NARUTO = 
{
	GENERIC = "It's Naruto!",
	ATTACKER = "Naruto looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Naruto, friend of ghosts.",
	GHOST = "Naruto could use a heart."
}

STRINGS.NAMES.BUNSHINJUTSU = "Kage Bunshin no Jutsu"
STRINGS.CHARACTERS.NARUTO.DESCRIBE.BUNSHINJUTSU = "Powerful Ninjutsu. Creates a clone, takes health for each copy."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUNSHINJUTSU = "Weird scroll."

STRINGS.NAMES.KUNAI = "Kunai"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KUNAI = "Sharp ninja knife."

GLOBAL.CLONE_HEALTH_COST 	= GetModConfigData("clone_health_cost")
GLOBAL.CLONE_HEALTH 		= GetModConfigData("clone_health")
GLOBAL.CLONE_DAMAGE 		= GetModConfigData("clone_damage")

AddMinimapAtlas("images/map_icons/naruto.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("naruto", "MALE")

