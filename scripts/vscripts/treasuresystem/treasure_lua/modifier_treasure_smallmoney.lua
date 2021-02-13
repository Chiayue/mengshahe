-- 宝物： 富二代

if modifier_treasure_smallmoney == nil then 
    modifier_treasure_smallmoney = class({})
end
function modifier_treasure_smallmoney:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_smallmoney"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_smallmoney:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_smallmoney:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_smallmoney:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

--游戏中选择此宝物时增加英雄1金币
function modifier_treasure_smallmoney:OnCreated(params)
    if not IsServer() then
        return
    end
    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(), 1)
end