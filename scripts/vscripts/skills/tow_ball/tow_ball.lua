tow_ball=class({})
tow_ball_b=tow_ball
tow_ball_a=tow_ball
LinkLuaModifier("modifier_tow_ball", "skills/tow_ball/tow_ball.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tow_ball_debuff", "skills/tow_ball/tow_ball.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function tow_ball:IsHiddenWhenStolen() 
    return false 
end

function tow_ball:IsStealable() 
    return true 
end

function tow_ball:IsRefreshable() 			
    return true 
end

function tow_ball:OnSpellStart() 
    local caster = self:GetCaster()
    local target_pos= self:GetCursorPosition()
    local duration=self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", caster)
    CreateModifierThinker(caster, self, "modifier_tow_ball", {duration = duration}, target_pos, caster:GetTeamNumber(), false)
end



modifier_tow_ball=class({})

function modifier_tow_ball:IsPurgable() 			
    return false
end

function modifier_tow_ball:IsPurgeException() 		
    return false 
end

function modifier_tow_ball:IsHidden()				
    return true 
end

function modifier_tow_ball:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dam_interval=self.ability:GetSpecialValueFor("dam_interval")
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.damageTable =
    {
        attacker = self.caster,
        ability = self.ability,
    }			
    if not IsServer() then 
            return 
    end
    self.parent_pos=self.parent:GetAbsOrigin()
    local p = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p, 0,  self.parent_pos )
    ParticleManager:SetParticleControl( p, 3,  self.parent_pos+self.parent:GetUpVector()*300 )
    self:AddParticle(p, false, false, -1, false, false)
    local p1 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf", PATTACH_WORLDORIGIN, self.parent) 
    ParticleManager:SetParticleControl( p1, 0, self.parent_pos+self.parent:GetUpVector()*100)
    ParticleManager:SetParticleControl( p1, 5, Vector(self.rd,0,0))
    self:AddParticle(p1, false, false, -1, false, false)
    self.team=self.parent:GetTeamNumber()
    self.damageTable.damage_type = self.ability:GetAbilityDamageType()
    self:StartIntervalThink(self.dam_interval)
end

function modifier_tow_ball:OnIntervalThink()
    local enemies = FindUnitsInRadius(self.team, self.parent_pos, nil,  self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies>0 then 
        local p = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_initial_explode_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( p, 3,  self.parent_pos+self.parent:GetUpVector()*300 )
        ParticleManager:ReleaseParticleIndex(p)
        EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Cast",  self.parent)
        for _,target in pairs(enemies) do
            self.damageTable.victim = target
            self.damageTable.damage = self.base_dam+self.caster:GetIntellect()*self.int_per
            ApplyDamage( self.damageTable )
            FindClearSpaceForUnit(target, self.parent_pos, false)
            target:AddNewModifier(self.caster, self.ability, "modifier_tow_ball_debuff", {duration=self.dur})
        end
    end
end


modifier_tow_ball_debuff=class({})

function modifier_tow_ball_debuff:IsPurgable() 			
    return false
end

function modifier_tow_ball_debuff:IsPurgeException() 		
    return false 
end

function modifier_tow_ball_debuff:IsHidden()				
    return false 
end

function modifier_tow_ball_debuff:IsDebuff()				
    return true 
end

function modifier_tow_ball_debuff:DeclareFunctions() 
    return 
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING
    } 
end
function modifier_tow_ball_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return self:GetAbility():GetSpecialValueFor("sp")
end

function modifier_tow_ball_debuff:GetDisableHealing()				
    return 1
end