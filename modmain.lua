PrefabFiles = {
	"naruto",
	"bunshinjutsu",
	"bunshin",
	"kunai",
	'kunai_projectile',
	'headbands',
	'exploding_tag'
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

	Asset("ANIM", "anim/chakra.zip"),

    Asset( "IMAGE", "images/recipe_tab/tab_ninja_gear.tex" ),
	Asset( "ATLAS", "images/recipe_tab/tab_ninja_gear.xml" )
}

local require 		= GLOBAL.require
local STRINGS 		= GLOBAL.STRINGS
local Ingredient 	= GLOBAL.Ingredient
local RECIPETABS 	= GLOBAL.RECIPETABS
local TECH 			= GLOBAL.TECH

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

RECIPETABS['NINJA_GEAR'] = { str = "NINJA_GEAR", sort = 1000, icon = "tab_ninja_gear.tex", icon_atlas = "images/recipe_tab/tab_ninja_gear.xml" }
STRINGS.TABS.NINJA_GEAR = "Ninja gear"

STRINGS.NAMES.BUNSHINJUTSU = "Scroll of the Forbidden Seal"
STRINGS.CHARACTERS.NARUTO.DESCRIBE.BUNSHINJUTSU = "Powerful Ninjutsu. Creates a clone, takes health for each copy."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUNSHINJUTSU = "Weird scroll."

AddRecipe("bunshinjutsu",
	{
		Ingredient("papyrus", 2),
		Ingredient('nightmarefuel', 1)
	},
	RECIPETABS.NINJA_GEAR, TECH.NONE, nil, nil, nil, nil, 'ninja', "images/inventoryimages/bunshinjutsu.xml")

STRINGS.NAMES.KUNAI = "Kunai"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KUNAI = "Sharp ninja knife."
STRINGS.RECIPE_DESC.KUNAI = "Sharp ninja knife."

AddRecipe("kunai",
	{
		Ingredient("flint", 2)
	},
	RECIPETABS.NINJA_GEAR, TECH.NONE, nil, nil, nil, nil, 'ninja', "images/inventoryimages/kunai.xml")

STRINGS.NAMES.EXPLODING_TAG = "Exploding tag"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLODING_TAG = "Exploding tag."
STRINGS.RECIPE_DESC.EXPLODING_TAG = "Exploding tag."

--[[AddRecipe("exploding_tag",
	{
		Ingredient("papyrus", 1),
		Ingredient("gunpowder", 1)
	},
	RECIPETABS.NINJA_GEAR, TECH.NONE, nil, nil, nil, nil, 'ninja', "images/inventoryimages/exploding_tag.xml")]]

headbands = {
	HEADBAND_BLUE = { name = 'Blue forehead protector' },
	HEADBAND_BLUE_MISSING = { name = 'Blue forehead protector' },
	HEADBAND_BLACK = { name = 'Black forehead protector' },
	HEADBAND_BLACK_MISSING = { name = 'Black forehead protector' },
	HEADBAND_RED = { name = 'Red forehead protector' },
	HEADBAND_RED_MISSING = { name = 'Red forehead protector' }
}

for k, v in pairs(headbands) do
	local lower = k:lower()

	STRINGS.NAMES[k] = v.name or "Ninja forehead protector"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[k] = v.description or "A symbol of pride and fealty."
	STRINGS.RECIPE_DESC[k] = v.description or "A symbol of pride and fealty."

	AddRecipe(lower,
	{
		Ingredient("manrabbit_tail", 1), Ingredient("tentaclespots", 2), Ingredient("flint", 2)
	},
	RECIPETABS.NINJA_GEAR, TECH.NONE, nil, nil, nil, nil, 'ninja', "images/inventoryimages/" .. lower .. ".xml")
end

GLOBAL.CLONE_HEALTH_COST 	= GetModConfigData("clone_health_cost")
GLOBAL.CLONE_HEALTH 		= GetModConfigData("clone_health")
GLOBAL.CLONE_DAMAGE 		= GetModConfigData("clone_damage")

