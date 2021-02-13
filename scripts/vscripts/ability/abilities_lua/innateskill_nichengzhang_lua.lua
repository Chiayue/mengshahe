require("info/game_playerinfo")


LinkLuaModifier("modifier_nichengzhang_lua","ability/abilities_lua/innateskill_nichengzhang_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
nichengzhang_lua = class({})

function nichengzhang_lua:GetIntrinsicModifierName()
	return "modifier_nichengzhang_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_nichengzhang_lua = class({})
--------------------------------------------------------------------------------

function modifier_nichengzhang_lua:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifier_nichengzhang_lua:IsHidden()
    return true
end

function modifier_nichengzhang_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_nichengzhang_lua,'hero_level_up'),self)
end

function modifier_nichengzhang_lua:hero_level_up(evt)
    local caster = self:GetAbility():GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    caster:SetModelScale(caster:GetModelScale() - 0.1)
    caster:SetBaseMoveSpeed(caster:GetBaseMoveSpeed() + self:GetAbility():GetSpecialValueFor("movespeed"))
    local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", self:GetAbility():GetSpecialValueFor("attackspeed"))
end