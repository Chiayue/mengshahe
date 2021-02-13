modifier_common_tp = class({})

function modifier_common_tp:OnCreated(kv)
    self.parent = self:GetParent()
    self.parent:AddNewModifier(nil, nil, "modifier_invulnerable", nil)
    self.nFXIndex = ParticleManager:CreateParticle(
        "particles/econ/events/fall_major_2016/teleport_start_fm06_lvl3.vpcf", 
        PATTACH_WORLDORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self.parent:GetOrigin())
    self:StartIntervalThink(2)
end

function modifier_common_tp:OnIntervalThink()
    ParticleManager:DestroyParticle(self.nFXIndex, false)
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)
    -- for key, value in pairs(self.parent:FindAllModifiers()) do
    --     -- self.parent:RemoveModifierByName(name)
    --     print("=======================================")
    --     DeepPrintTable(value)
    --     print("=======================================")
    -- end
    UTIL_Remove(self.parent)
    self:StartIntervalThink(-1)
end

function modifier_common_tp:IsHidden()
	return false
end

function modifier_common_tp:IsPurgable()
    return false
end

function modifier_common_tp:RemoveOnDeath()
	return true
end

function modifier_common_tp:GetEffectName()
	return "particles/econ/events/fall_major_2016/teleport_start_fm06_lvl3.vpcf"
end

function modifier_common_tp:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_common_tp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_common_tp:GetOverrideAnimation(params)
	return ACT_DOTA_IDLE
end

function modifier_common_tp:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
	}
end