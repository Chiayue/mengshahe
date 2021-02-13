---------------------------------------------------------------------------
-- 双倍快乐
---------------------------------------------------------------------------

if modifier_treasure_double_fire == nil then 
    modifier_treasure_double_fire = class({})
end

function modifier_treasure_double_fire:GetTexture()
    return "buff/modifier_treasure_double_fire"
end

function modifier_treasure_double_fire:IsPurgable()
    return false
end
 
function modifier_treasure_double_fire:RemoveOnDeath()
    return false
end