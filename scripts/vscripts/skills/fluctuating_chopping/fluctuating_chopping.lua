fluctuating_chopping=class({})
fluctuating_chopping_d=fluctuating_chopping
fluctuating_chopping_c=fluctuating_chopping

LinkLuaModifier("modifier_fluctuating_chopping_buff", "skills/fluctuating_chopping/fluctuating_chopping.lua", LUA_MODIFIER_MOTION_NONE)

function fluctuating_chopping:IsHiddenWhenStolen() 
    return false 
end

function fluctuating_chopping:IsStealable() 
    return true 
end

function fluctuating_chopping:IsRefreshable() 			
    return true 
end

function fluctuating_chopping:GetCastRange() 			
    return self:GetSpecialValueFor("rg") 
end

function fluctuating_chopping:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local caster_pos = caster:GetAbsOrigin()
    local target_pos = target:GetAbsOrigin()
    local knock = self:GetSpecialValueFor("knock")
    local duration = self:GetSpecialValueFor("duration")
    if caster:HasModifier("modifier_fluctuating_chopping_buff") then 
        caster:RemoveModifierByName("modifier_fluctuating_chopping_buff")
    end 
    EmitSoundOn("TG.fc", caster) 
    local p = ParticleManager:CreateParticle( "particles/econ/events/ti10/blink_dagger_start_ti10.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p, 0, caster_pos )
    ParticleManager:ReleaseParticleIndex( p )
    FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true)
    local p1 = ParticleManager:CreateParticle( "particles/econ/events/ti10/blink_dagger_end_ti10.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p1, 0, caster:GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( p1 )
    local Knockback =
    {
        should_stun = true,
        knockback_duration = knock,
        duration = knock,
        knockback_distance = 10,
        knockback_height = 400,
        center_x = target_pos.x,
        center_y = target_pos.y,
        center_z = target_pos.z
    }
    target:AddNewModifier(caster,self, "modifier_knockback", Knockback)
    caster:AddNewModifier(caster, self, "modifier_fluctuating_chopping_buff",{duration=duration,target = target:entindex()})
end


modifier_fluctuating_chopping_buff=class({})


function modifier_fluctuating_chopping_buff:IsPurgable() 			
    return false
end

function modifier_fluctuating_chopping_buff:IsPurgeException() 		
    return false 
end

function modifier_fluctuating_chopping_buff:IsHidden()				
    return false 
end

function modifier_fluctuating_chopping_buff:GetEffectAttachType()				
    return PATTACH_ABSORIGIN_FOLLOW  
end

function modifier_fluctuating_chopping_buff:GetEffectName()				
    return "particles/tgp/fluctuating_chopping/fluctuating_chopping_m.vpcf" 
end

function modifier_fluctuating_chopping_buff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dam_interval=self.ability:GetSpecialValueFor("dam_interval")
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")
    self.damageTable =
    {
        attacker = self.caster,
        damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, 
        ability = self.ability,
    }			
    if not IsServer() then 
            return 
    end
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    local p = ParticleManager:CreateParticle( "particles/generic_gameplay/screen_death_indicator.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
    ParticleManager:SetParticleControl( p, 0, self.caster:GetAbsOrigin() )
    self:AddParticle(p, false, false, -1, false, false)
    self.team=self.parent:GetTeamNumber()
    self.target = EntIndexToHScript(tg.target)
    self:StartIntervalThink(self.dam_interval)
end

function modifier_fluctuating_chopping_buff:OnIntervalThink()
    if self.target==nil or not self.target:IsAlive() then 
        self:StartIntervalThink(-1)
        self:Destroy()
    end
    self.caster:SetAbsOrigin(self.target:GetAbsOrigin())
    self.caster:PerformAttack(self.target, false, true, true, false, true, false, true)  
    self.damageTable.victim =  self.target
    self.damageTable.damage = self.base_dam+self.caster:GetIntellect()*self.int_per*0.01
    ApplyDamage( self.damageTable )
end

function modifier_fluctuating_chopping_buff:OnDestroy()
    if not IsServer() then 
        return 
    end
    FindClearSpaceForUnit(self.caster,  self.caster:GetAbsOrigin(), true)
end

function modifier_fluctuating_chopping_buff:CheckState() 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        [MODIFIER_STATE_OUT_OF_GAME] = true, 
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, 
        
    } 
end

function modifier_fluctuating_chopping_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
	}
end

function modifier_fluctuating_chopping_buff:GetModifierModelScale(tg)				
    return -100
end
