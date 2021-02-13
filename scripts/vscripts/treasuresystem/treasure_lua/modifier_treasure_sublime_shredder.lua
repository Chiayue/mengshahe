---------------------------------------------------------------------------
-- 升华(兵营)
---------------------------------------------------------------------------

if modifier_treasure_sublime_shredder == nil then 
    modifier_treasure_sublime_shredder = class({})
end

function modifier_treasure_sublime_shredder:GetTexture()
    return "buff/modifier_treasure_sublime_shredder"
end

function modifier_treasure_sublime_shredder:IsPurgable()
    return false
end

function modifier_treasure_sublime_shredder:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_shredder:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_shredder" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end