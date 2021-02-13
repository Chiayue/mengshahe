require("global/global_var_func")
require("info/game_playerinfo")

modifier_attack_speed_lua = class({})
--------------------------------------------------------------------------------

function modifier_attack_speed_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_attack_speed_lua:IsHidden()
    return true
end

function modifier_attack_speed_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_attack_speed_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_attack_speed_lua:OnCreated( kv )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	if not IsServer( ) then
        return
	end
	self:StartIntervalThink( 0.01 )
	-- print(">>>>>>>>>>>>> name: "..self:GetAbility():GetAbilityName())
	-- self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	-- DeepPrintTable(kv)
	-- self.attack_speed = kv.attack_speed
	-- print(">>>>>>>>>>> speed OnCreated22222222: "..self:GetAbility():GetSpecialValueFor( "attack_speed" ))
	-- local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
	-- print(">>>>>>>>>>> steam_id: "..steam_id)
	-- game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", self.attack_speed)
	-- DeepPrintTable(game_playerinfo:get_dynamic_properties(steam_id))
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	-- if IsServer() then
	-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
	-- 	self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	-- end
end

function modifier_attack_speed_lua:OnIntervalThink()
    self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	-- print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
	local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
	-- print(">>>>>>>>>>> steam_id: "..steam_id)
	game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", self.attack_speed)
    self:StartIntervalThink( -1 )
end

-- function modifier_attack_speed_lua:GetModifierAttackSpeedBonus_Constant()
-- 	-- 攻速变化
-- 	if not IsServer( ) then
--         return
-- 	end
-- 	print(">>>>>>>>>>> GetModifierAttackSpeedBonus_Constant: "..self.attack_speed)
-- 	-- local atk_speed = self:GetParent():GetAgility() * 0.5 + self.attack_speed
--     return 
-- end
