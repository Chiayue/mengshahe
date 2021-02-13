
LinkLuaModifier("modifier_passive_addall_attribute_lua_d","ability/abilities_lua/passive_addall_attribute_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_addall_attribute_lua_c","ability/abilities_lua/passive_addall_attribute_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_addall_attribute_lua_b","ability/abilities_lua/passive_addall_attribute_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_addall_attribute_lua_a","ability/abilities_lua/passive_addall_attribute_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_addall_attribute_lua_s","ability/abilities_lua/passive_addall_attribute_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_addall_attribute_lua_d = class({})
function passive_addall_attribute_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_addall_attribute_lua_d"
end

passive_addall_attribute_lua_c = class({})
function passive_addall_attribute_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_addall_attribute_lua_c"
end

passive_addall_attribute_lua_b = class({})
function passive_addall_attribute_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_addall_attribute_lua_b"
end

passive_addall_attribute_lua_a = class({})
function passive_addall_attribute_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_addall_attribute_lua_a"
end

passive_addall_attribute_lua_s = class({})
function passive_addall_attribute_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_addall_attribute_lua_s"
end

if modifier_passive_addall_attribute_lua_d == nil then
	modifier_passive_addall_attribute_lua_d = class({})
end


function modifier_passive_addall_attribute_lua_d:IsHidden()
    return true
end

function modifier_passive_addall_attribute_lua_d:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_addall_attribute_lua_d:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_addall_attribute_lua_d:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end
function modifier_passive_addall_attribute_lua_d:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_addall_attribute_lua_d:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_d:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_d:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_passive_addall_attribute_lua_c == nil then
	modifier_passive_addall_attribute_lua_c = class({})
end


function modifier_passive_addall_attribute_lua_c:IsHidden()
    return true
end

function modifier_passive_addall_attribute_lua_c:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_addall_attribute_lua_c:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_addall_attribute_lua_c:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end
function modifier_passive_addall_attribute_lua_c:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_addall_attribute_lua_c:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_c:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_c:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_passive_addall_attribute_lua_b == nil then
	modifier_passive_addall_attribute_lua_b = class({})
end


function modifier_passive_addall_attribute_lua_b:IsHidden()
    return true
end

function modifier_passive_addall_attribute_lua_b:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_addall_attribute_lua_b:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_addall_attribute_lua_b:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end
function modifier_passive_addall_attribute_lua_b:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_addall_attribute_lua_b:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_b:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_b:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_passive_addall_attribute_lua_a == nil then
	modifier_passive_addall_attribute_lua_a = class({})
end


function modifier_passive_addall_attribute_lua_a:IsHidden()
    return true
end

function modifier_passive_addall_attribute_lua_a:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_addall_attribute_lua_a:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_addall_attribute_lua_a:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end
function modifier_passive_addall_attribute_lua_a:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_addall_attribute_lua_a:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_a:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_a:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_passive_addall_attribute_lua_s == nil then
	modifier_passive_addall_attribute_lua_s = class({})
end


function modifier_passive_addall_attribute_lua_s:IsHidden()
    return true
end

function modifier_passive_addall_attribute_lua_s:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_addall_attribute_lua_s:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_addall_attribute_lua_s:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end
function modifier_passive_addall_attribute_lua_s:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_addall_attribute_lua_s:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_s:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end

function modifier_passive_addall_attribute_lua_s:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor( "attribute" )
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
