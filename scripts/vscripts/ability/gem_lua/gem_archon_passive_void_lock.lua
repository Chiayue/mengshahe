-- 被动技能(酷炫) 虚空锁定
LinkLuaModifier("modifier_gem_archon_passive_void_lock", "ability/gem_lua/gem_archon_passive_void_lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_void_lock_debuff", "ability/gem_lua/gem_archon_passive_void_lock", LUA_MODIFIER_MOTION_NONE)

if gem_archon_passive_void_lock == nil then 
	gem_archon_passive_void_lock = class({})
end

function gem_archon_passive_void_lock:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_void_lock"
end

if modifier_gem_archon_passive_void_lock == nil then 
	modifier_gem_archon_passive_void_lock = class({})
end

function modifier_gem_archon_passive_void_lock:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_void_lock:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_archon_passive_void_lock:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

function modifier_gem_archon_passive_void_lock:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	if not self:GetAbility():IsCooldownReady() then
		return 0
	end
	local hCaster = self:GetCaster()
	local hTarget = params.target
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local agi_multiple_damage = self:GetAbility():GetSpecialValueFor( "agi_multiple_damage" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )

	local nowChance = RandomInt(0,100)
	if nowChance  > chance then
		return 0
	end

	-- -- 创建效果
	-- local EffectName = "particles/test_particles/test_particlesfaceless_void_chronosphere.vpcf"
	local EffectName = "particles/units/heroes/hero_faceless_void/_2faceless_void_chronosphere.vpcf"
	-- 系统自带的特效 被我转移到我自己的文件中了
	--local EffectName = "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7_2buff.vpcf" 
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_ROOTBONE_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(nFXIndex, 0, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(radius, radius, radius))

	-- 范围伤害
	local enemies = FindUnitsInRadius(
		hCaster:GetTeamNumber(), 
		hTarget:GetOrigin(), 
		hTarget, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)

	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			local damage = {
				victim = enemy,
				attacker = hCaster,
				damage = hCaster:GetAgility() * agi_multiple_damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}

			ApplyDamage( damage )

			-- 敌人眩晕BUFF
			enemy:AddNewModifier( 
				self:GetCaster(), 
				self:GetAbility(), 
				"modifier_gem_archon_passive_void_lock_debuff", 
				{ duration = duration} 
			)
			
		end
	end

	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end

---------------------------------------眩晕BUFF---------------------------------------
if modifier_gem_archon_passive_void_lock_debuff == nil then 
	modifier_gem_archon_passive_void_lock_debuff = class({})
end

function modifier_gem_archon_passive_void_lock_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_void_lock_debuff:IsStunDebuff() -- 是否是眩晕的效果
	return true
end

function modifier_gem_archon_passive_void_lock_debuff:CheckState() -- 修饰器的状态 调整为启用
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

function modifier_gem_archon_passive_void_lock_debuff:DeclareFunctions( ... )
	return 
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
		}
end

function modifier_gem_archon_passive_void_lock_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" -- 眩晕特效
end

function modifier_gem_archon_passive_void_lock_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_gem_archon_passive_void_lock_debuff:GetOverrideAnimation( ... )
	return ACT_DOTA_DISABLED -- 伤残动画
end