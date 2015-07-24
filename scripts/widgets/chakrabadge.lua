local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local ChakraBadge = Class(Badge, function(self)
	self.owner = ThePlayer
    Badge._ctor(self, "chakra", self.owner)

    
    self:SetScale(1.5, 1.5, 1.5)
    self:SetPercent(100, 100, 0)

    self:StartUpdating()

    --[[

    local emotename = 'chakra 0% / 100%'
    local emote = { anim = {"emoteXL_waving1", "emoteXL_waving2"}, randomanim = true }
    local image = true

    self.isFE = false
    self:SetClickable(false)

    self.root = self:AddChild(Widget("root"))
    -- self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.icon = self.root:AddChild(Widget("target"))
    self.icon:SetScale(SMALLSCALE)
	self.expanded = false

    self.prefabname = "wilson"
	
	if image then
		local anim = type(emote.anim) == "table" and emote.anim[math.floor(#emote.anim/2)] or emote.anim
		self.headbg = self.icon:AddChild(Image(ATLAS, "avatar_bg.tex"))
		self.head = self.icon:AddChild(UIAnim())
		self.head:GetAnimState():SetBank("wilson")
		self.head:GetAnimState():SetBuild(self.prefabname)
		self.head:GetAnimState():Hide("ARM_carry")
		self.head:GetAnimState():SetPercent(anim, anim == "emoteXL_pre_dance0" and 1 or 0.5)

		local scale = 0.2

		self.head:SetScale(scale)
		self.head:SetPosition(0, 0, -1)
		
		self.headframe = self.icon:AddChild(Image(ATLAS, "avatar_frame_white.tex"))
		self.headframe:SetTint(unpack(BROWN))
	end
	

	self.bg = self.icon:AddChild(Image("images/ui/status_bg.xml", "status_bg.tex"))
	self.bg:SetScale(.11*(emotename:len()+1),.5,0)
	if image then self.bg:SetPosition(0, 0, 0) end
	self.bg:SetTint(unpack(DEFAULT_PLAYER_COLOUR))

	self.text = self.icon:AddChild(Text(NUMBERFONT, 28))
	self.text:SetHAlign(ANCHOR_MIDDLE)
	if image then
		self.text:SetPosition(0, 0, 0)
	else
		self.text:SetPosition(0, 0, 0)
	end
	self.text:SetScale(1,.78,1)
	self.text:SetString('chakra 100% / 100%')]]

end)

function ChakraBadge:SetPercent(val, max, penaltypercent)
    Badge.SetPercent(self, val, max)

    penaltypercent = penaltypercent or 0
    --self.topperanim:GetAnimState():SetPercent("anim", penaltypercent)
end

function ChakraBadge:OnUpdate(dt)
	return true
end

return ChakraBadge