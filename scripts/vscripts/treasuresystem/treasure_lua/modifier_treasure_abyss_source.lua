---------------------------------------------------------------------------
-- 宝物：来自深渊
---------------------------------------------------------------------------

if modifier_treasure_abyss_source == nil then 
    modifier_treasure_abyss_source = class({})
end

function modifier_treasure_abyss_source:GetTexture()
    return "buff/modifier_treasure_abyss_source"
end

function modifier_treasure_abyss_source:IsHidden()
    return false
end

function modifier_treasure_abyss_source:IsPurgable()
    return false
end

function modifier_treasure_abyss_source:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_source:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_abyss_orb")
        parent:RemoveModifierByName("modifier_treasure_abyss_sceptre")
        parent:RemoveModifierByName("modifier_treasure_abyss_law")
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_abyss_source:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_abyss_source_buff", nil)
        self:StartIntervalThink(-1)
    end
end

--------------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_abyss_source_buff","treasuresystem/treasure_lua/modifier_treasure_abyss_source", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_abyss_source_buff == nil then 
    modifier_treasure_abyss_source_buff = class({})
end

function modifier_treasure_abyss_source_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_abyss_source_buff:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_abyss_source_buff:IsHidden()
    return true
end

function modifier_treasure_abyss_source_buff:IsPurgable()
    return false
end
 
function modifier_treasure_abyss_source_buff:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_source_buff:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(math.ceil((self:GetParent():GetIntellect() + 120 + 140 + 200) * 0.4) + 120 + 140 + 200)
    end
end