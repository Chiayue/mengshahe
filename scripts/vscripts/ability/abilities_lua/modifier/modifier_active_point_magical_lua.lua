modifier_active_point_magical_lua = class({})

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:GetEffectName()
	return "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
