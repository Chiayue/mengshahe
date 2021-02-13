passive_lineage_lua = class({})

LinkLuaModifier("modifier_passive_lineage_lua","ability/abilities_lua/passive_lineage_lua",LUA_MODIFIER_MOTION_NONE )

function passive_lineage_lua:GetIntrinsicModifierName()
	return "modifier_passive_lineage_lua"
end

if modifier_passive_lineage_lua == nil then
    modifier_passive_lineage_lua = class({})
end

function modifier_passive_lineage_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_lineage_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_lineage_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_lineage_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_lineage_lua:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifier_passive_lineage_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster()
    self.MaxHealth = self.caster:GetMaxHealth()
    self:StartIntervalThink( 1 )
end

function modifier_passive_lineage_lua:OnIntervalThink()
    self.caster:Heal(self.MaxHealth*self:GetAbility():GetSpecialValueFor("proportion") + GameRules:GetCustomGameDifficulty()*0.01, self)
end