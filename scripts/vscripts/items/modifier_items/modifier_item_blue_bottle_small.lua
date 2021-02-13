require("items/lua_items_ability/item_ability")

if modifier_item_blue_bottle_small == nil then 
    modifier_item_blue_bottle_small = class({})
end

function modifier_item_blue_bottle_small:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_item_blue_bottle_small:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self.gain_mana = self:GetParent():GetMaxMana() * 0.4 / 20
    self:OnIntervalThink()
    self:StartIntervalThink( 1 )
end

function modifier_item_blue_bottle_small:GetTexture()
    return "buff/blue"
end

function modifier_item_blue_bottle_small:OnIntervalThink(  )
    self:GetParent():GiveMana(self.gain_mana )
end
