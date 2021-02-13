modifier_active_big_jump_bianshen_lua = class({})

function modifier_active_big_jump_bianshen_lua:OnCreated(kv)
    if not IsServer() then
        return
    end

    self.value_scale = self:GetAbility():GetSpecialValueFor("scale")
    self.hero = self:GetParent()
    self.scale = self.hero:GetModelScale()
    self.color = self.hero:GetRenderColor()

    self.hero:SetModelScale(self.scale * 2)
    self.hero:SetRenderColor(255, 215, 0)

    self.attack_bonus = self.value_scale * 100
    self.life_bonus = self.hero:GetMaxHealth() * (self.value_scale - 1)

    local nFXIndex = ParticleManager:CreateParticle(
        "particles/items_fx/black_king_bar_avatar.vpcf",
        PATTACH_ROOTBONE_FOLLOW,
        self.hero
    )
    self:AddParticle(nFXIndex, false, false, 10, false, false)

    self:StartIntervalThink(0.2)
end

function modifier_active_big_jump_bianshen_lua:OnDestroy(kv)
    if not IsServer() then
        return
    end
    self.hero:SetModelScale(self.scale)
    self.hero:SetRenderColor(self.color.x, self.color.y, self.color.z)
end

function modifier_active_big_jump_bianshen_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        -- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        -- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
    return funcs
end

function modifier_active_big_jump_bianshen_lua:GetModifierBonusStats_Strength()
    return self.hero:GetBaseStrength() * (self.value_scale - 1)
end

function modifier_active_big_jump_bianshen_lua:GetModifierBonusStats_Agility()
    return self.hero:GetBaseAgility() * (self.value_scale - 1)
end

function modifier_active_big_jump_bianshen_lua:GetModifierBonusStats_Intellect()
    return self.hero:GetBaseIntellect() * (self.value_scale - 1)
end

function modifier_active_big_jump_bianshen_lua:GetModifierDamageOutgoing_Percentage()
    if self:GetAbility():GetAbilityName() == "active_big_jump_lua_b" then
        return 200
    elseif self:GetAbility():GetAbilityName() == "active_big_jump_lua_a" then
        return 300
    elseif self:GetAbility():GetAbilityName() == "active_big_jump_lua_s" then
        return 500
    end
end

function modifier_active_big_jump_bianshen_lua:GetModifierExtraHealthBonus()
    return self.life_bonus
end

function modifier_active_big_jump_bianshen_lua:OnIntervalThink()
    self.hero:Heal(self.life_bonus, self:GetAbility())
    self:StartIntervalThink(-1)
end