require("global/global_var_func")
require("info/game_playerinfo")
require("global/msg")

modifier_addgold_second_lua = class({})
--------------------------------------------------------------------------------

function modifier_addgold_second_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_addgold_second_lua:GetTexture()
    return "modifier_addgold_second_lua"
end

function modifier_addgold_second_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_addgold_second_lua:OnRefresh(params)
    if IsServer() then
        return self:IncrementStackCount	()
    end
end

function modifier_addgold_second_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_addgold_second_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    self:StartIntervalThink(1)
end

function modifier_addgold_second_lua:OnIntervalThink()
    local addvalue = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "extra_addgold_second")
    game_playerinfo:set_player_gold(self.caster:GetPlayerID(),addvalue)
    -- game_playerinfo:update_player_economic(self.caster:GetPlayerID(), addvalue)
    PopupGoldGain(self.caster, addvalue)
end

function modifier_addgold_second_lua:IsHidden()
	return true
end
