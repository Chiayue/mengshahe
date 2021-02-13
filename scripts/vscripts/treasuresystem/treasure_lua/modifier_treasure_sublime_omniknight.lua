---------------------------------------------------------------------------
-- 升华(金蛋)
---------------------------------------------------------------------------

if modifier_treasure_sublime_omniknight == nil then 
    modifier_treasure_sublime_omniknight = class({})
end

function modifier_treasure_sublime_omniknight:GetTexture()
    return "buff/modifier_treasure_sublime_omniknight"
end

function modifier_treasure_sublime_omniknight:IsPurgable()
    return false
end

function modifier_treasure_sublime_omniknight:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_omniknight:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_omniknight" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end