-- 宝物: 阿哈利姆结晶


if modifier_treasure_aghanim_crystal == nil then 
    modifier_treasure_aghanim_crystal = class({})
end

function modifier_treasure_aghanim_crystal:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_aghanim_crystal"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_aghanim_crystal:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_aghanim_crystal:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_aghanim_crystal:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_aghanim_scepter") then
            local mdf = parent:FindModifierByName("modifier_treasure_aghanim_scepter")
            local stack_count = mdf:GetStackCount()
            if stack_count > 30 then
                mdf:SetStackCount(30)
            end
        end
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_aghanim_crystal:OnIntervalThink()
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then
        local parent = self:GetParent()
        local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        parent:GiveMana(math.ceil(parent:GetMaxMana() * 0.5)) 
        if parent:HasModifier("modifier_treasure_aghanim_scepter") then
            self:SetStackCount(30)
        else
            self:SetStackCount(50)
        end
    end
end