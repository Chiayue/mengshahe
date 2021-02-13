if modifier_item_rune_illusions == nil then 
    modifier_item_rune_illusions = class({})
end

function modifier_item_rune_illusions:OnDestroy()
    UTIL_RemoveImmediate(self:GetParent(  ))
end
