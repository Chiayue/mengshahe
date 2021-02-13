modifier_silenced_lua = class({})

--------------------------------------------------------------------------------

function modifier_silenced_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_silenced_lua:DeclareFunctions()
	local funcs = {
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_silenced_lua:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}
	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
