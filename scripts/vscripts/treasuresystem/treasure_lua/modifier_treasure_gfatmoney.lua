-- 宝物： G胖的钱包

if modifier_treasure_gfatmoney == nil then 
    modifier_treasure_gfatmoney = class({})
end
function modifier_treasure_gfatmoney:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_gfatmoney"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_gfatmoney:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_gfatmoney:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_gfatmoney:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

--游戏中选择此宝物时增加英雄1金币
function modifier_treasure_gfatmoney:OnCreated(params)
    if not IsServer() then
        return
    end
    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(), 1)
end