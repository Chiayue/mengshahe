-- 宝物: 阿哈利姆结晶

if modifier_treasure_aghanim_crystal == nil then 
    modifier_treasure_aghanim_crystal = class({})
end

function modifier_treasure_aghanim_crystal:GetTexture()
    return "buff/modifier_treasure_aghanim_crystal"
end

function modifier_treasure_aghanim_crystal:IsHidden()
    return false
end

function modifier_treasure_aghanim_crystal:IsPurgable()
    return false
end

function modifier_treasure_aghanim_crystal:RemoveOnDeath()
    return false
end

function modifier_treasure_aghanim_crystal:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_aghanim_scepter") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_aghanim_power", nil)
        else
            self:StartIntervalThink(50)
        end
    end
end

function modifier_treasure_aghanim_crystal:OnIntervalThink()
    local parent = self:GetParent()
    local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    parent:GiveMana(math.ceil(parent:GetMaxMana() * 0.5)) 
end