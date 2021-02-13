pierce_the_heart=class({})

LinkLuaModifier("modifier_pierce_the_heart_pa", "skills/pierce_the_heart/pierce_the_heart.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pierce_the_heart_debuff", "skills/pierce_the_heart/pierce_the_heart.lua", LUA_MODIFIER_MOTION_NONE)

function pierce_the_heart:GetIntrinsicModifierName() 
    return "modifier_pierce_the_heart_pa" 
end


modifier_pierce_the_heart_pa=class({})

function modifier_pierce_the_heart_pa:IsHidden() 			
    return true 
end

function modifier_pierce_the_heart_pa:IsPurgable() 			
    return false 
end

function modifier_pierce_the_heart_pa:IsPurgeException() 	
    return false 
end

function modifier_pierce_the_heart_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_pierce_the_heart_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_pierce_the_heart_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ar=self.ability:GetSpecialValueFor("ar")		
    self.dur=self.ability:GetSpecialValueFor("dur")	
    if not IsServer() then 
        return 
    end
end


function modifier_pierce_the_heart_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent()  then
		return
    end
    tg.target:AddNewModifier(self.caster, self.ability, "modifier_pierce_the_heart_debuff", {duration= self.ability:GetSpecialValueFor("dur"),num=self.ability:GetSpecialValueFor("ar")})
end


modifier_pierce_the_heart_debuff=class({})

function modifier_pierce_the_heart_debuff:IsDebuff() 			
    return true 
end

function modifier_pierce_the_heart_debuff:IsHidden() 			
    return false 
end

function modifier_pierce_the_heart_debuff:IsPurgable() 			
    return false 
end

function modifier_pierce_the_heart_debuff:IsPurgeException() 	
    return false 
end

function modifier_pierce_the_heart_debuff:IsPurgeException() 	
    return false 
end

function modifier_pierce_the_heart_debuff:GetEffectAttachType() 	
    return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_pierce_the_heart_debuff:GetEffectName() 	
    return "particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_overhead.vpcf" 
end

function modifier_pierce_the_heart_debuff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ar_max=self.ability:GetSpecialValueFor("ar_max")	
    self.base_dam=self.ability:GetSpecialValueFor("base_dam")
    self.int_per=self.ability:GetSpecialValueFor("int_per")	
    if not IsServer() then 
        return 
    end
    local ar=self:GetStackCount()+tg.num
    self:SetStackCount(ar)
    if ar>self.ability:GetSpecialValueFor("ar_max") then 
        local damageTable = {
            victim = self.parent,
            attacker = self.caster,
            damage = self.ability:GetSpecialValueFor("base_dam")+self.caster:GetIntellect()*self.ability:GetSpecialValueFor("int_per")*0.01,
            damage_type =DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, 
            ability = self.ability,
            }
        ApplyDamage(damageTable)
    end 
end


function modifier_pierce_the_heart_debuff:OnRefresh(tg) 	
   self:OnCreated(tg)
end


function modifier_pierce_the_heart_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    } 
end


function modifier_pierce_the_heart_debuff:GetModifierPhysicalArmorBonus() 
    return 0-self:GetStackCount()
end