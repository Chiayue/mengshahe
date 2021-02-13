aure_drain_mana = class({})

function aure_drain_mana:GetIntrinsicModifierName()
	return "modifier_aure_drain_mana"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_drain_mana","ability/abilities_lua/aure_drain_mana" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_drain_mana = class({})

function modifier_aure_drain_mana:IsHidden()
    return true
end

function modifier_aure_drain_mana:IsAura()
    return true
end

function modifier_aure_drain_mana:GetAuraRadius()
    return 1200
end

function modifier_aure_drain_mana:GetModifierAura()
    return "modifier_aure_drain_mana_debuff"
end

function modifier_aure_drain_mana:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aure_drain_mana:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_aure_drain_mana:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_drain_mana_debuff","ability/abilities_lua/aure_drain_mana" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_drain_mana_debuff = class({})

function modifier_aure_drain_mana_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_aure_drain_mana_debuff:OnCreated( kv )
    if IsServer() then
        local parent = self:GetParent()
        local caster = self:GetCaster()
        self.index = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(self.index, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetOrigin(), true)        
		ParticleManager:SetParticleControlEnt(self.index, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)        
		ParticleManager:SetParticleControlForward(self.index, 2, (parent:GetOrigin() - caster:GetOrigin()):Normalized())
        self.mana = 0
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self.mana = 3
        else
            self.mana = 6
        end
        self:StartIntervalThink(1)
    end
end

function modifier_aure_drain_mana_debuff:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.index, true)
        ParticleManager:ReleaseParticleIndex(self.index)
    end
end

function modifier_aure_drain_mana_debuff:OnIntervalThink()
    self:GetParent():ReduceMana(self.mana)
    self:GetCaster():GiveMana(self.mana)
end

