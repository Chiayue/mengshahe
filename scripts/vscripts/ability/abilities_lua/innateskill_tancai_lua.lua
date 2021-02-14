
require("info/game_playerinfo")

LinkLuaModifier( "modifier_tancai_lua", "ability/abilities_lua/innateskill_tancai_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if tancai_lua == nil then
	tancai_lua = class({})
end

function tancai_lua:GetIntrinsicModifierName()
 	return "modifier_tancai_lua"
end
--------------------------------------------------
if modifier_tancai_lua == nil then
	modifier_tancai_lua = class({})
end

function modifier_tancai_lua:IsHidden()
    return true
end

function modifier_tancai_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_tancai_lua:DeclareFunctions()
	local funcs = {
       
	}
	return funcs
end

function modifier_tancai_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.damagepercent = 0
    self:StartIntervalThink(1)
end

function modifier_tancai_lua:OnIntervalThink()
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    local playerID = self:GetAbility():GetCaster():GetPlayerID()
    local gold = game_playerinfo:get_player_gold(playerID)
    if self.damagepercent ~= 0 then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", -self.damagepercent)
    end
    self.damagepercent = math.floor(gold/self:GetAbility():GetSpecialValueFor("gold"))*self:GetAbility():GetSpecialValueFor("percent")
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", self.damagepercent)
end

function modifier_tancai_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    if self.damagepercent ~= 0 then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", -self.damagepercent)
    end
end
-------------------------------------------------

LinkLuaModifier( "modifier_sublime_tancai_lua", "ability/abilities_lua/innateskill_tancai_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if sublime_tancai_lua == nil then
	sublime_tancai_lua = class({})
end

function sublime_tancai_lua:GetIntrinsicModifierName()
 	return "modifier_sublime_tancai_lua"
end
--------------------------------------------------
if modifier_sublime_tancai_lua == nil then
	modifier_sublime_tancai_lua = class({})
end

function modifier_sublime_tancai_lua:IsHidden()
    return true
end

function modifier_sublime_tancai_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_sublime_tancai_lua:DeclareFunctions()
	local funcs = {

	}
	return funcs
end

function modifier_sublime_tancai_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.damagepercent = 0
    self:StartIntervalThink(1)
end

function modifier_sublime_tancai_lua:OnIntervalThink()
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    local playerID = self:GetAbility():GetCaster():GetPlayerID()
    local gold = game_playerinfo:get_player_gold(playerID)
    if self.damagepercent ~= 0 then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", -self.damagepercent)
    end
    self.damagepercent = math.floor(gold/self:GetAbility():GetSpecialValueFor("gold"))*self:GetAbility():GetSpecialValueFor("percent")
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", self.damagepercent)
end

