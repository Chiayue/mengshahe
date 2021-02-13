-- 宝物： 拉的祭品1

if modifier_treasure_ra_1 == nil then 
    modifier_treasure_ra_1 = class({})
end
function modifier_treasure_ra_1:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_ra_1"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_ra_1:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_ra_1:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_ra_1:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_treasure_ra_1:OnCreated(params)
    if not IsServer() then
        return
    end
end

function modifier_treasure_ra_1:GetModifierBonusStats_Strength()
    return math.ceil(self:GetCaster():GetBaseStrength()*0.12)
end

function modifier_treasure_ra_1:GetModifierBonusStats_Agility()
    return math.ceil(self:GetCaster():GetBaseAgility()*0.12)
end

function modifier_treasure_ra_1:GetModifierBonusStats_Intellect()
    return math.ceil(self:GetCaster():GetBaseIntellect()*0.12)
end