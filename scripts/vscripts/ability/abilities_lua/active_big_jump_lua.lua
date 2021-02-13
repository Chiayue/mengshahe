active_big_jump_lua = class({})
active_big_jump_lua_b = active_big_jump_lua
active_big_jump_lua_a = active_big_jump_lua
active_big_jump_lua_s = active_big_jump_lua

LinkLuaModifier("modifier_active_big_jump_lua", "ability/abilities_lua/modifier/modifier_active_big_jump_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_active_big_jump_bianshen_lua", "ability/abilities_lua/modifier/modifier_active_big_jump_bianshen_lua", LUA_MODIFIER_MOTION_NONE)

function active_big_jump_lua:GetAOERadius()
	return 500
end

function active_big_jump_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_active_big_jump_bianshen_lua", {duration = 20})
end