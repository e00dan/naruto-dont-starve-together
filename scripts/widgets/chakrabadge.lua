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