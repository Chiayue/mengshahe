---------------------------------------------------------------------------
-- 宝物：遗失之物 - 无墨之笔
---------------------------------------------------------------------------

if modifier_treasure_lost_pen == nil then 
    modifier_treasure_lost_pen = class({})
end

function modifier_treasure_lost_pen:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_pen"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_pen:CheckState()
	return {}
end

function modifier_treasure_lost_pen:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_treasure_lost_pen:GetModifierPreAttack_BonusDamage()
    return 2000
end

function modifier_treasure_lost_pen:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_lost_pen:OnIntervalThink()
    self:GetParent():ReduceMana(1)
end
 
function modifier_treasure_lost_pen:IsPurgable()
    return false
end
 
function modifier_treasure_lost_pen:RemoveOnDeath()
    return false
end