---------------------------------------------------------------------------
-- 宝物：金钱就是力量
---------------------------------------------------------------------------

if modifier_treasure_money_power == nil then 
    modifier_treasure_money_power = class({})
end

function modifier_treasure_money_power:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_money_power"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_money_power:DeclareFunctions()
	return {
        -- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

-- function modifier_treasure_money_power:GetModifierTotalDamageOutgoing_Percentage()
--     if IsServer() then
--         local money = game_playerinfo:get_player_gold(self:GetParent():GetPlayerID())
--         local percentage = math.floor(money / 5000) * 0.2
--         if percentage > 50 then
--             return 50
--         end
--         return percentage
--     end
--     return 0
-- end

function modifier_treasure_money_power:IsPurgable()
    return false
end
 
function modifier_treasure_money_power:RemoveOnDeath()
    return false
end

function modifier_treasure_money_power:OnCreated(kv)
    if IsServer() then
        self.current_added = 0
        self:StartIntervalThink(3)
    end
end

function modifier_treasure_money_power:OnIntervalThink() 
    local parent = self:GetParent()
    local money = game_playerinfo:get_player_gold(self:GetParent():GetPlayerID())
    local percentage = math.floor(money / 5000) * 2

    if percentage > 50 then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID()), "extra_attack_scale", 50 - self.current_added)
        self.current_added = 50
    else
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID()), "extra_attack_scale", percentage - self.current_added)
        self.current_added = percentage
    end
end

-- function modifier_treasure_money_power:OnDestroy()
--     if IsServer() then
--         if self.percentage > 50 then
--             game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID()), "extra_attack_scale", -50)
--         end
--         game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID()), "extra_attack_scale", -1*self.percentage)
--     end
-- end