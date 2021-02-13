
-- 宝物: 欧贝里斯克的祭品2

if modifier_treasure_obelisk_2 == nil then 
    modifier_treasure_obelisk_2 = class({})
end

function modifier_treasure_obelisk_2:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_obelisk_2"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_obelisk_2:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_obelisk_2:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_obelisk_2:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_obelisk_2:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    local steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", 10)
end

function modifier_treasure_obelisk_2:OnDestroy()
    if IsServer() then
        self.caster = self:GetCaster()
        local steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", -10)
        self:GetParent():RemoveModifierByName("modifier_treasure_obelisk_aura")
    end
end