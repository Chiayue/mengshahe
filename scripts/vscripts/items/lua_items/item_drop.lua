require("config/drop_config")

if item_drop == nil then
    item_drop = class({})
end


function item_drop:RollDrops(unit,killer)
    local wave = global_var_func.current_round
    local unitType = unit.unit_type_flag
    local dropTable = drop_config:GetDropTable(unitType)
    local unitDropScal = killer.drop_scale_unit or 0
    local bossDropScal = killer.drop_scale_boss or 0
    local DropScal = killer.drop_scale or 0
    local dropScalFlag = 0
    if ContainUnitTypeFlag(unit,global_var_func.flag_boss_tj) then
        return
    end
    if ContainUnitTypeFlag(unit,DOTA_UNIT_TYPE_FLAG_CREEP) then
        dropScalFlag = 1
        --小怪
        --无掉落使用通用掉落
        if dropTable==nil then
            local dropItemKey 
            if wave>0 and wave<= 10 then 
                dropItemKey = global_var_func.flag_creep.."_1"
            elseif wave>10 and wave<=20 then 
                dropItemKey = global_var_func.flag_creep.."_2"
            elseif wave> 20 then 
                dropItemKey = global_var_func.flag_creep.."_3"
            end
            dropTable = drop_config:GetDropTable(dropItemKey)
        end
    elseif ContainUnitTypeFlag(unit,DOTA_UNIT_TYPE_FLAG_BOSS) then
        dropScalFlag = 2
        if dropTable == nil then
        --普通boss
            dropTable = drop_config:GetDropTable(global_var_func.flag_boss_general)
        end
    end
    if dropTable == nil then
        return
    end
    local itemList = dropTable.ItemSet
    local itemAmount = dropTable.Multiple or 1
    local DropLimit = dropTable.DropLimit or -1
    local dropCount = 0
    local chanceScal = 1
    if dropScalFlag == 1 then
        chanceScal = chanceScal + DropScal + unitDropScal
    elseif dropScalFlag == 2 then
        chanceScal = chanceScal + DropScal + bossDropScal
    end
    for i=1, itemAmount do 
        local itemScal
        for _,v in pairs(itemList) do
            itemScal = chanceScal + (killer["drop_scale_"..v[1]] or 0 )
            if RandomChance(v[2] * itemScal) then 
                if DropLimit ~= nil and DropLimit > 0 then
                    if DropLimit > 0 and DropLimit > dropCount then
                        dropCount = dropCount + 1
                    elseif DropLimit <= dropCount then
                        return
                    end
                end
                DropItem(v[1],unit)
            end
        end
        if dropTable.common_drop then
            for _,eTab in pairs(dropTable.common_drop) do
                local nxDropTable = drop_config:GetCommonDrop(eTab)
                for _,chc in pairs(nxDropTable) do
                    if killer["drop_scale_"..chc[1]] then
                        --指定物品掉率加强
                        itemScal = chanceScal + (killer["drop_scale_"..chc[1]] or 0)
                    end
                    if RandomChance(chc[2] * itemScal) then
                        if DropLimit ~= nil and DropLimit > 0 then
                            if DropLimit > 0 and DropLimit > dropCount then
                                dropCount = dropCount + 1
                            elseif DropLimit <= dropCount then
                                return
                            end
                        end
                        DropItem(chc[1],unit)
                    end
                end
            end
        end
    end
end

function RandomChance(chance)
    if chance >= 1 then 
        return true
    end
    local base = 100000
    local chance_int = chance * base
    local randomInt = RandomInt(0,base)
    if chance_int > randomInt then
        return true
    else 
        return false
    end
end

function DropItem(itemName,unit)
    local item
    if itemName == "item_box_bronze" or itemName == "item_box_silver" or itemName == "item_box_gold" then
        local ownPlayer = PlayerResource:GetPlayer(unit.player_id)
        local owbhero = ownPlayer:GetAssignedHero()
        item = CreateItem(itemName, owbhero, ownPlayer)
        item:SetPurchaser(owbhero)
    else
        item = CreateItem(itemName, nil, nil)
    end
    if item == nil then
        return
    end
    local soundname = ""
    -- if string.find(itemName, "_materials") or string.find(itemName, "item_world_boss") then
    --     soundname = "drop.gem"
    -- elseif string.find(item_name, "_materials") then
    --     soundname = "drop.equipment"
    -- end
    -- item:EmitSound(soundname)
    item:SetPurchaseTime(0)
    local pos = unit:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( pos, item )
    local pos_launch = pos+RandomVector(RandomFloat(150,200))
    item:LaunchLoot(false, 200, 0.75, pos_launch)
    local pindx
    -- if itemName == "item_book_passive_d"  or itemName == "item_book_initiative_d" then
        -- pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_d.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    if itemName == "item_book_passive_c"  or itemName == "item_book_initiative_c" then
        pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    elseif itemName == "item_book_passive_b"  or itemName == "item_book_initiative_b" then
        pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    elseif itemName == "item_book_passive_a"  or itemName == "item_book_initiative_a" then
        pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    elseif itemName == "item_book_passive_s"  or itemName == "item_book_initiative_s" then
        pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_s.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    elseif itemName == "item_book_innateskill" then
        pindx = ParticleManager:CreateParticle( "particles/ui/ui_item_s.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    -- else
        -- pindx = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, item:GetContainer() )
    end
    if pindx ~= nil then
        ParticleManager:ReleaseParticleIndex(pindx)
    end
   
    -- change_item_color(item:GetContainer(),item_name)
end