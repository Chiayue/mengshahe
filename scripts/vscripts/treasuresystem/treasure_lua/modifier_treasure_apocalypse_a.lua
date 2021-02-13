---------------------------------------------------------------------------
-- 宝物：启示录【上】
---------------------------------------------------------------------------

if modifier_treasure_apocalypse_a == nil then 
    modifier_treasure_apocalypse_a = class({})
end

function modifier_treasure_apocalypse_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_apocalypse_a:GetModifierBonusStats_Strength()
    return 100
end
 
function modifier_treasure_apocalypse_a:GetModifierBonusStats_Agility()
    return 100
end

function modifier_treasure_apocalypse_a:GetModifierBonusStats_Intellect()
    return 100
end

function modifier_treasure_apocalypse_a:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_apocalypse_a"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_apocalypse_a:IsPurgable()
    return false
end
 
function modifier_treasure_apocalypse_a:RemoveOnDeath()
    return false
end

function modifier_treasure_apocalypse_a:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_apocalypse_b") and parent:HasModifier("modifier_treasure_apocalypse_c") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_apocalypse", nil)
        end
    end
end

function modifier_treasure_apocalypse_a:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_apocalypse")
    end
end
