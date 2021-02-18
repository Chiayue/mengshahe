if modifier_common_tp == nil then
	modifier_common_tp = class({})
end

function modifier_common_tp:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
	}
end

function modifier_common_tp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_common_tp:GetOverrideAnimation(params)
	return ACT_DOTA_IDLE
end

function modifier_common_tp:IsHidden()
	return true
end

function modifier_common_tp:IsPurgable()
    return false
end

function modifier_common_tp:RemoveOnDeath()
	return true
end

function modifier_common_tp:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        local nFXIndex1 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_lvl3.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(nFXIndex1, 0, parent:GetOrigin())
        self:AddParticle(nFXIndex1, false, false, 1, false, false)
        if parent:GetUnitName() == "task_box" then
            local nFXIndex2 = ParticleManager:CreateParticle("particles/diy_particles/run.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            self:AddParticle(nFXIndex2, false, false, 2, false, false) 
        end
        self:StartIntervalThink(3)
    end
end

function modifier_common_tp:OnIntervalThink()
    UTIL_Remove(self:GetParent())
end