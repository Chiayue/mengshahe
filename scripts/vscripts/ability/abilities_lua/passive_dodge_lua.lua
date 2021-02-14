passive_dodge_lua = class({})

LinkLuaModifier("modifier_passive_dodge_lua","ability/abilities_lua/passive_dodge_lua",LUA_MODIFIER_MOTION_NONE )

function passive_dodge_lua:GetIntrinsicModifierName()
	return "modifier_passive_dodge_lua"
end

if modifier_passive_dodge_lua == nil then
    modifier_passive_dodge_lua = class({})
end

function modifier_passive_dodge_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_dodge_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_dodge_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_dodge_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_dodge_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT ,
    }
    return funcs
end

function modifier_passive_dodge_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_dodge_lua:GetModifierEvasion_Constant(params)
    return self:GetAbility():GetSpecialValueFor("magic_resistance")
end