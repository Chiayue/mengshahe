---------------------------------------------------------------------------
-- 升华(一击男)
---------------------------------------------------------------------------

if modifier_treasure_sublime_tusk == nil then 
    modifier_treasure_sublime_tusk = class({})
end

function modifier_treasure_sublime_tusk:GetTexture()
    return "buff/modifier_treasure_sublime_tusk"
end

function modifier_treasure_sublime_tusk:IsPurgable()
    return false
end

function modifier_treasure_sublime_tusk:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_tusk:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_tusk" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end