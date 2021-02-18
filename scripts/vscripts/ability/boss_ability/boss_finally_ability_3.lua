boss_finally_ability_3 = class({})

function boss_finally_ability_3:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.start_position = self.caster:GetOrigin()
        ProjectileManager:CreateLinearProjectile({
            EffectName = "particles/econ/items/windrunner/windrunner_weapon_sparrowhawk/windrunner_spell_powershot_sparrowhawk.vpcf",
            Ability = self,
            fStartRadius = 200,
            fEndRadius = 200,
            vVelocity = self.caster:GetForwardVector() * 2000,
            fDistance = 2000,
            Source = self.caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO,
            vSpawnOrigin = self.caster:GetOrigin(),
            fExpireTime = GameRules:GetGameTime() + 5,
        })
    end
end

function boss_finally_ability_3:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    if hTarget and not hTarget:IsNull() and hTarget:IsAlive() then
        ApplyDamage{
            victim = hTarget,
			attacker = self.caster,
			damage = 4000,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
        }
        hTarget:SetOrigin(vLocation)
        local velocity = ProjectileManager:GetLinearProjectileVelocity(iProjectileHandle)
        local target_vector = vLocation + self.caster:GetForwardVector() * (2000 - (self.start_position - vLocation):Length2D())
        print(target_vector)
        hTarget:RemoveModifierByName("modifier_boss_finally_ability_3_motion")
        hTarget:AddNewModifier(self.caster, self, "modifier_boss_finally_ability_3_motion", {
            velocity_x = velocity.x,
            velocity_y = velocity.y,
            velocity_z = velocity.z,
            target_vector_x = target_vector.x,
            target_vector_y = target_vector.y,
            target_vector_z = target_vector.z,
        })
        return true
    end
    return false
end

--------------------------------------------------------------------------

LinkLuaModifier("modifier_boss_finally_ability_3_motion", "ability/boss_ability/boss_finally_ability_3", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_boss_finally_ability_3_motion = class({})

function modifier_boss_finally_ability_3_motion:CheckState()
	return {
        -- [MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_boss_finally_ability_3_motion:IsHidden()
	return true
end

function modifier_boss_finally_ability_3_motion:IsPurgable()
    return false
end

function modifier_boss_finally_ability_3_motion:RemoveOnDeath()
	return true
end

function modifier_boss_finally_ability_3_motion:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_boss_finally_ability_3_motion:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        self.start_position = self.parent:GetOrigin()
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.velocity = Vector(kv.velocity_x, kv.velocity_y, kv.velocity_z)
        self.target_vector = Vector(kv.target_vector_x, kv.target_vector_y, kv.target_vector_z)
        self.distance = kv.distance
        self:ApplyHorizontalMotionController()
    end
end

function modifier_boss_finally_ability_3_motion:UpdateHorizontalMotion(me, dt)
    local new_position = me:GetOrigin() + self.velocity * dt
    local len = (new_position - self.target_vector):Length2D()
    if len < 10 then
        self.parent:RemoveHorizontalMotionController(self)
        self.parent:RemoveModifierByName(self:GetClass())
        return
    end
    if not GridNav:IsTraversable(new_position) or self:FindBlock(new_position) then
        self.parent:RemoveHorizontalMotionController(self)
        self.parent:RemoveModifierByName(self:GetClass())
        me:AddNewModifier(self.caster, self.ability, "modifier_common_stun", {duration = 3})
        ApplyDamage{
            victim = self.parent,
            attacker = self.caster,
            damage = 2000,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }
        return
    end
    me:SetOrigin(new_position)
    local enemies = FindUnitsInRadius(
        me:GetTeamNumber(), 
        new_position, 
        nil, 
        200, 
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, 
        false
    )
    for _, enemy in pairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = self.caster,
            damage = 2000,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self,
        })
        if enemy:IsAlive() then
            local target_position = enemy:GetOrigin() + enemy:GetForwardVector() * 500
            enemy:AddNewModifier(self.caster, self.ability, "modifier_knockback", {
                duration = 1,
                should_stun = 1,
                knockback_duration = 1,
                knockback_distance = 500,
                knockback_height = 0,
                center_x = target_position.x,
                center_y = target_position.y,
                center_z = target_position.z,
            })
        end
    end
end

function modifier_boss_finally_ability_3_motion:FindBlock(position)
    for i = 1, 4 do
        if Entities: FindByNameNearest("door00"..i, position, 50) then
            return true
        end 
    end
    if Entities: FindByNameNearest("jinzita001", position, 50) then
        return true
    end 
    return false
end