passive_rage_lua = class({})

LinkLuaModifier("modifier_passive_rage_lua","ability/abilities_lua/passive_rage_lua",LUA_MODIFIER_MOTION_NONE )

function passive_rage_lua:GetIntrinsicModifierName()
	return "modifier_passive_rage_lua"
end

if modifier_passive_rage_lua == nil then
    modifier_passive_rage_lua = class({})
end

function modifier_passive_rage_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_rage_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_rage_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_rage_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_rage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_passive_rage_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster()
    self.damage = 0
    self.initial_damage = self:GetCaster():GetBaseDamageMax()
end

function modifier_passive_rage_lua:OnAttacked(params)
    if params.attacker == self.caster then
        local proportion = 1-self:GetCaster():GetHealth()/self:GetCaster():GetMaxHealth()
        local bonus = self:GetAbility():GetSpecialValueFor("bonus") + GameRules:GetCustomGameDifficulty()*0.5
        self.bonus_damage = math.floor(self.initial_damage * proportion * bonus)
    end
end

-- function modifier_passive_rage_lua:GetModifierPreAttack_BonusDamage(params)
--     return self.damage
-- end

function modifier_passive_rage_lua:GetModifierBaseAttack_BonusDamage(params)
    return self.bonus_damage
end