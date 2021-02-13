-- 宝物: 1+1


if modifier_treasure_doubleone == nil then 
    modifier_treasure_doubleone = class({})
end

function modifier_treasure_doubleone:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_doubleone"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_doubleone:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_doubleone:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_doubleone:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_doubleone:OnCreated(params)
    if not IsServer() then
        return
    end
    self.steamid = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(self.steamid, "drop_scale_unit", 1)
end
