barrier=class({})


LinkLuaModifier("modifier_barrier_pa", "skills/barrier/barrier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_barrier_buff", "skills/barrier/barrier.lua", LUA_MODIFIER_MOTION_NONE)
function barrier:GetIntrinsicModifierName() 
    return "modifier_barrier_pa" 
end

modifier_barrier_pa=class({})

function modifier_barrier_pa:IsHidden() 			
    return true 
end

function modifier_barrier_pa:IsPurgable() 			
    return false 
end

function modifier_barrier_pa:IsPurgeException() 	
    return false 
end

function modifier_barrier_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_barrier_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_barrier_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.stack=self.ability:GetSpecialValueFor("stack")
end


function modifier_barrier_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.target == self.parent or tg.attacker == self.parent then
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_barrier_buff", {num= self.ability:GetSpecialValueFor("stack")})  
    end
end


modifier_barrier_buff=class({})

function modifier_barrier_buff:IsHidden() 			
    return false 
end

function modifier_barrier_buff:IsPurgable() 			
    return false 
end

function modifier_barrier_buff:IsPurgeException() 	
    return false 
end

function modifier_barrier_buff:GetEffectAttachType() 	
    return PATTACH_OVERHEAD_FOLLOW    
end

function modifier_barrier_buff:GetEffectName() 	
    return "particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf"
end


function modifier_barrier_buff:OnCreated(tg) 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()		
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.max_stack=self.ability:GetSpecialValueFor("max_stack")
    if IsServer() then 
        self.stack=self:GetStackCount()+tg.num
        if self.stack>=self.max_stack then 
            self.stack=self.max_stack
        end 
        self:SetStackCount(self.stack)
    end
end

function modifier_barrier_buff:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_barrier_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_barrier_buff:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
    if tg.attacker == self.parent  then
        if self.stack >= self.ability:GetSpecialValueFor("max_stack") then 
            local hp=self:GetStackCount()*self.parent:GetIntellect()*0.01*self.ability:GetSpecialValueFor("int_per")
            self.parent:Heal(hp, self.parent)
            SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,hp, nil)
        end 
    end
end

function modifier_barrier_buff:GetModifierIncomingDamage_Percentage() 
    return 0-self:GetStackCount()
end

