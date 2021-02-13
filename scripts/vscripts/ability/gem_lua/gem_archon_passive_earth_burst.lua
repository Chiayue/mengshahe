-- 酷炫被动 大地爆裂
LinkLuaModifier("modifier_gem_archon_passive_earth_burst", "ability/gem_lua/gem_archon_passive_earth_burst", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_earth_burst_debuff", "ability/gem_lua/gem_archon_passive_earth_burst", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_gem_archon_passive_earth_burst_frozen_debuff", "ability/gem_archon_passive_earth_burst", LUA_MODIFIER_MOTION_NONE)


if gem_archon_passive_earth_burst == nil then 
	gem_archon_passive_earth_burst = class({})
end

function gem_archon_passive_earth_burst:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_earth_burst"
end

if modifier_gem_archon_passive_earth_burst == nil then 
	modifier_gem_archon_passive_earth_burst = class({})
end

function modifier_gem_archon_passive_earth_burst:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_earth_burst:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_archon_passive_earth_burst:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

function modifier_gem_archon_passive_earth_burst:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	if not self:GetAbility():IsCooldownReady() then
		return 0
	end
	local hCaster = self:GetCaster()
	local hTarget = params.target
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local attack_multiple = self:GetAbility():GetSpecialValueFor( "attack_multiple" )

	local nowChance = RandomInt(0,100)
	if nowChance  > chance then
		return 0
	end

	-- -- 创建效果
	local EffectName_0 = "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf"
	local nFXIndex_0 = ParticleManager:CreateParticle( EffectName_0, PATTACH_ROOTBONE_FOLLOW, hTarget)
	
	local EffectName_1 = "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf"
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, hTarget)

	local EffectName_2 = "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf"
	local nFXIndex_2 = ParticleManager:CreateParticle( EffectName_2, PATTACH_ROOTBONE_FOLLOW, hTarget)

	local EffectName_3 = "particles/units/heroes/hero_brewmaster/brewmaster_pulverize.vpcf"
	local nFXIndex_3 = ParticleManager:CreateParticle( EffectName_3, PATTACH_ROOTBONE_FOLLOW, hTarget)

	-- 范围搜索
	local enemies = FindUnitsInRadius(
		hCaster:GetTeamNumber(), 
		hTarget:GetOrigin(), 
		hTarget, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)
	-- 一开始就造成500范围内的敌人冰冻 
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			
			local damage = {
				victim = enemy,
				attacker = hCaster,
				damage = hCaster:GetIntellect() * attack_multiple,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}

			ApplyDamage( damage )

			local knockbackModifierTable =
				{
				should_stun = 1,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = 0,
				knockback_height = 100,
				center_x = hTarget:GetAbsOrigin().x,
				center_y = hTarget:GetAbsOrigin().y,
				center_z = hTarget:GetAbsOrigin().z
				}

			-- 敌人击飞   系统自带的击飞 modifier 
			enemy:AddNewModifier( hCaster, nil, "modifier_knockback", knockbackModifierTable )
			
		end
	end
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end