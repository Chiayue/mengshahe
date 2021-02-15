---------------------------------------------------------------------------
-- 升华(银月游侠)
---------------------------------------------------------------------------

if modifier_treasure_sublime_phoenix == nil then 
    modifier_treasure_sublime_phoenix = class({})
end

function modifier_treasure_sublime_phoenix:GetTexture()
    return "buff/modifier_treasure_sublime_phoenix"
end

function modifier_treasure_sublime_phoenix:IsPurgable()
    return false
end

function modifier_treasure_sublime_phoenix:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_phoenix:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_phoenix" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end