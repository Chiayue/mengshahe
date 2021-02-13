---------------------------------------------------------------------------
-- 速火
---------------------------------------------------------------------------

if modifier_treasure_speed_fire == nil then 
    modifier_treasure_speed_fire = class({})
end

function modifier_treasure_speed_fire:GetTexture()
    return "buff/modifier_treasure_speed_fire"
end

function modifier_treasure_speed_fire:IsPurgable()
    return false
end
 
function modifier_treasure_speed_fire:RemoveOnDeath()
    return false
end 

function modifier_treasure_speed_fire:OnCreated(kv)
    if IsServer() then
        local item = global_var_func.player_shop_item["player"..self:GetParent():GetPlayerID()]["item_custom_yanmo_call"]
        item[3] = item[3] - 30
        item[4] = item[4] - 30
    end
end