require("global/global_var_func")
require("info/game_playerinfo")

modifier_extra_strength_lua = class({})
--------------------------------------------------------------------------------

function modifier_extra_strength_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS ,
    }
    return funcs
end

function modifier_extra_strength_lua:IsHidden()
    return true
end
function modifier_extra_strength_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_extra_strength_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_extra_strength_lua:OnCreated( kv )
    self.strength = self:GetAbility():GetSpecialValueFor( "strength" )
    if not IsServer( ) then
        return
    end
	self:StartIntervalThink( 0.01 )
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

function modifier_extra_strength_lua:OnIntervalThink()
    self.strength = self:GetAbility():GetSpecialValueFor( "strength" )
    self:StartIntervalThink( -1 )
end

function modifier_extra_strength_lua:GetModifierBonusStats_Intellect()
	return self.strength
end

