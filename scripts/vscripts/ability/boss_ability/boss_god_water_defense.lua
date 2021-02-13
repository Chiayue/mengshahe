LinkLuaModifier("modifier_boss_god_water_defense", "ability/boss_ability/boss_god_water_defense", LUA_MODIFIER_MOTION_NONE)

boss_god_water_defense = class({})

function boss_god_water_defense:GetIntrinsicModifierName()
	return "modifier_boss_god_water_defense"
end

--------------------------------------------------------------------------------------------------

modifier_boss_god_water_defense = class({})

function modifier_boss_god_water_defense:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_boss_god_water_defense:GetModifierIncomingDamage_Percentage(params)
    if self.shift == 1 then
        if params.damage_type == DAMAGE_TYPE_PHYSICAL then
            return -90
        end
        if params.damage_type == DAMAGE_TYPE_MAGICAL then
            return 200
        end
    end
    if self.shift == -1 then
        if params.damage_type == DAMAGE_TYPE_PHYSICAL then
            return 200
        end
        if params.damage_type == DAMAGE_TYPE_MAGICAL then
            return -90
        end
    end
    return 0
end

function modifier_boss_god_water_defense:IsHidden()
    return true
end

function modifier_boss_god_water_defense:IsPurgable()
    return false
end

function modifier_boss_god_water_defense:RemoveOnDeath()
    return true
end

function modifier_boss_god_water_defense:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
        self.shift = 0
        self:StartIntervalThink(30)
    end
end

function modifier_boss_god_water_defense:OnIntervalThink()
    if IsServer() then
        self.shift = self.shift * -1
        if self.shift == 0 then
            self.shift = 1
        end
        if self.shift == 1 then
            if self.index then
                ParticleManager:DestroyParticle(self.index, false)
                ParticleManager:ReleaseParticleIndex(self.index)
            end
            self.index = ParticleManager:CreateParticle(
                "particles/diy_particles/shui_skill1.vpcf", 
                PATTACH_POINT_FOLLOW, 
                self.parent
            )
            ParticleManager:SetParticleControl(self.index, 0, self.parent:GetOrigin())
        end
        if self.shift == -1 then
            if self.index then
                ParticleManager:DestroyParticle(self.index, false)
                ParticleManager:ReleaseParticleIndex(self.index)
            end
            self.index = ParticleManager:CreateParticle(
                "particles/diy_particles/shui_skill2.vpcf", 
                PATTACH_POINT_FOLLOW, 
                self.parent
            )
            ParticleManager:SetParticleControl(self.index, 0, self.parent:GetOrigin())
        end
    end
end