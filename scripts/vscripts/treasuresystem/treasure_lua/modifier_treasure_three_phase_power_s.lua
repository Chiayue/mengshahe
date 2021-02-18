---------------------------------------------------------------------------
-- 宝物：三项碎片【上】
---------------------------------------------------------------------------

if modifier_treasure_three_phase_power_s == nil then 
    modifier_treasure_three_phase_power_s = class({})
end

function modifier_treasure_three_phase_power_s:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_three_phase_power_s:GetModifierBonusStats_Strength()
    return 150
end
 
function modifier_treasure_three_phase_power_s:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_three_phase_power_s"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_three_phase_power_s:IsPurgable()
    return false
end
 
function modifier_treasure_three_phase_power_s:RemoveOnDeath()
    return false
end
 
function modifier_treasure_three_phase_power_s:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_three_phase_power_s:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_three_phase_power_a") and parent:HasModifier("modifier_treasure_three_phase_power_i") then           
        parent:AddNewModifier(parent, nil, "modifier_treasure_three_phase_power", nil)
    end
    self:StartIntervalThink(-1)
end
-- function modifier_treasure_three_phase_power_s:OnDestroy()
--     if IsServer() then
--         self:GetParent():RemoveModifierByName("modifier_treasure_three_phase_power")
--     end
-- end
