--挑战boss5技能1
initiative_boss_call_5_one_lua = class({})
LinkLuaModifier("modifier_boss_call_5_one_buff","ability/abilities_lua/initiative_boss_call_5_one_lua",LUA_MODIFIER_MOTION_NONE )
function initiative_boss_call_5_one_lua:OnSpellStart()
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    caster:AddNewModifier(caster, self, "modifier_boss_call_5_one_buff", {duration = 5})
	caster:EmitSound("Imba.Hero_Dazzle.Weave") 
end
modifier_boss_call_5_one_buff = class({})
function modifier_boss_call_5_one_buff:IsDebuff()			return false end
function modifier_boss_call_5_one_buff:IsHidden() 			return true end
function modifier_boss_call_5_one_buff:IsPurgable() 		return true end
function modifier_boss_call_5_one_buff:IsPurgeException() 	return true end
function modifier_boss_call_5_one_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
    return funcs
end
function modifier_boss_call_5_one_buff:GetModifierBaseAttack_BonusDamage(params)
    return 30
end
function modifier_boss_call_5_one_buff:GetModifierModelScale()
    return 200
end