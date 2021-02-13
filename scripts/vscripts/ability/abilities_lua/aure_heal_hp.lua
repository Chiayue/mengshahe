aure_heal_hp = class({})

function aure_heal_hp:GetIntrinsicModifierName()
	return "modifier_aure_heal_hp"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_heal_hp","ability/abilities_lua/aure_heal_hp" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_heal_hp = class({})

function modifier_aure_heal_hp:IsHidden()
    return true
end

function modifier_aure_heal_hp:IsAura()
    return true
end

function modifier_aure_heal_hp:GetAuraRadius()
    return 1200
end

function modifier_aure_heal_hp:GetModifierAura()
    return "modifier_aure_heal_hp_buff"
end

function modifier_aure_heal_hp:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_heal_hp:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_heal_hp:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_heal_hp_buff","ability/abilities_lua/aure_heal_hp" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_heal_hp_buff = class({})

function modifier_aure_heal_hp_buff:OnCreated(kv)
    if IsServer() then
        self.hp = 0
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self.hp = 100
        else
            self.hp = 1000
        end
        self:StartIntervalThink(1)
    end
end

function modifier_aure_heal_hp_buff:OnIntervalThink()
    local parent = self:GetParent()
    parent:Heal(self.hp, self:GetAbility())
end