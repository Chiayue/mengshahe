---------------------------------------------------------------------------
-- 升华(超级士兵)
---------------------------------------------------------------------------

if modifier_treasure_sublime_visage == nil then 
    modifier_treasure_sublime_visage = class({})
end

function modifier_treasure_sublime_visage:GetTexture()
    return "buff/modifier_treasure_sublime_visage"
end

function modifier_treasure_sublime_visage:IsPurgable()
    return false
end

function modifier_treasure_sublime_visage:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_visage:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_visage" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end