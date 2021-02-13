blink_attack=class({})


LinkLuaModifier("modifier_blink_attack_pa", "skills/blink_attack/blink_attack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blink_attack_rg", "skills/blink_attack/blink_attack.lua", LUA_MODIFIER_MOTION_NONE)
function blink_attack:GetIntrinsicModifierName() 
    return "modifier_blink_attack_pa" 
end

modifier_blink_attack_pa=class({})

function modifier_blink_attack_pa:IsHidden() 			
    return true 
end

function modifier_blink_attack_pa:IsPurgable() 			
    return false 
end

function modifier_blink_attack_pa:IsPurgeException() 	
    return false 
end

function modifier_blink_attack_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_blink_attack_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_blink_attack_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ch=self.ability:GetSpecialValueFor("ch")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.back_dis=self.ability:GetSpecialValueFor("back_dis")
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.damageTable = {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self.ability,
    }
end


function modifier_blink_attack_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.target == self.parent  then
        if RollPseudoRandomPercentage(self.ability:GetSpecialValueFor("ch"),0,self.ability) then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_invincible", {num= self.ability:GetSpecialValueFor("dur")})  
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_blink_attack_rg", {num= self.ability:GetSpecialValueFor("dur")})  
            local P = ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControl(P, 0, self.parent:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(P)
            FindClearSpaceForUnit(self.parent, self.parent:GetForwardVector()*-self.ability:GetSpecialValueFor("back_dis"), false)
            self.damageTable.damage=self.parent:GetIntellect()*self.ability:GetSpecialValueFor("int_per")*0.01
            self.damageTable.victim=tg.attacker
            ApplyDamage(self.damageTable)
        end
    end
end


modifier_blink_attack_rg=class({})


function modifier_blink_attack_rg:IsHidden() 			
    return false 
end

function modifier_blink_attack_rg:IsPurgable() 			
    return false 
end

function modifier_blink_attack_rg:IsPurgeException() 	
    return false 
end

function modifier_blink_attack_rg:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
    } 
end

function modifier_blink_attack_rg:GetModifierAttackRangeBonus() 
    return self:GetAbility():GetSpecialValueFor("rg")
end