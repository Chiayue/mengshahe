---------------------------------------------------------------------------
-- 升华(死神)
---------------------------------------------------------------------------

if modifier_treasure_sublime_necrolyte == nil then 
    modifier_treasure_sublime_necrolyte = class({})
end

function modifier_treasure_sublime_necrolyte:GetTexture()
    return "buff/modifier_treasure_sublime_necrolyte"
end

function modifier_treasure_sublime_necrolyte:IsPurgable()
    return false
end

function modifier_treasure_sublime_necrolyte:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_necrolyte:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_necrolyte" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end