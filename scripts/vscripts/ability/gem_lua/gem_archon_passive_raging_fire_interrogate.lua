-- 被动技能(酷炫) 烈火审讯
LinkLuaModifier("modifier_gem_archon_passive_raging_fire_interrogate", "ability/gem_lua/gem_archon_passive_raging_fire_interrogate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_raging_fire_interrogate_debuff", "ability/gem_lua/gem_archon_passive_raging_fire_interrogate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_raging_fire_interrogate_damge", "ability/gem_lua/gem_archon_passive_raging_fire_interrogate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem_archon_passive_raging_fire_interrogate_duration_damge", "ability/gem_lua/gem_archon_passive_raging_fire_interrogate", LUA_MODIFIER_MOTION_NONE)




if gem_archon_passive_raging_fire_interrogate == nil then 
	gem_archon_passive_raging_fire_interrogate = class({})
end

function gem_archon_passive_raging_fire_interrogate:GetIntrinsicModifierName( ... )
	return "modifier_gem_archon_passive_raging_fire_interrogate"
end

if modifier_gem_archon_passive_raging_fire_interrogate == nil then 
	modifier_gem_archon_passive_raging_fire_interrogate = class({})
end

function modifier_gem_archon_passive_raging_fire_interrogate:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_archon_passive_raging_fire_interrogate:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_archon_passive_raging_fire_interrogate:DeclareFunctions( ... )
	return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中
		}
end

function modifier_gem_archon_passive_raging_fire_interrogate:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end

	local hCaster = self:GetCaster()
	local hTarget = params.target
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local hTarget_pos = hTarget:GetOrigin()
	local hAbility = self:GetAbility()

	local nowChance = RandomInt(0,100)
	if nowChance  > chance then
		return 0
	end
	if not self:GetAbility():IsCooldownReady() then
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
					damage = hCaster:GetIntellect() * 0.5 + hCaster:GetAttackDamage(),
					damage_type = self:GetAbility():GetAbilityDamageType(),
				}
			ApplyDamage(damage)
		end
	end

	-- 新建一个与NPC不相关的modifier 来实现伤害和减速的效果
	CreateModifierThinker(hCaster, hAbility, "modifier_gem_archon_passive_raging_fire_interrogate_debuff", {duration = duration}, hTarget_pos, hCaster:GetTeamNumber(), false)

	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end

---------------------------------------岩浆BUFF---------------------------------------
if modifier_gem_archon_passive_raging_fire_interrogate_debuff == nil then 
	modifier_gem_archon_passive_raging_fire_interrogate_debuff = class({})
end


function modifier_gem_archon_passive_raging_fire_interrogate_debuff:IsDebuff( ... )
	return true
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:IsAura()
	return true
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:GetModifierAura()
	return "modifier_gem_archon_passive_raging_fire_interrogate_damge"
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:GetAuraRadius()
	return self.radius
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:OnCreated( params )
---------------------------------------------- 创建效果(组合特效) ---------------------------------------------------
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	local EffectName = "particles/heroes/thtd_futo/ability_thtd_futo_03.vpcf" 
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/units/heroes/hero_phoenix/phoenix_supernova_egg_loadout.vpcf" 
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_1, 0, hParent:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(nFXIndex_1, 3, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	
	local EffectName_2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ult_2imate_linger.vpcf" 
	local nFXIndex_2 = ParticleManager:CreateParticle( EffectName_2, PATTACH_WORLDORIGIN, hParent)
	ParticleManager:SetParticleControl(nFXIndex_2, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(nFXIndex_2, 1, Vector(self.radius, 1, 1))
	self:AddParticle(nFXIndex_2, false, false, -1, false, false)
----------------------------------------------------------------------------------------------------------
end

function modifier_gem_archon_passive_raging_fire_interrogate_debuff:OnRefresh(params)
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end


-----------------------------------------damge-----------------------------------------
if modifier_gem_archon_passive_raging_fire_interrogate_damge == nil then 
	modifier_gem_archon_passive_raging_fire_interrogate_damge = class({})
end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:IsHidden()
	return true
end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:IsDebuff()
	return true
end

-- 在命中的敌人脚下生成一个毒液特效。只要有敌人经过  就必然燃烧 5秒 
-- 如果一直在上面，就一直刷新岩浆灼烧的持续时间
function modifier_gem_archon_passive_raging_fire_interrogate_damge:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )


	if IsServer() then 
		--hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_gem_archon_passive_raging_fire_interrogate_duration_damge", {duration = duration})
		self:StartIntervalThink(0.5)
	end
end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:OnIntervalThink( params )
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

				-- 敌人燃烧BUFF
				enemy:AddNewModifier( 
					hCaster, 
					self:GetAbility(), 
					"modifier_gem_archon_passive_raging_fire_interrogate_duration_damge", 
					{ duration = duration} 
				)
				
			end
		end

	end
end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:OnRefresh( ... )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.speed_cut = self:GetAbility():GetSpecialValueFor( "speed_cut" )

end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:DeclareFunctions( ... )
	return 
		{
			--MODIFIER_PROPERTY_OVERRIDE_ANIMATION, -- 动画
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- 移动速度
		}
end

function modifier_gem_archon_passive_raging_fire_interrogate_damge:GetModifierMoveSpeedBonus_Constant( ... )
	return -self.speed_cut
end

----------------------------------------------------------------------------------------------

-- 敌人离开毒阵后  毒液的依然持续造成伤害   直到持续时间结束
if modifier_gem_archon_passive_raging_fire_interrogate_duration_damge == nil then
	modifier_gem_archon_passive_raging_fire_interrogate_duration_damge = class({})
end


function modifier_gem_archon_passive_raging_fire_interrogate_duration_damge:IsDebuff()
	return true
end

function modifier_gem_archon_passive_raging_fire_interrogate_duration_damge:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )
	
	local EffectName = "particles/killstreak/killstreak_fire_hpbar_lv2.vpcf" -- 燃烧标志特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_OVERHEAD_FOLLOW, hParent)
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/killstreak/killstreak_fire_flames_lv2_hud.vpcf" -- 身体燃烧特效
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, hParent)
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	if IsServer() then 
		self:StartIntervalThink(1)
	end
end

function modifier_gem_archon_passive_raging_fire_interrogate_duration_damge:OnIntervalThink( params )
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	if IsServer() then
		ApplyDamage(
		{
			attacker = hCaster,
			victim = hParent,
			damage = hCaster:GetIntellect() * self.timer_attack_multiple,
			damage_type = self:GetAbility():GetAbilityDamageType(),
		}
		)

	end
end

function modifier_gem_archon_passive_raging_fire_interrogate_duration_damge:OnRefresh( ... )
	self.timer_attack_multiple = self:GetAbility():GetSpecialValueFor( "timer_attack_multiple" )
end