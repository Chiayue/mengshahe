modifier_stun_lua = class({})

function modifier_stun_lua:IsDebuff()
	return true
end

function modifier_stun_lua:IsStunDebuff()
	return true
end

function modifier_stun_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_stun_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_stun_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_stun_lua:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end

function modifier_stun_lua:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
	}
	return state
end