
LinkLuaModifier("modifier_passive_shredder_reactive_armor_c","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_main_passive_shredder_reactive_armor_c","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_passive_shredder_reactive_armor_b","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_main_passive_shredder_reactive_armor_b","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_passive_shredder_reactive_armor_a","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_main_passive_shredder_reactive_armor_a","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_passive_shredder_reactive_armor_s","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_main_passive_shredder_reactive_armor_s","ability/abilities_lua/passive_shredder_reactive_armor",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

shredder_reactive_armor_c = class({})
function shredder_reactive_armor_c:GetIntrinsicModifierName()
	return "modifier_main_passive_shredder_reactive_armor_c"
end

shredder_reactive_armor_b = class({})
function shredder_reactive_armor_b:GetIntrinsicModifierName()
	return "modifier_main_passive_shredder_reactive_armor_b"
end

shredder_reactive_armor_a = class({})
function shredder_reactive_armor_a:GetIntrinsicModifierName()
	return "modifier_main_passive_shredder_reactive_armor_a"
end

shredder_reactive_armor_s = class({})
function shredder_reactive_armor_s:GetIntrinsicModifierName()
	return "modifier_main_passive_shredder_reactive_armor_s"
end


---------------------------------------------------------------------------
if modifier_main_passive_shredder_reactive_armor_c == nil then
	modifier_main_passive_shredder_reactive_armor_c = class({})
end


function modifier_main_passive_shredder_reactive_armor_c:IsHidden()
    return true
end

function modifier_main_passive_shredder_reactive_armor_c:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_main_passive_shredder_reactive_armor_c:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_main_passive_shredder_reactive_armor_c:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_main_passive_shredder_reactive_armor_c:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_main_passive_shredder_reactive_armor_c:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()
    if caster ~= params.target then
        return
    end
    local durations = self:GetAbility():GetSpecialValueFor("stack_duration")
    -- print(" >>>>>>>>>>>>>>>> durations: "..durations)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_shredder_reactive_armor_c", {duration = durations})
    return
end

if modifier_passive_shredder_reactive_armor_c == nil then
	modifier_passive_shredder_reactive_armor_c = class({})
end

function modifier_passive_shredder_reactive_armor_c:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_shredder_reactive_armor_c:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_shredder_reactive_armor_c:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end
function modifier_passive_shredder_reactive_armor_c:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end
function modifier_passive_shredder_reactive_armor_c:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "stack_limit" ) then
        self:IncrementStackCount()
    end
end

function modifier_passive_shredder_reactive_armor_c:GetModifierPhysicalArmorBonus()
    -- print(" >>>>>>>>>>>>>>>> bonus_armor: "..self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount()
end

function modifier_passive_shredder_reactive_armor_c:GetModifierConstantHealthRegen()
    -- print(" >>>>>>>>>>>>>>>> bonus_hp_regen: "..self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_main_passive_shredder_reactive_armor_b == nil then
	modifier_main_passive_shredder_reactive_armor_b = class({})
end


function modifier_main_passive_shredder_reactive_armor_b:IsHidden()
    return true
end

function modifier_main_passive_shredder_reactive_armor_b:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_main_passive_shredder_reactive_armor_b:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_main_passive_shredder_reactive_armor_b:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_main_passive_shredder_reactive_armor_b:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_main_passive_shredder_reactive_armor_b:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()
    if caster ~= params.target then
        return
    end
    local durations = self:GetAbility():GetSpecialValueFor("stack_duration")
    -- print(" >>>>>>>>>>>>>>>> durations: "..durations)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_shredder_reactive_armor_b", {duration = durations})
    return
end

if modifier_passive_shredder_reactive_armor_b == nil then
	modifier_passive_shredder_reactive_armor_b = class({})
end

function modifier_passive_shredder_reactive_armor_b:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_shredder_reactive_armor_b:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_shredder_reactive_armor_b:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end
function modifier_passive_shredder_reactive_armor_b:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end
function modifier_passive_shredder_reactive_armor_b:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "stack_limit" ) then
        self:IncrementStackCount()
    end
end

function modifier_passive_shredder_reactive_armor_b:GetModifierPhysicalArmorBonus()
    -- print(" >>>>>>>>>>>>>>>> bonus_armor: "..self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount()
end

function modifier_passive_shredder_reactive_armor_b:GetModifierConstantHealthRegen()
    -- print(" >>>>>>>>>>>>>>>> bonus_hp_regen: "..self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_main_passive_shredder_reactive_armor_a == nil then
	modifier_main_passive_shredder_reactive_armor_a = class({})
end


function modifier_main_passive_shredder_reactive_armor_a:IsHidden()
    return true
end

function modifier_main_passive_shredder_reactive_armor_a:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_main_passive_shredder_reactive_armor_a:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_main_passive_shredder_reactive_armor_a:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_main_passive_shredder_reactive_armor_a:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_main_passive_shredder_reactive_armor_a:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()
    if caster ~= params.target then
        return
    end
    local durations = self:GetAbility():GetSpecialValueFor("stack_duration")
    -- print(" >>>>>>>>>>>>>>>> durations: "..durations)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_shredder_reactive_armor_a", {duration = durations})
    return
end

if modifier_passive_shredder_reactive_armor_a == nil then
	modifier_passive_shredder_reactive_armor_a = class({})
end

function modifier_passive_shredder_reactive_armor_a:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_shredder_reactive_armor_a:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_shredder_reactive_armor_a:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end
function modifier_passive_shredder_reactive_armor_a:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end
function modifier_passive_shredder_reactive_armor_a:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "stack_limit" ) then
        self:IncrementStackCount()
    end
end

function modifier_passive_shredder_reactive_armor_a:GetModifierPhysicalArmorBonus()
    -- print(" >>>>>>>>>>>>>>>> bonus_armor: "..self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount()
end

function modifier_passive_shredder_reactive_armor_a:GetModifierConstantHealthRegen()
    -- print(" >>>>>>>>>>>>>>>> bonus_hp_regen: "..self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_main_passive_shredder_reactive_armor_s == nil then
	modifier_main_passive_shredder_reactive_armor_s = class({})
end


function modifier_main_passive_shredder_reactive_armor_s:IsHidden()
    return true
end

function modifier_main_passive_shredder_reactive_armor_s:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_main_passive_shredder_reactive_armor_s:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_main_passive_shredder_reactive_armor_s:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_main_passive_shredder_reactive_armor_s:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_main_passive_shredder_reactive_armor_s:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()
    if caster ~= params.target then
        return
    end
    local durations = self:GetAbility():GetSpecialValueFor("stack_duration")
    -- print(" >>>>>>>>>>>>>>>> durations: "..durations)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_shredder_reactive_armor_s", {duration = durations})
    return
end

if modifier_passive_shredder_reactive_armor_s == nil then
	modifier_passive_shredder_reactive_armor_s = class({})
end

function modifier_passive_shredder_reactive_armor_s:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_shredder_reactive_armor_s:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_shredder_reactive_armor_s:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end
function modifier_passive_shredder_reactive_armor_s:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end
function modifier_passive_shredder_reactive_armor_s:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "stack_limit" ) then
        self:IncrementStackCount()
    end
end

function modifier_passive_shredder_reactive_armor_s:GetModifierPhysicalArmorBonus()
    -- print(" >>>>>>>>>>>>>>>> bonus_armor: "..self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )*self:GetStackCount()
end

function modifier_passive_shredder_reactive_armor_s:GetModifierConstantHealthRegen()
    -- print(" >>>>>>>>>>>>>>>> bonus_hp_regen: "..self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount())
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )*self:GetStackCount()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
