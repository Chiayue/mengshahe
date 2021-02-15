---------------------------------------------------------------------------
-- 升华(恶犬)
---------------------------------------------------------------------------

if modifier_treasure_sublime_abaddon == nil then 
    modifier_treasure_sublime_abaddon = class({})
end

function modifier_treasure_sublime_abaddon:GetTexture()
    return "buff/modifier_treasure_sublime_abaddon"
end

function modifier_treasure_sublime_abaddon:IsPurgable()
    return false
end

function modifier_treasure_sublime_abaddon:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_abaddon:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_abaddon" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end