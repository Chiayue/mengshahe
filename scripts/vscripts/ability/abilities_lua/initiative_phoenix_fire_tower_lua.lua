LinkLuaModifier( "modifier_initiative_phoenix_fire_tower_lua", "ability/abilities_lua/initiative_phoenix_fire_tower_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if initiative_phoenix_fire_tower_lua == nil then
	initiative_phoenix_fire_tower_lua = class({})
end

function initiative_phoenix_fire_tower_lua:GetIntrinsicModifierName()
 	return "modifier_initiative_phoenix_fire_tower_lua"
end

function initiative_phoenix_fire_tower_lua:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster():GetOwner(),
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage( damage )
	end

	return false
end
--------------------------------------------------
if modifier_initiative_phoenix_fire_tower_lua == nil then
	modifier_initiative_phoenix_fire_tower_lua = class({})
end

function modifier_initiative_phoenix_fire_tower_lua:IsHidden()
	return true
end
function modifier_initiative_phoenix_fire_tower_lua:DeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_initiative_phoenix_fire_tower_lua:OnCreated( kv )
    if not IsServer() then
        return
	end
	self.cooldown = self:GetAbility():GetCooldown(1)
	self:StartIntervalThink(self.cooldown)
end

function modifier_initiative_phoenix_fire_tower_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.Origin = caster:GetOrigin()
	for _, enemy in pairs(enemies) do
		if enemy:GetUnitName() ~= "boss_finally" then
			self.speed = 1800
			local info = {
				EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
				Ability = self:GetAbility(),
				iMoveSpeed = self.speed,
				Source = caster,
				Target = enemy,
				bDodgeable = true,
				bProvidesVision = true,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iVisionRadius = self:GetAbility():GetSpecialValueFor("radius"),
			}
			ProjectileManager:CreateTrackingProjectile( info )
			self:GetAbility():StartCooldown(self.cooldown)
			break
		end
	end
end
-----------------------------
