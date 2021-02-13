---------------------------------------------------------------------------
-- 宝物：休假用品 - 冰可乐
---------------------------------------------------------------------------

if modifier_treasure_holiday_icecola == nil then 
    modifier_treasure_holiday_icecola = class({})
end

function modifier_treasure_holiday_icecola:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

function modifier_treasure_holiday_icecola:GetModifierHealthRegenPercentage()
    return 2
end

function modifier_treasure_holiday_icecola:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_icecola:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_icecola:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_icecola"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holiday_icecola:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_treasure_holiday_icecola:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        local mdf = self:GetParent():FindModifierByName("modifier_treasure_holiday_note")
        if mdf then
            mdf:OnModifierAdded()
        end
    end
end