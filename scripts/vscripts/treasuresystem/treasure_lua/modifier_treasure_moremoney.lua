-- 宝物： 大富翁

if modifier_treasure_moremoney == nil then 
    modifier_treasure_moremoney = class({})
end
function modifier_treasure_moremoney:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_moremoney"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_moremoney:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_moremoney:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_moremoney:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

--游戏中选择此宝物时增加英雄1金币
function modifier_treasure_moremoney:OnCreated(params)
    if not IsServer() then
        return
    end
    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(), 1)
end