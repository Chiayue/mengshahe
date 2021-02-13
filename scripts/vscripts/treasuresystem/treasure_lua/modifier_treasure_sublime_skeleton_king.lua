---------------------------------------------------------------------------
-- 升华(支援小炮)
---------------------------------------------------------------------------

if modifier_treasure_sublime_skeleton_king == nil then 
    modifier_treasure_sublime_skeleton_king = class({})
end

function modifier_treasure_sublime_skeleton_king:GetTexture()
    return "buff/modifier_treasure_sublime_skeleton_king"
end

function modifier_treasure_sublime_skeleton_king:IsPurgable()
    return false
end

function modifier_treasure_sublime_skeleton_king:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_skeleton_king:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_skeleton_king" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end