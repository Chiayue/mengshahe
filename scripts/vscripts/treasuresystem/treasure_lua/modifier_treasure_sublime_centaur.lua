---------------------------------------------------------------------------
-- 升华(欧美克斯冠军)
---------------------------------------------------------------------------

if modifier_treasure_sublime_centaur == nil then 
    modifier_treasure_sublime_centaur = class({})
end

function modifier_treasure_sublime_centaur:GetTexture()
    return "buff/modifier_treasure_sublime_centaur"
end

function modifier_treasure_sublime_centaur:IsPurgable()
    return false
end

function modifier_treasure_sublime_centaur:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_centaur:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_centaur" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end