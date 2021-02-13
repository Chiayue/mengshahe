-- 腐朽圣剑

LinkLuaModifier( "modifier_treasure_decay_mana_str","treasuresystem/treasure_lua/modifier_treasure_decay_mana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_decay_mana_agi","treasuresystem/treasure_lua/modifier_treasure_decay_mana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_decay_mana_int","treasuresystem/treasure_lua/modifier_treasure_decay_mana", LUA_MODIFIER_MOTION_NONE )


if modifier_treasure_decay_mana == nil then 
    modifier_treasure_decay_mana = class({})
end

function modifier_treasure_decay_mana:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_decay_mana"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_decay_mana:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_decay_mana:GetModifierBonusStats_Strength()
    return -50
end

function modifier_treasure_decay_mana:GetModifierBonusStats_Agility()
    return -50
end

function modifier_treasure_decay_mana:GetModifierBonusStats_Intellect()
    return -50
end

function modifier_treasure_decay_mana:IsPurgable() 
    return false
end

function modifier_treasure_decay_mana:RemoveOnDeath() 
    return false
end

function modifier_treasure_decay_mana:OnCreated(params)
    if IsServer() then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "attack_critical_damage", 1.5)
    end
end

function modifier_treasure_decay_mana:OnDestroy()
    if IsServer() then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "attack_critical_damage", -1.5)
    end
end