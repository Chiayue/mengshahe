-- 宝物： 虚无之力

if modifier_treasure_xwzl == nil then 
    modifier_treasure_xwzl = class({})
end
function modifier_treasure_xwzl:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_xwzl"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_xwzl:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_xwzl:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_xwzl:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

--游戏中选择此宝物时增加英雄1智力
function modifier_treasure_xwzl:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_intellect", 1)
end