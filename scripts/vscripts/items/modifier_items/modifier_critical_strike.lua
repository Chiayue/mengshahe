require("items/lua_items_ability/item_ability")

if modifier_critical_strike == nil then 
    modifier_critical_strike = class({})
end

--暴击modifier
function modifier_critical_strike:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end


function modifier_critical_strike:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    local critical_damage = evt.critical_damage or self:GetAbility():GetSpecialValueFor( "critical_damage" ) 
    self.critical_damage =critical_damage * 100
end

function modifier_critical_strike:OnAttackLanded(evt)
    if not IsServer( ) then
        return
    end
    local attacker = evt.attacker 
    if attacker:IsHero() then 
        self:Destroy()
    end
end

function modifier_critical_strike:GetModifierPreAttack_CriticalStrike(params)
    return self.critical_damage
end

function modifier_critical_strike:IsHidden()
    return true    
 end