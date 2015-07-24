-- local Image = require "widgets/image"
local Widget = require "widgets/widget"
local ChakraBadge = require("widgets/chakrabadge")

-- local ATLAS = "images/avatars.xml"

local ChakraIndicator = Class(Widget, function(self)
    Widget._ctor(self, "ChakraIndicator")
    self.isFE = false
    self:SetClickable(false)

    self.root = self:AddChild(Widget("root"))
    -- self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.icon = self.root:AddChild(Widget("target"))
    self.icon:SetScale(1)
	self.badge = self.icon:AddChild(ChakraBadge())
end)

return ChakraIndicator