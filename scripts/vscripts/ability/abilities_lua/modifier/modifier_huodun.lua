modifier_huodun = class({})


function modifier_huodun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
    return funcs
end

function modifier_huodun:OnCreated(params)
    if IsServer() then
        local ability = self:GetAbility()
        local unit = self:GetParent()
        self.damage_range = ability:GetSpecialValueFor("damage_range")
        self.base_damage = ability:GetSpecialValueFor("damage_base") / 2
        self.damage_percent = ability:GetSpecialValueFor("damage_percent") / 200 
        self.take_damage_amount = 0
        self.avoid_damage_amount = ability:GetSpecialValueFor("avoid_damage_amount")
        self.particle_index = ParticleManager:CreateParticle("particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", PATTACH_ROOTBONE_FOLLOW, unit)
        self.damage_info = {
            victim = nil,
            attacker = unit,
            damage = 0,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ParticleManager:SetParticleControlEnt(self.particle_index, 0, unit, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
        self:StartIntervalThink(0.5)
    end
end

function modifier_huodun:OnRefresh(params)
    if IsServer() then
        self.take_damage_amount = 0
    end
end

function modifier_huodun:GetModifierAvoidDamage(params)
    self.take_damage_amount = self.take_damage_amount + params.damage 
    if self.take_damage_amount >= self.avoid_damage_amount then
        ParticleManager:DestroyParticle(self.particle_index,true)
        self:Destroy()
    end
    return params.damage
end

function modifier_huodun:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle( self.particle_index ,true)
        ParticleManager:ReleaseParticleIndex(self.particle_index)
    end
end


function modifier_huodun:OnIntervalThink()
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(),caster:GetOrigin(),nil,self.damage_range,DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
    for _,v in pairs(enemies) do
        if v:IsAlive() then
            self.damage_info.victim = v
            self.damage_info.damage = v:GetMaxHealth() * self.damage_percent + self.base_damage
            ApplyDamage(self.damage_info )
        end
    end
end

