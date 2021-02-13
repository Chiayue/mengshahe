require("items/lua_items_ability/item_ability")

if item_custom_ability_book_a == nil then 
    item_custom_ability_book_a = class({})
end


-- LinkLuaModifier( "modifier_item_custom_ability_book_a","items/modifier_items/modifier_item_custom_ability_book_a", LUA_MODIFIER_MOTION_NONE )

-- function item_custom_ability_book_a:GetIntrinsicModifierName()
-- 	return "modifier_item_custom_bone_0"
-- end



function item_custom_ability_book_a:OnSpellStart()
    common_item_ability:item_up(self:GetAbilityName(),self:GetCaster())
end