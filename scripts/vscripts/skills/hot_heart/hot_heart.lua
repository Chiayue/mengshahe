hot_heart=class({})

LinkLuaModifier("modifier_hot_heart_pa", "skills/hot_heart/hot_heart.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hot_heart_attsp", "skills/hot_heart/hot_heart.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hot_heart_att", "skills/hot_heart/hot_heart.lua", LUA_MODIFIER_MOTION_NONE)

function hot_heart:GetIntrinsicModifierName() 
    return "modifier_hot_heart_pa" 
end

modifier_hot_heart_pa=class({})

function modifier_hot_heart_pa:IsHidden() 			
    return true 
end

function modifier_hot_heart_pa:IsPurgable() 			
    return false 
end

function modifier_hot_heart_pa:IsPurgeException() 	
    return false 
end

function modifier_hot_heart_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_hot_heart_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_hot_heart_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.attsp=self.ability:GetSpecialValueFor("attsp")
    self.dur=self.ability:GetSpecialValueFor("dur")
end


function modifier_hot_heart_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
    if tg.attacker == self.parent then
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_hot_heart_attsp", {duration = self.ability:GetSpecialValueFor("dur") ,num= self.ability:GetSpecialValueFor("attsp")})  
    end
end


modifier_hot_heart_attsp=class({})

function modifier_hot_heart_attsp:IsHidden() 			
    return false 
end

function modifier_hot_heart_attsp:IsPurgable() 			
    return false 
end

function modifier_hot_heart_attsp:IsPurgeException() 	
    return false 
end

function modifier_hot_heart_attsp:GetEffectAttachType() 	
    return PATTACH_ABSORIGIN_FOLLOW   
end

function modifier_hot_heart_attsp:GetEffectName() 	
    return "particles/items2_fx/mask_of_madness.vpcf"
end


function modifier_hot_heart_attsp:OnCreated(tg) 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dur=self.ability:GetSpecialValueFor("dur")			
    self.att=self.ability:GetSpecialValueFor("att")	
    self.max_attsp=self.ability:GetSpecialValueFor("max_attsp")		
    if IsServer() then 
        local sp=self:GetStackCount()+tg.num
        self:SetStackCount(sp)
        if sp>self.ability:GetSpecialValueFor("max_attsp") then 
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hot_heart_att", {duration=self.ability:GetSpecialValueFor("dur") ,num=self.ability:GetSpecialValueFor("att")})
        end 
    end
end

function modifier_hot_heart_attsp:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_hot_heart_attsp:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
    } 
end

function modifier_hot_heart_attsp:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()
end


modifier_hot_heart_att=class({})

function modifier_hot_heart_att:IsHidden() 			
    return false 
end

function modifier_hot_heart_att:IsPurgable() 			
    return false 
end

function modifier_hot_heart_att:IsPurgeException() 	
    return false 
end


function modifier_hot_heart_att:OnCreated(tg) 	
    if IsServer() then 
        self:SetStackCount(self:GetStackCount()+tg.num)
    end
end

function modifier_hot_heart_att:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_hot_heart_att:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
    } 
end

function modifier_hot_heart_att:GetModifierPreAttack_BonusDamage() 
    return self:GetStackCount()
end