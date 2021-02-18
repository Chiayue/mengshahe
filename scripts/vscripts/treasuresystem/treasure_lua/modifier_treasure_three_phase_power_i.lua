---------------------------------------------------------------------------
-- 宝物：三项碎片【下】
---------------------------------------------------------------------------

if modifier_treasure_three_phase_power_i == nil then 
    modifier_treasure_three_phase_power_i = class({})
end

function modifier_treasure_three_phase_power_i:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_three_phase_power_i:GetModifierBonusStats_Intellect()
    return 150
end
 
function modifier_treasure_three_phase_power_i:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_three_phase_power_i"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_three_phase_power_i:IsPurgable()
    return false
end
 
function modifier_treasure_three_phase_power_i:RemoveOnDeath()
    return false
end

function modifier_treasure_three_phase_power_i:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_three_phase_power_i:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_three_phase_power_s") and parent:HasModifier("modifier_treasure_three_phase_power_a") then           
        parent:AddNewModifier(parent, nil, "modifier_treasure_three_phase_power", nil)
    end
    self:StartIntervalThink(-1)
end
-- function modifier_treasure_three_phase_power_i:OnDestroy()
--     if IsServer() then
--         self:GetParent():RemoveModifierByName("modifier_treasure_three_phase_power")
--     end
-- end