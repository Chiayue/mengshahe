deflection=class({})

LinkLuaModifier("modifier_deflection_pa", "skills/deflection/deflection.lua", LUA_MODIFIER_MOTION_NONE)

function deflection:GetIntrinsicModifierName() 
    return "modifier_deflection_pa" 
end

modifier_deflection_pa=class({})

function modifier_deflection_pa:IsHidden() 			
    return true 
end

function modifier_deflection_pa:IsPurgable() 			
    return false 
end

function modifier_deflection_pa:IsPurgeException() 	
    return false 
end

function modifier_deflection_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_deflection_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_deflection_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ab=self.ability:GetSpecialValueFor("ab")
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.damageTable = {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self.ability,
    }
    if not IsServer() then 
        return 
    end
    self.team=self.parent:GetTeamNumber()
end


function modifier_deflection_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
    if tg.target == self.parent then
        self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2.5)
        local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #enemies>0 then 
            for _,target in pairs(enemies) do
                self.parent:PerformAttack(target, false, false, true, false, true, false, true)  
                self.damageTable.victim = target
                self.damageTable.damage = self.parent:GetIntellect()*self.ability:GetSpecialValueFor("ab")*0.01+self.parent:GetStrength()*self.ab*0.01+self.parent:GetAgility()*self.ab*0.01
                ApplyDamage( self.damageTable )   
            end
        end
    end
end
