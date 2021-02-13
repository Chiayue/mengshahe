
LinkLuaModifier("modifier_passive_pillage_lua","ability/abilities_lua/passive_pillage_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_pillage_lua_e = class({})
function passive_pillage_lua_e:GetIntrinsicModifierName()
	return "modifier_passive_pillage_lua"
end


passive_pillage_lua_d = class({})
function passive_pillage_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_pillage_lua"
end

passive_pillage_lua_c = class({})
function passive_pillage_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_pillage_lua"
end

passive_pillage_lua_b = class({})
function passive_pillage_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_pillage_lua"
end

passive_pillage_lua_a = class({})
function passive_pillage_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_pillage_lua"
end

if modifier_passive_pillage_lua == nil then
	modifier_passive_pillage_lua = class({})
end


function modifier_passive_pillage_lua:IsHidden()
    return true
end

function modifier_passive_pillage_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_pillage_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_pillage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function modifier_passive_pillage_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_passive_pillage_lua:OnAttackLanded(params)
    -- DeepPrintTable(params)
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        game_playerinfo:set_player_gold(caster:GetPlayerID(),self:GetAbility():GetSpecialValueFor("gold"))
    end
    return
end
