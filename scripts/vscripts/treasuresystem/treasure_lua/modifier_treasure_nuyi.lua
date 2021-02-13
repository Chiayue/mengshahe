-- 宝物: 怒意

LinkLuaModifier( "modifier_treasure_nuyi_str","treasuresystem/treasure_lua/modifier_treasure_nuyi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_nuyi_agi","treasuresystem/treasure_lua/modifier_treasure_nuyi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_nuyi_int","treasuresystem/treasure_lua/modifier_treasure_nuyi", LUA_MODIFIER_MOTION_NONE )


if modifier_treasure_nuyi == nil then 
    modifier_treasure_nuyi = class({})
end

function modifier_treasure_nuyi:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_nuyi"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_nuyi:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_nuyi:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_nuyi:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_nuyi:GetModifierBonusStats_Strength()
    return -50
end

function modifier_treasure_nuyi:GetModifierBonusStats_Agility()
    return -50
end

function modifier_treasure_nuyi:GetModifierBonusStats_Intellect()
    return -50
end

function modifier_treasure_nuyi:GetModifierAttackSpeedBonus_Constant()
    return 80
end