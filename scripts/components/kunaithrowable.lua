local Kunaithrowable = Class(function(self, inst)
    self.inst = inst
    self.damage = 10
    self.attackrange = nil
    self.hitrange = nil
    self.onattack = nil
    self.onprojectilelaunch = nil
    self.projectile = nil

    --Monkey uses these
    self.modes = nil
    self.variedmodefn = nil
end,
nil,
{
})

function Kunaithrowable:OnRemoveFromEntity()
    if self.inst.replica.inventoryitem ~= nil then
        self.inst.replica.inventoryitem:SetAttackRange(-1)
    end
end

function Kunaithrowable:SetDamage(dmg)
    self.damage = dmg
end

function Kunaithrowable:SetRange(attack, hit)
    self.attackrange = attack
    self.hitrange = hit or self.attackrange
end

function Kunaithrowable:SetOnAttack(fn)
    self.onattack = fn
end

function Kunaithrowable:SetOnProjectileLaunch(fn)
    self.onprojectilelaunch = fn
end

function Kunaithrowable:SetProjectile(projectile)
    self.projectile = projectile
end

function Kunaithrowable:CanRangedAttack()
    if self.variedmodefn then
        local mode = self.variedmodefn(self.inst)
        if not mode.ranged then
            --determined to use melee mode, return false.
            return false
        end
    end

    return self.projectile ~= nil
end

function Kunaithrowable:SetAttackCallback(fn)
    self.onattack = fn
end

function Kunaithrowable:OnAttack(attacker, target, projectile)
    if self.onattack then
        self.onattack(self.inst, attacker, target)
    end
    
    if self.inst.components.finiteuses then
	    self.inst.components.finiteuses:Use(self.attackwear or 1)
    end
end

function Kunaithrowable:LaunchProjectile(attacker, target)
	if self.projectile then
        if self.onprojectilelaunch then
            self.onprojectilelaunch(self.inst, attacker, target)
        end

	    local proj = SpawnPrefab(self.projectile)
	    if proj then
            if proj.components.projectile then
    	        proj.Transform:SetPosition(attacker.Transform:GetWorldPosition() )
				--#rezecib had to add the line below because projectile refers back to weapon instead
				proj.components.projectile.onhit = self.onattack
    	        proj.components.projectile:Throw(attacker, target, attacker)
            elseif proj.components.complexprojectile then
                proj.Transform:SetPosition( attacker.Transform:GetWorldPosition() )
                proj.components.complexprojectile:Launch(Vector3( target.Transform:GetWorldPosition() ), attacker, self.inst)
            end
	    end
	end
end

return Kunaithrowable