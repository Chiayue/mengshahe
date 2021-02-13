initiative_munaiyi_two_lua = class({})

LinkLuaModifier("modifier_initiative_munaiyi_two_lua","ability/abilities_lua/initiative_munaiyi_two_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_munaiyi_two_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local cPos = caster:GetOrigin()
    local duration = self:GetSpecialValueFor("duration")
    local enemies = FindUnitsInRadius(caster:GetTeam(), cPos, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)            
      
    caster:StartGesture(ACT_DOTA_SPAWN)
    caster:EmitSound("shiwang.paoxiao")
    for i=1, #enemies do
        enemies[i]:AddNewModifier(enemies[i], self, "modifier_initiative_munaiyi_two_lua", { duration = duration})
    end
end

modifier_initiative_munaiyi_two_lua = class({})

function modifier_initiative_munaiyi_two_lua:IsDebuff()
	return true 
end
function modifier_initiative_munaiyi_two_lua:IsHidden()
	return false
end
function modifier_initiative_munaiyi_two_lua:IsPurgable()
	return true
end
function modifier_initiative_munaiyi_two_lua:IsPurgeException()
	return true
end
function modifier_initiative_munaiyi_two_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end
function modifier_initiative_munaiyi_two_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
end

function modifier_initiative_munaiyi_two_lua:GetModifierPhysicalArmorBonus(kv)
    return self:GetAbility():GetSpecialValueFor("armor_reduce")*-1
end