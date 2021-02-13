require("items/lua_items_ability/item_ability")

if modifier_item_red_bottle_small == nil then 
    modifier_item_red_bottle_small = class({})
end

function modifier_item_red_bottle_small:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_item_red_bottle_small:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self.gain_health = 0
    self:OnIntervalThink()
    self:StartIntervalThink( 1 )
end

function modifier_item_red_bottle_small:GetTexture()
    return "buff/blood"
end

function modifier_item_red_bottle_small:OnIntervalThink()
    local caster = self:GetCaster()
    self.gain_health = caster:GetMaxHealth() * 0.4 / 20
    caster:Heal( self.gain_health,caster );
end
