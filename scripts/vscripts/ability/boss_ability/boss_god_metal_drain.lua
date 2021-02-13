LinkLuaModifier("modifier_boss_god_metal_drain_health", "ability/boss_ability/boss_god_metal_drain", LUA_MODIFIER_MOTION_NONE)

boss_god_metal_drain = class({})

function boss_god_metal_drain:OnSpellStart()
    self.caster = self:GetCaster()
    self.caster.drain_delay = 0
    self.caster.create_particle_flag = true
    self.index_table = {}
    self.caster:SetContextThink(DoUniqueString("boss_god_metal_drain"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.drain_delay = self.caster.drain_delay + 0.1
        if self.caster.drain_delay >= 17 then
            for _, index in pairs(self.index_table) do
                if index then
                    ParticleManager:DestroyParticle(index, false)
                    ParticleManager:ReleaseParticleIndex(index)
                end
            end
            return nil
        end
        if self.caster.drain_delay >= 1.8 and self.caster.create_particle_flag then
            self.caster:AddNewModifier(self.caster, self, "modifier_boss_god_metal_drain_health", nil)
            for _, hero in pairs(HeroList:GetAllHeroes()) do
                local index = ParticleManager:CreateParticle(
                    "particles/diy_particles/baphomet_xi.vpcf", 
                    PATTACH_POINT_FOLLOW, 
                    self.caster
                )
                ParticleManager:SetParticleControlEnt(index, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_diy2", self.caster:GetOrigin(), true)
                ParticleManager:SetParticleControlEnt(index, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true)
                table.insert(self.index_table, index)
                hero:AddNewModifier(self.caster, self, "modifier_boss_god_metal_drain_health", nil)
                hero.particle_index = index
            end
            self.caster.create_particle_flag = false
        end

        return 0.1
    end, 0)
end

function boss_god_metal_drain:OnChannelThink(flInterval)
    for _, hero in pairs(HeroList:GetAllHeroes()) do
        if hero:IsAlive() then
            return
        end
    end
    self.caster:InterruptChannel()
end

--------------------------------------------------------------------------------------------

modifier_boss_god_metal_drain_health = class({})

function modifier_boss_god_metal_drain_health:IsHidden()
    return true
end

function modifier_boss_god_metal_drain_health:IsPurgable()
    return false
end

function modifier_boss_god_metal_drain_health:RemoveOnDeath()
    return true
end

function modifier_boss_god_metal_drain_health:OnCreated(kv)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
        self:StartIntervalThink(0.1)
    end
end

function modifier_boss_god_metal_drain_health:OnDestroy()
    if IsServer() then
        if self.parent.particle_index then
            ParticleManager:DestroyParticle(self.parent.particle_index, false)
            ParticleManager:ReleaseParticleIndex(self.parent.particle_index)
        end 
    end
end

function modifier_boss_god_metal_drain_health:OnIntervalThink()
    if IsServer() then
        if self.caster == self.parent then
            self.parent:Heal(self.parent:GetMaxHealth() * 0.01, self.parent)
        else
            ApplyDamage({
                victim = self.parent,
                attacker = self.caster,
                damage = self.parent:GetMaxHealth() * 0.01,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            })
        end
    end
end