-- 宝物： 莫多

if modifier_treasure_more == nil then 
    modifier_treasure_more = class({})
end
function modifier_treasure_more:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_more"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_more:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_more:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_more:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_more:OnCreated(params)
    if not IsServer() then
        return
    end
end