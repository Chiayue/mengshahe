modifier_active_tornado_fly_lua = class({})

function modifier_active_tornado_fly_lua:OnCreated(kv)
    if not IsServer() then
        return
    end

    self.scale = self:GetAbility():GetSpecialValueFor("scale")
    self.dam = self:GetAbility():GetSpecialValueFor("damage")
    self.start_positon = self:GetParent():GetAbsOrigin()
    self.target_position = Vector(kv.position_x, kv.position_y, kv.position_z)
    self.distance = (self.target_position - self.start_positon):Length2D()
    self.horizontal_speed = 3000
    self.duration = self.distance / self.horizontal_speed
    self.direction = (self.target_position - self.start_positon):Normalized()
    self.height = 1000

    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()

    self:GetParent():EmitSound("tornado.fly")
end

function modifier_active_tornado_fly_lua:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)
end

function modifier_active_tornado_fly_lua:UpdateHorizontalMotion(me, dt)
    if not IsServer() then
        return
    end
    local position = me:GetAbsOrigin()

    local distance = self.horizontal_speed * dt
    if distance > self.distance then
        distance = self.distance
    end

    position = position + self.direction * distance
    me:SetAbsOrigin(position)
end

function modifier_active_tornado_fly_lua:UpdateVerticalMotion(me, dt)
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

    if landed == true then
        local units = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self:GetParent():GetOrigin(), 
            nil, 
            500, 
            DOTA_UNIT_TARGET_TEAM_BOTH, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )
        local damage_total = me:GetHealth() * self.scale / #units
        for _, unit in pairs(units) do
            if unit:GetEntityIndex() ~= me:GetEntityIndex() then
                local damage = {
                    victim = unit,
                    attacker = self:GetAbility():GetCaster(),
                    damage = damage_total,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }
                ApplyDamage(damage)
            end
        end

        local dam = {
            victim = me,
            attacker = self:GetAbility():GetCaster(),
            damage = self.dam,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
        ApplyDamage(dam)


        local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        me:EmitSound("tornado.drop")

        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveModifierByName("modifier_active_tornado_fly_lua")
    end
end