require("global/global_var_func")
require("info/game_playerinfo")

modifier_damage_percent_lua = class({})
--------------------------------------------------------------------------------

function modifier_damage_percent_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_damage_percent_lua:IsHidden()
    return true
end


function modifier_damage_percent_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_damage_percent_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_damage_percent_lua:OnCreated( kv )
    self.damage_percent = (self:GetAbility():GetSpecialValueFor( "damage_percent" ) or 0)
    if not IsServer( ) then
        return
	end
	self:StartIntervalThink( 0.01 )
    -- print(">>>>>>>>>>> OnCreated: "..self.damage_percent)
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

function modifier_damage_percent_lua:OnIntervalThink()
    self.damage_percent = (self:GetAbility():GetSpecialValueFor( "damage_percent" ) or 0)
	-- print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
	local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
	-- print(">>>>>>>>>>> steam_id: "..steam_id)
	game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", self.damage_percent)
    self:StartIntervalThink( -1 )
end

-- function modifier_damage_percent_lua:GetModifierDamageOutgoing_Percentage()
--     -- local caster = self:GetParent();
--     if not IsServer( ) then
--         return
--     end
--     -- print(">>>>>>>>>>> GetModifierAttackSpeedBonus_Constant: "..self.damage_percent)
-- 	return self.damage_percent
-- end

