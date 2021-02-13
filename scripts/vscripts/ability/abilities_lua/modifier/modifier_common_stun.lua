modifier_common_stun = class({})

function modifier_common_stun:IsHidden()
	return false
end

function modifier_common_stun:IsPurgable()
    return false
end

function modifier_common_stun:IsDebuff()
	return true
end

function modifier_common_stun:IsStunDebuff()
	return true
end

function modifier_common_stun:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned_symbol.vpcf"
end

function modifier_common_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_common_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_common_stun:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end

function modifier_common_stun:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
	}
	return state
end