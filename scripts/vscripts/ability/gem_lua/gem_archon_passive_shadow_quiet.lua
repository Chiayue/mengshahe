-- 酷炫被动 暗影沉寂

LinkLuaModifier("modifier_gem_archon_passive_shadow_quiet", "ability/gem_lua/gem_archon_passive_shadow_quiet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_shadow_quiet_debuff", "ability/gem_lua/gem_archon_passive_shadow_quiet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_shadow_quiet_frozen_debuff", "ability/gem_lua/gem_archon_passive_shadow_quiet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_shadow_quiet_sleep_debuff", "ability/gem_lua/gem_archon_passive_shadow_quiet", LUA_MODIFIER_MOTION_NONE)


if gem_archon_passive_shadow_quiet == nil then 
	gem_archon_passive_shadow_quiet = class({})
end

function gem_archon_passive_shadow_quiet:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_shadow_quiet"
end

if modifier_gem_archon_passive_shadow_quiet == nil then 
	modifier_gem_archon_passive_shadow_quiet = class({})
end

function modifier_gem_archon_passive_shadow_quiet:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_shadow_quiet:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_archon_passive_shadow_quiet:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

function modifier_gem_archon_passive_shadow_quiet:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end

	local hCaster = self:GetCaster()
	local hTarget = params.target
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local attack_multiple = self:GetAbility():GetSpecialValueFor( "attack_multiple" )
	local sleep_duration = self:GetAbility():GetSpecialValueFor( "sleep_duration" ) -- 睡眠效果持续时间
	local hTarget_pos = hTarget:GetOrigin()
	local hAbility = self:GetAbility()

	local nowChance = RandomInt(0,100)
	if nowChance  > chance then
		return 0
	end
	if not self:GetAbility():IsCooldownReady() then
		return 0
	end
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
	-- 一开始就造成500范围内的敌人睡眠
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			
			local damage = {
				victim = enemy,
				attacker = hCaster,
				damage = ( hCaster:GetStrength() + hCaster:GetAgility() + hCaster:GetIntellect() ) * attack_multiple ,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}

			ApplyDamage( damage )
			
			-- 敌人睡眠BUFF
			enemy:AddNewModifier( 
				hCaster, 
				self:GetAbility(), 
				"modifier_gem_archon_passive_shadow_quiet_sleep_debuff", 
				{ duration = sleep_duration} 
			)
		end
	end

	-- 新建一个与NPC不相关的modifier 来实现伤害和减速的效果
	CreateModifierThinker(hCaster, hAbility, "modifier_gem_archon_passive_shadow_quiet_debuff", {duration = duration}, hTarget_pos, hCaster:GetTeamNumber(), false)
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end

if modifier_gem_archon_passive_shadow_quiet_debuff == nil then 
	modifier_gem_archon_passive_shadow_quiet_debuff = class({})
end

function modifier_gem_archon_passive_shadow_quiet_debuff:IsHidden()
	return true
end

function modifier_gem_archon_passive_shadow_quiet_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_shadow_quiet_debuff:IsAura()
	return true
end

function modifier_gem_archon_passive_shadow_quiet_debuff:GetModifierAura()
	return "modifier_gem_archon_passive_shadow_quiet_frozen_debuff"
end

function modifier_gem_archon_passive_shadow_quiet_debuff:GetAuraRadius()
	return self.radius
end

function modifier_gem_archon_passive_shadow_quiet_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gem_archon_passive_shadow_quiet_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_gem_archon_passive_shadow_quiet_debuff:OnCreated( params )
---------------------------------------------- 创建效果(组合特效) ---------------------------------------------------
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	local EffectName = "particles/units/heroes/hero_void_spirit/void_spirit_entryportal_2.vpcf" 
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf" 
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_1, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex_1, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	
	local EffectName_2 = "particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_untargetable.vpcf" 
	local nFXIndex_2 = ParticleManager:CreateParticle( EffectName_2, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_2, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex_2, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_2, false, false, -1, false, false)
----------------------------------------------------------------------------------------------------------
end

function modifier_gem_archon_passive_shadow_quiet_debuff:OnRefresh(params)
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end


-----------------------------------------damge-----------------------------------------
if modifier_gem_archon_passive_shadow_quiet_frozen_debuff == nil then 
	modifier_gem_archon_passive_shadow_quiet_frozen_debuff = class({})
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:IsHidden()
	return true
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:IsDebuff()
	return true
end

-- 在命中的敌人脚下生成一个暗影特效。
function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )

	if IsServer() then 
		--hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_archon_passive_raging_fire_interrogate_duration_damge", {duration = duration})
		self:StartIntervalThink(1)
	end
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:OnIntervalThink( params )
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )

	if IsServer() then
		ApplyDamage(
		{
			--ability = hAbility,
			attacker = hCaster,
			victim = hParent,
			damage = hCaster:GetIntellect() * timer_attack_multiple,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		)
	end
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:OnRefresh( ... )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:DeclareFunctions( ... )
	return 
		{
			--MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- 移动速度
		}
end

function modifier_gem_archon_passive_shadow_quiet_frozen_debuff:GetModifierMoveSpeedBonus_Constant( ... )
	return -self.speed_cut
end

-- 敌人睡眠DeBuff
if modifier_gem_archon_passive_shadow_quiet_sleep_debuff == nil then
	modifier_gem_archon_passive_shadow_quiet_sleep_debuff = class({})
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:IsStunDebuff() -- 是否是眩晕的效果
	return true
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:CheckState() -- 修饰器的状态 调整为启用
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:DeclareFunctions( ... )
	return 
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
		}
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:GetEffectName()
	return "particles/newplayer_fx/npx_sleeping.vpcf" -- 睡眠特效
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_gem_archon_passive_shadow_quiet_sleep_debuff:GetOverrideAnimation( ... )
	return ACT_DOTA_DISABLED -- 出生动画      -- 睡眠动画
end