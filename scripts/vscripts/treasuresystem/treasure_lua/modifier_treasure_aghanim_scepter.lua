-- 宝物: 阿哈利姆神杖

if modifier_treasure_aghanim_scepter == nil then 
    modifier_treasure_aghanim_scepter = class({})
end

function modifier_treasure_aghanim_scepter:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_aghanim_scepter"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_aghanim_scepter:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_aghanim_scepter:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_aghanim_scepter:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_aghanim_crystal") then
            local mdf = parent:FindModifierByName("modifier_treasure_aghanim_crystal")
            local stack_count = mdf:GetStackCount()
            if stack_count > 30 then
                mdf:SetStackCount(30)
            end
        end
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_aghanim_scepter:OnIntervalThink()
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then
        local parent = self:GetParent()
        local index = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_RENDERORIGIN_FOLLOW, parent)
        ParticleManager:SetParticleControl(index, 0, parent:GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
        parent:Heal(parent:GetMaxHealth() * 0.5, nil)
        if parent:HasModifier("modifier_treasure_aghanim_crystal") then
            self:SetStackCount(30)
        else
            self:SetStackCount(50)
        end
    end
end