-- 宝物: 暴君王袍

if modifier_treasure_despot == nil then 
    modifier_treasure_despot = class({})
end

function modifier_treasure_despot:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_despot"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_despot:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_despot:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_despot:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_despot:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(self.steam_id, "respawn_time", 0.5)
end