-- 宝物： 雷霆神力

if modifier_treasure_ltsl == nil then 
    modifier_treasure_ltsl = class({})
end
function modifier_treasure_ltsl:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_ltsl"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_ltsl:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_ltsl:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_ltsl:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

--游戏中选择此宝物时增加英雄1敏捷
function modifier_treasure_ltsl:OnCreated(params)
    if not IsServer() then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "add_agility", 1)
end