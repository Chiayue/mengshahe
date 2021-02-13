---------------------------------------------------------------------------
-- 宝物：三项碎片【中】
---------------------------------------------------------------------------

if modifier_treasure_three_phase_power_a == nil then 
    modifier_treasure_three_phase_power_a = class({})
end

function modifier_treasure_three_phase_power_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_three_phase_power_a:GetModifierBonusStats_Agility()
    return 150
end
 
function modifier_treasure_three_phase_power_a:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_three_phase_power_a"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_three_phase_power_a:IsPurgable()
    return false
end
 
function modifier_treasure_three_phase_power_a:RemoveOnDeath()
    return false
end

function modifier_treasure_three_phase_power_a:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_three_phase_power_s") and parent:HasModifier("modifier_treasure_three_phase_power_i") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_three_phase_power", nil)
        end
    end
end

function modifier_treasure_three_phase_power_a:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_three_phase_power")
    end
end
