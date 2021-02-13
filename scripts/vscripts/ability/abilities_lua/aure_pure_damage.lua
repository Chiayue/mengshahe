aure_pure_damage = class({})

function aure_pure_damage:GetIntrinsicModifierName()
	return "modifier_aure_pure_damage"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_pure_damage","ability/abilities_lua/aure_pure_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_pure_damage = class({})

function modifier_aure_pure_damage:IsHidden()
    return true
end

function modifier_aure_pure_damage:IsAura()
    return true
end

function modifier_aure_pure_damage:GetAuraRadius()
    return 1200
end

function modifier_aure_pure_damage:GetModifierAura()
    return "modifier_aure_pure_damage_buff"
end

function modifier_aure_pure_damage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_pure_damage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_pure_damage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_pure_damage_buff","ability/abilities_lua/aure_pure_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_pure_damage_buff = class({})

function modifier_aure_pure_damage_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_aure_pure_damage_buff:OnAttackLanded(event)
    if event.attacker == self:GetParent() then
        ApplyDamage({
            victim = event.target,
			attacker = event.attacker,
			damage = self.pure,
			damage_type = DAMAGE_TYPE_PURE,
        })
    end
end

function modifier_aure_pure_damage_buff:OnCreated(kv)
    if IsServer() then
        self.pure = 0
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self.pure = 5
        else
            self.pure = 50
        end
    end
end