ambulance_lua = class({})
LinkLuaModifier("modifier_ambulance_lua","ability/abilities_lua/modifier/modifier_ambulance_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ambulance_lua:GetIntrinsicModifierName()
	return "modifier_ambulance_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
