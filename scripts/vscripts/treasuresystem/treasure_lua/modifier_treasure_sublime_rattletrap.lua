---------------------------------------------------------------------------
-- 升华(坏心眼)
---------------------------------------------------------------------------

if modifier_treasure_sublime_rattletrap == nil then 
    modifier_treasure_sublime_rattletrap = class({})
end

function modifier_treasure_sublime_rattletrap:GetTexture()
    return "buff/modifier_treasure_sublime_rattletrap"
end

function modifier_treasure_sublime_rattletrap:IsPurgable()
    return false
end

function modifier_treasure_sublime_rattletrap:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_rattletrap:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_rattletrap" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end