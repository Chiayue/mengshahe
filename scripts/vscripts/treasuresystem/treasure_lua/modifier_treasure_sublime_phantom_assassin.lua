---------------------------------------------------------------------------
-- 升华(守望者)
---------------------------------------------------------------------------

if modifier_treasure_sublime_phantom_assassin == nil then 
    modifier_treasure_sublime_phantom_assassin = class({})
end

function modifier_treasure_sublime_phantom_assassin:GetTexture()
    return "buff/modifier_treasure_sublime_phantom_assassin"
end

function modifier_treasure_sublime_phantom_assassin:IsPurgable()
    return false
end

function modifier_treasure_sublime_phantom_assassin:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_phantom_assassin:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end