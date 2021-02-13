-- 被动技能(酷炫) 死亡毒液
LinkLuaModifier("modifier_gem_archon_passive_die_venom", "ability/gem_lua/gem_archon_passive_die_venom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_die_venom_debuff", "ability/gem_lua/gem_archon_passive_die_venom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_die_venom_damge", "ability/gem_lua/gem_archon_passive_die_venom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_die_venom_duration_damge", "ability/gem_lua/gem_archon_passive_die_venom", LUA_MODIFIER_MOTION_NONE)


if gem_archon_passive_die_venom == nil then 
	gem_archon_passive_die_venom = class({})
end

function gem_archon_passive_die_venom:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_die_venom"
end

if modifier_gem_archon_passive_die_venom == nil then 
	modifier_gem_archon_passive_die_venom = class({})
end

function modifier_gem_archon_passive_die_venom:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_die_venom:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_archon_passive_die_venom:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

-- 在命中的敌人脚下生成一个毒液特效。只要有敌人经过  就必然感染毒液 5秒
function modifier_gem_archon_passive_die_venom:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	if not self:GetAbility():IsCooldownReady() then
		return 0
	end
	local hCaster = self:GetCaster()
	local hTarget = params.target
	local hTarget_pos = hTarget:GetOrigin()
	local hAbility = self:GetAbility()
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local attack_multiple = self:GetAbility():GetSpecialValueFor( "attack_multiple" )

	local nowChance = RandomInt(0,100)
	if nowChance  > chance then
		return 0
	end

	-- 范围寻找
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
				local damage = 
					{
						victim = enemy,
						attacker = hCaster,
						damage = hCaster:GetStrength() * attack_multiple,
						damage_type = self:GetAbility():GetAbilityDamageType(),
					}
					ApplyDamage(damage)
			end
		end

	-- 新建一个与NPC不相关的modifier 来实现伤害和减速的效果
	CreateModifierThinker(hCaster, hAbility, "modifier_gem_archon_passive_die_venom_debuff", {duration = duration}, hTarget_pos, hCaster:GetTeamNumber(), false)
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end

---------------------------------------毒液BUFF---------------------------------------
if modifier_gem_archon_passive_die_venom_debuff == nil then 
	modifier_gem_archon_passive_die_venom_debuff = class({})
end

function modifier_gem_archon_passive_die_venom_debuff:IsHidden()
	return true
end

function modifier_gem_archon_passive_die_venom_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_die_venom_debuff:IsAura()
	return true
end

function modifier_gem_archon_passive_die_venom_debuff:GetModifierAura()
	return "modifier_gem_archon_passive_die_venom_damge"
end

function modifier_gem_archon_passive_die_venom_debuff:GetAuraRadius()
	return self.radius
end

function modifier_gem_archon_passive_die_venom_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gem_archon_passive_die_venom_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_gem_archon_passive_die_venom_debuff:OnCreated( params )
---------------------------------------------- 创建效果 ---------------------------------------------------
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	local EffectName = "particles/units/heroes/hero_rubick/rubick_supernova_egg_2.vpcf" 
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf" 
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_1, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex_1, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	
	local EffectName_2 = "particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf" 
	local nFXIndex_2 = ParticleManager:CreateParticle( EffectName_2, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_2, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex_2, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_2, false, false, -1, false, false)
----------------------------------------------------------------------------------------------------------
end

function modifier_gem_archon_passive_die_venom_debuff:OnRefresh(params)
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end


-----------------------------------------damge-----------------------------------------
if modifier_gem_archon_passive_die_venom_damge == nil then 
	modifier_gem_archon_passive_die_venom_damge = class({})
end

function modifier_gem_archon_passive_die_venom_damge:IsHidden()
	return true
end

function modifier_gem_archon_passive_die_venom_damge:IsDebuff()
	return true
end

-- 如果一直在上面，就一直刷新毒液的持续时间
function modifier_gem_archon_passive_die_venom_damge:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then 
		--hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_gem_archon_passive_die_venom_duration_damge", {duration = duration})
		self:StartIntervalThink(0.5)
	end
end

function modifier_gem_archon_passive_die_venom_damge:OnIntervalThink( params )
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
		local duration = self:GetAbility():GetSpecialValueFor( "duration" )

	if IsServer() then
		-- 范围寻找
		local enemies = FindUnitsInRadius(
			hCaster:GetTeamNumber(), 
			hParent:GetOrigin(), 
			hParent, 
			self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			0, 0, false 
		)

		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

				-- 敌人毒液BUFF
				enemy:AddNewModifier( 
					hCaster, 
					self:GetAbility(), 
					"modifier_gem_archon_passive_die_venom_duration_damge", 
					{ duration = duration} 
				)
				
			end
		end

	end
end

function modifier_gem_archon_passive_die_venom_damge:OnRefresh( ... )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )
end

function modifier_gem_archon_passive_die_venom_damge:DeclareFunctions( ... )
	return 
		{
			--MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- 移动速度
		}
end

function modifier_gem_archon_passive_die_venom_damge:GetModifierMoveSpeedBonus_Constant( ... )
	return -self.speed_cut
end

----------------------------------------------------------------------------------------------

-- 敌人离开毒阵后  毒液的依然持续造成伤害   直到持续时间结束
if modifier_gem_archon_passive_die_venom_duration_damge == nil then
	modifier_gem_archon_passive_die_venom_duration_damge = class({})
end


function modifier_gem_archon_passive_die_venom_duration_damge:IsHidden()
	return false
end

function modifier_gem_archon_passive_die_venom_duration_damge:IsDebuff()
	return true
end

function modifier_gem_archon_passive_die_venom_duration_damge:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )

	local EffectName = "particles/units/heroes/hero_pudge/pudge_swallow.vpcf" -- 毒液特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_OVERHEAD_FOLLOW, hParent)
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_ambient_ti_5.vpcf" -- 毒液特效
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_OVERHEAD_FOLLOW, hParent)
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	if IsServer() then 
		self:StartIntervalThink(1)
	end
end

function modifier_gem_archon_passive_die_venom_duration_damge:OnIntervalThink( params )
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	if IsServer() then
		ApplyDamage(
		{
			attacker = hCaster,
			victim = hParent,
			damage = hCaster:GetIntellect() * self.timer_attack_multiple,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		)

	end
end