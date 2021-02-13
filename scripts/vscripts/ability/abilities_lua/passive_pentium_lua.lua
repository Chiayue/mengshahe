passive_pentium_lua = class({})

LinkLuaModifier("modifier_passive_pentium_lua","ability/abilities_lua/passive_pentium_lua",LUA_MODIFIER_MOTION_NONE )

function passive_pentium_lua:GetIntrinsicModifierName()
	return "modifier_passive_pentium_lua"
end

if modifier_passive_pentium_lua == nil then
    modifier_passive_pentium_lua = class({})
end

function modifier_passive_pentium_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_pentium_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_pentium_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT 
    }
    return funcs
end

function modifier_passive_pentium_lua:GetModifierMoveSpeedBonus_Constant()
    local speed = self:GetAbility():GetSpecialValueFor("speed") + GameRules:GetCustomGameDifficulty()*10
    return speed
end