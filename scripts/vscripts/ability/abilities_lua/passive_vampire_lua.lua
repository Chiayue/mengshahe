require("global/global_var_func")
require("info/game_playerinfo")
LinkLuaModifier("modifier_passive_vampire_lua","ability/abilities_lua/passive_vampire_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_vampire_lua_d = class({})
function passive_vampire_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_vampire_lua"
end

passive_vampire_lua_c = class({})
function passive_vampire_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_vampire_lua"
end

passive_vampire_lua_b = class({})
function passive_vampire_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_vampire_lua"
end

passive_vampire_lua_a = class({})
function passive_vampire_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_vampire_lua"
end

passive_vampire_lua_s = class({})
function passive_vampire_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_vampire_lua"
end

if modifier_passive_vampire_lua == nil then
	modifier_passive_vampire_lua = class({})
end


function modifier_passive_vampire_lua:IsHidden()
    return true
end

function modifier_passive_vampire_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_vampire_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_vampire_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end
function modifier_passive_vampire_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(0.1)
    ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_passive_vampire_lua,'killed_monster'),self)
end

function modifier_passive_vampire_lua:OnIntervalThink()
    self.caster = self:GetAbility():GetCaster()
    self.base_health = self:GetAbility():GetSpecialValueFor("base_health")
    self.scale = self:GetAbility():GetSpecialValueFor("scale")
	local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "attack_heal", self.base_health)
    self:StartIntervalThink(-1)
end

function modifier_passive_vampire_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
   
    if not hero:IsHero() then
        return
    end
    if hero~=self.caster then
        -- 怪必须是自己击杀的
        return
    end
    local health_value = self.caster:GetStrength() * self.scale

    self.caster:Heal(health_value,self.caster)
    -- end
end
