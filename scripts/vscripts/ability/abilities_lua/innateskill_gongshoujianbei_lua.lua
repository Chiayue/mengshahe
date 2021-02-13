require("info/game_playerinfo")


LinkLuaModifier("modifier_gongshoujianbei_lua","ability/abilities_lua/innateskill_gongshoujianbei_lua.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
gongshoujianbei_lua = class({})

function gongshoujianbei_lua:GetIntrinsicModifierName()
	return "modifier_gongshoujianbei_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_gongshoujianbei_lua = class({})
--------------------------------------------------------------------------------

function modifier_gongshoujianbei_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_gongshoujianbei_lua:IsHidden()
    return true
end

function modifier_gongshoujianbei_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_gongshoujianbei_lua,'hero_level_up'),self)
end

function modifier_gongshoujianbei_lua:hero_level_up(evt)
    local caster = self:GetAbility():GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", self:GetAbility():GetSpecialValueFor("damagepercent"))
end

function modifier_gongshoujianbei_lua:GetModifierPhysicalArmorBonus()
    if not IsServer() then
        local armor = CustomNetTables:GetTableValue("dynamic_properties", "player_armor_gain"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { armor = 0 }
        return armor.armor
    end
    local armor = self:GetAbility():GetCaster():GetLevel()*self:GetAbility():GetSpecialValueFor("armor")
    CustomNetTables:SetTableValue("dynamic_properties", "player_armor_gain"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { armor = armor})
    return armor
end