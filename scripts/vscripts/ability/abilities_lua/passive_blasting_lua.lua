passive_blasting_lua = class({})

LinkLuaModifier("modifier_passive_blasting_lua","ability/abilities_lua/passive_blasting_lua",LUA_MODIFIER_MOTION_NONE )

function passive_blasting_lua:GetIntrinsicModifierName()
	return "modifier_passive_blasting_lua"
end

if modifier_passive_blasting_lua == nil then
    modifier_passive_blasting_lua = class({})
end

function modifier_passive_blasting_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_blasting_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_blasting_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_blasting_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_blasting_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED ,
    }
    return funcs
end

function modifier_passive_blasting_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster	= self:GetCaster()
end

function modifier_passive_blasting_lua:OnAttackLanded(params)
    if params.attacker == self.caster then
        local coefficient = self:GetAbility():GetSpecialValueFor("coefficient") + GameRules:GetCustomGameDifficulty()*2
        local armor = params.target:GetPhysicalArmorValue(false)
        local damagetable = {
            victim = params.target,                                 
            attacker = self.caster,								 
            damage = coefficient*armor,								 
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage(damagetable)
    end 
end
