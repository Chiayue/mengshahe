passive_mana_burn_lua = class({})

LinkLuaModifier("modifier_passive_mana_burn_lua","ability/abilities_lua/passive_mana_burn_lua",LUA_MODIFIER_MOTION_NONE )

function passive_mana_burn_lua:GetIntrinsicModifierName()
	return "modifier_passive_mana_burn_lua"
end

if modifier_passive_mana_burn_lua == nil then
    modifier_passive_mana_burn_lua = class({})
end

function modifier_passive_mana_burn_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_mana_burn_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_mana_burn_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_mana_burn_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_mana_burn_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED ,
    }
    return funcs
end

function modifier_passive_mana_burn_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster	= self:GetCaster()
end

function modifier_passive_mana_burn_lua:OnAttacked(params)
    if params.attacker == self.caster then
        local random = math.random(1,100)
        if random <= 40 then
            local target = params.target
            target:ReduceMana(self:GetAbility():GetSpecialValueFor("burn") + GameRules:GetCustomGameDifficulty()*0.5)
        end
    end 
end
