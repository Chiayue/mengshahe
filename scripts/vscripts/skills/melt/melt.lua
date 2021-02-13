melt=class({})

LinkLuaModifier("modifier_melt_pa", "skills/melt/melt.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_melt_buff", "skills/melt/melt.lua", LUA_MODIFIER_MOTION_NONE)

function melt:GetIntrinsicModifierName() 
    return "modifier_melt_pa" 
end


modifier_melt_pa=class({})

function modifier_melt_pa:IsHidden() 			
    return true 
end

function modifier_melt_pa:IsPurgable() 			
    return false 
end

function modifier_melt_pa:IsPurgeException() 	
    return false 
end

function modifier_melt_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_melt_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_melt_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.rd=self.ability:GetSpecialValueFor("rd")		
    self.int_per=self.ability:GetSpecialValueFor("int_per")	
    self.dur=self.ability:GetSpecialValueFor("dur")	
    self.mr=self.ability:GetSpecialValueFor("mr")	
    self.damageTable = {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
    }
    if not IsServer() then 
        return 
    end
    self.team=self.parent:GetTeamNumber()
end


function modifier_melt_pa:OnAbilityFullyCast(tg)
    if not IsServer() then
		return
	end
    if tg.unit == self.parent then
        if not tg.ability or tg.ability:IsItem() or tg.ability:IsToggle() then 
            return 
        end
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_melt_buff", {duration = self.dur ,num= self.mr})     
        local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #enemies>0 then 
            for _,target in pairs(enemies) do
                self.damageTable.victim = target
                self.damageTable.damage = self.int_per*self.parent:GetIntellect()*0.01
                ApplyDamage( self.damageTable )
                target:AddNewModifier(self.parent, self.ability, "modifier_melt_buff", {duration = self.dur ,num= self.mr})     
            end
        end
    end
end

modifier_melt_buff=class({})

function modifier_melt_buff:IsDebuff() 
    if 	self:GetParent()==self:GetCaster() then 		
        return false 
    else 
        return true 
    end
end

function modifier_melt_buff:IsHidden() 			
    return false 
end

function modifier_melt_buff:IsPurgable() 			
    return false 
end

function modifier_melt_buff:IsPurgeException() 	
    return false 
end

function modifier_melt_buff:OnCreated(tg) 	
    if IsServer() then 
        self:SetStackCount(self:GetStackCount()+tg.num)
    end
end

function modifier_melt_buff:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_melt_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
    } 
end

function modifier_melt_buff:GetModifierMagicalResistanceBonus() 
    return 0-self:GetStackCount()
end