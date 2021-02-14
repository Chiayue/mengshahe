-- 宝物： 迈达斯的珍藏

if modifier_treasure_midas_collection == nil then 
    modifier_treasure_midas_collection = class({})
end
function modifier_treasure_midas_collection:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_midas_collection"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_midas_collection:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_midas_collection:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_midas_collection:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_midas_collection:OnCreated(params)
    if not IsServer() then
        return
    end
end