---------------------------------------------------------------------------
-- 宝物：5000经验
---------------------------------------------------------------------------

if modifier_treasure_five_thousand_exp == nil then 
    modifier_treasure_five_thousand_exp = class({})
end

function modifier_treasure_five_thousand_exp:GetTexture()
    return "buff/modifier_treasure_five_thousand_exp"
end

function modifier_treasure_five_thousand_exp:IsPurgable()
    return false
end
 
function modifier_treasure_five_thousand_exp:RemoveOnDeath()
    return false
end

function modifier_treasure_five_thousand_exp:OnCreated(kv)
    if IsServer() then
        self:GetParent():AddExperience(5000, DOTA_ModifyXP_Unspecified, false, false)
    end
end