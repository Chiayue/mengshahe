---------------------------------------------------------------------------
-- 宝物：启示录【下】
---------------------------------------------------------------------------

if modifier_treasure_apocalypse_c == nil then 
    modifier_treasure_apocalypse_c = class({})
end

function modifier_treasure_apocalypse_c:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_apocalypse_c:GetModifierBonusStats_Strength()
    return 100
end
 
function modifier_treasure_apocalypse_c:GetModifierBonusStats_Agility()
    return 100
end

function modifier_treasure_apocalypse_c:GetModifierBonusStats_Intellect()
    return 100
end

function modifier_treasure_apocalypse_c:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_apocalypse_c"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_apocalypse_c:IsPurgable()
    return false
end
 
function modifier_treasure_apocalypse_c:RemoveOnDeath()
    return false
end

function modifier_treasure_apocalypse_c:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_apocalypse_a") and parent:HasModifier("modifier_treasure_apocalypse_b") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_apocalypse", nil)
        end
    end
end

function modifier_treasure_apocalypse_c:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_apocalypse")
    end
end