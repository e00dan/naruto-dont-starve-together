local function onpercent(self)
    --[[if self.inst.components.combat ~= nil then
        self.inst.components.combat.panic_thresh = self.inst.components.combat.panic_thresh
    end]]
end

local function onmaxchakra(self, maxchakra)
    --self:SetMax(maxchakra)
    --self.inst.components.chakra:SetIsFull((self.currentchakra or maxchakra) >= maxchakra)
    onpercent(self)
end

local function oncurrentchakra(self, currentchakra)
	--self.currentchakra = currentchakra
    --self.inst.components.chakra:SetIsFull(currentchakra >= self.maxchakra)
    onpercent(self)
end

local Chakra = Class(function(self, inst)
    self.inst = inst
    self.maxchakra = 100
    self.minchakra = 0
    self.currentchakra = self.maxchakra
end,
nil,
{
    maxchakra = onmaxchakra,
    currentchakra = oncurrentchakra
})

function Chakra:OnRemoveFromEntity()
    onpercent(self)
end

function Chakra:SetInvincible(val)
    self.invincible = val
    self.inst:PushEvent("invincibletoggle", { invincible = val })
end

function Chakra:OnSave()
    return
    {
        chakra = self.currentchakra
    }
end

function Chakra:RecalculatePenalty(forceupdatewidget) 
    --self:DoDelta(0, nil, "resurrection_penalty", forceupdatewidget)
end

function Chakra:OnLoad(data)
    if data.chakra ~= nil then
        self:SetVal(data.chakra, "file_load")
        self:DoDelta(0) --to update hud
    elseif data.percent ~= nil then
        -- used for setpieces!
        self:SetPercent(data.percent, true, "file_load")
        self:DoDelta(0) --to update hud
    end
end

local FIRE_TIMEOUT = .5

function Chakra:OnUpdate(dt)
    --local time = GetTime()
end

function Chakra:DoRegen()
    --print(string.format("Chakra:DoRegen ^%.2g/%.2fs", self.regen.amount, self.regen.period))
    if not self:IsDead() then
        self:DoDelta(self.regen.amount, true, "regen")
    else
        --print("    can't regen from dead!")
    end
end

function Chakra:StartRegen(amount, period, interruptcurrentregen)

    -- We don't always do this just for backwards compatibility sake. While unlikely, it's possible some modder was previously relying on
    -- the fact that StartRegen didn't stop the existing task. If they want to continue using that behavior, they now just need to add
    -- a "false" flag as the last parameter of their StartRegen call. Generally, we want to restart the task, though.
    if interruptcurrentregen == nil or interruptcurrentregen == true then
        self:StopRegen()
    end

    if not self.regen then
        self.regen = {}
    end
    self.regen.amount = amount
    self.regen.period = period

    if not self.regen.task then
        self.regen.task = self.inst:DoPeriodicTask(self.regen.period, function() self:DoRegen() end)
    end
end

function Chakra:StopRegen()
    --print("Chakra:StopRegen")
    if self.regen then
        if self.regen.task then
            --print("   stopping task")
            self.regen.task:Cancel()
            self.regen.task = nil
        end
        self.regen = nil
    end
end

function Chakra:GetPenaltyPercent()
    return 1 - self:GetMaxWithPenalty() / self.maxchakra
end

function Chakra:GetPercent()
    return self.currentchakra / self.maxchakra
end

function Chakra:IsInvincible()
    return self.invincible
end

function Chakra:GetDebugString()
    local s = string.format("%2.2f / %2.2f", self.currentchakra, self:GetMaxWithPenalty())
    if self.regen then
        s = s .. string.format(", regen %.2f every %.2fs", self.regen.amount, self.regen.period)
    end
    return s
end

function Chakra:SetCurrentChakra(amount)
    self.currentchakra = amount
end

function Chakra:Max()
	return self.maxchakra
end

function Chakra:SetMaxChakra(amount)
	if amount == nil then
		self.maxchakra = 0
	    self.currentchakra = 0
	else
	    self.maxchakra = amount
	    self.currentchakra = amount
	end
end

function Chakra:SetMinChakra(amount)
    self.minchakra = amount
end

function Chakra:IsHurt()
    return self.currentchakra < self:GetMaxWithPenalty()
end

function Chakra:GetMaxWithPenalty()
    return math.max(1, self.maxchakra)
end

function Chakra:IsDead()
    return self.currentchakra <= 0
end

local function destroy(inst)
    local time_to_erode = 1
    local tick_time = TheSim:GetTickTime()

    if inst.DynamicShadow then
        inst.DynamicShadow:Enable(false)
    end

    inst:StartThread( function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
            ticks = ticks + 1
            Yield()
        end
        inst:Remove()
    end)
end

function Chakra:SetPercent(percent, overtime, cause)
    self:SetVal(self.maxchakra * percent, cause)
    self:DoDelta(0, overtime, cause)
end

function Chakra:SetVal(val, cause)
    local old_percent = self:GetPercent()

    if val > self:GetMaxWithPenalty() then
        val = self:GetMaxWithPenalty()
    end

    if self.minchakra and val < self.minchakra then
        self.currentchakra = self.minchakra
        self.inst:PushEvent("minchakra", { cause = cause })
    elseif val < 0 then
        self.currentchakra = 0
    else
        self.currentchakra = val
    end

    local new_percent = self:GetPercent()
    
    if old_percent > 0 and new_percent <= 0 or self:GetMaxWithPenalty() <= 0 then
        --self.inst:PushEvent("death", { cause = cause, afflicter = afflicter })

        --TheWorld:PushEvent("entity_death", { inst = self.inst, cause = cause, afflicter = afflicter })
    end
end

function Chakra:DoDelta(amount, overtime, cause)
    local old_percent = self:GetPercent()
    self:SetVal(self.currentchakra + amount, cause)
    local new_percent = self:GetPercent()

    self.inst:PushEvent("chakradelta", {oldpercent = old_percent, newpercent = self:GetPercent(), overtime = overtime, cause = cause, amount = amount })

-- KAJ: TODO: GetPlayer reference but only used for metrics/fightstat
--    if METRICS_ENABLED and self.inst == GetPlayer() and cause and cause ~= "debug_key" then
--        if amount > 0 then
--            ProfileStatsAdd("healby_" .. cause, math.floor(amount))
--            FightStat_Heal(math.floor(amount))
--        end
--    end

    if self.ondelta then
        self.ondelta(self.inst, old_percent, self:GetPercent())
    end
end

function Chakra:Respawn(chakra)
    self:DoDelta(chakra or 10)
    self.inst:PushEvent("respawn", {})
end

return Chakra
