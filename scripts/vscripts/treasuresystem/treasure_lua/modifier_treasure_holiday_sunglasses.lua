---------------------------------------------------------------------------
-- 宝物：休假用品 - 墨镜
---------------------------------------------------------------------------

if modifier_treasure_holiday_sunglasses == nil then 
    modifier_treasure_holiday_sunglasses = class({})
end

function modifier_treasure_holiday_sunglasses:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_holiday_sunglasses:OnAttackFail(event)
    if RollPercentage(35) then
        self:GetParent():PerformAttack(event.target, false, true, true, false, true, false, true) 
    end
end

function modifier_treasure_holiday_sunglasses:GetModifierBonusStats_Strength()
    return 50
end

function modifier_treasure_holiday_sunglasses:GetModifierBonusStats_Agility()
    return 50
end

function modifier_treasure_holiday_sunglasses:GetModifierBonusStats_Intellect()
    return 50
end

function modifier_treasure_holiday_sunglasses:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_sunglasses"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holiday_sunglasses:IsPurgable()
    return false
end

function modifier_treasure_holiday_sunglasses:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_sunglasses:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_treasure_holiday_sunglasses:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        local mdf = self:GetParent():FindModifierByName("modifier_treasure_holiday_note")
        if mdf then
            mdf:OnModifierAdded()
        end
    end
end