---------------------------------------------------------------------------
-- 升华(黑洞)
---------------------------------------------------------------------------

if modifier_treasure_sublime_wisp == nil then 
    modifier_treasure_sublime_wisp = class({})
end

function modifier_treasure_sublime_wisp:GetTexture()
    return "buff/modifier_treasure_sublime_wisp"
end

function modifier_treasure_sublime_wisp:IsPurgable()
    return false
end

function modifier_treasure_sublime_wisp:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_wisp:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_wisp" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end