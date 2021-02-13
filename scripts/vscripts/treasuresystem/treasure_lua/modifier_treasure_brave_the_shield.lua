-- 宝物: 英勇盾牌


if modifier_treasure_brave_the_shield == nil then 
    modifier_treasure_brave_the_shield = class({})
end

function modifier_treasure_brave_the_shield:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_brave_the_shield"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_brave_the_shield:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_brave_the_shield:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_brave_the_shield:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_treasure_brave_the_shield:GetModifierIncomingDamage_Percentage(params)
    if not IsServer() then
        return
    end
    local angle = CalculationAngle(params.attacker, params.target)
    if angle >= 90 and angle <= 180 then
        return -30
    end
    return 0
end
