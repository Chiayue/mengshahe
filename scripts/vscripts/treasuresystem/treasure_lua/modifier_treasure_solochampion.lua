-- 宝物： SOLO冠军


if modifier_treasure_solochampion == nil then 
    modifier_treasure_solochampion = class({})
end
function modifier_treasure_solochampion:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_solochampion"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_solochampion:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_solochampion:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_solochampion:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_solochampion:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    local steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", (4-global_var_func.all_player_amount)*10)
end
