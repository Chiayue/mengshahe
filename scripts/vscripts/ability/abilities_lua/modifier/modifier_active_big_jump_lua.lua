modifier_active_big_jump_lua = class({})

function modifier_active_big_jump_lua:IsHidden()
    return true
end

function modifier_active_big_jump_lua:OnCreated(kv)
    if not IsServer() then
        return
    end

    self.scale = self:GetAbility():GetSpecialValueFor("scale")

    self.start_positon = self:GetParent():GetAbsOrigin()
    self.target_position = self:GetAbility():GetCursorPosition()
    self.distance = (self.target_position - self.start_positon):Length2D()
    self.speed = 1000
    self.duration = self.distance / self.speed
    self.direction = (self.target_position - self.start_positon):Normalized()
    self.height = 5000
    self.flag = true
    self.damage_total = self:GetParent():GetHealth() * self.scale

    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()

    self:GetParent():EmitSound("tornado.fly")
end

function modifier_active_big_jump_lua:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)
end

function modifier_active_big_jump_lua:UpdateHorizontalMotion(me, dt)
    if not IsServer() then
        return
    end
    local position = me:GetAbsOrigin()
    local distance = self.speed * dt
    if distance > self.distance then
        distance = self.distance
    end
    position = position + self.direction * distance
    me:SetAbsOrigin(position)
end

function modifier_active_big_jump_lua:UpdateVerticalMotion(me, dt)
    if not IsServer() then
        return
    end

    local position = me:GetAbsOrigin()
    local distance = (position - self.start_positon):Length2D()
    position.z = - 4 * self.height / (self.distance * self.distance) * (distance * distance) + 4 * self.height / self.distance * distance

    local ground_height = GetGroundHeight( position, self:GetParent() )
    local landed = false

    if ( position.z < ground_height and distance > self.distance / 2 ) then
        position.z = ground_height
        landed   = true
    end

    me:SetAbsOrigin(position)

    if self.flag and position.z > self.distance - 100 then
        me:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_active_big_jump_bianshen_lua", {duration = 20})
        self.flag = false
    end

    if landed == true then
        local units = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            me:GetAbsOrigin(), 
            nil, 
            500, 
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )

        for _, unit in pairs(units) do
            ApplyDamage({
                victim = unit,
                attacker = self:GetAbility():GetCaster(),
                damage = self.damage_total,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            })
        end

        local particle = ParticleManager:CreateParticle(
            "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_physical.vpcf", 
            PATTACH_WORLDORIGIN,
            self:GetParent()
        )
        ParticleManager:SetParticleControl(particle, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        me:EmitSound("tornado.drop")

        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveModifierByName("modifier_active_big_jump_lua")
    end
end