initiative_shitouren_two_lua = class({})

LinkLuaModifier("modifier_initiative_shitouren_two_lua","ability/abilities_lua/initiative_shitouren_two_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_shitouren_two_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    caster:EmitSound("game.shixue")
	ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", PATTACH_ROOTBONE_FOLLOW, caster)
    local ally = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		self:GetCaster():GetOrigin(),
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    caster:AddNewModifier(caster, self, "modifier_initiative_shitouren_two_lua", {duration = 5})
    for i=1,#ally do 
        ally[i]:AddNewModifier(ally[i], self, "modifier_initiative_shitouren_two_lua", {duration = 5})--调用修饰器
    end
    Timers:CreateTimer(1, function()
        caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    end)
end

modifier_initiative_shitouren_two_lua = class({})

function modifier_initiative_shitouren_two_lua:IsDebuff()
	return false 
end
function modifier_initiative_shitouren_two_lua:IsHidden()
	return false
end
function modifier_initiative_shitouren_two_lua:IsPurgable()
	return false
end
function modifier_initiative_shitouren_two_lua:IsPurgeException()
	return false
end
function modifier_initiative_shitouren_two_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
    return funcs
end
function modifier_initiative_shitouren_two_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
end
function modifier_initiative_shitouren_two_lua:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end
function modifier_initiative_shitouren_two_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("mobile_speed")
end
function modifier_initiative_shitouren_two_lua:GetModifierModelScale()
    return 50
end