
LinkLuaModifier( "modifier_lilian_lua", "ability/abilities_lua/innateskill_lilian_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if lilian_lua == nil then
	lilian_lua = class({})
end

function lilian_lua:GetIntrinsicModifierName()
 	return "modifier_lilian_lua"
end
--------------------------------------------------
if modifier_lilian_lua == nil then
	modifier_lilian_lua = class({})
end

function modifier_lilian_lua:IsHidden()
    return true
end

function modifier_lilian_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_lilian_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_lilian_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.strength = 0
    self.agility = 0
    self.intellect = 0
    self:StartIntervalThink(1)
end

function modifier_lilian_lua:OnIntervalThink()
    local playerID = self:GetAbility():GetCaster():GetPlayerID()
    local killnumber = 0
    if 0==playerID then
        killnumber = #global_var_func.player_0_kill_count
    elseif 1==playerID then
        killnumber = #global_var_func.player_1_kill_count
    elseif 2==playerID then
        killnumber = #global_var_func.player_2_kill_count
    elseif 3==playerID then
        killnumber = #global_var_func.player_3_kill_count
    end
    self.strength = math.floor(killnumber/self:GetAbility():GetSpecialValueFor("killnumber"))*35
    self.agility = math.floor(killnumber/self:GetAbility():GetSpecialValueFor("killnumber"))*35
    self.intellect = math.floor(killnumber/self:GetAbility():GetSpecialValueFor("killnumber"))*35
end

function modifier_lilian_lua:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_lilian_lua:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_lilian_lua:GetModifierBonusStats_Strength()
	return self.strength
end