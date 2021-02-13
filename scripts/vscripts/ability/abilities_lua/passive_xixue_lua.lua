passive_xixue_lua = class({})

LinkLuaModifier("modifier_passive_xixue_lua","ability/abilities_lua/passive_xixue_lua",LUA_MODIFIER_MOTION_NONE )

function passive_xixue_lua:GetIntrinsicModifierName()
	return "modifier_passive_xixue_lua"
end

if modifier_passive_xixue_lua == nil then
    modifier_passive_xixue_lua = class({})
end

function modifier_passive_xixue_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_xixue_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_xixue_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_xixue_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_xixue_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED ,
    }
    return funcs
end

function modifier_passive_xixue_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster	= self:GetCaster()
end

function modifier_passive_xixue_lua:OnAttacked(params)
    if params.attacker == self.caster then
        local bonus = self:GetAbility():GetSpecialValueFor("proportion") + GameRules:GetCustomGameDifficulty()*0.1
        local reply = params.damage * bonus
        self.caster:Heal(reply, self)
    end 
end
