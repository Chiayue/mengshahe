---------------------------------------------------------------------------
-- 宝物：强欲之壶
---------------------------------------------------------------------------

if modifier_treasure_pot_of_greed == nil then 
    modifier_treasure_pot_of_greed = class({})
end
function modifier_treasure_pot_of_greed:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_pot_of_greed"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_pot_of_greed:IsPurgable()
    return false
end

function modifier_treasure_pot_of_greed:RemoveOnDeath()
    return false
end

function modifier_treasure_pot_of_greed:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
        for i = 1, 2 do
            local item = AddItemByName(self.parent, "item_noItem_baoWu_book")
            item.treasure_number = 2
        end
    end
end