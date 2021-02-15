modifier_test = class({})

function modifier_test:IsHidden()
	return false
end

function modifier_test:IsPurgable()
    return false
end

function modifier_test:RemoveOnDeath()
    return false
end

function modifier_test:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
end

function modifier_test:GetModifierExtraHealthBonus()
    return 1000 * 10000
end

function modifier_test:GetModifierAvoidDamage()
    return 1
end

function modifier_test:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

function modifier_test:GetModifierAttackSpeedBonus_Constant()
    return 1000
end

function modifier_test:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_test:OnIntervalThink()
    self:SetStackCount(RandomInt(0, 999999))
end