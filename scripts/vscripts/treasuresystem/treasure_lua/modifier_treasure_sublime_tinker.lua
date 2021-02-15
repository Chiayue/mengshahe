---------------------------------------------------------------------------
-- 升华(刷新侠)
---------------------------------------------------------------------------

if modifier_treasure_sublime_tinker == nil then 
    modifier_treasure_sublime_tinker = class({})
end

function modifier_treasure_sublime_tinker:GetTexture()
    return "buff/modifier_treasure_sublime_tinker"
end

function modifier_treasure_sublime_tinker:IsPurgable()
    return false
end

function modifier_treasure_sublime_tinker:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_tinker:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_tinker" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end