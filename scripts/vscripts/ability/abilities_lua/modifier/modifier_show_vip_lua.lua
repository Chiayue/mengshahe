require("global/global_var_func")
require("info/game_playerinfo")

modifier_show_vip_lua = class({})
--------------------------------------------------------------------------------

function modifier_show_vip_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_show_vip_lua:IsHidden()
    return true
end
function modifier_show_vip_lua:OnCreated( kv )
	-- self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

function modifier_show_vip_lua:GetModifierBaseAttack_BonusDamage()
    -- local caster = self:GetParent();
    -- print(">>>>>>>>>>> str: "..caster:GetStrength())
	return (self:GetParent():GetStrength() * 3);
end
