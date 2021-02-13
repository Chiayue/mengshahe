require("info/game_playerinfo")


LinkLuaModifier("modifier_zhuozhuangchengzhang_lua","ability/abilities_lua/innateskill_zhuozhuangchengzhang_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
zhuozhuangchengzhang_lua = class({})

function zhuozhuangchengzhang_lua:GetIntrinsicModifierName()
	return "modifier_zhuozhuangchengzhang_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_zhuozhuangchengzhang_lua = class({})
--------------------------------------------------------------------------------

function modifier_zhuozhuangchengzhang_lua:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifier_zhuozhuangchengzhang_lua:IsHidden()
    return true
end

function modifier_zhuozhuangchengzhang_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_zhuozhuangchengzhang_lua,'hero_level_up'),self)
end

function modifier_zhuozhuangchengzhang_lua:hero_level_up(evt)
    local caster = self:GetAbility():GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    local level = caster:GetLevel()
    caster:SetModelScale(caster:GetModelScale() + 0.1)
    caster:SetBaseMoveSpeed(caster:GetBaseMoveSpeed() - self:GetAbility():GetSpecialValueFor("movespeed"))
    
    -- local player = EntIndexToHScript(evt.pl)
    -- ischange_str = true
    -- ischange_agi = true
    -- ischange_int = true
end