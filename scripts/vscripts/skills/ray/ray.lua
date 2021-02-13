ray=class({})
ray_d=ray
ray_c=ray


LinkLuaModifier("modifier_ray_buff", "skills/ray/ray.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function ray:IsHiddenWhenStolen() 
    return false 
end

function ray:IsStealable() 
    return true 
end

function ray:IsRefreshable() 			
    return true 
end



function ray:OnSpellStart()
    local caster = self:GetCaster()
    local team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local cur_pos = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("duration")
    CreateModifierThinker(caster, self, "modifier_ray_buff", {duration = duration}, cur_pos, team, false)
end

modifier_ray_buff=class({})

function modifier_ray_buff:IsHidden() 			
    return false 
end

function modifier_ray_buff:IsPurgable() 			
    return false 
end

function modifier_ray_buff:IsPurgeException() 	
    return false 
end


function modifier_ray_buff:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dam_interval=self.ability:GetSpecialValueFor("dam_interval")
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.damageTable =
    {
        attacker = self.caster,
        ability = self.ability,
    }	
    if not IsServer() then
        return
    end 
    EmitSoundOn("Hero_Phoenix.SunRay.Loop", self.parent)
    self.pos=self.parent:GetAbsOrigin()
    self.team=self.parent:GetTeamNumber()
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    self.sun_rayfx = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_WORLDORIGIN, nil )
    self:AddParticle( self.sun_rayfx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(self.dam_interval)
end

function modifier_ray_buff:OnIntervalThink()
    ParticleManager:SetParticleControl(self.sun_rayfx, 0,self.pos+self.caster:GetUpVector()*2000)
    self.end_Pos=Vector(self.pos.x,self.pos.y,self.pos.z+100)
    ParticleManager:SetParticleControl( self.sun_rayfx, 1,self.end_Pos)
    ParticleManager:SetParticleControl( self.sun_rayfx, 9,self.end_Pos)
    local enemies = FindUnitsInRadius(self.team, self.pos, nil,  self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies>0 then 
        for _,target in pairs(enemies) do
            target:Stop()
            target:Hold()
            target:Interrupt()
            self.damageTable.victim = target
            self.damageTable.damage = self.base_dam+self.caster:GetIntellect()*self.int_per
            ApplyDamage( self.damageTable )
        end
    end
end

function modifier_ray_buff:OnDestroy()
    if not IsServer() then
        return
    end 
    StopSoundOn( "Hero_Phoenix.SunRay.Loop", self.parent)
    EmitSoundOn("Hero_Phoenix.SunRay.Stop", self.parent)
end