AddMinimapAtlas("images/map_icons/naruto.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("naruto", "MALE")

local ChakraBadge = GLOBAL.require("widgets/chakrabadge")

GLOBAL.CONTROLS = nil

local function AddChakraIndicator(self)
	controls = self -- this just makes controls available in the rest of the modmain's functions

	controls.chakraindicator = controls.sidepanel:AddChild(ChakraBadge())
	controls.chakraindicator:SetPosition(0, -151, 0)

	controls.chakraindicator:MoveToBack()

	controls.chakraindicator:SetClickable(false)

	GLOBAL.CONTROLS = controls
end

AddClassPostConstruct("widgets/controls", AddChakraIndicator)


--- Kunai

GLOBAL.SMALL_MISS_CHANCE = GetModConfigData("SMALL_MISS_CHANCE")
GLOBAL.SMALL_USES = GetModConfigData("SMALL_USES")
GLOBAL.LARGE_USES = GetModConfigData("LARGE_USES")
GLOBAL.RANGE_CHECK = GetModConfigData("RANGE_CHECK")

local KUNAITHROW = GLOBAL.Action(4,		-- priority
								false,	-- instant (set to not instant)
								true,	-- right mouse button
								10,		-- distance check
								false,	-- ghost valid (set to not ghost valid)
								false,	-- can force (false)
								nil)	-- range check function
KUNAITHROW.str = "Throw kunai"
KUNAITHROW.id = "KUNAITHROW"
KUNAITHROW.fn = function(act)
	if act.invobject then
		local pvp = GLOBAL.TheNet:GetPVPEnabled()
		local target = act.target
		if target == nil then
			for k,v in pairs(GLOBAL.TheSim:FindEntities(act.pos.x, act.pos.y, act.pos.z, 20)) do
				if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(act.doer) and
				act.doer.replica and act.doer.replica.combat and act.doer.replica.combat:CanTarget(v)
				and (not v:HasTag("wall")) and (pvp or ((not pvp)
						and (not (act.doer:HasTag("player") and v:HasTag("player"))))) then
					target = v
					break
				end
			end
		end
		if target then
			-- table.insert(actions, GLOBAL.ACTIONS.KUNAITHROW)
			-- if (not act.doer.components.combat.laststartattacktime) or
					-- (GLOBAL.GetTime() - act.doer.components.combat.laststartattacktime > 1) then
				local prefab = act.invobject.prefab
				act.invobject.components.kunaithrowable:LaunchProjectile(act.doer, target)
				local newkunai = act.doer.components.inventory:FindItem(
					function(item) return item.prefab == prefab end)
				if newkunai then
					act.doer.components.inventory:Equip(newkunai)
				end
			-- end
		elseif act.doer.components and act.doer.components.talker then
			local fail_message = "There's nothing to throw it at."
			if act.doer.prefab == 'wx78' then fail_message = "NO TARGET" end
			act.doer.components.talker:Say(fail_message)
		end
		return true
	end
end
AddAction(KUNAITHROW)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES

local throw_kunai = State({
        name = "throw_kunai",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
			inst.components.combat:SetTarget(target)
			inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("throw")

            inst.sg:SetTimeout(2)

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
			elseif buffaction ~= nil and buffaction.pos ~= nil then
                inst:FacePoint(buffaction.pos)
            end
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			-- inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,})
AddStategraphState("wilson", throw_kunai)

local throw_kunai_client = State({
        name = "throw_kunai",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
			inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("throw")

            inst.sg:SetTimeout(2)

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
			elseif buffaction ~= nil and buffaction.pos ~= nil then
                inst:FacePoint(buffaction.pos)
            end
			if buffaction ~= nil then
				inst:PerformPreviewBufferedAction()
			end
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			-- inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.replica.combat:CancelAttack()
            end
        end,})
AddStategraphState("wilson_client", throw_kunai_client)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(KUNAITHROW, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "throw_kunai"
	end
end))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(KUNAITHROW, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "throw_kunai"
	end
end))

local function kunaithrow_point(inst, doer, pos, actions, right)
	if right then
		local target = nil
		local pvp = GLOBAL.TheNet:GetPVPEnabled()
		local cur_time = GLOBAL.GetTime()
		if RANGE_CHECK then
			for k,v in pairs(GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 2)) do
				if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(doer) and
				doer.replica and doer.replica.combat and doer.replica.combat:CanTarget(v)
				and (not v:HasTag("wall")) and (pvp or ((not pvp)
						and (not (doer:HasTag("player") and v:HasTag("player"))))) then
					target = v
					break
				end
			end
		end
		if target then
			table.insert(actions, GLOBAL.ACTIONS.KUNAITHROW)
		end
	end
end
AddComponentAction("POINT", "kunaithrowable", kunaithrow_point)

local function kunaithrow_target(inst, doer, target, actions, right)
	local pvp = GLOBAL.TheNet:GetPVPEnabled()
	local cur_time = GLOBAL.GetTime()
	if right and (not target:HasTag("wall"))
		and doer.replica.combat ~= nil
		and doer.replica.combat:CanTarget(target)
		and target.replica.combat:CanBeAttacked(doer)
		and (pvp or ((not pvp)
					and (not (doer:HasTag("player") and target:HasTag("player")))))
			then
		table.insert(actions, GLOBAL.ACTIONS.KUNAITHROW)
	end
end
AddComponentAction("EQUIPPED", "kunaithrowable", kunaithrow_target)