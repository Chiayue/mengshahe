passive_fighting_lua = class({})

LinkLuaModifier("modifier_passive_fighting_lua","ability/abilities_lua/passive_fighting_lua",LUA_MODIFIER_MOTION_NONE )

function passive_fighting_lua:GetIntrinsicModifierName()
	return "modifier_passive_fighting_lua"
end

modifier_passive_fighting_lua = class({})

function modifier_passive_fighting_lua:IsHidden()
    return false -- 不隐藏
end

function modifier_passive_fighting_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_fighting_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_fighting_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_fighting_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,                                
    }
    return funcs
end

function modifier_passive_fighting_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.target = nil
    self.attack_rate_ab = 0
end

function modifier_passive_fighting_lua:OnAttackStart(params)
    if not IsServer( ) then
        return
    end

    if params.attacker ~= self:GetParent() then
       return
    end

    self.caster = self:GetCaster()
    self.layer = self:GetAbility():GetSpecialValueFor("layer")
    self.attack_rate = self:GetAbility():GetSpecialValueFor("attack_rate") + GameRules:GetCustomGameDifficulty()*5
    self.num = self.caster:GetModifierStackCount("modifier_passive_fighting_lua",nil)

    if self.target == self.caster:GetAttackTarget() then
        if self.num < self.layer then
            self:IncrementStackCount()
            self.attack_rate_ab = self.attack_rate*(self.num + 1)
        end
    else
        self.target = self.caster:GetAttackTarget()
        self.caster:SetModifierStackCount("modifier_passive_fighting_lua",self.caster,0)
        self.attack_rate_ab = 0   
    end
end

function modifier_passive_fighting_lua:GetModifierAttackSpeedBonus_Constant()
	return self.attack_rate_ab
end