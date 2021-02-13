LinkLuaModifier("modifier_boss_finally_ability_motion", "ability/boss_ability/boss_finally_ability_2", LUA_MODIFIER_MOTION_BOTH)

boss_finally_ability_2 = class({})

function boss_finally_ability_2:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.caster.boss_finally_ability_2_delay = 0
        self.caster:SetContextThink(DoUniqueString("boss_finally_ability_2"), function ()
            if GameRules:IsGamePaused() then
                return 1
            end
            self.caster.boss_finally_ability_2_delay = self.caster.boss_finally_ability_2_delay + 0.1
            if self.caster.boss_finally_ability_2_delay >= 1.6 then
                local position = self.caster:GetOrigin()
                position = position + self.caster:GetForwardVector() * 1000
                local index = ParticleManager:CreateParticle(
                    "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf",
                    PATTACH_WORLDORIGIN,
                    nil
                )
                ParticleManager:SetParticleControl(index, 0, position)
                ParticleManager:ReleaseParticleIndex(index)
                local enemies = FindUnitsInRadius(
                    self.caster:GetTeamNumber(), 
                    position, 
                    nil, 
                    1000, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_ANY_ORDER, 
                    false
                )
                for _,enemy in pairs(enemies) do
                    if enemy and not enemy:IsNull() and enemy:IsAlive() then
                        ApplyDamage({
                            victim = enemy,
                            attacker = self.caster,
                            damage = 3000,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self,
                        })
                        if enemy:IsAlive() then
                            enemy:AddNewModifier(self.caster, self, "modifier_boss_finally_ability_motion", {
                                position_x = position.x,
                                position_y = position.y,
                                position_z = position.z,
                            })
                        end 
                    end
                end
                return nil
            end
            return 0.1
        end, 0)

    end
end

--------------------------------------------------------------------------

modifier_boss_finally_ability_motion = class({})

function modifier_boss_finally_ability_motion:IsHidden()
	return true
end

function modifier_boss_finally_ability_motion:IsPurgable()
    return false
end

function modifier_boss_finally_ability_motion:RemoveOnDeath()
	return true
end

function modifier_boss_finally_ability_motion:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_boss_finally_ability_motion:OnCreated(kv)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
        self.start_positon = Vector(kv.position_x, kv.position_y, kv.position_z)
        self.target_position = self.parent:GetOrigin()
        self.direction = (self.target_position - self.start_positon):Normalized()
        self.distance = 1000
        self.height = 200
        self.speed = 2000
        self.landed = false
        self:ApplyHorizontalMotionController()
        self:ApplyVerticalMotionController()
    end
end

function modifier_boss_finally_ability_motion:OnDestroy()
    if IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
        self.parent:RemoveVerticalMotionController(self)
    end
end

function modifier_boss_finally_ability_motion:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        me:SetOrigin(me:GetOrigin() + self.direction * self.speed * dt)
    end
end

function modifier_boss_finally_ability_motion:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local position = me:GetOrigin()
        local distance = (position - self.start_positon):Length2D()
        position.z = -4 * self.height * (distance * distance) / (self.distance * self.distance) + 4 * self.height * distance / self.distance
        local height = GetGroundHeight(position, self.parent)


        if (distance > self.distance / 2 and position.z < height) then
            position.z = height
            self.landed   = true
        end
        me:SetOrigin(position)
        if self.landed then
            self.parent:RemoveHorizontalMotionController(self)
            self.parent:RemoveVerticalMotionController(self)
            self.parent:RemoveModifierByName(self:GetClass())
            EmitSoundOn("tornado.drop", me)
            local index = ParticleManager:CreateParticle(
                "particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_impact_dust.vpcf",
                PATTACH_WORLDORIGIN,
                nil
            )
            ParticleManager:SetParticleControl(index, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
            me:AddNewModifier(self.caster, self.ability, "modifier_common_stun", {duration = 4})
        end
    end
end