-- 宝物： 虚无神力

if modifier_treasure_xwsl == nil then 
    modifier_treasure_xwsl = class({})
end
function modifier_treasure_xwsl:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_xwsl"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_xwsl:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_xwsl:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_xwsl:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

--游戏中选择此宝物时增加英雄1智力
function modifier_treasure_xwsl:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_intellect", 1)
end