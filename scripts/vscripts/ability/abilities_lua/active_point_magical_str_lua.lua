require("global/random_affix")
active_point_magical_str_lua_d = class({})
LinkLuaModifier( "modifier_active_point_magical_lua","ability/abilities_lua/modifier/modifier_active_point_magical_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_active_point_magical_lua_thinker","ability/abilities_lua/modifier/modifier_active_point_magical_lua_thinker", LUA_MODIFIER_MOTION_NONE )
-- 添加随机词条模块
LinkLuaModifier( "modifier_active_point_magical_str_lua","ability/abilities_lua/active_point_magical_str_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function active_point_magical_str_lua_d:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------

function active_point_magical_str_lua_d:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_active_point_magical_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function active_point_magical_str_lua_d:GetIntrinsicModifierName()
	return "modifier_active_point_magical_str_lua"
end
--------------------------------------------------------------------------------
active_point_magical_str_lua_c = class({})

function active_point_magical_str_lua_c:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

function active_point_magical_str_lua_c:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_active_point_magical_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function active_point_magical_str_lua_c:GetIntrinsicModifierName()
	return "modifier_active_point_magical_str_lua"
end

--------------------------------------------------------------------------------
active_point_magical_str_lua_b = class({})

function active_point_magical_str_lua_b:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

function active_point_magical_str_lua_b:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_active_point_magical_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function active_point_magical_str_lua_b:GetIntrinsicModifierName()
	return "modifier_active_point_magical_str_lua"
end

--------------------------------------------------------------------------------
active_point_magical_str_lua_a = class({})

function active_point_magical_str_lua_a:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

function active_point_magical_str_lua_a:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_active_point_magical_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function active_point_magical_str_lua_a:GetIntrinsicModifierName()
	return "modifier_active_point_magical_str_lua"
end


if modifier_active_point_magical_str_lua == nil then
	modifier_active_point_magical_str_lua = class({})
end


function modifier_active_point_magical_str_lua:IsHidden()
    return true
end

function modifier_active_point_magical_str_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_active_point_magical_str_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_active_point_magical_str_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_active_point_magical_str_lua:OnCreated(params)
    if not IsServer( ) then
        return
	end
end

function modifier_active_point_magical_str_lua:OnDestroy()
	if not IsServer( ) then
        return
    end
end