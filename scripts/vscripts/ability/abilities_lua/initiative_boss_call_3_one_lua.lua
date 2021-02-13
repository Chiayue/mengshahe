--挑战boss3技能1
initiative_boss_call_3_one_lua = class({})

function initiative_boss_call_3_one_lua:OnSpellStart()
  local caster = self:GetCaster()
  caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:EmitSound("hero.attack.npc_dota_hero_naga_siren")
  local vDirection = self:GetCaster():GetForwardVector()	
  vDirection.z = 0.0
  vDirection = vDirection:Normalized()	
  local info = {
      EffectName = "particles/diy_particles/tornado.vpcf",
      Ability = self,
      vSpawnOrigin =  caster:GetOrigin(), 
      fStartRadius = 50,
      fEndRadius = 50,
      vVelocity = vDirection * 500,
      fDistance = 600,
      Source = caster,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
  }
  ProjectileManager:CreateLinearProjectile( info )    

end
function initiative_boss_call_3_one_lua:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
    local damage = {
      victim = hTarget,
      attacker = self:GetCaster(),
      damage = 5000,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self
		}
		ApplyDamage( damage )
    end
    return false
end