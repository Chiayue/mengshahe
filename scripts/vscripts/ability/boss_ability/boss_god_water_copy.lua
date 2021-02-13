LinkLuaModifier("modifier_boss_god_water_copy", "ability/boss_ability/boss_god_water_copy", LUA_MODIFIER_MOTION_NONE)

boss_god_water_copy = class({})

function boss_god_water_copy:OnSpellStart()
    self.illusions = {}
    self.finished = false
    self.caster = self:GetCaster()
    self.info = {
        EffectName = "particles/diy_particles/shui_skill3.vpcf",
        Ability = self,
        iMoveSpeed = 1000,
        Source = self.caster,
        -- Target = hero,
        bDodgeable = false,
        bProvidesVision = true,
        iVisionTeamNumber = self.caster:GetTeamNumber(),
        iVisionRadius = 0,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_NONE, 
    }
    for _, hero in pairs(HeroList:GetAllHeroes()) do
        if hero:IsAlive() and hero:IsRealHero() then
            self.info.Target = hero
            ProjectileManager:CreateTrackingProjectile(self.info) 
        end
    end
    self.caster.boss_god_water_copy_delay = 0
    self.caster:SetContextThink(DoUniqueString("boss_god_water_copy"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.boss_god_water_copy_delay = self.caster.boss_god_water_copy_delay + 1
        if self.caster.boss_god_water_copy_delay >= 20 then
            for _, illusion in pairs(self.illusions) do
                if illusion and illusion:IsAlive() then
                    illusion:AddNewModifier(nil, nil, "modifier_invulnerable", nil)
                end
            end
            self.max = self.caster
            for _, illusion in pairs(self.illusions) do
                if illusion:IsAlive() then
                    if self.max:GetHealth() / self.max:GetMaxHealth() < illusion:GetHealth() / illusion:GetMaxHealth() then
                        self.max = illusion
                    end
                end
            end
            if self.max ~= self.caster then
                self.info.Target = self.max
                self.info.iMoveSpeed = 5000
                ProjectileManager:CreateTrackingProjectile(self.info)
                self.finished = true
            else
                for _, illusion in pairs(self.illusions) do
                    if illusion and illusion:IsAlive() then
                        illusion:ForceKill(false)
                    end
                end
            end
            return nil
        end
        return 1
    end, 0)
end

function boss_god_water_copy:OnProjectileHit(hTarget, vLocation)
    if hTarget and hTarget:IsAlive() then
        if self.finished then
            local position = self.max:GetOrigin()
            local scale = self.max:GetHealth() / self.max:GetMaxHealth()
            for _, illusion in pairs(self.illusions) do
                if illusion and illusion:IsAlive() then
                    illusion:ForceKill(false)
                end
            end
            FindClearSpaceForUnit(self.caster, position, true)
            self.caster:SetHealth(self.caster:GetMaxHealth() * scale)
        else
            local Illusions = CreateIllusions(
                hTarget,
                hTarget,
                {
                    outgoing_damage = 100,
                    incoming_damage = 200,
                }, 
                1, 
                0, 
                true, 
                true
            )
            for _,illusion in pairs(Illusions) do
                illusion:SetBaseStrength(hTarget:GetBaseStrength())
                illusion:SetBaseAgility(hTarget:GetBaseAgility())
                illusion:SetBaseIntellect(hTarget:GetBaseIntellect())
                illusion:SetTeam(self.caster:GetTeamNumber())
                illusion:SetOwner(self.caster)
                illusion:SetAcquisitionRange(99999)
                if illusion:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                    illusion:MoveToNPC(hTarget)
                end
                illusion:AddNewModifier(nil, nil, "modifier_boss_god_water_copy", nil)
                illusion:SetHealth(illusion:GetMaxHealth())
                table.insert(self.illusions, illusion)
            end
        end
        return true
    end
	return false
end

------------------------------------------------------------------------------

modifier_boss_god_water_copy = class({})

function modifier_boss_god_water_copy:CheckState()
	return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end

function modifier_boss_god_water_copy:DeclareFunctions()
	return {
	}
end

function modifier_boss_god_water_copy:IsHidden()
	return true
end

function modifier_boss_god_water_copy:IsPurgable()
    return false
end

function modifier_boss_god_water_copy:RemoveOnDeath()
	return true
end