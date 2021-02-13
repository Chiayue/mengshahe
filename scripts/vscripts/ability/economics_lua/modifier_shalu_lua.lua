require("global/global_var_func")
require("info/game_playerinfo")
require("global/msg")

modifier_shalu_lua = class({})
--------------------------------------------------------------------------------

function modifier_shalu_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_shalu_lua:GetTexture()
    return "modifier_shalu_lua"
end


function modifier_shalu_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_shalu_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_shalu_lua:OnRefresh(params)
    if IsServer() then
        return self:IncrementStackCount	()
    end
end

function modifier_shalu_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_shalu_lua,'killed_monster'),self)
end

function modifier_shalu_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)

    if hero == self.caster then
        local percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "shalu_increase")
        local skill_level = self:GetStackCount()+global_var_func.extra_operate_level[self.caster:GetPlayerID() + 1]["modifier_shalu_lua"]
        local addvalue = math.ceil(skill_level*1*(100+percent)/100)
        game_playerinfo:set_player_gold(self.caster:GetPlayerID(),addvalue)
        -- game_playerinfo:update_player_economic(self.caster:GetPlayerID(), addvalue)
        PopupGoldGain(self.caster, addvalue)
    end
end

function modifier_shalu_lua:OnTooltip()
	return self:GetStackCount()*2
end

function modifier_shalu_lua:IsHidden()
	return true
end
