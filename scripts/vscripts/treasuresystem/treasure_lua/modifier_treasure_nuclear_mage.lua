-- 宝物: 法师灵核


if modifier_treasure_nuclear_mage == nil then 
    modifier_treasure_nuclear_mage = class({})
end

function modifier_treasure_nuclear_mage:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_nuclear_mage"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_nuclear_mage:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_nuclear_mage:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_nuclear_mage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_treasure_nuclear_mage:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    local steam_id = PlayerResource:GetSteamAccountID( self.caster:GetPlayerID() )
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", -100)
    game_playerinfo:set_dynamic_properties(steam_id, "magic_attack_scale", 30)
    game_playerinfo:set_dynamic_properties(steam_id, "mana_regen", 3)
end

function modifier_treasure_nuclear_mage:GetModifierDamageOutgoing_Percentage()
	return -50
end