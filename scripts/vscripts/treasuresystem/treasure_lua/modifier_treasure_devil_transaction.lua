---------------------------------------------------------------------------
-- 宝物：恶魔交易
---------------------------------------------------------------------------

if modifier_treasure_devil_transaction == nil then 
    modifier_treasure_devil_transaction = class({})
end

function modifier_treasure_devil_transaction:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_devil_transaction"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_devil_transaction:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_devil_transaction:GetModifierBonusStats_Strength()
    return -100
end

function modifier_treasure_devil_transaction:GetModifierBonusStats_Agility()
    return -100
end

function modifier_treasure_devil_transaction:GetModifierBonusStats_Intellect()
    return -100
end

function modifier_treasure_devil_transaction:IsPurgable()
    return false
end

function modifier_treasure_devil_transaction:RemoveOnDeath()
    return false
end

function modifier_treasure_devil_transaction:OnCreated(params)
    if IsServer() then
        for i = 1, 2 do
            local quality = "SSR"
            local random = RandomInt(1, 100)
            if random >= 1 and random <= 60 then
                quality = "N"
            elseif random >= 61 and random <= 90 then
                quality = "R"
            elseif random >= 91 and random <= 99 then
                quality = "SR"
            end
            AddTreasureForHeroByquality(self:GetParent(), quality, {})
        end
    end
end