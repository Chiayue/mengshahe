passive_jinzhanfashi_lua = class({})

LinkLuaModifier("modifier_passive_jinzhanfashi_lua","ability/abilities_lua/passive_jinzhanfashi_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_jinzhanfashi_debuff_lua","ability/abilities_lua/passive_jinzhanfashi_lua",LUA_MODIFIER_MOTION_NONE )

function passive_jinzhanfashi_lua:GetIntrinsicModifierName()
	return "modifier_passive_jinzhanfashi_lua"
end

if modifier_passive_jinzhanfashi_lua == nil then
    modifier_passive_jinzhanfashi_lua = class({})
end

function modifier_passive_jinzhanfashi_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_jinzhanfashi_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_jinzhanfashi_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED ,
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL ,
    }
    return funcs
end

function modifier_passive_jinzhanfashi_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster	= self:GetCaster()
end

function modifier_passive_jinzhanfashi_lua:GetOverrideAttackMagical()
    return 1
end

function modifier_passive_jinzhanfashi_lua:OnAttacked(params)
    
    if params.attacker == self.caster then
        local damage = {
			victim = params.target,
			attacker = params.attacker,
			damage = params.original_damage,	
			damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage( damage )
        params.target:AddNewModifier(params.target, self:GetAbility(), "modifier_passive_jinzhanfashi_debuff_lua", {duration = 2})
    end 
end

--debuff实际效果
if modifier_passive_jinzhanfashi_debuff_lua == nil then
    modifier_passive_jinzhanfashi_debuff_lua = class({})
end

function modifier_passive_jinzhanfashi_debuff_lua:IsHidden()
    return false -- 不隐藏
end

function modifier_passive_jinzhanfashi_debuff_lua:IsDebuff()
    return true -- Debuff
end

function modifier_passive_jinzhanfashi_debuff_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_jinzhanfashi_debuff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
    }
    return funcs
end

function modifier_passive_jinzhanfashi_debuff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_jinzhanfashi_debuff_lua:GetModifierMagicalResistanceDirectModification()
-- 每个难度提升会使被攻击单位减10%魔抗
    local resistance = GameRules:GetCustomGameDifficulty()*10*-1
    return resistance
end
