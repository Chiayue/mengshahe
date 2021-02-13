
require("items/lua_items_ability/item_ability")
--属性书加血量
if modifier_hero_add_health == nil then 
    modifier_hero_add_health = class({})
end

function modifier_hero_add_health:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_hero_add_health:RemoveOnDeath()
    return false -- 死亡不移除
end
function modifier_hero_add_health:IsHidden()
    return true 
end
function modifier_hero_add_health:DeclareFunctions()
    local funcs = {
        -- 额外生命值
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end
function modifier_hero_add_health:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self:SetStackCount(evt.add_health)
end


function modifier_hero_add_health:GetModifierHealthBonus()
    return self:GetStackCount()
end
function modifier_hero_add_health:OnRefresh(evt)
    -- self:IncrementStackCount()
    if not IsServer( ) then
        return
    end
    if evt.add_health ~=nil then
    
        self:SetStackCount(evt.add_health+self:GetStackCount())
    end

end