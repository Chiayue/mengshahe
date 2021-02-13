require("info/game_playerinfo")

LinkLuaModifier("modifier_guanjunzhili_lua","ability/abilities_lua/innateskill_guanjunzhili_lua.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
guanjunzhili_lua = class({})

function guanjunzhili_lua:GetIntrinsicModifierName()
	return "modifier_guanjunzhili_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_guanjunzhili_lua = class({})
--------------------------------------------------------------------------------

function modifier_guanjunzhili_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_guanjunzhili_lua:IsHidden()
    return true
end

function modifier_guanjunzhili_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster()
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    game_playerinfo:set_dynamic_properties(steam_id, "respawn_time", (self:GetAbility():GetSpecialValueFor("swaptime") or 0.5))
    self:StartIntervalThink(1)
    table.insert(global_var_func.championgroup, self:GetCaster():GetPlayerID())
end

function modifier_guanjunzhili_lua:OnIntervalThink()
    if #global_var_func.championgroup >= 2 and global_var_func.championgroupnumber < #global_var_func.championgroup then
        for key, value in ipairs(global_var_func.championgroup) do
            local hero = PlayerResource:GetPlayer(value):GetAssignedHero()
            if not hero:FindModifierByName("modifier_attribute_50_lua") then
                hero:AddNewModifier(hero, nil, "modifier_attribute_50_lua", {})
                global_var_func.championgroupnumber = global_var_func.championgroupnumber + 1
            end
        end
    end
end