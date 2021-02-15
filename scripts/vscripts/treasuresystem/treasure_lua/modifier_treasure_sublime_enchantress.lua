---------------------------------------------------------------------------
-- 升华(泉水)
---------------------------------------------------------------------------

if modifier_treasure_sublime_enchantress == nil then 
    modifier_treasure_sublime_enchantress = class({})
end

function modifier_treasure_sublime_enchantress:GetTexture()
    return "buff/modifier_treasure_sublime_enchantress"
end

function modifier_treasure_sublime_enchantress:IsPurgable()
    return false
end

function modifier_treasure_sublime_enchantress:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_enchantress:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_enchantress" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end