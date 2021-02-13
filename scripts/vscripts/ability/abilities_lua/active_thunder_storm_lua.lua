active_thunder_storm_lua = class({})
active_thunder_storm_lua_d = active_thunder_storm_lua
active_thunder_storm_lua_c = active_thunder_storm_lua
active_thunder_storm_lua_b = active_thunder_storm_lua
active_thunder_storm_lua_a = active_thunder_storm_lua
active_thunder_storm_lua_s = active_thunder_storm_lua

LinkLuaModifier("modifier_active_thunder_storm_lua", "ability/abilities_lua/modifier/modifier_active_thunder_storm_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stun_lua", "ability/abilities_lua/modifier/modifier_stun_lua", LUA_MODIFIER_MOTION_NONE)

function active_thunder_storm_lua:GetAOERadius()
	return 500
end

function active_thunder_storm_lua:OnSpellStart()
	CreateModifierThinker(
		self:GetCaster(), 
		self, 
		"modifier_active_thunder_storm_lua", 
		{
			duration = 30
		}, 
		self:GetCursorPosition(), 
		self:GetCaster():GetTeamNumber(), 
		false
	)
end