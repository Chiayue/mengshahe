---------------------------------------------------------------------------
-- 宝物：疾风之剑
---------------------------------------------------------------------------

if modifier_treasure_rapid_sword == nil then 
    modifier_treasure_rapid_sword = class({})
end

function modifier_treasure_rapid_sword:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_rapid_sword"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_rapid_sword:IsPurgable()
    return false
end
 
function modifier_treasure_rapid_sword:RemoveOnDeath()
    return false
end

function modifier_treasure_rapid_sword:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_rapid_sword:GetModifierBonusStats_Agility()
    return 200
end

function modifier_treasure_rapid_sword:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_rapid_sword:OnIntervalThink() 
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_rapid_bayonet") and parent:HasModifier("modifier_treasure_rapid_dagger") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_rapid_tao", nil)
    end
    self:StartIntervalThink(-1)
end

-- function modifier_treasure_rapid_sword:OnDestroy()
--     if IsServer() then
--         self:GetParent():RemoveModifierByName("modifier_treasure_rapid_tao")
--     end
-- end