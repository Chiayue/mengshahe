---------------------------------------------------------------------------
-- 升华(土豪)
---------------------------------------------------------------------------

if modifier_treasure_sublime_alchemist == nil then 
    modifier_treasure_sublime_alchemist = class({})
end

function modifier_treasure_sublime_alchemist:GetTexture()
    return "buff/modifier_treasure_sublime_alchemist"
end

function modifier_treasure_sublime_alchemist:IsPurgable()
    return false
end

function modifier_treasure_sublime_alchemist:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_alchemist:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_alchemist" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end