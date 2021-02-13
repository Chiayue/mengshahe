---------------------------------------------------------------------------
-- 宝物：小金袋
---------------------------------------------------------------------------

if modifier_treasure_small_gold_bag == nil then 
    modifier_treasure_small_gold_bag = class({})
end

function modifier_treasure_small_gold_bag:GetTexture()
    return "buff/modifier_treasure_small_gold_bag"
end

function modifier_treasure_small_gold_bag:IsPurgable()
    return false
end
 
function modifier_treasure_small_gold_bag:RemoveOnDeath()
    return false
end

function modifier_treasure_small_gold_bag:OnCreated(kv)
    if IsServer() then
        game_playerinfo:set_player_gold(self:GetParent():GetPlayerID(), 20000)
    end
end