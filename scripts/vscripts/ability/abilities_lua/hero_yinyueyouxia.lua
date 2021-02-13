LinkLuaModifier("modifier_hero_yinyueyouxia", "ability/abilities_lua/hero_yinyueyouxia", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sublime_hero_yinyueyouxia", "ability/abilities_lua/hero_yinyueyouxia", LUA_MODIFIER_MOTION_NONE)

hero_yinyueyouxia = class({})

function hero_yinyueyouxia:GetIntrinsicModifierName()
    return "modifier_hero_yinyueyouxia"
end

--------------------------------------------------------------------------

modifier_hero_yinyueyouxia = class({})

function modifier_hero_yinyueyouxia:IsHidden()
	return true
end

function modifier_hero_yinyueyouxia:IsPurgable()
    return false
end

function modifier_hero_yinyueyouxia:RemoveOnDeath()
	return false
end

function modifier_hero_yinyueyouxia:OnCreated(table)
    if IsServer() then
        local hero = self:GetParent()
        local add_amount = self:GetAbility():GetSpecialValueFor("add_amount")/100
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id,"attack_critical_damage",add_amount)
    end
end

function modifier_hero_yinyueyouxia:OnDestroy()
    if IsServer() then
        local hero = self:GetParent()
        local add_amount = -self:GetAbility():GetSpecialValueFor("add_amount")/100
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id,"attack_critical_damage",add_amount)
    end
end


sublime_hero_yinyueyouxia = class({})

function sublime_hero_yinyueyouxia:GetIntrinsicModifierName()
    return "modifier_sublime_hero_yinyueyouxia"
end

modifier_sublime_hero_yinyueyouxia = class({})


function modifier_sublime_hero_yinyueyouxia:IsHidden()
	return true
end

function modifier_sublime_hero_yinyueyouxia:IsPurgable()
    return false
end

function modifier_sublime_hero_yinyueyouxia:RemoveOnDeath()
	return false
end

function modifier_sublime_hero_yinyueyouxia:OnCreated(table)
    if IsServer() then
        local hero = self:GetParent()
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        Timers:CreateTimer({
        endTime = 1, 
        callback = function()
            local add_amount = self:GetAbility():GetSpecialValueFor("add_amount")/100
            game_playerinfo:set_dynamic_properties(steam_id,"attack_critical_damage",add_amount)
        end
        })
    end
end

function modifier_sublime_hero_yinyueyouxia:OnDestroy()
    if IsServer() then
        local hero = self:GetParent()
        local add_amount = -self:GetAbility():GetSpecialValueFor("add_amount")/100
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id,"attack_critical_damage",add_amount)
    end
end

