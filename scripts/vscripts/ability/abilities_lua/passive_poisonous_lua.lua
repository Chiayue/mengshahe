passive_poisonous_lua = class({})

LinkLuaModifier("modifier_passive_poisonous_lua","ability/abilities_lua/passive_poisonous_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_poisonous_effect_debuff_lua","ability/abilities_lua/passive_poisonous_lua",LUA_MODIFIER_MOTION_NONE )

function passive_poisonous_lua:GetIntrinsicModifierName()
    return "modifier_passive_poisonous_lua"
end

if modifier_passive_poisonous_lua == nil then
    modifier_passive_poisonous_lua = class({})
end

function modifier_passive_poisonous_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_poisonous_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_poisonous_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED ,
    }
    return funcs
end

function modifier_passive_poisonous_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster	= self:GetCaster()
end

function modifier_passive_poisonous_lua:OnAttacked(params)
    -- if params.target.count == nil  then
    --     params.target.count = 0
    -- end
    if params.attacker == self.caster then
        -- if params.target.count < 6 then
            params.target:AddNewModifier(params.target, self:GetAbility(), "modifier_passive_poisonous_effect_debuff_lua", { duration = 7 ,target = 1})
            self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_passive_poisonous_effect_debuff_lua", { duration = 7 })
        -- end
    end 
end

--debuff实际效果
if modifier_passive_poisonous_effect_debuff_lua == nil then
    modifier_passive_poisonous_effect_debuff_lua = class({})
end

function modifier_passive_poisonous_effect_debuff_lua:IsHidden()
    return false -- 不隐藏
end

function modifier_passive_poisonous_effect_debuff_lua:IsDebuff()
    return true -- Debuff
end

function modifier_passive_poisonous_effect_debuff_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_poisonous_effect_debuff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT ,
    }
    return funcs
end

function modifier_passive_poisonous_effect_debuff_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_passive_poisonous_effect_debuff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- if  params.target == 1  then
    --     self:GetParent().count = self:GetParent().count + 1
    -- end
    self.attack_rate = self:GetCaster():GetDisplayAttackSpeed() * self:GetAbility():GetSpecialValueFor( "attack_rate" ) / 100 *-1
end

function modifier_passive_poisonous_effect_debuff_lua:GetModifierAttackSpeedBonus_Constant()
    return self.attack_rate
end

-- function modifier_passive_poisonous_effect_debuff_lua:DestroyOnExpire()
-- 	return true
-- end
-- function modifier_passive_poisonous_effect_debuff_lua:OnDestroy()
--     if not IsServer( ) then
--         return
--     end
--     if  self:GetParent().count ~= nil  then
--         if self:GetParent().count > 0 then
--             self:GetParent().count = self:GetParent().count - 1
--         else
--             self:GetParent().count = 0
--         end
--     end
-- end