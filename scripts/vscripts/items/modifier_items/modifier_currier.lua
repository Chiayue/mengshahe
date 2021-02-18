if modifier_currier == nil then 
    modifier_currier = class({})
end

function modifier_currier:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_currier:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_currier:IsHidden()
    return true    
end

function modifier_currier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_STATE_INVULNERABLE,
        MODIFIER_EVENT_ON_ORDER,
    }
    return funcs
end


function modifier_currier:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self:GetParent():AddNewModifier(self:GetParent(),self,"modifier_bloodseeker_thirst",nil)
end


--移速
function modifier_currier:GetModifierMoveSpeedBonus_Constant(params)
    return 0
end

function modifier_currier:CheckState()
    local states = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
    return states
end

function modifier_currier:OnOrder(params)
    if params.unit == self:GetParent() then
        local unit = self:GetParent()
        local order_type = params.order_type
        if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET
        or order_type == DOTA_UNIT_ORDER_CAST_POSITION or order_type == DOTA_UNIT_ORDER_CAST_TARGET then
            unit:RemoveModifierByName("modifier_currier_pickup_item")
            unit:RemoveModifierByName("modifier_currier_send_item")
        end
    end
end
