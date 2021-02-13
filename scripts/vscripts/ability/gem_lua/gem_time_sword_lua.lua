gem_time_sword_lua = class({})
LinkLuaModifier("modifier_gem_time_sword_lua","ability/gem_lua/gem_time_sword_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_time_sword_lua:GetIntrinsicModifierName()
	return "modifier_gem_time_sword_lua"
end

if modifier_gem_time_sword_lua == nil then
	modifier_gem_time_sword_lua = class({})
end

function modifier_gem_time_sword_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_EVENT_ON_RESPAWN,
    }
    return funcs
end

function modifier_gem_time_sword_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_time_sword_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_time_sword_lua:OnCreated(params)
    -- self.damage_percent = (self:GetAbility():GetSpecialValueFor( "damage_percent" ) or 0)
    if not IsServer( ) then
        return
	end
	self:StartIntervalThink( 60 )
end

function modifier_gem_time_sword_lua:OnIntervalThink()
    self.damage_percent = (self:GetAbility():GetSpecialValueFor( "damage_percent" ) or 0)
	-- print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
	local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
	-- print(">>>>>>>>>>> steam_id: "..steam_id)
	game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", self.damage_percent)
end
