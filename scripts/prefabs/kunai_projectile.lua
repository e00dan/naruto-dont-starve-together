local assets =
{
	Asset("ANIM", "anim/kunai_projectile.zip"),
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("kunai_projectile")
    inst.AnimState:SetBuild("kunai_projectile")
    inst.AnimState:PlayAnimation("idle", true)
	
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.AnimState:SetBank("projectile")
    -- inst.AnimState:SetBuild("staff_projectile")

    inst:AddTag("projectile")
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetLaunchOffset({x=0, y=2})
    -- inst.components.projectile:SetOnHitFn(inst.Remove)
    -- inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.Transform:SetScale(1.8,1.8,1.8)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)

	-- inst.AnimState:PlayAnimation("fire_spin_loop", true)
	-- inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

	inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
	
	
	
	return inst
end

return Prefab("common/inventory/kunai_projectile", fn, assets)