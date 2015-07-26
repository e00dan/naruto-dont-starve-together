local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local ChakraBadge = Class(Badge, function(self)
	self.owner = ThePlayer
    Badge._ctor(self, "chakra", self.owner)

    self:SetScale(1.35, 1.35, 1.35)
    --self:SetPercent(100, 100, 0)

    if not self.owner:HasTag('ninja') then
        self:Hide()
    end

    if self.owner.components.chakra then
    	self.onchakradelta = function(owner, data) self:ChakraDelta(data) end
    	self.owner:ListenForEvent("chakradelta", self.onchakradelta, self.owner)

    	self:SetChakraPercent(self.owner.components.chakra:GetPercent())
    end

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

function ChakraBadge:ChakraDelta(data)
    self:SetChakraPercent(data.newpercent)

    --[[if not data.overtime then
        if data.newpercent > data.oldpercent then
            self.heart:PulseGreen()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_up")
        elseif data.newpercent < data.oldpercent then
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_down")
            self.heart:PulseRed()
        end
    end]]
end

function ChakraBadge:SetChakraPercent(pct)
    self:SetPercent(pct, self.owner.components.chakra:Max(), 0) 

    --[[if pct <= .33 then
        self.heart:StartWarning()
    else
        self.heart:StopWarning()
    end]]
end

function ChakraBadge:SetPercent(val, max, penaltypercent)
    Badge.SetPercent(self, val, max)

    penaltypercent = penaltypercent or 0
    --self.topperanim:GetAnimState():SetPercent("anim", penaltypercent)
end

function ChakraBadge:OnUpdate(dt)
	return true
end

return ChakraBadge