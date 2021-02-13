LinkLuaModifier("modifier_boss_god_metal_spear", "ability/boss_ability/boss_god_metal_spear", LUA_MODIFIER_MOTION_HORIZONTAL)

boss_god_metal_spear = class({})

function boss_god_metal_spear:OnSpellStart()
    self.caster = self:GetCaster()
    self.caster.delay = 0
    self.caster:SetContextThink(DoUniqueString("CreateProjectile"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.delay = self.caster.delay + 0.1
        if self.caster.delay >= 2.3 then
            self:CreateProjectile()
            return nil
        end
        return 0.1
    end, 0)
end

function boss_god_metal_spear:CreateProjectile()
    local info = {
        EffectName = "particles/units/heroes/hero_mars/mars_spear.vpcf",
        Ability = self,
        fStartRadius = 10,
        fEndRadius = 200,
        -- vVelocity = self.caster:GetForwardVector() * 1000,
        fDistance = 5000,
        Source = self.caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO,
        vSpawnOrigin = self.caster:GetOrigin() + self.caster:GetForwardVector() * 200,
        fExpireTime = GameRules:GetGameTime() + 10,
    }
    local angle = 10
    local num = 360 / angle
    local position = self.caster:GetOrigin()
    local forward = self.caster:GetForwardVector() * 500
    for i = 1, num do
        local target = position + forward
        target = RotatePosition(
            position, 
            QAngle(0, i * angle, 0), 
            target
        )
        info.vVelocity = (target - position):Normalized() * 1000
        ProjectileManager:CreateLinearProjectile(info)
    end
end

function boss_god_metal_spear:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    if hTarget then
        if not hTarget:FindModifierByName("modifier_boss_god_metal_spear") then
            hTarget:SetOrigin(vLocation)
            local velocity = ProjectileManager:GetLinearProjectileVelocity(iProjectileHandle)
            hTarget:AddNewModifier(self.caster, self, "modifier_boss_god_metal_spear", {
                velocity_x = velocity.x,
                velocity_y = velocity.y,
                velocity_z = velocity.z,
                projectile = iProjectileHandle,
            })
        end
    end
	return false
end

---------------------------------------------------------------------------------------------------------------

modifier_boss_god_metal_spear = class({})

function modifier_boss_god_metal_spear:IsHidden()
    return true
end

function modifier_boss_god_metal_spear:IsPurgable()
    return false
end

function modifier_boss_god_metal_spear:IsDebuff()
	return true
end

function modifier_boss_god_metal_spear:IsStunDebuff()
	return true
end

function modifier_boss_god_metal_spear:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_boss_god_metal_spear:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_boss_god_metal_spear:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_boss_god_metal_spear:OnCreated(kv)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
        self.velocity = Vector(kv.velocity_x, kv.velocity_y, kv.velocity_z)
        self.projectile = kv.projectile
        self:ApplyHorizontalMotionController()
    end
end

function modifier_boss_god_metal_spear:OnDestroy()
    if IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
        self.parent:RemoveModifierByName(self:GetClass())
    end
end

function modifier_boss_god_metal_spear:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local position = me:GetOrigin()
        local target = position + self.velocity * dt
        if not GridNav:IsTraversable(target) or self:FindDoor(target) then
            me:AddNewModifier(self.caster, self.ability, "modifier_common_stun", {duration = 3})
            ProjectileManager:DestroyLinearProjectile(self.projectile)
            self.parent:RemoveHorizontalMotionController(self)
            self.parent:RemoveModifierByName(self:GetClass())
            ApplyDamage({
                victim = me,
                attacker = self.caster,
                damage = me:GetMaxHealth() / 2,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            })
        else
            me:SetOrigin(target)
        end
    end
end

function modifier_boss_god_metal_spear:FindDoor(target)
    for i = 1, 4 do
        if Entities: FindByNameNearest("door00"..i, target, 50) then
            return true
        end 
    end
    return false
end