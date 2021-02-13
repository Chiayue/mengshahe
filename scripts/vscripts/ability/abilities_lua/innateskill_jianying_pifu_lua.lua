LinkLuaModifier( "modifier_jianying_pifu_lua", "ability/abilities_lua/innateskill_jianying_pifu_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pifu_buff_lua", "ability/abilities_lua/innateskill_jianying_pifu_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if jianying_pifu_lua == nil then
	jianying_pifu_lua = class({})
end

function jianying_pifu_lua:GetIntrinsicModifierName()
 	return "modifier_jianying_pifu_lua"
end
--------------------------------------------------
if modifier_jianying_pifu_lua == nil then
	modifier_jianying_pifu_lua = class({})
end

function modifier_jianying_pifu_lua:IsHidden()
    return true
end

function modifier_jianying_pifu_lua:DeclareFunctions()
	local funcs = {
        
	}
	return funcs
end

function modifier_jianying_pifu_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_jianying_pifu_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    local HealthPercent = caster:GetHealthPercent()
    if HealthPercent <= 30 then
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_pifu_buff_lua", {})
    else
        if caster:FindModifierByName("modifier_pifu_buff_lua") then
            caster:RemoveModifierByName("modifier_pifu_buff_lua")
        end
    end
end


if modifier_pifu_buff_lua == nil then
	modifier_pifu_buff_lua = class({})
end

function modifier_pifu_buff_lua:IsHidden()
    return true
end

function modifier_pifu_buff_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_pifu_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    
end

function modifier_pifu_buff_lua:GetModifierPhysicalArmorBonus()
    return 50
end

function modifier_pifu_buff_lua:GetModifierMagicalResistanceBonus()
    return 50
end

--------------------------------------------------------------------

LinkLuaModifier( "modifier_sublime_jianying_pifu_lua", "ability/abilities_lua/innateskill_jianying_pifu_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sublime_pifu_buff_lua", "ability/abilities_lua/innateskill_jianying_pifu_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if sublime_jianying_pifu_lua == nil then
	sublime_jianying_pifu_lua = class({})
end

function sublime_jianying_pifu_lua:GetIntrinsicModifierName()
 	return "modifier_sublime_jianying_pifu_lua"
end
--------------------------------------------------
if modifier_sublime_jianying_pifu_lua == nil then
	modifier_sublime_jianying_pifu_lua = class({})
end

function modifier_sublime_jianying_pifu_lua:IsHidden()
    return true
end

function modifier_sublime_jianying_pifu_lua:DeclareFunctions()
	local funcs = {
        
	}
	return funcs
end

function modifier_sublime_jianying_pifu_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.damagepercent = 0
    self:StartIntervalThink(1)
end

function modifier_sublime_jianying_pifu_lua:OnIntervalThink()
    local playerID = self:GetCaster():GetPlayerID()
    local steam_id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID())
    local caster = self:GetAbility():GetCaster()
    local HealthPercent = caster:GetHealthPercent()
    if HealthPercent <= 30 then
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_sublime_pifu_buff_lua", {})
    else
        if caster:FindModifierByName("modifier_sublime_pifu_buff_lua") then
            caster:RemoveModifierByName("modifier_sublime_pifu_buff_lua")
        end
    end
    if self.damagepercent ~= 0 then
        game_playerinfo:set_dynamic_properties(steam_id, "physics_attack_scale", -self.damagepercent)
    end
    local key = "player_"..playerID.."_current_count"
    self.damagepercent = #global_var_func[key]*self:GetAbility():GetSpecialValueFor("percent")
    game_playerinfo:set_dynamic_properties(steam_id, "physics_attack_scale", self.damagepercent)
end


if modifier_sublime_pifu_buff_lua == nil then
	modifier_sublime_pifu_buff_lua = class({})
end

function modifier_sublime_pifu_buff_lua:IsHidden()
    return true
end

function modifier_sublime_pifu_buff_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_sublime_pifu_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    
end

function modifier_sublime_pifu_buff_lua:GetModifierPhysicalArmorBonus()
    return 20
end

function modifier_sublime_pifu_buff_lua:GetModifierMagicalResistanceBonus()
    return 30
end