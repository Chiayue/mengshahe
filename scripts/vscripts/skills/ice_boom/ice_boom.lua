ice_boom=class({})
ice_boom_d=ice_boom
ice_boom_c=ice_boom

LinkLuaModifier("modifier_ice_boom", "skills/ice_boom/ice_boom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_boom_debuff", "skills/ice_boom/ice_boom.lua", LUA_MODIFIER_MOTION_NONE)

function ice_boom:IsHiddenWhenStolen() 
    return false 
end

function ice_boom:IsStealable() 
    return true 
end

function ice_boom:IsRefreshable() 			
    return true 
end

function ice_boom:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("num")*self:GetSpecialValueFor("explosion_interval") 
    EmitSoundOn("DOTA_Item.RepairKit.Target", caster) 
    local p = ParticleManager:CreateParticle( "particles/econ/events/nexon_hero_compendium_2014/teleport_end_ground_flash_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p, 0, caster_pos )
    ParticleManager:ReleaseParticleIndex( p )
    local p1 = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p1, 0, caster_pos )
    ParticleManager:SetParticleControl( p1, 3, caster_pos )
    ParticleManager:ReleaseParticleIndex( p1 )
	CreateModifierThinker(caster, self, "modifier_ice_boom", {duration = duration}, caster_pos, caster:GetTeamNumber(), false)
end

modifier_ice_boom=class({})

function modifier_ice_boom:IsPurgable() 			
    return false
end

function modifier_ice_boom:IsPurgeException() 		
    return false 
end

function modifier_ice_boom:IsHidden()				
    return true 
end

function modifier_ice_boom:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.explosion_interval=self.ability:GetSpecialValueFor("explosion_interval")
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.explosion_radius=self.ability:GetSpecialValueFor("explosion_radius")
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")	
    self.debuff_dur=self.ability:GetSpecialValueFor("debuff_dur")	
    self.damageTable =
    {
        attacker = self.caster,
        damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
        ability = self.ability,
    }			
    if not IsServer() then 
            return 
    end
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    self.team=self.parent:GetTeamNumber()
    self.parent_pos=self.parent:GetAbsOrigin()
    self:StartIntervalThink(self.explosion_interval)
end

function modifier_ice_boom:OnIntervalThink()
    local pos = GetGroundPosition(GetRandomPosition2D(self.parent_pos,self.radius), self.parent)				
    local p = ParticleManager:CreateParticle( "particles/econ/events/ti9/high_five/high_five_impact_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p, 3, pos )
    ParticleManager:ReleaseParticleIndex( p )
    EmitSoundOnLocationWithCaster(pos, "TG.boom", self.parent)
    local enemies = FindUnitsInRadius(self.team, pos, nil, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies>0 then 
        for _,target in pairs(enemies) do
            self.damageTable.victim = target
            self.damageTable.damage = self.base_dam
            ApplyDamage( self.damageTable )
            target:AddNewModifier(self.caster, self.ability, "modifier_ice_boom_debuff", {duration = self.debuff_dur})     
        end
    end
end


modifier_ice_boom_debuff=class({})

function modifier_ice_boom_debuff:IsPurgable() 			
    return false
end

function modifier_ice_boom_debuff:IsPurgeException() 		
    return false 
end

function modifier_ice_boom_debuff:IsHidden()				
    return false 
end

function modifier_ice_boom_debuff:IsDebuff()				
    return true 
end

function modifier_ice_boom_debuff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.interval_dam=self.ability:GetSpecialValueFor("interval_dam")
    self.int_per=self.ability:GetSpecialValueFor("int_per")	
    self.dam=self.ability:GetSpecialValueFor("dam")		
    self.damageTable =
    {
        victim = self.parent,
        attacker = self.caster,
        damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
        ability = self.ability,
    }	
    if not IsServer() then 
            return 
    end
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    self:StartIntervalThink(self.interval_dam)
end

function modifier_ice_boom_debuff:OnIntervalThink()
    self.damageTable.damage = self.caster:GetIntellect()*self.int_per
    ApplyDamage( self.damageTable )
end

function modifier_ice_boom_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
    } 
end

function modifier_ice_boom_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return self.ability:GetSpecialValueFor("sp")
end

