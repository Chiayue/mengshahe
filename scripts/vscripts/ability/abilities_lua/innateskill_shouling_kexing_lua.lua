LinkLuaModifier( "modifier_sublime_shouling_kexing_lua", "ability/abilities_lua/innateskill_shouling_kexing_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if sublime_shouling_kexing_lua == nil then
	sublime_shouling_kexing_lua = class({})
end

function sublime_shouling_kexing_lua:GetIntrinsicModifierName()
 	return "modifier_sublime_shouling_kexing_lua"
end
--------------------------------------------------
if modifier_sublime_shouling_kexing_lua == nil then
	modifier_sublime_shouling_kexing_lua = class({})
end

-- function modifier_sublime_shouling_kexing_lua:IsHidden()
--     return true
-- end

function modifier_sublime_shouling_kexing_lua:DeclareFunctions()
	local funcs = {
        
	}
	return funcs
end

function modifier_sublime_shouling_kexing_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_sublime_shouling_kexing_lua:OnIntervalThink()
    if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("damage") then
        createcommonunit(self:GetAbility():GetCaster():GetPlayerID(), 20)
        self:SetStackCount(0)
    end
end
