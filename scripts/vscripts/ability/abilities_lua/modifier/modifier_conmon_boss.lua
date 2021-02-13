modifier_conmon_boss = class({})

function modifier_conmon_boss:IsHidden()
	return true
end

function modifier_conmon_boss:IsPurgable()
    return false
end

function modifier_conmon_boss:RemoveOnDeath()
    return true
end

function modifier_conmon_boss:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent() 
    end
end

function modifier_conmon_boss:DeclareFunctions()
	return {
	}
end

function modifier_conmon_boss:CheckState()
	return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

-- function modifier_conmon_boss:GetStatusEffectName()
--     return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
-- end