require("items/lua_items_ability/item_ability")

if modifier_item_blue_bottle_large == nil then 
    modifier_item_blue_bottle_large = class({})
end

function modifier_item_blue_bottle_large:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_item_blue_bottle_large:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self.gain_mana = self:GetParent():GetMaxMana() * 0.8 / 20
    self:OnIntervalThink()
    self:StartIntervalThink( 1 )
end

function modifier_item_blue_bottle_large:GetTexture()
    return "buff/bigblue"
end

function modifier_item_blue_bottle_large:OnIntervalThink()
    self:GetParent():GiveMana(self.gain_mana)
end
