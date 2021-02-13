modifier_common_knockback = class({})

function modifier_common_knockback:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_common_knockback:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_common_knockback:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_common_knockback:IsHidden()
    return true
end

function modifier_common_knockback:IsPurgable()
    return false
end
 
function modifier_common_knockback:RemoveOnDeath()
    return true
end

function modifier_common_knockback:OnCreated(kv)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
        self.start_positon = self.parent:GetOrigin()
        self.target_position = RotatePosition(
            self.start_positon, 
            QAngle(0, 180, 0), 
            self.start_positon + self.parent:GetForwardVector() * 200
        )
        self.direction = (self.target_position - self.start_positon):Normalized()
        self.distance = (self.target_position - self.start_positon):Length2D()
        self.speed = 800
        self.height = 200
        self.landed = false
        self:ApplyHorizontalMotionController()
        self:ApplyVerticalMotionController()
    end
end

function modifier_common_knockback:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
    end
end

function modifier_common_knockback:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        me:SetOrigin(me:GetOrigin() + self.direction * self.speed * dt)
    end
end

function modifier_common_knockback:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local position = me:GetOrigin()
        local distance = (position - self.start_positon):Length2D()
        position.z = -4 * self.height * (distance * distance) / (self.distance * self.distance) + 4 * self.height * distance / self.distance
        local height = GetGroundHeight(position, self:GetParent())
        if (distance > self.distance / 2 and position.z < height) then
            position.z = height
            self.landed   = true
        end
        me:SetOrigin(position)
        if self.landed then
            self:GetParent():RemoveHorizontalMotionController(self)
            self:GetParent():RemoveVerticalMotionController(self)
            self:GetParent():RemoveModifierByName(self:GetClass())
            EmitSoundOn("tornado.drop", me)
            local index = ParticleManager:CreateParticle(
                "particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_impact_dust.vpcf",
                PATTACH_WORLDORIGIN,
                nil
            )
            ParticleManager:SetParticleControl(index, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
            me:AddNewModifier(self.caster, self.ability, "modifier_common_stun", {
                duration = 0.5
            })
        end
    end
end