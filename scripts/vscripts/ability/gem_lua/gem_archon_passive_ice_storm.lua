-- 被动技能(酷炫) 冰川风暴
LinkLuaModifier("modifier_gem_archon_passive_Ice_storm", "ability/gem_lua/gem_archon_passive_Ice_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_Ice_storm_debuff", "ability/gem_lua/gem_archon_passive_Ice_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_Ice_storm_frozen_debuff", "ability/gem_lua/gem_archon_passive_Ice_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_Ice_storm_damge", "ability/gem_lua/gem_archon_passive_Ice_storm", LUA_MODIFIER_MOTION_NONE)

if gem_archon_passive_Ice_storm == nil then 
	gem_archon_passive_Ice_storm = class({})
end

function gem_archon_passive_Ice_storm:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_Ice_storm"
end

if modifier_gem_archon_passive_Ice_storm == nil then 
	modifier_gem_archon_passive_Ice_storm = class({})
end


function modifier_gem_archon_passive_Ice_storm:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

function modifier_gem_archon_passive_Ice_storm:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end

	local hCaster = self:GetCaster()
	local hTarget = params.target
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local frozen_duration = self:GetAbility():GetSpecialValueFor( "frozen_duration" ) -- 冰冻效果持续时间
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local attack_multiple = self:GetAbility():GetSpecialValueFor( "attack_multiple" )

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
	-- 一开始就造成500范围内的敌人冰冻 
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			
			local damage = {
				victim = enemy,
				attacker = hCaster,
				damage = hCaster:GetStrength() * attack_multiple,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}

			ApplyDamage( damage )

			-- 敌人冰冻BUFF
			enemy:AddNewModifier( 
				self:GetCaster(), 
				self:GetAbility(), 
				"modifier_gem_archon_passive_Ice_storm_frozen_debuff", 
				{ duration = frozen_duration} 
			)
			
		end
	end

	-- 在命中的敌人脚下生成一个冰川风暴。只要有敌人经过  就必然感染冷气 10秒 

	local hTarget_pos = hTarget:GetOrigin()
	local hAbility = self:GetAbility()



	-- 新建一个与NPC不相关的modifier 来实现伤害和减速的效果
	CreateModifierThinker(hCaster, hAbility, "modifier_gem_archon_passive_Ice_storm_debuff", {duration = duration}, hTarget_pos, hCaster:GetTeamNumber(), false)
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end

---------------------------------------毒液BUFF---------------------------------------
if modifier_gem_archon_passive_Ice_storm_debuff == nil then 
	modifier_gem_archon_passive_Ice_storm_debuff = class({})
end

function modifier_gem_archon_passive_Ice_storm_debuff:IsHidden()
	return true
end

function modifier_gem_archon_passive_Ice_storm_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_Ice_storm_debuff:IsAura()
	return true
end

function modifier_gem_archon_passive_Ice_storm_debuff:GetModifierAura()
	return "modifier_gem_archon_passive_Ice_storm_damge"
end

function modifier_gem_archon_passive_Ice_storm_debuff:GetAuraRadius()
	return self.radius
end

function modifier_gem_archon_passive_Ice_storm_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gem_archon_passive_Ice_storm_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_gem_archon_passive_Ice_storm_debuff:OnCreated( params )
---------------------------------------------- 创建效果 ---------------------------------------------------
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	local EffectName = "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7_2buff.vpcf" -- 冰川风暴特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex, false, false, -1, false, false)
----------------------------------------------------------------------------------------------------------
end

function modifier_gem_archon_passive_Ice_storm_debuff:OnRefresh(params)
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-----------------------------------------伤害--------------------------------------------------------------
if modifier_gem_archon_passive_Ice_storm_damge == nil then 
	modifier_gem_archon_passive_Ice_storm_damge = class({})
end

function modifier_gem_archon_passive_Ice_storm_damge:IsHidden()
	return false
end

function modifier_gem_archon_passive_Ice_storm_damge:IsDebuff()
	return true
end

function modifier_gem_archon_passive_Ice_storm_damge:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )

	local EffectName = "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff_frost.vpcf" -- 冰气特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_ABSORIGIN_FOLLOW, hParent)
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	if IsServer() then 
		self:StartIntervalThink(1)
	end
end

function modifier_gem_archon_passive_Ice_storm_damge:OnIntervalThink( params )
	

	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if IsServer() then
		ApplyDamage(
		{
			--ability = hAbility,
			attacker = hCaster,
			victim = hParent,
			damage = hCaster:GetStrength() * self.timer_attack_multiple,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		)

	end
end

function modifier_gem_archon_passive_Ice_storm_damge:OnRefresh( ... )
	self.timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )
end

function modifier_gem_archon_passive_Ice_storm_damge:DeclareFunctions( ... )
	return 
		{
			--MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- 移动速度
		}
end

function modifier_gem_archon_passive_Ice_storm_damge:GetModifierMoveSpeedBonus_Constant( ... )
	return -self.speed_cut
end

-------------------------------------------冰冻BUFF--------------------------------------------
if modifier_gem_archon_passive_Ice_storm_frozen_debuff == nil then
	modifier_gem_archon_passive_Ice_storm_frozen_debuff = class({})
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:IsStunDebuff() -- 是否是眩晕的效果
	return true
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_Ice_storm_frozen_debuff:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:CheckState() -- 修饰器的状态 调整为启用
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:DeclareFunctions( ... )
	return 
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
		}
end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:GetEffectName()
	return "particles/heroes/cirno/ability_cirno_04_buff.vpcf" -- 冰冻特效
end

-- function modifier_archon_passive_void_lock_debuff:GetEffectAttachType()
-- 	return PATTACH_ROOTBONE_FOLLOW
-- end

function modifier_gem_archon_passive_Ice_storm_frozen_debuff:GetOverrideAnimation( ... )
	return ACT_DOTA_DISABLED -- 伤残动画
end