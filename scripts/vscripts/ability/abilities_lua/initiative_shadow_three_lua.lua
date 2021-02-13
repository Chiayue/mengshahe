initiative_shadow_three_lua = class({})

LinkLuaModifier("modifier_initiative_shadow_three_lua","ability/abilities_lua/initiative_shadow_three_lua",LUA_MODIFIER_MOTION_NONE)
--开始施法
function initiative_shadow_three_lua:OnSpellStart()
    if not IsServer() then
        return
    end

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local caster_postion = caster:GetOrigin()
    local target_postion = target:GetOrigin()
    local damage = self:GetSpecialValueFor("damage")

    caster:StartGesture(ACT_DOTA_CAST_ABILITY_6)
    local damagetable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    Timers:CreateTimer(0.5, function()
        if caster:IsAlive() and target:IsAlive() then
            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_sweep_up_right.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt( index, 0, nil, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack1", caster_postion, true );
            ParticleManager:SetParticleControlEnt( index, 1, nil, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack2", caster_postion, true );
            ParticleManager:SetParticleControlEnt( index, 2, nil, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack3", caster_postion, true ); 
            caster:EmitSound("hero.attack.npc_dota_hero_axe")
            target:AddNewModifier(target, self, "modifier_initiative_shadow_three_lua", {duration = 10})
            ApplyDamage(damagetable)
        end
    end)
   
end

modifier_initiative_shadow_three_lua = class({})

function modifier_initiative_shadow_three_lua:IsDebuff()
	return true 
end
function modifier_initiative_shadow_three_lua:IsHidden()
	return false
end
function modifier_initiative_shadow_three_lua:IsPurgable()
	return true
end
function modifier_initiative_shadow_three_lua:IsPurgeException()
	return true
end
function modifier_initiative_shadow_three_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    self:StartIntervalThink(1)
end
function modifier_initiative_shadow_three_lua:OnIntervalThink()
    local damagetable = {
        victim = self:GetParent(),
        attacker = self:GetAbility():GetCaster(),
        damage = self:GetAbility():GetSpecialValueFor("debuff_damage"),
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(damagetable)
end
function modifier_initiative_shadow_three_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end
