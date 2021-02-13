-- 宝物： 蛮荒灵力

if modifier_treasure_mhll == nil then 
    modifier_treasure_mhll = class({})
end
function modifier_treasure_mhll:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_mhll"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_mhll:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_mhll:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_mhll:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

--游戏中选择此宝物时增加英雄1力量
function modifier_treasure_mhll:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_strength", 1)
end