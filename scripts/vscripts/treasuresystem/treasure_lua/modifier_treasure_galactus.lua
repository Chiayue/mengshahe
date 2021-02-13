---------------------------------------------------------------------------
-- 宝物：吞噬者
---------------------------------------------------------------------------

if modifier_treasure_galactus == nil then 
    modifier_treasure_galactus = class({})
end

function modifier_treasure_galactus:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_galactus"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_galactus:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_galactus:OnAbilityExecuted(event)
    local temp = CallAbilityContain(event.ability:GetAbilityName())
    if temp then
        Timers(function ()
            if self:GetParent():IsChanneling() then
                return 0.1
            end
            local parent = self:GetParent()
            local current_hp = parent:GetHealth()
            local add_max = 0
            for key, value in pairs(parent.call_unit) do
                if value:GetUnitName() == temp[2] then
                    if add_max < value:GetMaxHealth() then
                        add_max = value:GetMaxHealth()
                    end
                    value:ForceKill(false)
                end
            end
            parent:AddNewModifier(parent, nil, "modifier_treasure_galactus_add_health", {
                duration = 10,
                add_max = add_max,
            })
            parent:SetHealth(current_hp + add_max)
        end)
    end
end

function modifier_treasure_galactus:IsPurgable()
    return false
end
 
function modifier_treasure_galactus:RemoveOnDeath()
    return false
end

---------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_galactus_add_health","treasuresystem/treasure_lua/modifier_treasure_galactus", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_galactus_add_health == nil then
    modifier_treasure_galactus_add_health = class({})
end

function modifier_treasure_galactus_add_health:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end

function modifier_treasure_galactus_add_health:GetModifierHealthBonus()
    return self:GetStackCount()
end

function modifier_treasure_galactus_add_health:IsHidden()
    return true
end
 
function modifier_treasure_galactus_add_health:IsPurgable()
    return false
end
 
function modifier_treasure_galactus_add_health:RemoveOnDeath()
    return false
end

function modifier_treasure_galactus_add_health:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(kv.add_max)
    end
end