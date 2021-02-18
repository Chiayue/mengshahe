-- 宝物: 阿哈利姆之力

if modifier_treasure_aghanim_power == nil then 
    modifier_treasure_aghanim_power = class({})
end

function modifier_treasure_aghanim_power:GetTexture()
    return "buff/modifier_treasure_aghanim_power"
end

function modifier_treasure_aghanim_power:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_aghanim_power:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_aghanim_power:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_aghanim_crystal")
        parent:RemoveModifierByName("modifier_treasure_aghanim_scepter")
        self:StartIntervalThink(30)
    end
end

function modifier_treasure_aghanim_power:OnIntervalThink()
    local parent = self:GetParent()
    local nFXIndex1 = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_RENDERORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(nFXIndex1, 0, parent:GetOrigin())
    ParticleManager:ReleaseParticleIndex(nFXIndex1)
    local nFXIndex2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(nFXIndex2, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(nFXIndex2, 1, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(nFXIndex2)
    parent:Heal(parent:GetMaxHealth() * 0.5, nil)
    parent:GiveMana(math.ceil(parent:GetMaxMana() * 0.5))
end