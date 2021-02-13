LinkLuaModifier("modifier_boss_god_metal_fervor", "ability/boss_ability/boss_god_metal_fervor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_god_metal_fervor_punish", "ability/boss_ability/boss_god_metal_fervor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_god_metal_fervor_kill", "ability/boss_ability/boss_god_metal_fervor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_god_metal_fervor_kill_count", "ability/boss_ability/boss_god_metal_fervor", LUA_MODIFIER_MOTION_NONE)

boss_god_metal_fervor = class({})

function boss_god_metal_fervor:GetIntrinsicModifierName()
	return "modifier_boss_god_metal_fervor"
end

--------------------------------------------------------------------------------------------------

modifier_boss_god_metal_fervor = class({})

function modifier_boss_god_metal_fervor:IsHidden()
    return true
end

function modifier_boss_god_metal_fervor:IsPurgable()
    return false
end

function modifier_boss_god_metal_fervor:RemoveOnDeath()
    return true
end

function modifier_boss_god_metal_fervor:OnCreated(kv)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.caster.center_position = Vector(-1212, -1152, 128)
        self.distance = 2750
        self.caster.delay = 0
        self.caster:SetContextThink(DoUniqueString("CreateProjectile"), function ()
            if GameRules:IsGamePaused() then
                return 1
            end
            self.caster.delay = self.caster.delay + 0.1
            if self.caster.delay >= 5 then
                self:OnIntervalThink()
                self:StartIntervalThink(60)
                return nil
            end
            return 0.1
        end, 0)
        self.caster:AddNewModifier(self.caster, self, "modifier_boss_god_metal_fervor_kill_count", nil)
    end
end

function modifier_boss_god_metal_fervor:OnDestroy()
    if IsServer() then
        if self.index then
            ParticleManager:DestroyParticle(self.index, false)
            ParticleManager:ReleaseParticleIndex(self.index)
        end
    end
end

function modifier_boss_god_metal_fervor:OnIntervalThink()
    if IsServer() then
        if self.caster:IsChanneling() then
            self:StartIntervalThink(1)
        end
        if self.caster:IsAlive() then
            self.distance = self.distance - 250
            self.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
            if not self.caster:IsChanneling() then
                self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
            end
            self.caster.delay = 0
            self.caster:SetContextThink(DoUniqueString("CreateParticle"), function ()
                if GameRules:IsGamePaused() then
                    return 1
                end
                self.caster.delay = self.caster.delay + 0.1
                if self.caster.delay >= 1.5 then
                    if self.index ~= nil then
                        ParticleManager:DestroyParticle(self.index, false)
                        ParticleManager:ReleaseParticleIndex(self.index)
                    end
                    self.index = ParticleManager:CreateParticle(
                        "particles/diy_particles/god_metal_fervor_base.vpcf", 
                        PATTACH_WORLDORIGIN, 
                        nil
                    )
                    ParticleManager:SetParticleControl(self.index, 0, self.caster.center_position)
                    ParticleManager:SetParticleControl(self.index, 1, Vector(self.distance, 0, 0))
                    ParticleManager:SetParticleControl(self.index, 2, self.caster.center_position)
                    self.caster:RemoveModifierByName("modifier_boss_god_metal_fervor_punish")
                    self.caster:AddNewModifier(self.caster, self.ability, "modifier_boss_god_metal_fervor_punish", {
                        distance = self.distance
                    })
                    self.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
                    return nil
                end
                return 0.1
            end, 0) 
            self:StartIntervalThink(60)
        end
    end
end

------------------------------------------------------------------------------------------------------

modifier_boss_god_metal_fervor_punish = class({})

function modifier_boss_god_metal_fervor_punish:IsHidden()
    return true
end

function modifier_boss_god_metal_fervor_punish:IsPurgable()
    return false
end

function modifier_boss_god_metal_fervor_punish:RemoveOnDeath()
    return true
end

function modifier_boss_god_metal_fervor_punish:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self.distance = kv.distance
        self.center_position = self.parent.center_position
        self:StartIntervalThink(0.1)
    end
end

function modifier_boss_god_metal_fervor_punish:OnIntervalThink()
    for _, hero in pairs(HeroList:GetAllHeroes()) do
        local position = hero:GetOrigin()
        local target_positio = position + hero:GetForwardVector()
        local distance = (position - self.center_position):Length2D()
        if distance > self.distance - 200 then
            if distance < self.distance then
                hero:AddNewModifier(self.parent, self.ability, "modifier_knockback", {
                    duration = 0.5,
                    should_stun = 0,
                    knockback_duration = 0.5,
                    knockback_distance = 200,
                    knockback_height = 0,
                    center_x = target_positio.x,
                    center_y = target_positio.y,
                    center_z = target_positio.z,
                } )
            else
                if hero:FindModifierByName("modifier_boss_god_metal_fervor_kill") == nil and hero:FindModifierByName("modifier_boss_god_metal_spear") == nil then
                    hero:AddNewModifier(self.parent, self.ability, "modifier_boss_god_metal_fervor_kill", nil)
                end
            end
        end
    end
end

-------------------------------------------------------------------------------------

modifier_boss_god_metal_fervor_kill = class({})

function modifier_boss_god_metal_fervor_kill:IsHidden()
    return false
end

function modifier_boss_god_metal_fervor_kill:IsPurgable()
    return false
end

function modifier_boss_god_metal_fervor_kill:RemoveOnDeath()
    return true
end

function modifier_boss_god_metal_fervor_kill:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        self.parent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
        local index = ParticleManager:CreateParticle(
            "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", 
            PATTACH_WORLDORIGIN, 
            nil
        )
        local position = self.parent:GetOrigin()
        ParticleManager:SetParticleControl(index, 0, position)
        ParticleManager:SetParticleControl(index, 1, position)
        ParticleManager:SetParticleControl(index, 4, position)
        ParticleManager:ReleaseParticleIndex(index)
        self:StartIntervalThink(1.5)
    end
end

function modifier_boss_god_metal_fervor_kill:OnIntervalThink()
    self.parent:ForceKill(false)
    self.parent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    self:StartIntervalThink(-1)
end

-----------------------------------------------------------------------------------

modifier_boss_god_metal_fervor_kill_count = class({})

function modifier_boss_god_metal_fervor_kill_count:IsHidden()
    return true
end

function modifier_boss_god_metal_fervor_kill_count:IsPurgable()
    return false
end

function modifier_boss_god_metal_fervor_kill_count:RemoveOnDeath()
    return true
end

function modifier_boss_god_metal_fervor_kill_count:OnCreated(kv)
    if IsServer() then
        self.damage = self:GetParent():GetBaseDamageMax() * 0.3
        self:SetStackCount(0)
        self.listen_flag = ListenToGameEvent("dota_player_killed",Dynamic_Wrap(modifier_boss_god_metal_fervor_kill_count,'dota_player_killed'),self)
    end
end

function modifier_boss_god_metal_fervor_kill_count:OnDestroy()
    if IsServer() then
        StopListeningToGameEvent(self.listen_flag)
    end
end

function modifier_boss_god_metal_fervor_kill_count:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_boss_god_metal_fervor_kill_count:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

function modifier_boss_god_metal_fervor_kill_count:dota_player_killed(event)
    self:SetStackCount(self:GetStackCount() + self.damage)
end