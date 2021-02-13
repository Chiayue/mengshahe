LinkLuaModifier( "modifier_archon_ability_tornado", "ability/abilities_lua/archon_ability_tornado.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
-- 龙卷风
--
if archon_ability_tornado == nil then
	archon_ability_tornado = class({})
end

if modifier_archon_ability_tornado == nil then
	modifier_archon_ability_tornado = class({})
end
function archon_ability_tornado:OnSpellStart()
	self.tornado_speed = self:GetSpecialValueFor( "tornado_speed" )
	self.tornado_width_initial = self:GetSpecialValueFor( "tornado_width_initial" )
	self.tornado_width_end = self:GetSpecialValueFor( "tornado_width_end" )
	self.tornado_distance = self:GetSpecialValueFor( "tornado_distance" )
	self.tornado_damage = self:GetSpecialValueFor( "tornado_damage" ) 
	self.tornado_duration = self:GetSpecialValueFor( "tornado_duration" ) 
	self.tornado_movespeed_out = self:GetSpecialValueFor( "tornado_movespeed_out" ) 

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.tornado_width_initial,
		fEndRadius = self.tornado_width_end,
		vVelocity = vDirection * self.tornado_speed,
		fDistance = self.tornado_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
end

function archon_ability_tornado:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.tornado_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		hTarget:AddNewModifier( 
			self:GetCaster(), 
			self, 
			"modifier_archon_ability_tornado", 
			{ duration = self.tornado_duration } 
		)
	end

	return false
end

--------------------

function modifier_archon_ability_tornado:IsDebuff()
	return true
end

function modifier_archon_ability_tornado:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_archon_ability_tornado:GetModifierMoveSpeedBonus_Percentage()
	return self.tornado_movespeed_out
end

function modifier_archon_ability_tornado:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_tornado_dust_trail_b.vpcf"
end


function modifier_archon_ability_tornado:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_archon_ability_tornado:OnCreated( kv )
	self.tornado_movespeed_out = self:GetAbility():GetSpecialValueFor( "tornado_movespeed_out" )
end

--------------------------------------------------------------------------------

function modifier_archon_ability_tornado:OnRefresh( kv )
	self.tornado_movespeed_out = self:GetAbility():GetSpecialValueFor( "tornado_movespeed_out" )
end