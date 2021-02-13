LinkLuaModifier("modifier_passive_more_sleep", "ability/abilities_lua/passive_more_sleep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_more_sleep_state", "ability/abilities_lua/passive_more_sleep.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_more_sleep = class({})

function passive_more_sleep:GetIntrinsicModifierName()
	return "modifier_passive_more_sleep"
end

-------------------------------------------------------------

modifier_passive_more_sleep = class({})

function modifier_passive_more_sleep:CheckState()
	return {}
end

function modifier_passive_more_sleep:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_passive_more_sleep:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_passive_more_sleep:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_passive_more_sleep:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_passive_more_sleep:IsHidden()
    return true
end

function modifier_passive_more_sleep:IsPurgable()
    return false
end
 
function modifier_passive_more_sleep:RemoveOnDeath()
    return false
end

function modifier_passive_more_sleep:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        self.parent = self:GetParent()
        self:StartIntervalThink(5)
    end
end

function modifier_passive_more_sleep:OnIntervalThink()
    if IsServer() then
        if self.parent:IsAlive() then
            if RollPercentage(10) then
                if not self.parent:FindModifierByName("modifier_passive_more_sleep_state") then
                    self:StartIntervalThink(-1)
                    self.parent:AddNewModifier(self.parent, self.ability, "modifier_passive_more_sleep_state", {duration = RandomInt(3, 12)})
                end
            end 
        end
    end
end

-------------------------------------------------------------

modifier_passive_more_sleep_state = class({})

function modifier_passive_more_sleep_state:CheckState()
	return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_passive_more_sleep_state:DeclareFunctions()
	return {}
end

function modifier_passive_more_sleep_state:IsHidden()
    return true
end

function modifier_passive_more_sleep_state:IsPurgable()
    return false
end
 
function modifier_passive_more_sleep_state:RemoveOnDeath()
    return true
end

function modifier_passive_more_sleep_state:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.mdf = self.parent:FindModifierByName("modifier_passive_more_sleep")
        local position = self.parent:GetOrigin()
        self.index = ParticleManager:CreateParticle("particles/generic_gameplay/generic_sleep.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(self.index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", position, true)
        self.parent:StartGesture(ACT_DOTA_IDLE)
        self:StartIntervalThink(1)
    end
end

function modifier_passive_more_sleep_state:OnIntervalThink()
    if IsServer() then
        self.mdf:SetStackCount(self.mdf:GetStackCount() + 3)
        self.parent:Heal(self.parent:GetMaxHealth() * 0.15, self.parent)
    end
end

function modifier_passive_more_sleep_state:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.index, true)
        ParticleManager:ReleaseParticleIndex(self.index)
        self.parent:RemoveGesture(ACT_DOTA_IDLE)
        self.mdf:StartIntervalThink(5)
    end
end