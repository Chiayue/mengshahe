if item_more_and_more ==nil then
    item_more_and_more =({})
end
--无尽药水
function recover(params)
    local hero = params.caster
    local heal_amount = math.ceil(hero:GetMaxHealth() * 0.4)
    local mana_amount = math.ceil(hero:GetMaxMana() * 0.4)
    hero:Heal( heal_amount, hero )
    hero:GiveMana( mana_amount )
    hero:EmitSound("hero.eatdrug1")
    for i=0,6 do 
        local item_handle =  hero:GetItemInSlot(i)
        if item_handle then 
            local item_name = item_handle:GetAbilityName()
            if item_name == "item_more_and_more" then
                local local_charges = item_handle:GetCurrentCharges()-1
                item_handle:SetCurrentCharges(local_charges)
                break
            end
        end
    end
end