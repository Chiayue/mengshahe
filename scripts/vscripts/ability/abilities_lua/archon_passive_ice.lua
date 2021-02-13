LinkLuaModifier( "modifier_archon_passive_ice", "ability/abilities_lua/archon_passive_ice.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archon_passive_ice_attackdown", "ability/abilities_lua/archon_passive_ice.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_ice == nil then
	archon_passive_ice = class({})
end

if modifier_archon_passive_ice_attackdown == nil then
	modifier_archon_passive_ice_attackdown = class({})
end

function archon_passive_ice:GetIntrinsicModifierName()
 	return "modifier_archon_passive_ice"
end
--------------------------------------------------
if modifier_archon_passive_ice == nil then
	modifier_archon_passive_ice = class({})
end

function modifier_archon_passive_ice:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_archon_passive_ice:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	local hTarget = params.target
	local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
	local abil_damage = self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "coefficient" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	-- local str = self:GetCaster():GetStrength()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		hTarget:GetOrigin(), 
		hTarget, 
		aoe, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)
	
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = abil_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}

			ApplyDamage( damage )
			enemy:AddNewModifier( 
				self:GetCaster(), 
				self:GetAbility(), 
				"modifier_archon_passive_ice_attackdown", 
				{ duration = duration} 
			)
			
		end
	end
end

-----------------------------

function modifier_archon_passive_ice_attackdown:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_archon_passive_ice_attackdown:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_archon_passive_ice_attackdown:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
--------------
function modifier_archon_passive_ice_attackdown:OnCreated( kv )
	self.attackspeed_out = self:GetAbility():GetSpecialValueFor( "attackspeed_out" )
	self.movespeed_out = self:GetAbility():GetSpecialValueFor( "movespeed_out" )
end

--------------------------------------------------------------------------------

function modifier_archon_passive_ice_attackdown:OnRefresh( kv )
	self.attackspeed_out = self:GetAbility():GetSpecialValueFor( "attackspeed_out" )
	self.movespeed_out = self:GetAbility():GetSpecialValueFor( "movespeed_out" )
end

--------------------------------------------------------------------------------

function modifier_archon_passive_ice_attackdown:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_archon_passive_ice_attackdown:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_out
end

function modifier_archon_passive_ice_attackdown:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_out
end

