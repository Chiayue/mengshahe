-- 宝物: 太极大师

if modifier_treasure_taiji_intermediate == nil then 
    modifier_treasure_taiji_intermediate = class({})
end

function modifier_treasure_taiji_intermediate:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_taiji_intermediate"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_taiji_intermediate:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_taiji_intermediate:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_taiji_intermediate:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_taiji_intermediate:GetModifierBonusStats_Strength()
    return 300
end

function modifier_treasure_taiji_intermediate:GetModifierBonusStats_Agility()
    return 300
end

function modifier_treasure_taiji_intermediate:GetModifierBonusStats_Intellect()
    return 300
end

function modifier_treasure_taiji_intermediate:GetModifierAttackSpeedBonus_Constant()
    return -200
end