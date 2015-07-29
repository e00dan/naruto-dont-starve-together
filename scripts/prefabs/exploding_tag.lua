local assets =
{
    Asset("ANIM", "anim/exploding_tag.zip"),

    Asset("ATLAS", "images/inventoryimages/exploding_tag.xml"),
    Asset("IMAGE", "images/inventoryimages/exploding_tag.tex")
}

local EXPLODING_TAG_DAMAGE = 100

local function onfinished_normal(inst)
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("mine")
    inst.persists = false
    --inst.AnimState:PushAnimation("used", false)
    --inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:DoTaskInTime(3, inst.Remove)
end

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
end

local function OnExplode(inst, target)
    inst.SoundEmitter:KillSound("hiss")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

    if target then
        --inst.SoundEmitter:PlaySound("dontstarve/common/exploding_tag_trigger")
        target.components.combat:GetAttacked(inst, EXPLODING_TAG_DAMAGE)
        if METRICS_ENABLED then
            FightStat_TrapSprung(inst,target, EXPLODING_TAG_DAMAGE)
        end
    end

    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function OnReset(inst)
    inst.AnimState:PlayAnimation("idle", false)
end

local function OnResetMax(inst)
    inst.AnimState:PlayAnimation("idle")
    --inst.AnimState:PushAnimation("idle", false)
end

local function SetSprung(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function SetInactive(inst)
    inst.AnimState:PlayAnimation("inactive")
end

local function OnDropped(inst)
    inst.components.mine:Deactivate()
end

local function ondeploy(inst, pt, deployer)
    inst.components.mine:Reset()
    inst.Physics:Teleport(pt:Get())
end

--legacy save support - mines used to start out activated
local function onload(inst, data)
    if not data or not data.mine then
        inst.components.mine:Reset()
    end
end

local function common_fn(bank, build, isinventoryitem)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    --inst.MiniMapEntity:SetIcon("toothtrap.png")

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("trap")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    if isinventoryitem then
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.nobounce = true
        inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
        inst.components.inventoryitem.imagename = "exploding_tag"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/exploding_tag.xml"
    end

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS)
    inst.components.mine:SetAlignment("player")
    inst.components.mine:SetOnExplodeFn(OnExplode)
    inst.components.mine:SetOnResetFn(OnReset)
    inst.components.mine:SetOnSprungFn(SetSprung)
    inst.components.mine:SetOnDeactivateFn(SetInactive)
    --inst.components.mine:StartTesting()

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1)
    inst.components.finiteuses:SetUses(1)
    inst.components.finiteuses:SetOnFinished(onfinished_normal)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    inst.components.mine:Deactivate()
    inst.OnLoad = onload
    return inst
end

local function MakeExplodingTagNormal()
    return common_fn("exploding_tag", "exploding_tag", true)
end

return Prefab("common/inventory/exploding_tag", MakeExplodingTagNormal, assets),
    MakePlacer("common/exploding_tag_placer", "exploding_tag", "exploding_tag", "idle")