if modifier_currier_send_item == nil then 
    modifier_currier_send_item = class({})
end

function modifier_currier_send_item:OnCreated( table )
    if IsServer() then 
        self:StartIntervalThink( 0.5)
    end
end

function modifier_currier_send_item:OnIntervalThink()
    if IsServer() then 
        local unit = self:GetParent()
        local owner = self:GetParent():GetOwner()
        local isFull = 0
        for i=0,8 do
            local hero_item = owner:GetItemInSlot(i)
            if hero_item then 
                isFull = isFull + 1
            end
        end
        for i=0,8 do
            local item = unit:GetItemInSlot(i)
            if item then 
                if isFull < 9 then 
                    unit:MoveToNPCToGiveItem(owner,item)
                else
                    self:Destroy(  )
                    send_error_tip(owner:GetPlayerID(),"error_noitembox")
                end
                break
            end
            if i==8 then 
                self:Destroy(  )
            end
        end
        for i=0 , 8 do 
            local item_handle =  owner:GetItemInSlot(i)
            if item_handle and string.find(item_handle:GetAbilityName(),"item_book_") then
                item_handle:SetPurchaser( owner )
                item_handle:SetSellable(true)
            end
        end
    end
end


function modifier_currier_send_item:IsHidden()
    return true    
end