---------------------------------------------------------------------------
-- 升华(银行圣装狗子)
---------------------------------------------------------------------------

if modifier_treasure_sublime_earth_spirit == nil then 
    modifier_treasure_sublime_earth_spirit = class({})
end

function modifier_treasure_sublime_earth_spirit:GetTexture()
    return "buff/modifier_treasure_sublime_earth_spirit"
end

function modifier_treasure_sublime_earth_spirit:IsPurgable()
    return false
end

function modifier_treasure_sublime_earth_spirit:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_earth_spirit:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_earth_spirit" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end