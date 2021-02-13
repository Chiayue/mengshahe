-- 宝物: 不存在的数字

if modifier_treasure_no_number == nil then 
    modifier_treasure_no_number = class({})
end

function modifier_treasure_no_number:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_no_number"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_no_number:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_no_number:RemoveOnDeath()
    return false -- 死亡不移除
end