---------------------------------------------------------------------------
-- 宝物：蓄力箭
---------------------------------------------------------------------------

if modifier_treasure_storage_strength_arrow == nil then 
    modifier_treasure_storage_strength_arrow = class({})
end

function modifier_treasure_storage_strength_arrow:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_storage_strength_arrow"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_storage_strength_arrow:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_storage_strength_arrow:OnAbilityExecuted(event)
    if string.find(event.ability:GetAbilityName(), "item_book_initiative") then
        Timers(function ()
            local parent = self:GetParent()
            local steam_id = PlayerResource:GetSteamAccountID(parent:GetPlayerID())
            local old_name = game_playerinfo:get_player_active(steam_id)
            if string.find(old_name, "active_wind_array_arrow") then
                local level = string.sub(old_name, -1, -1)
                if level == "b" or level == "a" or level == "s" then
                    local new_name = "active_storage_strength_arrow"
                    local old_ability = parent:FindAbilityByName(old_name)
                    local new_ability = parent:AddAbility(new_name)
                    new_ability:SetLevel(1)
                    new_ability.nScale = old_ability:GetSpecialValueFor("scale")
                    parent:SwapAbilities(new_name, old_name, true, false)
                    parent:RemoveAbility(old_name)
                    game_playerinfo:set_player_active(steam_id, new_name) 
                    self.level = level
                end
            end
        end)
    end
end

function modifier_treasure_storage_strength_arrow:IsPurgable()
    return false
end
 
function modifier_treasure_storage_strength_arrow:RemoveOnDeath()
    return false
end

function modifier_treasure_storage_strength_arrow:OnCreated(params)
    if IsServer() then
        self.level = ""
        local parent = self:GetParent()
        local steam_id = PlayerResource:GetSteamAccountID(parent:GetPlayerID())
        local old_name = game_playerinfo:get_player_active(steam_id)
        if string.find(old_name, "active_wind_array_arrow") then
            local level = string.sub(old_name, -1, -1)
            if level == "b" or level == "a" or level == "s" then
                local new_name = "active_storage_strength_arrow"
                local old_ability = parent:FindAbilityByName(old_name)
                local new_ability = parent:AddAbility(new_name)
                new_ability:SetLevel(1)
                new_ability.nScale = old_ability:GetSpecialValueFor("scale")
                parent:SwapAbilities(new_name, old_name, true, false)
                parent:RemoveAbility(old_name)
                game_playerinfo:set_player_active(steam_id, new_name)
                self.level = level
            end
        end
    end
end

function modifier_treasure_storage_strength_arrow:OnRemoved()
    if IsServer() then
        local parent = self:GetParent()
        local steam_id = PlayerResource:GetSteamAccountID(parent:GetPlayerID())
        local old_name = game_playerinfo:get_player_active(steam_id)
        if old_name == "active_storage_strength_arrow" then
            local new_name = "active_wind_array_arrow_"..self.level
            parent:AddAbility(new_name):SetLevel(1)
            parent:SwapAbilities(new_name, old_name, true, false)
            parent:RemoveAbility(old_name)
            game_playerinfo:set_player_active(steam_id, new_name)
        end
    end
end