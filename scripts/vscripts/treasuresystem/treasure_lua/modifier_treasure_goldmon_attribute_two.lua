-- 宝物： 金币怪杀手

if modifier_treasure_goldmon_attribute_two == nil then 
    modifier_treasure_goldmon_attribute_two = class({})
end
function modifier_treasure_goldmon_attribute_two:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_goldmon_attribute_two"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_goldmon_attribute_two:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_goldmon_attribute_two:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_goldmon_attribute_two:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_goldmon_attribute_two:OnCreated(params)
    if not IsServer() then
        return
    end
end