local assets=
{ 
    Asset("ANIM", "anim/kunai.zip"),
    Asset("ANIM", "anim/swap_kunai.zip"), 

    Asset("ATLAS", "images/inventoryimages/kunai.xml"),
    Asset("IMAGE", "images/inventoryimages/kunai.tex")
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
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20)
	inst.components.weapon:SetRange(0.15, 0.15)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    return inst
end

return  Prefab("common/inventory/kunai", fn, assets)