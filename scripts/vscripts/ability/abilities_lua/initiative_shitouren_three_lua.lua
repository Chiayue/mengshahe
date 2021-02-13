initiative_shitouren_three_lua = class({})

--开始施法
function initiative_shitouren_three_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    caster:EmitSound("skill.bom2")
	ParticleManager:CreateParticle( "particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_sprit_ti8_overload_discharge.vpcf", PATTACH_ROOTBONE_FOLLOW, caster)
    local target = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		caster:GetOrigin(),
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    local damagetable = {
        victim = nil,                                 
        attacker = caster,
        damage = self:GetSpecialValueFor("damage"),								 
        damage_type = DAMAGE_TYPE_MAGICAL,				 
    }
    for i=1,#target do 
        damagetable.victim = target[i]
        ApplyDamage(damagetable) --对单位造成伤害，传入列表参数
    end
    Timers:CreateTimer(1, function()
        caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    end)
end