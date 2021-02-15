---------------------------------------------------------------------------
-- 升华(遗迹守卫)
---------------------------------------------------------------------------

if modifier_treasure_sublime_slardar == nil then 
    modifier_treasure_sublime_slardar = class({})
end

function modifier_treasure_sublime_slardar:GetTexture()
    return "buff/modifier_treasure_sublime_slardar"
end

function modifier_treasure_sublime_slardar:IsPurgable()
    return false
end

function modifier_treasure_sublime_slardar:RemoveOnDeath()
    return false
end

function modifier_treasure_sublime_slardar:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetUnitName() == "npc_dota_hero_slardar" then
            herosublimesys:Treasureherosublime(parent:GetPlayerID(), parent)
        end
    end
end