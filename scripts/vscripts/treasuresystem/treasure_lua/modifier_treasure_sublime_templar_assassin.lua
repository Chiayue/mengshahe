---------------------------------------------------------------------------
-- 升华(主角)
---------------------------------------------------------------------------

if modifier_treasure_sublime_templar_assassin == nil then 
    modifier_treasure_sublime_templar_assassin = class({})
end

function modifier_treasure_sublime_templar_assassin:GetTexture()
    return "buff/modifier_treasure_sublime_templar_assassin"
end

function modifier_treasure_sublime_templar_assassin:IsPurgable()
    return false
end

function modifier_treasure_sublime_templar_assassin:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_templar_assassin:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_templar_assassin" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end