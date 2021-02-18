-- 宝物: 利维坦的外壳

if modifier_treasure_leviathan_skin == nil then 
    modifier_treasure_leviathan_skin = class({})
end

function modifier_treasure_leviathan_skin:GetTexture()
    return "buff/modifier_treasure_leviathan_skin"
end

function modifier_treasure_leviathan_skin:IsHidden()
    return false
end

function modifier_treasure_leviathan_skin:IsPurgable()
    return false
end
 
function modifier_treasure_leviathan_skin:RemoveOnDeath()
    return false
end

function modifier_treasure_leviathan_skin:OnCreated(kv)
    if IsServer() then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "reduce_attack_point", 100)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_leviathan_skin:OnDestroy()
    if IsServer() then
        game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()), "reduce_attack_point", -100)
    end
end

function modifier_treasure_leviathan_skin:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_beerbung") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_marine_overlord", nil)
    end
    self:StartIntervalThink(-1)
end