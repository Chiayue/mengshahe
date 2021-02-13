gem_one_two_three = class({})
LinkLuaModifier("modifier_gem_one_two_three","ability/gem_lua/gem_one_two_three",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_one_two_three:GetIntrinsicModifierName()
	return "modifier_gem_one_two_three"
end

if modifier_gem_one_two_three == nil then
	modifier_gem_one_two_three = class({})
end

function modifier_gem_one_two_three:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_gem_one_two_three:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_one_two_three:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_one_two_three:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.setpower = 0
    self:StartIntervalThink(3)
end

function modifier_gem_one_two_three:OnIntervalThink()
    -- 天赋技能
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    self.power = (self:GetAbility():GetSpecialValueFor( "power" ) or 0)
    
    local innateskill = self:GetAbility():GetCaster():GetAbilityByIndex(0)
    if bit.band(innateskill:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
        if self.setpower > 0 then
            game_playerinfo:set_dynamic_properties(self.steam_id, "mana_regen", -self.power)
            -- print(" >>>>>>>>>>>> 11111 self.setpower: "..self.setpower)
            self.setpower = 0
        end
        return
    end
    -- 主动技能
    local activeskill = self:GetAbility():GetCaster():FindAbilityByName(game_playerinfo:get_player_active(self.steam_id))
    if bit.band(activeskill:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
        if self.setpower > 0 then
            game_playerinfo:set_dynamic_properties(self.steam_id, "mana_regen", -self.power)
            -- print(" >>>>>>>>>>>> 222222 self.setpower: "..self.setpower)
            -- print(" >>>>>>>>>>>> 222222 FindAbilityByName: "..game_playerinfo:get_player_active(self.steam_id))
            self.setpower = 0
        end
        return
    end
    -- 混乱技能
    local compositeskill = self:GetAbility():GetCaster():FindAbilityByName(game_playerinfo:get_player_chaos(self.steam_id))
    if bit.band(compositeskill:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
        if self.setpower > 0 then
            game_playerinfo:set_dynamic_properties(self.steam_id, "mana_regen", -self.power)
            -- print(" >>>>>>>>>>>> 33333 self.setpower: "..self.setpower)
            -- print(" >>>>>>>>>>>> 222222 FindAbilityByName: "..game_playerinfo:get_player_chaos(self.steam_id))
            self.setpower = 0
        end
        return
    end
    if self.setpower <= 0 then
        self.setpower = self.power
        local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
        -- print(" >>>>>>>>>>>> self.setpower: "..self.setpower)
        game_playerinfo:set_dynamic_properties(steam_id, "mana_regen", self.setpower)
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
