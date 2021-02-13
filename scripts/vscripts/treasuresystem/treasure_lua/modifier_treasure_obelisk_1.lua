
-- 宝物: 欧贝里斯克的祭品1

if modifier_treasure_obelisk_1 == nil then 
    modifier_treasure_obelisk_1 = class({})
end

function modifier_treasure_obelisk_1:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_obelisk_1"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_obelisk_1:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_obelisk_1:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_obelisk_1:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_obelisk_1:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    local steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", 8)
end

function modifier_treasure_obelisk_1:OnDestroy()
    if IsServer() then
        self.caster = self:GetCaster()
        local steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", -8)
        self:GetParent():RemoveModifierByName("modifier_treasure_obelisk_aura")
    end
end