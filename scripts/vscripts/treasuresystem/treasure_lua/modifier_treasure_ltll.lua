-- 宝物： 雷霆灵力

if modifier_treasure_ltll == nil then 
    modifier_treasure_ltll = class({})
end
function modifier_treasure_ltll:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_ltll"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_ltll:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_ltll:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_ltll:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

--游戏中选择此宝物时增加英雄1敏捷
function modifier_treasure_ltll:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_agility", 1)
end