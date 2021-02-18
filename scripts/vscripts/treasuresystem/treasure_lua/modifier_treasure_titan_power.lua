---------------------------------------------------------------------------
-- 宝物：泰坦神力
---------------------------------------------------------------------------

if modifier_treasure_titan_power == nil then 
    modifier_treasure_titan_power = class({})
end

function modifier_treasure_titan_power:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_titan_power"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_titan_power:IsHidden()
    return false
end

function modifier_treasure_titan_power:IsPurgable()
    return false
end
 
function modifier_treasure_titan_power:RemoveOnDeath()
    return false
end

function modifier_treasure_titan_power:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_titan_power:GetModifierBonusStats_Strength()
    -- return self:GetStackCount()
    return self.increase
end

function modifier_treasure_titan_power:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_titan_armet")
        parent:RemoveModifierByName("modifier_treasure_titan_hammer")
        parent:RemoveModifierByName("modifier_treasure_titan_shield")
        self.increase = math.ceil((self:GetParent():GetStrength()+460)*0.4+460)
        -- self:SetStackCount(math.ceil((self:GetParent():GetStrength()+460)*0.4+460))
    end
end