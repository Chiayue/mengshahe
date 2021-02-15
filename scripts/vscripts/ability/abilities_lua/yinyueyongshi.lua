LinkLuaModifier("modifier_yinyueyongshi", "ability/abilities_lua/yinyueyongshi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sublime_yinyueyongshi", "ability/abilities_lua/yinyueyongshi", LUA_MODIFIER_MOTION_NONE)

yinyueyongshi = class({})

function yinyueyongshi:GetIntrinsicModifierName()
    return "modifier_yinyueyongshi"
end

--------------------------------------------------------------------------

modifier_yinyueyongshi = class({})

function modifier_yinyueyongshi:IsHidden()
	return true
end

function modifier_yinyueyongshi:IsPurgable()
    return false
end

function modifier_yinyueyongshi:RemoveOnDeath()
	return false
end

function modifier_yinyueyongshi:OnCreated(table)
    if IsServer() then
        local hero = self:GetParent()
        self.steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        
        self:StartIntervalThink(1)
    end
end

function modifier_yinyueyongshi:OnIntervalThink()
    self.add_amount = self:GetAbility():GetSpecialValueFor("add_amount")
    game_playerinfo:set_dynamic_properties(self.steam_id,"attack_critical",self.add_amount)
    self:StartIntervalThink(-1)
end

function modifier_yinyueyongshi:OnDestroy()
    if IsServer() then
        game_playerinfo:set_dynamic_properties(self.steam_id,"attack_critical",-self.add_amount)
    end
end


sublime_yinyueyongshi = class({})

function sublime_yinyueyongshi:GetIntrinsicModifierName()
    return "modifier_sublime_yinyueyongshi"
end

modifier_sublime_yinyueyongshi = class({})


function modifier_sublime_yinyueyongshi:IsHidden()
	return true
end

function modifier_sublime_yinyueyongshi:IsPurgable()
    return false
end

function modifier_sublime_yinyueyongshi:RemoveOnDeath()
	return false
end

function modifier_sublime_yinyueyongshi:OnCreated(table)
    if IsServer() then
        local hero = self:GetParent()
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        Timers:CreateTimer({
        endTime = 1, 
        callback = function()
            local add_amount = self:GetAbility():GetSpecialValueFor("add_amount")
            game_playerinfo:set_dynamic_properties(steam_id,"attack_critical",add_amount)
        end
        })
    end
end

function modifier_sublime_yinyueyongshi:OnDestroy()
    if IsServer() then
        local hero = self:GetParent()
        local add_amount = -self:GetAbility():GetSpecialValueFor("add_amount")
        local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id,"attack_critical",add_amount)
    end
end

