---------------------------------------------------------------------------
-- 宝物：天使的恩赐
---------------------------------------------------------------------------

if modifier_treasure_angel_gift == nil then 
    modifier_treasure_angel_gift = class({})
end

function modifier_treasure_angel_gift:GetTexture()
    return "buff/modifier_treasure_angel_gift"
end

function modifier_treasure_angel_gift:IsHidden()
    return false
end

function modifier_treasure_angel_gift:IsPurgable()
    return false
end

function modifier_treasure_angel_gift:RemoveOnDeath()
    return false
end

function modifier_treasure_angel_gift:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_angel_gift:OnIntervalThink()
    local parent = self:GetParent()
    for i = 1, 3 do
        local item = AddItemByName(parent, "item_noItem_baoWu_book")
        item.treasure_number = 2
    end
    self:StartIntervalThink(-1)
end