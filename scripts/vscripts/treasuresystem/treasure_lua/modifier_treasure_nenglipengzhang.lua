
-- 宝物: 能力膨胀

if modifier_treasure_nenglipengzhang == nil then 
    modifier_treasure_nenglipengzhang = class({})
end

function modifier_treasure_nenglipengzhang:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_nenglipengzhang"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_nenglipengzhang:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_nenglipengzhang:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_nenglipengzhang:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_treasure_nenglipengzhang:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
end

function modifier_treasure_nenglipengzhang:GetModifierBonusStats_Agility()
    return 500
end

function modifier_treasure_nenglipengzhang:GetModifierBonusStats_Intellect()
    return 500
end

function modifier_treasure_nenglipengzhang:GetModifierBonusStats_Strength()
    return 500
end

function modifier_treasure_nenglipengzhang:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        -- 玩家击杀计数
        if self:GetStackCount() < 500 then
            self:IncrementStackCount()
        end
    end
end