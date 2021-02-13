LinkLuaModifier("modifier_passive_hit_fly", "ability/abilities_lua/passive_hit_fly.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_hit_fly_motion", "ability/abilities_lua/passive_hit_fly.lua", LUA_MODIFIER_MOTION_BOTH)

-------------------------------------------------------------------------------------------------

passive_hit_fly = class({})

function passive_hit_fly:GetIntrinsicModifierName()
	return "modifier_passive_hit_fly"
end

-------------------------------------------------------------------------------------------------

modifier_passive_hit_fly = class({})

function modifier_passive_hit_fly:IsHidden()
    return true
end

function modifier_passive_hit_fly:IsPurgable()
    return false
end
 
function modifier_passive_hit_fly:RemoveOnDeath()
    return false
end

function modifier_passive_hit_fly:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self:StartIntervalThink(1)
end

function modifier_passive_hit_fly:OnIntervalThink()
    if self.parent:GetHealth() < self.parent:GetMaxHealth() * 0.5 then
        self:Trigger()
        self:StartIntervalThink(-1)
    end
end

function modifier_passive_hit_fly:Trigger()
    local units = FindUnitsInLine(
        self.parent:GetTeamNumber(), 
        self.parent:GetOrigin(), 
        self.parent:GetOrigin() + self.parent:GetForwardVector() * 150, 
        nil, 
        150, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_NONE
    )
    if units and #units > 0 then
        local attacker = units[1]
        EmitSoundOn("punch.fly", self:GetParent())
        ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle(
            "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf",
            PATTACH_ROOTBONE_FOLLOW,
            attacker
        ))
        ApplyDamage({
            victim = attacker,
            attacker = self.parent,
            damage = self.parent:GetAttackDamage() * 3,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
            ability = self.ability
        })
        if attacker:IsAlive() then
            attacker:AddNewModifier(self.parent, self.ability, "modifier_passive_hit_fly_motion", nil)
        end
    end
end

-------------------------------------------------------------------------------------------------

modifier_passive_hit_fly_motion = class({})

function modifier_passive_hit_fly_motion:IsHidden()
    return true
end

function modifier_passive_hit_fly_motion:OnCreated(kv)
    if not IsServer() then
        return
    end
	self.ability = self:GetAbility()
	self.caster = self.ability:GetCaster()
	self.parent = self:GetParent()
    self.start_positon = self.parent:GetOrigin()
	self.target_position = RotatePosition(
        self.start_positon, 
        QAngle(0, 180, 0), 
        self.start_positon + self.parent:GetForwardVector() * 800
    )
    self.direction = (self.target_position - self.start_positon):Normalized()
    self.distance = (self.target_position - self.start_positon):Length2D()
	self.speed = 2000
    self.height = 200
    self.landed = false
    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()
end

function modifier_passive_hit_fly_motion:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)
end

function modifier_passive_hit_fly_motion:UpdateHorizontalMotion(me, dt)
    if not IsServer() then
        return
    end
    me:SetOrigin(me:GetOrigin() + self.direction * self.speed * dt)
end

function modifier_passive_hit_fly_motion:UpdateVerticalMotion(me, dt)
    if not IsServer() then
        return
    end
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
        local units = FindUnitsInRadius(
            me:GetTeamNumber(),
            me:GetOrigin(),
            nil, 
            me:GetHullRadius() + 100,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )
        local health = me:GetHealth()
        for _, unit in pairs(units) do
            if unit:GetEntityIndex() ~= me:GetEntityIndex() then
                ApplyDamage({
                    victim = unit,
                    attacker = self.caster,
                    damage = health,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
                    ability = self.ability
                })
            end
            unit:AddNewModifier(self.caster, self.ability, "modifier_common_stun", {
                duration = 0.5
            }) 
        end
    end
end

function modifier_passive_hit_fly_motion:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_passive_hit_fly_motion:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

-------------------------------------------------------------------------------------------------