-- 宝物： 蛮荒神力

if modifier_treasure_mhsl == nil then 
    modifier_treasure_mhsl = class({})
end
function modifier_treasure_mhsl:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_mhsl"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_mhsl:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_mhsl:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_mhsl:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

--游戏中选择此宝物时增加英雄1力量
function modifier_treasure_mhsl:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_strength", 1)
end