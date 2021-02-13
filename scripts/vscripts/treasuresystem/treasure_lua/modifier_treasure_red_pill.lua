---------------------------------------------------------------------------
-- 宝物：红色药丸
---------------------------------------------------------------------------

if modifier_treasure_red_pill == nil then 
    modifier_treasure_red_pill = class({})
end

function modifier_treasure_red_pill:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_red_pill"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_red_pill:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_red_pill:GetModifierBonusStats_Strength()
    if self:GetParent():HasModifier("modifier_treasure_red_pill_debuff") then
        return 200
    else
        return 500
    end
end

function modifier_treasure_red_pill:IsHidden() 
    return false
end

function modifier_treasure_red_pill:IsPurgable() 
    return false
end

function modifier_treasure_red_pill:RemoveOnDeath() 
    return false
end

function modifier_treasure_red_pill:OnCreated(kv) 
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_red_pill_debuff", nil)
        if parent:HasModifier("modifier_treasure_green_pill") and parent:HasModifier("modifier_treasure_blue_pill") then
            parent:RemoveModifierByName("modifier_treasure_green_pill_debuff")
            parent:RemoveModifierByName("modifier_treasure_blue_pill_debuff")
            parent:RemoveModifierByName("modifier_treasure_red_pill_debuff")
        end
    end
end

function modifier_treasure_red_pill:OnDestroy() 
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_red_pill_debuff")
        if parent:HasModifier("modifier_treasure_green_pill") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_green_pill_debuff", nil)
        end
        if parent:HasModifier("modifier_treasure_blue_pill") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_blue_pill_debuff", nil)
        end
    end
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_red_pill_debuff","treasuresystem/treasure_lua/modifier_treasure_red_pill", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_red_pill_debuff == nil then 
    modifier_treasure_red_pill_debuff = class({})
end

function modifier_treasure_red_pill_debuff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_red_pill_debuff:GetModifierBonusStats_Agility()
    return -50
end

function modifier_treasure_red_pill_debuff:GetModifierBonusStats_Intellect()
    return -50
end

function modifier_treasure_red_pill_debuff:IsHidden() 
    return true
end

function modifier_treasure_red_pill_debuff:IsPurgable() 
    return false
end

function modifier_treasure_red_pill_debuff:RemoveOnDeath() 
    return false
end