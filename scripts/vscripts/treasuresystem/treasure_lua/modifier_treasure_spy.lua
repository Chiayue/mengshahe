-- 宝物: 内鬼


if modifier_treasure_spy == nil then 
    modifier_treasure_spy = class({})
end

function modifier_treasure_spy:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_spy"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_spy:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_spy:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_spy:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_spy:OnCreated(params)
    if not IsServer() then
        return
    end
end
