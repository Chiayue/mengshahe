-- 宝物： 金币怪悬赏令

if modifier_treasure_goldmon_attribute_one == nil then 
    modifier_treasure_goldmon_attribute_one = class({})
end
function modifier_treasure_goldmon_attribute_one:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_goldmon_attribute_one"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_goldmon_attribute_one:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_goldmon_attribute_one:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_goldmon_attribute_one:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_goldmon_attribute_one:OnCreated(params)
    if not IsServer() then
        return
    end
end