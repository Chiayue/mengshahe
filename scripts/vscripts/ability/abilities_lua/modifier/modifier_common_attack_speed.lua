modifier_common_attack_speed = class({})

function modifier_common_attack_speed:IsHidden()
	return false
end

function modifier_common_attack_speed:IsPurgable()
    return false
end

function modifier_common_attack_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_common_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return 1000
end