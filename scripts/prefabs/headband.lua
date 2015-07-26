local assets =
{ 
    Asset("ANIM", "anim/headband.zip"),

    Asset("ATLAS", "images/inventoryimages/headband.xml"),
    Asset("IMAGE", "images/inventoryimages/headband.tex")
}

 local function OnEquip(inst, owner, fname_override)
    owner.AnimState:OverrideSymbol("swap_hat", 'headband', "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
    
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
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

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function fn(colour)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
   
	inst.AnimState:SetBank("headband")
    inst.AnimState:SetBuild("headband")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
	
	inst.entity:SetPristine()
 
    if not TheWorld.ismastersim then
        return inst
    end	

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "headband"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/headband.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	inst:AddComponent("inspectable")
	
    return inst
end

return  Prefab("common/inventory/headband", fn, assets)