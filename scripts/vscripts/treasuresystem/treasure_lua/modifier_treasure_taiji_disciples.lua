-- 宝物: 太极门徒

if modifier_treasure_taiji_disciples == nil then 
    modifier_treasure_taiji_disciples = class({})
end

function modifier_treasure_taiji_disciples:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_taiji_disciples"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_taiji_disciples:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_taiji_disciples:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_taiji_disciples:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_taiji_disciples:GetModifierBonusStats_Strength()
    return 200
end

function modifier_treasure_taiji_disciples:GetModifierBonusStats_Agility()
    return 200
end

function modifier_treasure_taiji_disciples:GetModifierBonusStats_Intellect()
    return 200
end

function modifier_treasure_taiji_disciples:GetModifierAttackSpeedBonus_Constant()
    return -150
end