explosion_lightning=class({})
explosion_lightning_s=explosion_lightning
LinkLuaModifier("modifier_explosion_lightning_debuff", "skills/explosion_lightning/explosion_lightning.lua", LUA_MODIFIER_MOTION_NONE)

function explosion_lightning:IsHiddenWhenStolen() 
    return false 
end

function explosion_lightning:IsStealable() 
    return true 
end

function explosion_lightning:IsRefreshable() 			
    return true 
end

function explosion_lightning:OnSpellStart()
    local caster = self:GetCaster()
    local team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Zuus.LightningBolt", caster) 
    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW,caster)
    ParticleManager:SetParticleControlEnt(p, 0,caster, PATTACH_POINT_FOLLOW, "attach_attack1",caster_pos, true)
    ParticleManager:SetParticleControlEnt(p, 1,target, PATTACH_POINT_FOLLOW, "attach_hitloc",target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(p)
    target:AddNewModifier(caster, self, "modifier_explosion_lightning_debuff", {duration=duration})
end



modifier_explosion_lightning_debuff=class({})

function modifier_explosion_lightning_debuff:IsPurgable() 			
    return false
end

function modifier_explosion_lightning_debuff:IsPurgeException() 		
    return false 
end

function modifier_explosion_lightning_debuff:IsHidden()				
    return false 
end

function modifier_explosion_lightning_debuff:IsDebuff()				
    return true 
end

function modifier_explosion_lightning_debuff:RemoveOnDeath()				
    return true 
end

function modifier_explosion_lightning_debuff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.interval=self.ability:GetSpecialValueFor("dam_interval")	
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")	
    self.rd=self.ability:GetSpecialValueFor("rd")	
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.attsp=self.ability:GetSpecialValueFor("attsp")
    self.rd2=self.ability:GetSpecialValueFor("rd2")
    self.duration=self.ability:GetSpecialValueFor("duration")
    self.damageTable =
    {
        attacker = self.caster,
        ability = self.ability,
    }	
    if not IsServer() then 
            return 
    end
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    self.team=self.caster:GetTeamNumber()
    self:OnIntervalThink()
    self:StartIntervalThink(self.interval)
end

function modifier_explosion_lightning_debuff:OnIntervalThink()
    local p = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW , self.parent )
    ParticleManager:SetParticleControl( p, 0, self.parent:GetAbsOrigin() )
    ParticleManager:SetParticleControl( p, 1, Vector(self.rd,0,0) )
    ParticleManager:SetParticleControl( p, 2, Vector(1,0,0) )
    ParticleManager:SetParticleControl( p, 60,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)) )
    ParticleManager:SetParticleControl( p, 61, Vector(1,1,1) )
    local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies>0 then 
        EmitSoundOn("Hero_Zuus.ArcLightning.Cast", self.parent) 
        for _,target in pairs(enemies) do
            if not target:IsMagicImmune() then 
                self.damageTable.victim = target
                self.damageTable.damage = self.base_dam+self.caster:GetIntellect()*self.int_per
                ApplyDamage( self.damageTable )
            end
        end
    end
end

function modifier_explosion_lightning_debuff:OnDestroy()
    if not IsServer() then 
        return 
    end				
    local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies>0 then 
        local tar=enemies[RandomInt(1,#enemies)]
        if tar~=nil then 
            local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW,self.parent)
            ParticleManager:SetParticleControlEnt(p, 0,self.parent, PATTACH_POINT_FOLLOW, "attach_attack1",self.parent:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(p, 1,tar, PATTACH_POINT_FOLLOW, "attach_hitloc",tar:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(p)
            tar:AddNewModifier( self.caster, self.ability, "modifier_explosion_lightning_debuff", {duration=self.duration})
        end 
    end
end

function modifier_explosion_lightning_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    } 
end

function modifier_explosion_lightning_debuff:GetModifierMoveSpeedBonus_Constant() 
    return 0-self.sp
end

function modifier_explosion_lightning_debuff:GetModifierAttackSpeedBonus_Constant() 
    return 0-self.attsp
end