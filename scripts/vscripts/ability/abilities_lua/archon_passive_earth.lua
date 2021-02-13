LinkLuaModifier( "modifier_archon_passive_earth", "ability/abilities_lua/archon_passive_earth.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archon_passive_earth_attackdown", "ability/abilities_lua/archon_passive_earth.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_earth == nil then
	archon_passive_earth = class({})
end

if modifier_archon_passive_earth_attackdown == nil then
	modifier_archon_passive_earth_attackdown = class({})
end

function archon_passive_earth:GetIntrinsicModifierName()
 	return "modifier_archon_passive_earth"
end
--------------------------------------------------
if modifier_archon_passive_earth == nil then
	modifier_archon_passive_earth = class({})
end

function modifier_archon_passive_earth:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_archon_passive_earth:OnAttackLanded( params )
	local hTarget = params.target
	local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
	local abil_damage = self:GetCaster():GetHealth() * self:GetAbility():GetSpecialValueFor( "coefficient" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local str = self:GetCaster():GetStrength()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		hTarget:GetOrigin(), 
		hTarget, 
		aoe, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)
	-- self.damage_out = self:GetAbility():GetSpecialValueFor( "damage_out" )
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = abil_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			enemy:AddNewModifier( 
				self:GetCaster(), 
				self:GetAbility(), 
				"modifier_archon_passive_earth_attackdown", 
				{ duration = duration} 
			)
			
			ApplyDamage( damage )
			
		end
	end
end

-----------------------------

function modifier_archon_passive_earth_attackdown:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_archon_passive_earth_attackdown:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_archon_passive_earth_attackdown:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_archon_passive_earth_attackdown:OnCreated( kv )
	self.damage_out = self:GetAbility():GetSpecialValueFor( "damage_out" )
	self.bonus_damage = -self:GetCaster():GetStrength()
end

--------------------------------------------------------------------------------

function modifier_archon_passive_earth_attackdown:OnRefresh( kv )
	self.damage_out = self:GetAbility():GetSpecialValueFor( "damage_out" )
	self.bonus_damage = -self:GetCaster():GetStrength()
end

--------------------------------------------------------------------------------

function modifier_archon_passive_earth_attackdown:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE 
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_archon_passive_earth_attackdown:GetModifierDamageOutgoing_Percentage()
	return self.damage_out
end

function modifier_archon_passive_earth_attackdown:GetModifierPreAttack_BonusDamage( kv )
	return self.bonus_damage
end
