passive_berserker_lua = class({})
passive_berserker_lua_d = passive_berserker_lua
passive_berserker_lua_c = passive_berserker_lua
passive_berserker_lua_b = passive_berserker_lua
passive_berserker_lua_a = passive_berserker_lua
passive_berserker_lua_s = passive_berserker_lua

LinkLuaModifier("modifier_passive_berserker_lua_d","ability/abilities_lua/passive_berserker_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_berserker_lua_c","ability/abilities_lua/passive_berserker_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_berserker_lua_b","ability/abilities_lua/passive_berserker_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_berserker_lua_a","ability/abilities_lua/passive_berserker_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_berserker_lua_s","ability/abilities_lua/passive_berserker_lua",LUA_MODIFIER_MOTION_NONE )

function passive_berserker_lua:GetIntrinsicModifierName()
    if self:GetAbilityName() == "passive_berserker_lua_d" then
        return "modifier_passive_berserker_lua_d"
    elseif self:GetAbilityName() == "passive_berserker_lua_c" then
        return "modifier_passive_berserker_lua_c"
    elseif self:GetAbilityName() == "passive_berserker_lua_b" then
        return "modifier_passive_berserker_lua_b"
    elseif self:GetAbilityName() == "passive_berserker_lua_a" then
        return "modifier_passive_berserker_lua_a"
    elseif self:GetAbilityName() == "passive_berserker_lua_s" then
        return "modifier_passive_berserker_lua_s"
    end 
end

if modifier_passive_berserker_lua == nil then
    modifier_passive_berserker_lua = class({})
    modifier_passive_berserker_lua_d = modifier_passive_berserker_lua
    modifier_passive_berserker_lua_c = modifier_passive_berserker_lua
    modifier_passive_berserker_lua_b = modifier_passive_berserker_lua
    modifier_passive_berserker_lua_a = modifier_passive_berserker_lua
    modifier_passive_berserker_lua_s = modifier_passive_berserker_lua
end

function modifier_passive_berserker_lua:IsHidden()
    return  true
end

function modifier_passive_berserker_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_berserker_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end
function modifier_passive_berserker_lua:OnCreated(params)
    
    if IsServer( ) then
        self:StartIntervalThink(0.5)
        self.damage = 0
    end
end

function modifier_passive_berserker_lua:OnIntervalThink(params)
    if IsServer() then 
        self.damage = math.floor((1-self:GetCaster():GetHealth()/self:GetCaster():GetMaxHealth())*100)*self:GetAbility():GetSpecialValueFor("damage")
    end 
end

-- function modifier_passive_berserker_lua:GetModifierPreAttack_BonusDamage(params)
--     return self.damage    
-- end

function modifier_passive_berserker_lua:GetModifierBaseAttack_BonusDamage(params)
    return self.damage    
end