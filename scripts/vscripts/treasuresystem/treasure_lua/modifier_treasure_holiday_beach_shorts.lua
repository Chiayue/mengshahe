---------------------------------------------------------------------------
-- 宝物：休假用品 - 沙滩裤
---------------------------------------------------------------------------

if modifier_treasure_holiday_beach_shorts == nil then 
    modifier_treasure_holiday_beach_shorts = class({})
end

function modifier_treasure_holiday_beach_shorts:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_treasure_holiday_beach_shorts:GetModifierConstantManaRegen()
    return 1
end

function modifier_treasure_holiday_beach_shorts:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_beach_shorts:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_beach_shorts:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_beach_shorts"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holiday_beach_shorts:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_treasure_holiday_beach_shorts:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        local mdf = self:GetParent():FindModifierByName("modifier_treasure_holiday_note")
        if mdf then
            mdf:OnModifierAdded()
        end
    end
end