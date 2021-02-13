demon_incarnation=class({})
demon_incarnation_b=demon_incarnation
demon_incarnation_a=demon_incarnation

LinkLuaModifier("modifier_demon_incarnation_buff", "skills/demon_incarnation/demon_incarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_incarnation_buff2", "skills/demon_incarnation/demon_incarnation.lua", LUA_MODIFIER_MOTION_NONE)

function demon_incarnation:IsHiddenWhenStolen() 
    return false 
end

function demon_incarnation:IsStealable() 
    return true 
end

function demon_incarnation:IsRefreshable() 			
    return true 
end

function demon_incarnation:OnSpellStart()
	local caster = self:GetCaster()
    local duration=self:GetSpecialValueFor("duration") 
    caster:EmitSound( "Hero_Terrorblade.Metamorphosis" )
    caster:AddNewModifier( caster, self, "modifier_demon_incarnation_buff", {duration=duration})
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
    
end

modifier_demon_incarnation_buff = class({})


function modifier_demon_incarnation_buff:IsHidden() 			
    return false 
end

function modifier_demon_incarnation_buff:IsPurgable() 			
    return false 
end

function modifier_demon_incarnation_buff:IsPurgeException() 	
    return false 
end

function modifier_demon_incarnation_buff:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.int_per=self.ability:GetSpecialValueFor("int_per")
    self.att_per=self.ability:GetSpecialValueFor("att_per")
    self.attsp=self.ability:GetSpecialValueFor("attsp")
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.hp=self.ability:GetSpecialValueFor("hp")
    self.damageTable =
    {
        attacker = self.parent,
        ability = self.ability,
        damage_type = DAMAGE_TYPE_PHYSICAL,
    }	
    if IsServer() then 
        local P = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
        self:AddParticle( P, false, false, 20, false, false ) 
        local P2 = ParticleManager:CreateParticle("particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf", PATTACH_CENTER_FOLLOW ,self.parent)
        for a=0,4 do
            ParticleManager:SetParticleControl(P2,a,self.parent:GetAbsOrigin())
        end 
        ParticleManager:SetParticleControl(P2, 61,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(P2,16,Vector(1,0,0))
        self:AddParticle( P2, false, false, 20, false, false )   
    end
end

function modifier_demon_incarnation_buff:OnRefresh() 
    if IsServer() then 
        local P2 = ParticleManager:CreateParticle("particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf", PATTACH_CENTER_FOLLOW ,self.parent)
        for a=0,4 do
            ParticleManager:SetParticleControl(P2,a,self.parent:GetAbsOrigin())
        end 
        ParticleManager:SetParticleControl(P2, 61,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(P2,16,Vector(1,0,0))
        self:AddParticle( P2, false, false, 20, false, false )   
    end
end


function modifier_demon_incarnation_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    } 
end

function modifier_demon_incarnation_buff:GetModifierAttackSpeedBonus_Constant() 
    return self.attsp
end

function modifier_demon_incarnation_buff:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end

function modifier_demon_incarnation_buff:GetModifierModelChange() 
    return "models/items/terrorblade/tb_samurai_samurai_demon/tb_samurai_samurai_demon.vmdl"
end

function modifier_demon_incarnation_buff:GetModifierModelScale() 
    if self.parent~=nil and self.parent:HasModifier("modifier_fluctuating_chopping_buff") then 
        return -1000
    else 
        return 100
    end 
end



function modifier_demon_incarnation_buff:OnAttackLanded(tg) 
    if IsServer() then 
        if tg.attacker==self.parent then 
            self.damageTable.victim = tg.target
            self.damageTable.damage = self.parent:GetAverageTrueAttackDamage(self.parent)*self.att_per*0.01+self.parent:GetIntellect()*self.int_per*0.01
            ApplyDamage( self.damageTable )
        end 
    end
end

function modifier_demon_incarnation_buff:OnDeath(tg) 
    if IsServer() then 
        if tg.attacker==self.parent then 
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_demon_incarnation_buff2", {num=self.hp})
        end 
    end
end


modifier_demon_incarnation_buff2= class({})


function modifier_demon_incarnation_buff2:IsHidden() 			
    return false 
end

function modifier_demon_incarnation_buff2:IsPurgable() 			
    return false 
end

function modifier_demon_incarnation_buff2:IsPurgeException() 	
    return false 
end

function modifier_demon_incarnation_buff2:IsPermanent() 	
    return true 
end

function modifier_demon_incarnation_buff2:RemoveOnDeath() 	
    return false 
end

function modifier_demon_incarnation_buff2:OnCreated(tg) 	
    if IsServer() then 
        self:SetStackCount(self:GetStackCount()+tg.num)
    end
end

function modifier_demon_incarnation_buff2:OnRefresh(tg) 
    self:OnCreated(tg) 
end

 
function modifier_demon_incarnation_buff2:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_HEALTH_BONUS, 
    } 
end

function modifier_demon_incarnation_buff2:GetModifierHealthBonus() 
    return self:GetStackCount()
end