require("global/global_var_func")
require("info/game_playerinfo")

modifier_updatehero_attribute_lua = class({})
--------------------------------------------------------------------------------

function modifier_updatehero_attribute_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_RESPAWN,
    }
    return funcs
end

function modifier_updatehero_attribute_lua:IsHidden()
    return true
end
function modifier_updatehero_attribute_lua:OnCreated(kv)
    if not IsServer( ) then
        return
    end
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
end

function modifier_updatehero_attribute_lua:OnRespawn(params)
    if not IsServer( ) then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断重生对象是否是自己
        params.unit:AddNewModifier( 
            self:GetAbility():GetCaster(), 
            self:GetAbility(), 
            "modifier_attack_speed_lua", 
            { duration = 9999999 } 
        )
    end
end

function modifier_updatehero_attribute_lua:GetModifierBaseAttack_BonusDamage()
	return (self:GetParent():GetIntellect() * 3);
end

function modifier_updatehero_attribute_lua:GetModifierHealthBonus()
    -- 力量 * 25 增加血量
    return (self:GetParent():GetStrength() * 25);
end

function modifier_updatehero_attribute_lua:GetModifierMoveSpeed_Limit()
    return 2000;
end

function modifier_updatehero_attribute_lua:GetModifierAttackSpeedBonus_Constant()
    -- 敏捷影响攻速,1点敏捷=0.25攻速
    if not IsServer( ) then
        local catk_speed = CustomNetTables:GetTableValue("dynamic_properties", "player_atk_speed"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { atk_speed = 0 }
        return catk_speed.atk_speed
    end
    local extra_attack_speed = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "extra_attack_speed")
    local base_attack_speed_percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "base_attack_speed_percent")
    -- print(">>>>>>>>>> extra_attack_speed: "..extra_attack_speed.."     steamid: "..self.steam_id)
    local agispeed = self:GetParent():GetAgility() * 0.25
    if agispeed > global_var_func.max_atk_speed[self:GetAbility():GetCaster():GetPlayerOwnerID() + 1] then
        agispeed = global_var_func.max_atk_speed[self:GetAbility():GetCaster():GetPlayerOwnerID() + 1]
    end
    local atk_speed = agispeed * (1 + base_attack_speed_percent*0.01) + extra_attack_speed
    -- local atk_speed = self:GetParent():GetAgility() * 0.25 * (1 + base_attack_speed_percent*0.01) + extra_attack_speed
    CustomNetTables:SetTableValue("dynamic_properties", "player_atk_speed"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { atk_speed = atk_speed})
    -- print(">>>>>>>>>> atk_speed: "..atk_speed.."     steamid: "..self.steam_id)
    return atk_speed
end

function modifier_updatehero_attribute_lua:GetModifierMoveSpeedBonus_Percentage()
    -- 敏捷 * 1 增加移动速度百分比
    if not IsServer( ) then
        local cmove_speed = CustomNetTables:GetTableValue("dynamic_properties", "player_move_speed"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { movespeed = 0 }
        return cmove_speed.movespeed
    end
    local movespeed = ((self:GetParent():GetAgility()-self:GetParent():GetBaseAgility())*0.1)
    CustomNetTables:SetTableValue("dynamic_properties", "player_move_speed"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { movespeed = movespeed})
    return movespeed
end

function modifier_updatehero_attribute_lua:GetModifierConstantManaRegen()
    if not IsServer() then
        local cmana_regen = CustomNetTables:GetTableValue("dynamic_properties", "player_mana_regen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { mana_regen = 0 }
        return cmana_regen.mana_regen
    end
    local intel = self:GetParent():GetIntellect()
    local mana_regen = global_var_func:GloFunc_Getgame_enum().BASE_MANA_REGEN -(intel/20) + game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "mana_regen")
    CustomNetTables:SetTableValue("dynamic_properties", "player_mana_regen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { mana_regen = mana_regen})
    return mana_regen
end

function modifier_updatehero_attribute_lua:GetModifierConstantHealthRegen()
    if not IsServer() then
        local heal_regen = CustomNetTables:GetTableValue("dynamic_properties", "player_heal_regen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { heal_regen = 0 }
        return heal_regen.heal_regen
    end
    local heal_regen = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "heal_regen")
    CustomNetTables:SetTableValue("dynamic_properties", "player_heal_regen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { heal_regen = heal_regen})
    return heal_regen
end

-- function modifier_updatehero_attribute_lua:GetModifierDamageOutgoing_Percentage()
--     local percent = 0
--     if IsServer() then
--         percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "extra_attack_scale")
--         CustomNetTables:SetTableValue("dynamic_properties", "player_attack_scale"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { percent = percent})
--         return percent
--     end
--     local percenttable = (CustomNetTables:GetTableValue("dynamic_properties", "player_attack_scale"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { percent = 0 })
-- 	return percenttable.percent
-- end