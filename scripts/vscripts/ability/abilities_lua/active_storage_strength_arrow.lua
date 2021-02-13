active_storage_strength_arrow = class({})

function active_storage_strength_arrow:OnSpellStart()
    self.percentage = GameRules:GetGameTime()
    local caster = self:GetCaster()
    self.index = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6_arc.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.index, 3, caster:GetOrigin() + caster:GetForwardVector() * 100 + Vector(0, 0, 100))
    ParticleManager:SetParticleControlForward(self.index, 3, caster:GetForwardVector())
end

function active_storage_strength_arrow:OnChannelFinish(interrupted)
    ParticleManager:DestroyParticle(self.index, true)
    ParticleManager:ReleaseParticleIndex(self.index)
    self.percentage = GameRules:GetGameTime() - self.percentage
    local caster = self:GetCaster()
    local velocity = caster:GetForwardVector()
    ProjectileManager:CreateLinearProjectile({
        EffectName = "particles/econ/items/windrunner/windrunner_weapon_sparrowhawk/windrunner_spell_powershot_sparrowhawk.vpcf",
        Ability = self,
        Source = caster,
        fStartRadius = 200,
        fEndRadius = 200,
        fDistance = 2000,
        vVelocity = velocity * 3000,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vSpawnOrigin = caster:GetOrigin() + velocity * 50,
        fExpireTime = GameRules:GetGameTime() + 1
    })
end

function active_storage_strength_arrow:OnProjectileHit(hTarget, vLocation)
    if hTarget and hTarget:IsAlive() and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
        local caster = self:GetCaster()
        ApplyDamage({
            victim = hTarget,
            attacker = caster,
			damage = (100 + caster:GetStrength() * self.nScale) * 60 * self.percentage,
            damage_type = DAMAGE_TYPE_MAGICAL,
        })
    end
	return false
end