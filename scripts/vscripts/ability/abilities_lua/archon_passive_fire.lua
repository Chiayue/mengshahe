-- LinkLuaModifier( "modifier_archon_passive_fire", "ability/archon_passive_fire.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_fire == nil then
	archon_passive_fire = class({})
end

function archon_passive_fire:GetIntrinsicModifierName()
 	return "modifier_archon_passive_fire"
end

--------------------------------------------------------------------------------
if modifier_archon_passive_fire == nil then
	modifier_archon_passive_fire = class({})
end

function modifier_archon_passive_fire:IsDebuff()
	return false
end

function modifier_archon_passive_fire:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	--self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end


function modifier_archon_passive_fire:IsHidden()
	return true
end

function modifier_archon_passive_fire:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	--self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end

function modifier_archon_passive_fire:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end


function modifier_archon_passive_fire:OnAttack( params )
	-- 开始攻击时
end
--------------------------------------------------------------------------------

