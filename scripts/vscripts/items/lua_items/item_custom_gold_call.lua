require("items/lua_items_ability/item_ability")

if item_custom_gold_call == nil then 
    item_custom_gold_call = class({})
end


-- LinkLuaModifier( "modifier_item_book_initiative_a","items/modifier_items/modifier_item_book_initiative_a", LUA_MODIFIER_MOTION_NONE )

-- function item_book_initiative_a:GetIntrinsicModifierName()
-- 	return "modifier_item_custom_bone_0"
-- end



function item_custom_gold_call:OnSpellStart()
    UTIL_RemoveImmediate(self)
end