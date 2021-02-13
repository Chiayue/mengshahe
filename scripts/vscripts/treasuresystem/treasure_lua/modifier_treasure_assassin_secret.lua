---------------------------------------------------------------------------
-- 宝物：刺客秘籍
---------------------------------------------------------------------------

if modifier_treasure_assassin_secret == nil then 
    modifier_treasure_assassin_secret = class({})
end

function modifier_treasure_assassin_secret:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_assassin_secret"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_assassin_secret:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_assassin_secret:GetModifierTotalDamageOutgoing_Percentage(params)
    if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
        local angle = math.abs(AngleDiff(VectorToAngles(params.attacker:GetForwardVector()).y, VectorToAngles(params.target:GetForwardVector()).y))
        if angle < 90 then
            return 50
        end
    end
    return 0
end

function modifier_treasure_assassin_secret:IsPurgable()
    return false
end
 
function modifier_treasure_assassin_secret:RemoveOnDeath()
    return false
end
