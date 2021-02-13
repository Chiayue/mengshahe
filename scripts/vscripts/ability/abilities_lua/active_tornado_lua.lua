active_tornado_lua = class({})
active_tornado_lua_d = active_tornado_lua
active_tornado_lua_c = active_tornado_lua
active_tornado_lua_b = active_tornado_lua
active_tornado_lua_a = active_tornado_lua
active_tornado_lua_s = active_tornado_lua

LinkLuaModifier("modifier_active_tornado_lua", "ability/abilities_lua/modifier/modifier_active_tornado_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_active_tornado_fly_lua", "ability/abilities_lua/modifier/modifier_active_tornado_fly_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_active_tornado_drop_point_lua", "ability/abilities_lua/modifier/modifier_active_tornado_drop_point_lua", LUA_MODIFIER_MOTION_NONE)

function active_tornado_lua:OnSpellStart()
    if not IsServer() then
        return
    end

    self.tornado = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_active_tornado_lua",
		nil, 
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
end

function active_tornado_lua:OnChannelFinish(bInterrupted)
    if self.tornado then
        self.tornado:Destroy()
    end
end