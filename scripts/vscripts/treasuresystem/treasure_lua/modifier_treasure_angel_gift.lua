---------------------------------------------------------------------------
-- 宝物：天使的恩赐
---------------------------------------------------------------------------

if modifier_treasure_angel_gift == nil then 
    modifier_treasure_angel_gift = class({})
end

function modifier_treasure_angel_gift:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_angel_gift"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_angel_gift:IsPurgable()
    return false
end

function modifier_treasure_angel_gift:RemoveOnDeath()
    return false
end

function modifier_treasure_angel_gift:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
        for i = 1, 3 do
            local item = AddItemByName(self.parent, "item_noItem_baoWu_book")
            item.treasure_number = 2
        end
    end
end