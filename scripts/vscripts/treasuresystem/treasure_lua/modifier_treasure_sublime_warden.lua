---------------------------------------------------------------------------
-- 升华(符娃)
---------------------------------------------------------------------------

if modifier_treasure_sublime_warden == nil then 
    modifier_treasure_sublime_warden = class({})
end

function modifier_treasure_sublime_warden:GetTexture()
    return "buff/modifier_treasure_sublime_warden"
end

function modifier_treasure_sublime_warden:IsPurgable()
    return false
end

function modifier_treasure_sublime_warden:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_warden:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_arc_warden" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end