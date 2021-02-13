initiative_meidusha_two_lua = class({})

LinkLuaModifier("modifier_initiative_meidusha_two_lua","ability/abilities_lua/initiative_meidusha_two_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_meidusha_two_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    
    local caster = self:GetCaster()
    local cPos = caster:GetOrigin()
    -- caster:StartGesture(ACT_DOTA_DISABLED)
    caster:EmitSound("hero.attack.npc_dota_hero_clinkz")
    local index = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_venomancer_poison_nova.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( index, 0, nil, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_head",  caster:GetOrigin(), true );
    ParticleManager:SetParticleControlForward(index, 1, (caster:GetOrigin() - caster:GetOrigin()):Normalized())
	local enemies = FindUnitsInRadius(caster:GetTeam(), cPos, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
    for i=1,#enemies do
        enemies[i]:AddNewModifier(enemies[i], self, "modifier_initiative_meidusha_two_lua", { duration = 4 })
    end 
end

modifier_initiative_meidusha_two_lua = class({})

function modifier_initiative_meidusha_two_lua:IsDebuff()
	return true 
end
function modifier_initiative_meidusha_two_lua:IsHidden()
	return false
end
function modifier_initiative_meidusha_two_lua:IsPurgable()
	return true
end
function modifier_initiative_meidusha_two_lua:IsPurgeException()
	return true
end
function modifier_initiative_meidusha_two_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    self:StartIntervalThink(1)
end
function modifier_initiative_meidusha_two_lua:OnIntervalThink()
    local damagetable = {
        victim = self:GetParent(),
        attacker = self:GetAbility():GetCaster(),
        damage = self:GetAbility():GetSpecialValueFor("debuff_damage"),
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(damagetable)
end
function modifier_initiative_meidusha_two_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end