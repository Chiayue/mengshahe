require("items/lua_items_ability/item_ability")

if modifier_item_red_bottle_large == nil then 
    modifier_item_red_bottle_large = class({})
end

function modifier_item_red_bottle_large:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_item_red_bottle_large:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self.gain_health = 0
    self:OnIntervalThink()
    self:StartIntervalThink( 1 )
end

function modifier_item_red_bottle_large:GetTexture()
    return "buff/bigblood"
end

function modifier_item_red_bottle_large:OnIntervalThink(  )
    local caster = self:GetCaster()
    self.gain_health = caster:GetMaxHealth() * 0.8 / 20
    caster:Heal( self.gain_health,caster );
end
