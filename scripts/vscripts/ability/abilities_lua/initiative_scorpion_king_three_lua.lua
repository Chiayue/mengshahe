--蝎子王技能3
LinkLuaModifier("modifier_scorpion_king_three_lua","ability/abilities_lua/initiative_scorpion_king_three_lua",LUA_MODIFIER_MOTION_NONE)
initiative_scorpion_king_three_lua = class({})

function initiative_scorpion_king_three_lua:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_scorpion_king_three_lua", {duration = 10})
    caster:EmitSound("game.shixue")
end

if modifier_scorpion_king_three_lua == nil then
	modifier_scorpion_king_three_lua = class({})
end


function modifier_scorpion_king_three_lua:IsHidden()
    return false
end

function modifier_scorpion_king_three_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_scorpion_king_three_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_scorpion_king_three_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_scorpion_king_three_lua:GetModifierDamageOutgoing_Percentage()
	return 50
end
function modifier_scorpion_king_three_lua:GetModifierPhysicalArmorBonus()
	return 20
end
function modifier_scorpion_king_three_lua:GetEffectName()
	return "particles/econ/items/phantom_assassin/ti9_cache_pa_gothic_hunter_belt/ti9_cache_pa_gothic_belt_ambient.vpcf"
end
function modifier_scorpion_king_three_lua:StatusEffectPriority()
	return 15
end
function modifier_scorpion_king_three_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_scorpion_king_three_lua:OnCreated(params)
    if not IsServer( ) then
        return
	end
end
function modifier_scorpion_king_three_lua:OnDestroy()
	if not IsServer( ) then
        return
    end
end
