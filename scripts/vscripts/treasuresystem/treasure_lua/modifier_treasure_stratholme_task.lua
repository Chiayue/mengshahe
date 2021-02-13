---------------------------------------------------------------------------
-- 宝物：斯坦索姆的任务
---------------------------------------------------------------------------

if modifier_treasure_stratholme_task == nil then 
    modifier_treasure_stratholme_task = class({})
end
function modifier_treasure_stratholme_task:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stratholme_task"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_stratholme_task:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_stratholme_task:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) and params.unit:GetUnitName() == "creep_skeleton" then
        if self:GetStackCount() < 60 then
            self:IncrementStackCount()
            if self:GetStackCount() == 60 then
                self:StartIntervalThink(-1)
            end 
        end
    end
end

function modifier_treasure_stratholme_task:GetModifierBonusStats_Strength(params)
    if self:GetStackCount() >= 60 then
        return 300
    end
    return 0
end

function modifier_treasure_stratholme_task:GetModifierBonusStats_Agility(params)
    if self:GetStackCount() >= 60 then
        return 300
    end
    return 0
end

function modifier_treasure_stratholme_task:GetModifierBonusStats_Intellect(params)
    if self:GetStackCount() >= 60 then
        return 300
    end
    return 0
end

function modifier_treasure_stratholme_task:IsPurgable()
    return false
end
 
function modifier_treasure_stratholme_task:RemoveOnDeath()
    return false
end

function modifier_treasure_stratholme_task:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(90)
    end
end

function modifier_treasure_stratholme_task:OnIntervalThink()
    self:StartIntervalThink(-1)
    if self:GetStackCount() < 60 then
        self:Destroy()
    end
end