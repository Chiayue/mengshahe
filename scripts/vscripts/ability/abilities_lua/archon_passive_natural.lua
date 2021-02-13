LinkLuaModifier( "modifier_archon_passive_natural", "ability/abilities_lua/archon_passive_natural.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archon_passive_natural_debuff", "ability/abilities_lua/archon_passive_natural.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_natural == nil then
	archon_passive_natural = class({})
end

if modifier_archon_passive_natural_debuff == nil then
	modifier_archon_passive_natural_debuff = class({})
end

function archon_passive_natural:GetIntrinsicModifierName()
 	return "modifier_archon_passive_natural"
end
--------------------------------------------------
if modifier_archon_passive_natural == nil then
	modifier_archon_passive_natural = class({})
end

function modifier_archon_passive_natural:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_archon_passive_natural:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	local hTarget = params.target
	local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
	local abil_damage = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor( "coefficient" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	
	hTarget:AddNewModifier( 
		self:GetCaster(), 
		self:GetAbility(), 
		"modifier_archon_passive_natural_debuff", 
		{ duration = duration} 
	)
	
	local Modifiers = hTarget:FindModifierByName("modifier_archon_passive_natural_debuff")
	local stacks = 0
	if Modifiers ~= nil then
		stacks =Modifiers:GetStackCount()
	end

	local damage = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = abil_damage * (1 + stacks * 0.2),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage( damage )
end

--------------------------------------------------------------------------------

function modifier_archon_passive_natural_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_archon_passive_natural_debuff:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

function modifier_archon_passive_natural_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_archon_passive_natural_debuff:OnCreated( kv )
end


function modifier_archon_passive_natural_debuff:OnRefresh( kv )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stacks" )
	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
	end
end





