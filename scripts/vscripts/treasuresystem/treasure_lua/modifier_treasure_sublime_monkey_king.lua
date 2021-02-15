---------------------------------------------------------------------------
-- 升华(巨小)
---------------------------------------------------------------------------

if modifier_treasure_sublime_monkey_king == nil then 
    modifier_treasure_sublime_monkey_king = class({})
end

function modifier_treasure_sublime_monkey_king:GetTexture()
    return "buff/modifier_treasure_sublime_monkey_king"
end

function modifier_treasure_sublime_monkey_king:IsPurgable()
    return false
end

function modifier_treasure_sublime_monkey_king:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_monkey_king:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_monkey_king" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end