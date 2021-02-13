LinkLuaModifier("modifier_boss_finally_ability_4", "ability/boss_ability/boss_finally_ability_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_finally_ability_4_burning", "ability/boss_ability/boss_finally_ability_4", LUA_MODIFIER_MOTION_NONE)

boss_finally_ability_4 = class({})

function boss_finally_ability_4:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.caster:AddNewModifier(self.caster, self, "modifier_boss_finally_ability_4", {duration = 20})
    end
end

function boss_finally_ability_4:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    if hTarget and hTarget:IsAlive() then
        hTarget:AddNewModifier(self.caster, self, "modifier_boss_finally_ability_4_burning", {duration = 3})
    end
    return false
end

------------------------------------------------------------------------

modifier_boss_finally_ability_4 = class({})

function modifier_boss_finally_ability_4:OnCreated(table)
    if IsServer() then
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self:StartIntervalThink(2)
    end
end

function modifier_boss_finally_ability_4:OnIntervalThink()
    if IsServer() then
        for _, hero in pairs(HeroList:GetAllHeroes()) do
            if hero:IsAlive() then
                self:CreateParticle(hero)
            end
        end
    end
end

function modifier_boss_finally_ability_4:CreateParticle(hero)
    if IsServer() then
        local t_position = hero:GetOrigin() + RandomVector(RandomInt(0, 1000))
        local s_position = t_position + RandomVector(1000)
        local velocity = (t_position - s_position):Normalized()
        s_position.z = 1000
        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(index, 0, s_position)
        ParticleManager:SetParticleControl(index, 1, t_position)
        ParticleManager:ReleaseParticleIndex(index)
        self.parent:SetContextThink(DoUniqueString("chaos_meteor"), function ()
            if GameRules:IsGamePaused() then
                return 1
            end
            t_position = t_position - velocity * 200
            ProjectileManager:CreateLinearProjectile({
                EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
                vSpawnOrigin = t_position,
                vVelocity = velocity * 800,
                fDistance = 2000,
                fStartRadius = 500,
                fEndRadius = 500,
                Source = self.parent,
                Ability = self.ability,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO,
                fExpireTime = GameRules:GetGameTime() + 5,
            })
            return nil
        end, 1)
    end
end

------------------------------------------------------------------------

modifier_boss_finally_ability_4_burning = class({})

function modifier_boss_finally_ability_4_burning:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_boss_finally_ability_4_burning:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self:StartIntervalThink(1)
    end
end

function modifier_boss_finally_ability_4_burning:OnIntervalThink()
    if IsServer() then
        ApplyDamage({
            victim = self.parent,
			attacker = self.caster,
			damage = 300,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
        })
    end
end