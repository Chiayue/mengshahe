-- 宝物: 阿哈利姆神杖

if modifier_treasure_aghanim_scepter == nil then 
    modifier_treasure_aghanim_scepter = class({})
end

function modifier_treasure_aghanim_scepter:GetTexture()
    return "buff/modifier_treasure_aghanim_scepter"
end

function modifier_treasure_aghanim_scepter:IsHidden()
    return false
end

function modifier_treasure_aghanim_scepter:IsPurgable()
    return false
end
 
function modifier_treasure_aghanim_scepter:RemoveOnDeath()
    return false
end

function modifier_treasure_aghanim_scepter:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_aghanim_crystal") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_aghanim_power", nil)
        else
            self:StartIntervalThink(50)
        end
    end
end

function modifier_treasure_aghanim_scepter:OnIntervalThink()
    local parent = self:GetParent()
    local index = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_RENDERORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(index, 0, parent:GetOrigin())
    ParticleManager:ReleaseParticleIndex(index)
    parent:Heal(parent:GetMaxHealth() * 0.5, nil)
end