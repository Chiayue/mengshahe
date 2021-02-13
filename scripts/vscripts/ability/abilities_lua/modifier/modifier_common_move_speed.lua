modifier_common_move_speed = class({})

function modifier_common_move_speed:IsHidden()
	return false
end

function modifier_common_move_speed:IsPurgable()
    return false
end

function modifier_common_move_speed:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned.vpcf"
end

function modifier_common_move_speed:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_common_move_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_common_move_speed:OnCreated(params)
	if IsServer() then
		self.movespeed_reduce = self:GetAbility().movespeed_reduce
	end
end

function modifier_common_move_speed:GetModifierMoveSpeedBonus_Percentage(params)
	if not self.movespeed_reduce then
		self.movespeed_reduce = -100
	end
	return self.movespeed_reduce
end