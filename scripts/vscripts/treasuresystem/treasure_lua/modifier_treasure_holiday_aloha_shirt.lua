---------------------------------------------------------------------------
-- 宝物：休假用品 - 夏威夷衬衫
---------------------------------------------------------------------------

if modifier_treasure_holiday_aloha_shirt == nil then 
    modifier_treasure_holiday_aloha_shirt = class({})
end

function modifier_treasure_holiday_aloha_shirt:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_holiday_aloha_shirt:GetModifierPhysicalArmorBonus()
    return 6
end

function modifier_treasure_holiday_aloha_shirt:GetModifierAttackSpeedBonus_Constant()
    return 20
end

function modifier_treasure_holiday_aloha_shirt:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_aloha_shirt:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_aloha_shirt:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_aloha_shirt"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holiday_aloha_shirt:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_treasure_holiday_aloha_shirt:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        local mdf = self:GetParent():FindModifierByName("modifier_treasure_holiday_note")
        if mdf then
            mdf:OnModifierAdded()
        end
    end
end