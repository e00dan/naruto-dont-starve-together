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

	Asset("ANIM", "anim/chakra.zip")
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.naruto = "Naruto"
STRINGS.CHARACTER_NAMES.naruto = "Naruto"
STRINGS.CHARACTER_DESCRIPTIONS.naruto = "*Kage Bunshin no Jutsu\n*Uses Kunai"
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

local ChakraIndicator = GLOBAL.require("widgets/ChakraIndicator")

local controls = nil

local STARTSCALE = 0.25
local NORMSCALE = 1

local function IsDefaultScreen()
	return GLOBAL.TheFrontEnd:GetActiveScreen().name:find("HUD") ~= nil
end

--[[local function HideGestureWheel()
	keydown = false
	SetModHUDFocus("GestureWheel", false)
	
	controls.chakraindicator:Hide()
	controls.chakraindicator.inst.UITransform:SetScale(STARTSCALE, STARTSCALE, 1)
	
	if not IsDefaultScreen() then return end
	
	if RESTORECURSOR then
		if ADJUSTCURSOR then
			local x,y = GLOBAL.TheInputProxy:GetOSCursorPos()
			local gx, gy = controls.chakraindicator:GetPosition():Get()
			local dx, dy = x-gx, y-gy
			cursorx = cursorx + dx
			cursory = cursory + dy
		end
		GLOBAL.TheInputProxy:SetOSCursorPos(cursorx, cursory)
	end
	
	if controls.chakraindicator.activegesture then
		GLOBAL.TheNet:SendSlashCmdToServer("/" .. controls.chakraindicator.activegesture, true)
	end
end]]

local function AddChakraIndicator(self)
	controls = self -- this just makes controls available in the rest of the modmain's functions
	controls.chakraindicator = controls:AddChild(ChakraIndicator())
	local screenwidth, screenheight = GLOBAL.TheSim:GetScreenSize()
	centerx = screenwidth / 2
	centery = screenheight / 2
	controls.chakraindicator:SetPosition(screenwidth - 72, screenheight - 190, 0)
	controls.chakraindicator.inst.UITransform:SetScale(STARTSCALE, STARTSCALE, 1)
	
	-- Keyboard controls
	--GLOBAL.TheInput:AddKeyDownHandler(KEYBOARDTOGGLEKEY, ShowGestureWheel)
	--GLOBAL.TheInput:AddKeyUpHandler(KEYBOARDTOGGLEKEY, HideGestureWheel)
	
	--SetModHUDFocus("ChakraIndicator", true)
	
	--if not IsDefaultScreen() then return end
	
	--[[if RESTORECURSOR then
		cursorx, cursory = GLOBAL.TheInputProxy:GetOSCursorPos()
	end
	
	if CENTERWHEEL then
		GLOBAL.TheInputProxy:SetOSCursorPos(centerx, centery)
	else
		
	end]]
	--controls.chakraindicator:SetPosition(GLOBAL.TheInput:GetScreenPosition():Get())

	controls.chakraindicator:Show()
	controls.chakraindicator:ScaleTo(STARTSCALE, NORMSCALE, .25)
	
	local OldOnUpdate = controls.OnUpdate
	local function OnUpdate(...)
		OldOnUpdate(...)
		if keydown then
			self.chakraindicator:OnUpdate()
		end
	end
	controls.OnUpdate = OnUpdate

	controls.chakraindicator:MoveToBack()
end

AddClassPostConstruct("widgets/controls", AddChakraIndicator)