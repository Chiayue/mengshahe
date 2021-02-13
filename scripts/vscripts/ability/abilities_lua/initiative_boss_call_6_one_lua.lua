--挑战boss6技能1
initiative_boss_call_6_one_lua = class({})

LinkLuaModifier("modifier_boss_call_6_one_missile_caster","ability/abilities_lua/initiative_boss_call_6_one_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_call_6_one_missile_target","ability/abilities_lua/initiative_boss_call_6_one_lua.lua", LUA_MODIFIER_MOTION_NONE)
function initiative_boss_call_6_one_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Leshrac.Lightning_Storm")  
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	local projectile_info = {
		EffectName = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", 
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		Target = target,
		Source = caster,
		bHasFrontalCone = false,
		iMoveSpeed = 450,
		bReplaceExisting = false,
		bProvidesVision = false
	  }
	  ProjectileManager:CreateTrackingProjectile(projectile_info)

end
function initiative_boss_call_6_one_lua:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local caster = self:GetCaster()
		local damageTable = {
			victim  =  hTarget,--
			attacker = caster,
			damage = 15000,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}
		ApplyDamage(damageTable)
	end
end
