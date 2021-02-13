LinkLuaModifier( "modifier_passive_changbiyuan_lua_d", "ability/abilities_lua/passive_changbiyuan_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_changbiyuan_lua_c", "ability/abilities_lua/passive_changbiyuan_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_changbiyuan_lua_b", "ability/abilities_lua/passive_changbiyuan_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_changbiyuan_lua_a", "ability/abilities_lua/passive_changbiyuan_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if passive_changbiyuan_lua_d == nil then
	passive_changbiyuan_lua_d = class({})
end

function passive_changbiyuan_lua_d:GetIntrinsicModifierName()
 	return "modifier_passive_changbiyuan_lua_d"
end
if passive_changbiyuan_lua_c == nil then
	passive_changbiyuan_lua_c = class({})
end

function passive_changbiyuan_lua_c:GetIntrinsicModifierName()
 	return "modifier_passive_changbiyuan_lua_c"
end
if passive_changbiyuan_lua_b == nil then
	passive_changbiyuan_lua_b = class({})
end

function passive_changbiyuan_lua_b:GetIntrinsicModifierName()
 	return "modifier_passive_changbiyuan_lua_b"
end
if passive_changbiyuan_lua_a == nil then
	passive_changbiyuan_lua_a = class({})
end

function passive_changbiyuan_lua_a:GetIntrinsicModifierName()
 	return "modifier_passive_changbiyuan_lua_a"
end
--------------------------------------------------
if modifier_passive_changbiyuan_lua_d == nil then
	modifier_passive_changbiyuan_lua_d = class({})
end

function modifier_passive_changbiyuan_lua_d:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_passive_changbiyuan_lua_d:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor( "range" )
end
-----------------------------
if modifier_passive_changbiyuan_lua_c == nil then
	modifier_passive_changbiyuan_lua_c = class({})
end

function modifier_passive_changbiyuan_lua_c:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_passive_changbiyuan_lua_c:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor( "range" )
end
-----------------------------
if modifier_passive_changbiyuan_lua_b == nil then
	modifier_passive_changbiyuan_lua_b = class({})
end

function modifier_passive_changbiyuan_lua_b:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_passive_changbiyuan_lua_b:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor( "range" )
end
-----------------------------
if modifier_passive_changbiyuan_lua_a == nil then
	modifier_passive_changbiyuan_lua_a = class({})
end

function modifier_passive_changbiyuan_lua_a:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_passive_changbiyuan_lua_a:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor( "range" )
end
-----------------------------
