--火焰弹
initiative_bullet_fly_lua = class({})
initiative_bullet_fly_lua_d = initiative_bullet_fly_lua
initiative_bullet_fly_lua_c = initiative_bullet_fly_lua
initiative_bullet_fly_lua_b = initiative_bullet_fly_lua
initiative_bullet_fly_lua_a = initiative_bullet_fly_lua
initiative_bullet_fly_lua_s = initiative_bullet_fly_lua

LinkLuaModifier("modifier_burn_injury_damage","ability/abilities_lua/initiative_bullet_fly_lua",LUA_MODIFIER_MOTION_NONE)
function initiative_bullet_fly_lua:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  local projectile_info = {
    EffectName = "particles/tgp/laser_turret/ltmissile.vpcf", 
    Ability = self,
    vSpawnOrigin = caster:GetOrigin(),
    Target = target,
    Source = caster,
    bHasFrontalCone = false,
    iMoveSpeed = 1200,
    bReplaceExisting = false,
    bProvidesVision = false
  }
  ProjectileManager:CreateTrackingProjectile(projectile_info)
end

function initiative_bullet_fly_lua:OnProjectileHit(hTarget, vLocation)
  local caster = self:GetCaster()
  caster:EmitSound("skill.bom1")
  if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
    local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( nFXIndex, 0, vLocation)
    ParticleManager:SetParticleControl( nFXIndex, 62, vLocation)
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    local enemies = FindUnitsInRadius(
      caster:GetTeamNumber(), 
      vLocation, --hTarget:GetOrigin()
      nil, 
      800, 
      DOTA_UNIT_TARGET_TEAM_ENEMY, 
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
      DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
      FIND_CLOSEST, 
      false
    )
    if(#enemies > 0) then
      for a,enemy in pairs(enemies) do
        if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable())  and (not enemy:HasModifier("modifier_burn_injury_damage"))then
          enemy:AddNewModifier(caster,self, "modifier_burn_injury_damage", {duration = 4})
        end
      end
    end
  end
  return false 
end

--修饰器
modifier_burn_injury_damage = class({})
function modifier_burn_injury_damage:IsHidden() 			return true end
function modifier_burn_injury_damage:IsDebuff() return true end


function modifier_burn_injury_damage:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end

function modifier_burn_injury_damage:StatusEffectPriority()
	return 15
end
function modifier_burn_injury_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_burn_injury_damage:OnCreated()
  if not IsServer() then
    return
  end
  self.count = 3
  local caster = self:GetAbility():GetCaster()
  self.demage =  self:GetAbility():GetSpecialValueFor("damage_per_second")+caster:GetIntellect()*self:GetAbility():GetSpecialValueFor("scale")
  --设置计时器
  self:StartIntervalThink(1)
  --启动计时器
  self:OnIntervalThink()
end

function modifier_burn_injury_damage:OnIntervalThink()

  if self.count  <= 0 then
    self:GetParent():RemoveModifierByName("modifier_burn_injury_damage")
    return
  end
  local damageTable = {
    victim  =  self:GetParent(),--
    attacker = self:GetAbility():GetCaster(),
    damage = self.demage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility(),
  }
  ApplyDamage(damageTable)
  self.count = self.count - 1
end