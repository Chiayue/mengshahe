---------------------------------------------------------------------------
-- 宝物：吸食者
---------------------------------------------------------------------------

if modifier_treasure_smoker == nil then 
    modifier_treasure_smoker = class({})
end

function modifier_treasure_smoker:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_smoker"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_smoker:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_smoker:OnAbilityExecuted(event)
    local temp = CallAbilityContain(event.ability:GetAbilityName())
    if temp then
        Timers(function ()
            if self:GetParent():IsChanneling() then
                return 0.1
            end
            local add_max = 0
            local parent = self:GetParent()
            for key, value in pairs(parent.call_unit) do
                if value:GetUnitName() == temp[2] then
                    if add_max < value:GetAttackDamage() then
                        add_max = value:GetAttackDamage()
                    end
                    value:ForceKill(false)
                end
            end
            parent:AddNewModifier(parent, nil, "modifier_treasure_smoker_add", {
                duration = 10,
                add_max = add_max,
            })
        end)
    end
end

function modifier_treasure_smoker:IsPurgable()
    return false
end
 
function modifier_treasure_smoker:RemoveOnDeath()
    return false
end

---------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_smoker_add","treasuresystem/treasure_lua/modifier_treasure_smoker", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_smoker_add == nil then
    modifier_treasure_smoker_add = class({})
end

function modifier_treasure_smoker_add:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_treasure_smoker_add:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

function modifier_treasure_smoker_add:IsHidden()
    return true
end
 
function modifier_treasure_smoker_add:IsPurgable()
    return false
end
 
function modifier_treasure_smoker_add:RemoveOnDeath()
    return false
end

function modifier_treasure_smoker_add:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(kv.add_max)
    end
end