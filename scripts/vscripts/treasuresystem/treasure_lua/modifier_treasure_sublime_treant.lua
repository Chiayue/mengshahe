---------------------------------------------------------------------------
-- 升华(代码哥)
---------------------------------------------------------------------------

if modifier_treasure_sublime_treant == nil then 
    modifier_treasure_sublime_treant = class({})
end

function modifier_treasure_sublime_treant:GetTexture()
    return "buff/modifier_treasure_sublime_treant"
end

function modifier_treasure_sublime_treant:IsPurgable()
    return false
end

function modifier_treasure_sublime_treant:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_treant:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_treant" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end