---------------------------------------------------------------------------
-- 宝物：生存猎
---------------------------------------------------------------------------

if modifier_treasure_survival_hunters == nil then 
    modifier_treasure_survival_hunters = class({})
end

function modifier_treasure_survival_hunters:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_survival_hunters:OnAbilityExecuted(event)
    local temp = CallAbilityContain(event.ability:GetAbilityName())
    if temp then
        Timers(function ()
            if self:GetParent():IsChanneling() then
                return 0.1
            end
            self:CountCallUnit()
        end)
    end
end

function modifier_treasure_survival_hunters:OnDeath(params)
    local parent = self:GetParent()
    local unit = params.unit
    if unit:GetTeamNumber() == parent:GetTeamNumber() and unit:GetOwner() == parent then
        Timers(function ()
            self:CountCallUnit()
        end)
    end
end

function modifier_treasure_survival_hunters:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_survival_hunters"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_survival_hunters:IsPurgable()
    return false
end
 
function modifier_treasure_survival_hunters:RemoveOnDeath()
    return false
end
 
function modifier_treasure_survival_hunters:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_survival_hunters_buff")
        for key, value in pairs(parent.call_unit) do
            value:RemoveModifierByName("modifier_treasure_survival_hunters_buff")
        end
    end
end

function modifier_treasure_survival_hunters:OnCreated(kv)
    if IsServer() then
        self:CountCallUnit()
    end
end

function modifier_treasure_survival_hunters:CountCallUnit()
    local parent = self:GetParent()
    local call_unit_map = {}
    for key, value in pairs(parent.call_unit) do
        call_unit_map[value:GetUnitName()] = 1
    end
    local current_count = 0
    for key, value in pairs(call_unit_map) do
        current_count = current_count + 1
    end
    if current_count > 0 then
        parent:AddNewModifier(parent, nil, "modifier_treasure_survival_hunters_buff", {current_count = current_count})
        for key, value in pairs(parent.call_unit) do
            value:AddNewModifier(parent, nil, "modifier_treasure_survival_hunters_buff", {current_count = current_count})
        end 
    else
        parent:RemoveModifierByName("modifier_treasure_survival_hunters_buff")
        for key, value in pairs(parent.call_unit) do
            value:RemoveModifierByName("modifier_treasure_survival_hunters_buff")
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_survival_hunters_buff","treasuresystem/treasure_lua/modifier_treasure_survival_hunters", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_survival_hunters_buff == nil then 
    modifier_treasure_survival_hunters_buff = class({})
end

function modifier_treasure_survival_hunters_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_survival_hunters_buff:GetModifierIncomingDamage_Percentage()
    return -10 * self:GetStackCount()
end

function modifier_treasure_survival_hunters_buff:GetModifierHealAmplify_PercentageTarget()
    return 10 * self:GetStackCount()
end

function modifier_treasure_survival_hunters_buff:GetModifierHPRegenAmplify_Percentage()
    return 10 * self:GetStackCount()
end

function modifier_treasure_survival_hunters_buff:GetModifierDamageOutgoing_Percentage()
    return -40
end

function modifier_treasure_survival_hunters_buff:IsHidden()
    return true
end
 
function modifier_treasure_survival_hunters_buff:IsPurgable()
    return false
end
 
function modifier_treasure_survival_hunters_buff:RemoveOnDeath()
    return false
end

function modifier_treasure_survival_hunters_buff:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(kv.current_count)
    end
end

function modifier_treasure_survival_hunters_buff:OnRefresh(kv)
    if IsServer() then
        self:SetStackCount(kv.current_count)
    end
end
