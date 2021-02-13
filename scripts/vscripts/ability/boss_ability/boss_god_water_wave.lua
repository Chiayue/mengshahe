LinkLuaModifier("modifier_boss_god_water_wave", "ability/boss_ability/boss_god_water_wave", LUA_MODIFIER_MOTION_NONE)

boss_god_water_wave = class({})

function boss_god_water_wave:OnSpellStart()
    self.caster = self:GetCaster()
    self.position = self.caster:GetOrigin()
    self.info = {
        EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
        Ability = self,
        vSpawnOrigin = self.caster:GetOrigin(), 
        fStartRadius = 300,
        fEndRadius = 300,
        fDistance = 9999,
        Source = self.caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    }
    self.count = 0
    self.delay = 0
    self.finish = false
    self.caster:SetContextThink("boss_god_water_wave", function ()
        if self.finish then
            return nil
        end
        self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        return 1
    end, 0)
end

function boss_god_water_wave:OnChannelThink(flInterval)
    self.delay = self.delay + flInterval
    if self.delay > 2 then
        local t_position = self.position + self.caster:GetForwardVector() * 100
        t_position = RotatePosition(self.position, QAngle(0, self.count * 33, 0), t_position)
        self.info.vVelocity = (t_position - self.position):Normalized() * 1000
        self.info.fExpireTime = GameRules:GetGameTime() + 5
        ProjectileManager:CreateLinearProjectile(self.info)
        self.count = self.count + 1  
    end
end

function boss_god_water_wave:OnChannelFinish(bInterrupted)
    self.finish = true
end

function boss_god_water_wave:OnProjectileHit(hTarget, vLocation)
    if hTarget then
        local mdf = hTarget:FindModifierByName("modifier_boss_god_water_wave")
        if mdf then
            mdf:SetStackCount(mdf:GetStackCount() + 1)
            mdf:SetDuration(2, true)
        else
            hTarget:AddNewModifier(self.caster, self, "modifier_boss_god_water_wave", {duration = 2})
        end
        ApplyDamage({
            victim = hTarget,
            attacker = self.caster,
            damage = hTarget:GetMaxHealth() * 0.05,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }) 
    end
end

---------------------------------------------------------------------

modifier_boss_god_water_wave = class({})

function modifier_boss_god_water_wave:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_boss_god_water_wave:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount() * -30
end

function modifier_boss_god_water_wave:GetModifierMagicalResistanceBonus()
    return self:GetStackCount() * -15
end

function modifier_boss_god_water_wave:IsHidden()
	return false
end

function modifier_boss_god_water_wave:IsPurgable()
    return false
end

function modifier_boss_god_water_wave:RemoveOnDeath()
	return true
end

function modifier_boss_god_water_wave:OnCreated(table)
    if IsServer() then
        self:SetStackCount(1)
    end
end