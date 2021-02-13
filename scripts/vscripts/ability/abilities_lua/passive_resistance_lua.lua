passive_resistance_lua = class({})

LinkLuaModifier("modifier_passive_resistance_lua","ability/abilities_lua/passive_resistance_lua",LUA_MODIFIER_MOTION_NONE )

function passive_resistance_lua:GetIntrinsicModifierName()
	return "modifier_passive_resistance_lua"
end

if modifier_passive_resistance_lua == nil then
    modifier_passive_resistance_lua = class({})
end

function modifier_passive_resistance_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_resistance_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_resistance_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_resistance_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_resistance_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
    }
    return funcs
end

function modifier_passive_resistance_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local resistance = 36 + GameRules:GetCustomGameDifficulty()*5
    self:GetCaster():SetBaseMagicalResistanceValue(resistance)
end

-- function modifier_passive_resistance_lua:GetModifierMagicalResistanceDirectModification(params)
--     return 44
-- end