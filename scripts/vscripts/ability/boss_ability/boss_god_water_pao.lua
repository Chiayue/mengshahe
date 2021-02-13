LinkLuaModifier("modifier_boss_god_water_pao", "ability/boss_ability/boss_god_water_pao", LUA_MODIFIER_MOTION_NONE)

boss_god_water_pao = class({})

function boss_god_water_pao:OnSpellStart()
    self.caster = self:GetCaster()
    self.target = self:GetCursorTarget()
    local target_position = self.target:GetOrigin()
    local index = ParticleManager:CreateParticle(
        "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", 
        PATTACH_WORLDORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(index, 0, target_position)
    ParticleManager:ReleaseParticleIndex(index)
    self.caster.delay1 = 0
    self.caster:SetContextThink(DoUniqueString("delay1"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.delay1 = self.caster.delay1 + 0.1
        if self.caster.delay1 >= 1.3 then
            local index = ParticleManager:CreateParticle(
                "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", 
                PATTACH_WORLDORIGIN, 
                nil
            )
            ParticleManager:SetParticleControl(index, 0, target_position)
            ParticleManager:ReleaseParticleIndex(index)
            local enemies = FindUnitsInRadius(
                self.caster:GetTeamNumber(), 
                target_position, 
                nil, 
                320, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                DOTA_DAMAGE_FLAG_NONE, 
                FIND_ANY_ORDER, 
                false
            )
            for _, enemy in pairs(enemies) do
                if enemy:FindModifierByName("modifier_boss_god_water_pao") == nil then
                    enemy:AddNewModifier(self.caster, self, "modifier_boss_god_water_pao", nil)
                end
            end
            return nil
        end
        return 0.1
    end, 0)
end

-----------------------------------------------------------------------------------

modifier_boss_god_water_pao = class({})

function modifier_boss_god_water_pao:IsHidden()
	return false
end

function modifier_boss_god_water_pao:IsPurgable()
    return false
end

function modifier_boss_god_water_pao:RemoveOnDeath()
	return true
end

function modifier_boss_god_water_pao:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end

function modifier_boss_god_water_pao:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end

function modifier_boss_god_water_pao:GetVisualZDelta()
    return 300
end

function modifier_boss_god_water_pao:GetModifierAvoidDamage(params)
    self.damage = self.damage - params.damage
    if self.damage <= 0 then
        self.parent:RemoveModifierByName(self:GetClass())
    end
    return params.damage
end

function modifier_boss_god_water_pao:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}
end

function modifier_boss_god_water_pao:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        local parent_position = self.parent:GetOrigin()
        self.index = ParticleManager:CreateParticle(
            "particles/diy_particles/paopao.vpcf", 
            PATTACH_POINT_FOLLOW, 
            self.parent
        )
        ParticleManager:SetParticleControlEnt(self.index, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent_position, true)
        ParticleManager:SetParticleControlEnt(self.index, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent_position, true)
        self.damage = self.parent:GetMaxHealth()
    end
end

function modifier_boss_god_water_pao:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.index, false)
        ParticleManager:ReleaseParticleIndex(self.index)
    end
end