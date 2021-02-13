-- 宝物： 蛮荒之力

if modifier_treasure_mhzl == nil then 
    modifier_treasure_mhzl = class({})
end
function modifier_treasure_mhzl:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_mhzl"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_mhzl:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_mhzl:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_mhzl:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

--游戏中选择此宝物时增加英雄1力量
function modifier_treasure_mhzl:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_strength", 1)
end