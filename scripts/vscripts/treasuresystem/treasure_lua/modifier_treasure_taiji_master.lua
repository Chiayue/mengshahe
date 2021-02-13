-- 宝物: 怒意

if modifier_treasure_taiji_master == nil then 
    modifier_treasure_taiji_master = class({})
end

function modifier_treasure_taiji_master:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_taiji_master"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_taiji_master:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_taiji_master:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_taiji_master:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_taiji_master:GetModifierBonusStats_Strength()
    return 400
end

function modifier_treasure_taiji_master:GetModifierBonusStats_Agility()
    return 400
end

function modifier_treasure_taiji_master:GetModifierBonusStats_Intellect()
    return 400
end

function modifier_treasure_taiji_master:GetModifierAttackSpeedBonus_Constant()
    return -250
end