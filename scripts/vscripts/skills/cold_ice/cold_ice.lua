cold_ice=class({})
cold_ice_b=cold_ice
cold_ice_a=cold_ice


LinkLuaModifier("modifier_cold_ice_pa", "skills/cold_ice/cold_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold_ice_buff", "skills/cold_ice/cold_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold_ice_debuff", "skills/cold_ice/cold_ice.lua", LUA_MODIFIER_MOTION_NONE)
function cold_ice:GetIntrinsicModifierName() 
    return "modifier_cold_ice_pa" 
end

modifier_cold_ice_pa=class({})

function modifier_cold_ice_pa:IsHidden() 			
    return true 
end

function modifier_cold_ice_pa:IsPurgable() 			
    return false 
end

function modifier_cold_ice_pa:IsPurgeException() 	
    return false 
end

function modifier_cold_ice_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_cold_ice_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_cold_ice_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.spell=self.ability:GetSpecialValueFor("spell")
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


function modifier_cold_ice_pa:OnDeath(tg)
    if not IsServer() then
		return
	end
    if tg.attacker == self.parent then
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_cold_ice_buff", {num= self.ability:GetSpecialValueFor("spell")})  
    end
end

function modifier_cold_ice_pa:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_cold_ice_buff")
    end
end


modifier_cold_ice_buff=class({})

function modifier_cold_ice_buff:IsHidden() 			
    return false 
end

function modifier_cold_ice_buff:IsPurgable() 			
    return false 
end

function modifier_cold_ice_buff:IsPurgeException() 	
    return false 
end

function modifier_cold_ice_buff:RemoveOnDeath() 	
    return false 
end

function modifier_cold_ice_buff:IsDebuff() 	
    return false 
end

function modifier_cold_ice_buff:OnCreated(tg) 	
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.max_spell=self.ability:GetSpecialValueFor("max_spell")
    self.rd2=self.ability:GetSpecialValueFor("rd2")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    
    self.damageTable = {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
    }
    if IsServer() then 
        self.team=self.parent:GetTeamNumber()
        local spell=self:GetStackCount()+tg.num
        self:SetStackCount(spell)
        if spell>=self.ability:GetSpecialValueFor("max_spell") then 
            self:Destroy()
        end 
    end
end

function modifier_cold_ice_buff:OnRefresh(tg) 
    self:OnCreated(tg) 
end

function modifier_cold_ice_buff:OnDestroy(tg) 
    if IsServer() then 
        local P = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(P, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(P, 1, Vector(self.ability:GetSpecialValueFor("rd2"),self.ability:GetSpecialValueFor("rd2"),400))
        ParticleManager:SetParticleControl(P, 2,  self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(P)
        local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("rd2"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #enemies>0 then 
            for _,target in pairs(enemies) do
                -- self.damageTable.damage=self.parent:GetIntellect()*self.ability:GetSpecialValueFor("int_per")*0.01
                self.damageTable.damage=self.parent:GetBaseDamageMin()*self.ability:GetSpecialValueFor("int_per")
                self.damageTable.victim=target
                ApplyDamage(self.damageTable)
                target:AddNewModifier(self.parent, self.ability, "modifier_cold_ice_debuff", {duration = self.ability:GetSpecialValueFor("dur")})     
            end
        end 
    end
end


 
function modifier_cold_ice_buff:DeclareFunctions() 
    return 
    {
        -- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    } 
end

-- function modifier_cold_ice_buff:GetModifierSpellAmplify_Percentage() 
--     return self:GetStackCount()
-- end

function modifier_cold_ice_buff:GetModifierDamageOutgoing_Percentage() 
    return self:GetStackCount()
end


modifier_cold_ice_debuff=class({})

function modifier_cold_ice_debuff:IsHidden() 			
    return false 
end

function modifier_cold_ice_debuff:IsPurgable() 			
    return false 
end

function modifier_cold_ice_debuff:IsPurgeException() 	
    return false 
end

function modifier_cold_ice_debuff:IsDebuff() 	
    return true 
end

function modifier_cold_ice_debuff:GetEffectName() 
    return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" 
end

function modifier_cold_ice_debuff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end


function modifier_cold_ice_debuff:CheckState() 
    return 
    {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_TETHERED] = true,    
    } 
end