link=class({})

LinkLuaModifier("modifier_link_pa", "skills/link/link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_link_attsp", "skills/link/link.lua", LUA_MODIFIER_MOTION_NONE)

function link:GetIntrinsicModifierName() 
    return "modifier_link_pa" 
end

modifier_link_pa=class({})

function modifier_link_pa:IsHidden() 			
    return true 
end

function modifier_link_pa:IsPurgable() 			
    return false 
end

function modifier_link_pa:IsPurgeException() 	
    return false 
end

function modifier_link_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_link_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_link_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dam=self.ability:GetSpecialValueFor("dam")		
    self.ch=self.ability:GetSpecialValueFor("ch")	
    self.hp=self.ability:GetSpecialValueFor("hp")	
    self.attsp=self.ability:GetSpecialValueFor("attsp")
    self.dur=self.ability:GetSpecialValueFor("dur")
    if not IsServer() then 
        return 
    end
end


function modifier_link_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
    if tg.target == self.parent then
        if RollPseudoRandomPercentage(self.ability:GetSpecialValueFor("ch"),0,self.ability) then
            local hp=self.ability:GetSpecialValueFor("hp")*tg.damage*0.01+self.parent:GetIntellect()
            self.parent:Heal(hp, self.parent)
            SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,hp, nil)
            if tg.damage>self.ability:GetSpecialValueFor("dam") then 
                self.parent:Purge(false, true, false, true, true)
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_link_attsp", {duration = self.ability:GetSpecialValueFor("dur") ,num= self.ability:GetSpecialValueFor("attsp")})  
            end 
        end
    end
end

modifier_link_attsp=class({})

function modifier_link_attsp:IsHidden() 			
    return false 
end

function modifier_link_attsp:IsPurgable() 			
    return false 
end

function modifier_link_attsp:IsPurgeException() 	
    return false 
end

function modifier_link_attsp:GetEffectAttachType() 	
    return PATTACH_OVERHEAD_FOLLOW  
end

function modifier_link_attsp:GetEffectName() 	
    return "particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf"
end


function modifier_link_attsp:OnCreated(tg) 	
    if IsServer() then 
        self:SetStackCount(self:GetStackCount()+tg.num)
    end
end

function modifier_link_attsp:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_link_attsp:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
    } 
end

function modifier_link_attsp:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()
end