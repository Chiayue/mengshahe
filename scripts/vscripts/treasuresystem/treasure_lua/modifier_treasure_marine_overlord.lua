-- 宝物: 海洋霸主

if modifier_treasure_marine_overlord == nil then 
    modifier_treasure_marine_overlord = class({})
end

function modifier_treasure_marine_overlord:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_treasure_marine_overlord:GetModifierConstantHealthRegen()
    return 2000
end

function modifier_treasure_marine_overlord:GetTexture()
    return "buff/modifier_treasure_marine_overlord"
end

function modifier_treasure_marine_overlord:IsHidden()
    return false
end

function modifier_treasure_marine_overlord:IsPurgable()
    return false
end
 
function modifier_treasure_marine_overlord:RemoveOnDeath()
    return false
end
 
function modifier_treasure_marine_overlord:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_beerbung")
        parent:RemoveModifierByName("modifier_treasure_leviathan_skin")
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "reduce_attack_point", 500)
    end
end

function modifier_treasure_marine_overlord:OnDestroy()
    if IsServer() then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "reduce_attack_point", -500)
    end
end
