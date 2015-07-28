local assets =
{ 
    Asset("ANIM", "anim/kunai.zip"),
    Asset("ANIM", "anim/swap_kunai.zip"), 

    Asset("ATLAS", "images/inventoryimages/kunai.xml"),
    Asset("IMAGE", "images/inventoryimages/kunai.tex")
}

local smallhits =
{
    frog = true,
    penguin = true,
    eyeplant = true
}

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_kunai", "kunai")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
end

local function fn(colour)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
   
	inst.AnimState:SetBank("kunai")
    inst.AnimState:SetBuild("kunai")
    inst.AnimState:PlayAnimation("idle")
	
	inst.entity:SetPristine()
 
    if not TheWorld.ismastersim then
        return inst
    end	

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "kunai"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kunai.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	--inst.components.equippable.walkspeedmult = 1.10
	
	inst:AddComponent("inspectable")

    local kunai_damage = 25
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(kunai_damage)
	inst.components.weapon:SetRange(0.15, 0.15)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    local kunai = inst
    local function onattack(inst, attacker, target, skipsanity)
        local smalltarget = target:HasTag("smallcreature") and not smallhits[target.prefab]
        local missed = false
        if math.random() < SMALL_MISS_CHANCE and smalltarget then
            missed = true
            if attacker.components and attacker.components.talker then
                local miss_message = "Ugh, I don't think I can hit something that small!"
                if attacker.prefab == 'wx78' then miss_message = "INSUFFICIENT ACCURACY" end
                attacker.components.talker:Say(miss_message)
                target:PushEvent("attacked", {attacker = attacker, damage = kunai_damage, weapon = kunai})
            end
        else
            if target.components.combat then
                target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, kunai), kunai)
            end         
        end
            
        local newkunai = SpawnPrefab('kunai')
        newkunai.Transform:SetPosition(inst:GetPosition():Get())
        if newkunai.components.finiteuses then
            newkunai.components.finiteuses:SetUses(kunai.components.finiteuses:GetUses())
            newkunai.components.finiteuses:Use((smalltarget and not missed)
                and TUNING.SPEAR_USES/SMALL_USES
                or TUNING.SPEAR_USES/LARGE_USES)
        end
        newkunai:AddTag("scarytoprey")
        newkunai:DoTaskInTime(1, function(inst) inst:RemoveTag("scarytoprey") end)
        inst:Remove()
        -- kunai.parent.AnimState:OverrideSymbol("swap_object", "", "")
        kunai:Remove()

        attacker.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
    end
    
    inst:AddComponent('kunaithrowable')
    inst.components.kunaithrowable:SetRange(8, 10)
    inst.components.kunaithrowable:SetOnAttack(onattack)
    inst.components.kunaithrowable:SetProjectile("kunai_projectile")
	
    return inst
end

return  Prefab("common/inventory/kunai", fn, assets)