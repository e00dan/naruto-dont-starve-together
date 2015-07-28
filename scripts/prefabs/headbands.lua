local function MakeHeadband(name)

    local function OnEquip(inst, owner, fname_override)
        owner.AnimState:OverrideSymbol("swap_hat", name, "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end

        if inst.components.sanity ~= nil then
            owner.components.sanity.rate_modifier = 0.5
        end
    end

    local function OnUnequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.sanity ~= nil then
            owner.components.sanity.rate_modifier = 1
        end
    end

    local function basic()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
       
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag('headband')
        
        inst.entity:SetPristine()
     
        if not TheWorld.ismastersim then
            return inst
        end 

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. ".xml"

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip( OnEquip )
        inst.components.equippable:SetOnUnequip( OnUnequip )
        
        inst:AddComponent("inspectable")
        
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(1000, .15)

        if not inst.components.characterspecific then
            inst:AddComponent("characterspecific")
            inst.components.characterspecific:SetOwner("naruto")
            inst.components.characterspecific:SetStorable(false)
        end

        inst.components.inventoryitem.onputininventoryfn = function(inst, player)
            if player.prefab ~= nil and not player:HasTag('ninja') then
                inst:DoTaskInTime(0.1, function()
                    player.components.inventory:DropItem(inst)
                    player.components.talker:Say("I'm not a Ninja.")
                end)
            end
        end

        return inst
    end

    local assets =
    { 
        Asset("ANIM", "anim/" .. name .. ".zip"),

        Asset("ATLAS", "images/inventoryimages/" .. name .. ".xml"),
        Asset("IMAGE", "images/inventoryimages/" .. name .. ".tex")
    }

    local fn = nil
    local prefabs = nil

    --[[if name == "headband_blue" then
        fn = basic
    elseif name == "headband_black_missing" then
        fn = basic
    elseif name == 'headband_red' then
        fn = basic
    end]]

    return Prefab("common/inventory/" .. name, basic, assets, prefabs)
end

return MakeHeadband('headband_blue'),
       MakeHeadband('headband_blue_missing'),
       MakeHeadband('headband_black'),
       MakeHeadband('headband_black_missing'),
       MakeHeadband('headband_red'),
       MakeHeadband('headband_red_missing')