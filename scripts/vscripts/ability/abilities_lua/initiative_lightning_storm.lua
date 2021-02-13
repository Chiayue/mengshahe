
LinkLuaModifier("modifier_tg_lh_ls_debuff", "ability/abilities_lua/initiative_lightning_storm.lua", LUA_MODIFIER_MOTION_NONE)

tg_lh_ls_d=tg_lh_ls_d or class({})

function tg_lh_ls_d:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_ls_d:IsStealable() 
    return true 
end

function tg_lh_ls_d:IsNetherWardStealable() 
    return true 
end

function tg_lh_ls_d:IsRefreshable() 			
    return true 
end

function tg_lh_ls_d:ProcsMagicStick() 			
    return true 
end


function tg_lh_ls_d:OnSpellStart()
    local  enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    local attr_scale = self:GetSpecialValueFor("attr_scale")
    for _,target in pairs(enemies) do
        local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 1000))
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
        target:EmitSound("Hero_Leshrac.Lightning_Storm")  
        local damageTable = {
            attacker =  self:GetCaster(),
            victim = target,
            damage = self:GetSpecialValueFor("dam") + self:GetCaster():GetIntellect() * attr_scale,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        }
        ApplyDamage(damageTable)
        target:AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_ls_debuff", {duration=self:GetSpecialValueFor("debufft")})
    end
end

tg_lh_ls_c=tg_lh_ls_c or class({})

function tg_lh_ls_c:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_ls_c:IsStealable() 
    return true 
end

function tg_lh_ls_c:IsNetherWardStealable() 
    return true 
end

function tg_lh_ls_c:IsRefreshable() 			
    return true 
end

function tg_lh_ls_c:ProcsMagicStick() 			
    return true 
end


function tg_lh_ls_c:OnSpellStart()
    local  enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	
    local attr_scale = self:GetSpecialValueFor("attr_scale")	
    for _,target in pairs(enemies) do
        local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 1000))
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
        target:EmitSound("Hero_Leshrac.Lightning_Storm")  
        local damageTable = {
            attacker =  self:GetCaster(),
            victim = target,
            damage = self:GetSpecialValueFor("dam") + self:GetCaster():GetIntellect() * attr_scale,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        }
        ApplyDamage(damageTable)
        target:AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_ls_debuff", {duration=self:GetSpecialValueFor("debufft")})
    end
end


tg_lh_ls_b=tg_lh_ls_b or class({})

function tg_lh_ls_b:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_ls_b:IsStealable() 
    return true 
end

function tg_lh_ls_b:IsNetherWardStealable() 
    return true 
end

function tg_lh_ls_b:IsRefreshable() 			
    return true 
end

function tg_lh_ls_b:ProcsMagicStick() 			
    return true 
end


function tg_lh_ls_b:OnSpellStart()
    local  enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    local attr_scale = self:GetSpecialValueFor("attr_scale")
    for _,target in pairs(enemies) do
        local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 1000))
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
        target:EmitSound("Hero_Leshrac.Lightning_Storm")  
        local damageTable = {
            attacker =  self:GetCaster(),
            victim = target,
            damage = self:GetSpecialValueFor("dam") + self:GetCaster():GetIntellect() * attr_scale,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        }
        ApplyDamage(damageTable)
        target:AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_ls_debuff", {duration=self:GetSpecialValueFor("debufft")})
    end
end

tg_lh_ls_a=tg_lh_ls_a or class({})

function tg_lh_ls_a:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_ls_a:IsStealable() 
    return true 
end

function tg_lh_ls_a:IsNetherWardStealable() 
    return true 
end

function tg_lh_ls_a:IsRefreshable() 			
    return true 
end

function tg_lh_ls_a:ProcsMagicStick() 			
    return true 
end


function tg_lh_ls_a:OnSpellStart()
    local  enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    local attr_scale = self:GetSpecialValueFor("attr_scale")
    for _,target in pairs(enemies) do
        local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 1000))
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
        target:EmitSound("Hero_Leshrac.Lightning_Storm")  
        local damageTable = {
            attacker =  self:GetCaster():GetOwner(),
            victim = target,
            damage = self:GetSpecialValueFor("dam") + self:GetCaster():GetIntellect() * attr_scale,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        }
        ApplyDamage(damageTable)
        target:AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_ls_debuff", {duration=self:GetSpecialValueFor("debufft")})
    end
end


modifier_tg_lh_ls_debuff=modifier_tg_lh_ls_debuff or class({})
function modifier_tg_lh_ls_debuff:IsDebuff()
    return true 
end
function modifier_tg_lh_ls_debuff:IsPurgable() 			
    return false
end
function modifier_tg_lh_ls_debuff:IsPurgeException() 		
    return false 
end
function modifier_tg_lh_ls_debuff:IsHidden()				
    return false 
end

function modifier_tg_lh_ls_debuff:OnCreated()	
    
end

function modifier_tg_lh_ls_debuff:DeclareFunctions()
    return   {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_tg_lh_ls_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -25
end

function modifier_tg_lh_ls_debuff:GetModifierAttackSpeedBonus_Constant()
	return -100
end

function modifier_tg_lh_ls_debuff:GetEffectName() 
	return "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf" 
end

function modifier_tg_lh_ls_debuff:GetEffectAttachType() 
	return PATTACH_ABSORIGIN_FOLLOW 
end