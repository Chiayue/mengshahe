if modifier_currier_pickup_item == nil then 
    modifier_currier_pickup_item = class({})
end

function modifier_currier_pickup_item:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_currier_pickup_item:OnCreated( table )
    if IsServer() then 
        self:StartIntervalThink( 0.5)
    end
end

function modifier_currier_pickup_item:OnIntervalThink()
    if IsServer() then 
        local unit = self:GetParent()
        local vc = unit:GetOrigin()
        local entities = Entities:FindAllByClassnameWithin("dota_item_drop",vc,600)
        if #entities < 1 then
            self:Destroy(  )
        end
        for _,v in pairs(entities) do 
            ExecuteOrderFromTable({
                UnitIndex = unit:entindex(),
                OrderType = DOTA_UNIT_ORDER_PICKUP_ITEM,
                TargetIndex =v:entindex()
            })
            break
        end
    end
end

function modifier_currier_pickup_item:IsHidden()
    return true    
end
