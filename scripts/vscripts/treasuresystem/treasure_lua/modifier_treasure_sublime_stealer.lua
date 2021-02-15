---------------------------------------------------------------------------
-- 升华(萨特爸爸)
---------------------------------------------------------------------------

if modifier_treasure_sublime_stealer == nil then 
    modifier_treasure_sublime_stealer = class({})
end

function modifier_treasure_sublime_stealer:GetTexture()
    return "buff/modifier_treasure_sublime_stealer"
end

function modifier_treasure_sublime_stealer:IsPurgable()
    return false
end

function modifier_treasure_sublime_stealer:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_stealer:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_life_stealer" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end