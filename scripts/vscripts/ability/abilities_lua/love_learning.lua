LinkLuaModifier( "modifier_love_learning","ability/abilities_lua/love_learning", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_love_learning_courier","ability/abilities_lua/love_learning", LUA_MODIFIER_MOTION_NONE )


if love_learning == nil then
	love_learning = class({})
end

function love_learning:GetIntrinsicModifierName()
 	return "modifier_love_learning"
end

if modifier_love_learning == nil then
	modifier_love_learning = ({})
end

function modifier_love_learning:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ORDER,
    }
    return funcs
end

function modifier_love_learning:IsPurgable()
    return false 
end
 
function modifier_love_learning:RemoveOnDeath()
    return false 
end

function modifier_love_learning:OnCreated( params )
	if IsServer() then 
        local hero = self:GetParent()
        local weartable = {
            "models/heroes/invoker_kid/invoker_kid_cape.vmdl",
            "models/heroes/invoker_kid/invoker_kid_hair.vmdl",
        }
        WearForHero(weartable,self:GetParent())
	end
end

function modifier_love_learning:OnOrder( params )
    if  params.unit ~= self:GetParent() then
        if params.unit:GetOwner() == nil or params.unit:GetOwner() ~= self:GetParent() then
            return
        end
    end
    local type = params.order_type
    if type == DOTA_UNIT_ORDER_CAST_POSITION	or	
        type == DOTA_UNIT_ORDER_CAST_TARGET	or	
        type == DOTA_UNIT_ORDER_CAST_TARGET_TREE	or	
        type == DOTA_UNIT_ORDER_CAST_NO_TARGET	or	
        type == DOTA_UNIT_ORDER_CAST_TOGGLE   then
        if params.ability then
            if string.find(params.ability:GetAbilityName(),"item_book") then
                self:IncrementStackCount()
            end
        end
    end
    
end

function modifier_love_learning:GetModifierBonusStats_Intellect()
    return 15 * self:GetStackCount()
end

function modifier_love_learning:GetModifierBonusStats_Strength()
    return 15 * self:GetStackCount()
end

function modifier_love_learning:GetModifierBonusStats_Agility()
    return 15 * self:GetStackCount()
end

-- function modifier_love_learning:AddModifierForCourier(courier_index,ability,caster)
--     if not courier_index then
--         Timers:CreateTimer({
--             endTime = 1, 
--             callback = function()
--                 courier_index = global_var_func.courier_table[self:GetParent():GetPlayerID()]
--                 self:AddModifierForCourier(courier_index,ability,caster)
--             end
--         })
--     else
--         local courier = EntIndexToHScript(courier_index)
--         courier:AddNewModifier(caster, ability, "modifier_love_learning_courier", {})
--     end
    
-- end

--------------------------------------------

-- if modifier_love_learning_courier == nil then
--     modifier_love_learning_courier =({})
-- end

-- function modifier_love_learning_courier:DeclareFunctions()
--     local funcs = {
-- 		MODIFIER_EVENT_ON_ORDER,
--     }
--     return funcs
-- end

-- function modifier_love_learning_courier:OnOrder( params )
--     local type = params.order_type
--     if type == DOTA_UNIT_ORDER_CAST_POSITION	or	
--         type == DOTA_UNIT_ORDER_CAST_TARGET	or	
--         type == DOTA_UNIT_ORDER_CAST_TARGET_TREE	or	
--         type == DOTA_UNIT_ORDER_CAST_NO_TARGET	or	
--         type == DOTA_UNIT_ORDER_CAST_TOGGLE then

--         if params.ability then
--             print(params.ability:GetAbilityName())
--             if string.find(params.ability:GetAbilityName(),"item_book") then
--                 self:GetParent():GetOwner():FindModifierByName("modifier_love_learning"):IncrementStackCount()
--             end
--         end
--     end
    
-- end

