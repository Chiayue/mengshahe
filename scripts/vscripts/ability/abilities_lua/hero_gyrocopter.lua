 CreateEmptyTalents("gyrocopter")

-- 05 08 by MysticBug -------------
-- designer by 毒瘤无所谓输赢 ------
-----------------------------------

--gyrocopter_rocket_barrage  火箭弹幕
--向矮人直升机周围一定范围内的敌方单位齐射导弹。持续%abilityduration%秒。
--imba 防御粉碎：受影响的目标魔抗将会削弱

--火箭弹幕不能伤害矮人直升机视野之外的单位。  Note1

imba_gyrocopter_rocket_barrage = class({})
LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage_caster","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage_debuff","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)

function imba_gyrocopter_rocket_barrage:IsHiddenWhenStolen()  	return false end
function imba_gyrocopter_rocket_barrage:IsRefreshable()			return true end
function imba_gyrocopter_rocket_barrage:IsStealable() 			return true end
function imba_gyrocopter_rocket_barrage:IsNetherWardStealable() return false end
function imba_gyrocopter_rocket_barrage:GetCooldown( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_cooldown")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

function imba_gyrocopter_rocket_barrage:GetManaCost( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_manacost")
	else
		return self.BaseClass.GetManaCost( self, iLevel )
	end
end

function imba_gyrocopter_rocket_barrage:OnSpellStart()
	local caster = self:GetCaster()
	--音效
	caster:EmitSound("Hero_Gyrocopter.Rocket_Barrage")
	--add modifier
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_gyrocopter_rocket_barrage_caster", -- modifier name
		{ duration = self:GetDuration() } -- kv
	)
end

modifier_imba_gyrocopter_rocket_barrage_caster = class({})

function modifier_imba_gyrocopter_rocket_barrage_caster:IsDebuff()			return false end
function modifier_imba_gyrocopter_rocket_barrage_caster:IsHidden() 			return false end
function modifier_imba_gyrocopter_rocket_barrage_caster:IsPurgable() 		return false end
function modifier_imba_gyrocopter_rocket_barrage_caster:IsPurgeException() 	return false end
function modifier_imba_gyrocopter_rocket_barrage_caster:OnCreated(kv)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
			self.radius = self:GetAbility():GetSpecialValueFor("ult_radius")
		end
		self.rockets_per_second = self:GetAbility():GetSpecialValueFor("rockets_per_second")
		self.rocket_damage = self:GetAbility():GetSpecialValueFor("rocket_damage")
		if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_4") then 
			self.rocket_damage = self:GetCaster():GetTalentValue("special_bonus_imba_gyrocopter_4")
		end
		self.rocket_pfx = {"attach_attack1", "attach_attack2"}
		self.barrage_pfx_name = "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf"
		if HeroItems:UnitHasItem(self:GetCaster(), "gyrocopter_immortal_weapon") then
			self.barrage_pfx_name = "particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf"
		end
		--火箭数量
		--self:SetStackCount(self.rockets_per_second)
		--1s 
		self:StartIntervalThink(1/self.rockets_per_second)
	end
end

function modifier_imba_gyrocopter_rocket_barrage_caster:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --火箭弹幕不能伤害矮人直升机视野之外的单位
		FIND_ANY_ORDER, 
		false
		)
	for _, enemy in pairs(enemies) do
		--hit sound
		if HeroItems:UnitHasItem(self:GetCaster(), "gyrocopter_immortal_weapon") then
			enemy:EmitSound("Hero_Gyrocopter.ART_Barrage.Launch")
		else
			enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
		end
		--hit pfx 
		--------------------------------------------------------
		--particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf
		--particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf
		self.barrage_pfx = ParticleManager:CreateParticle(self.barrage_pfx_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.barrage_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.rocket_pfx[RandomInt(1, #self.rocket_pfx)], self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.barrage_pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.barrage_pfx)
		--------------------------------------------------------
		--造成伤害
		ApplyDamage(
			{
				attacker = caster, 
				victim = enemy, 
				damage = self.rocket_damage, 
				ability = self:GetAbility(), 
				damage_type = self:GetAbility():GetAbilityDamageType()
			}
		)
		--DEBUFF
		enemy:AddNewModifier(self:GetCaster(), 
			self:GetAbility(), 
			"modifier_imba_gyrocopter_rocket_barrage_debuff", 
			{duration = self:GetAbility():GetDuration()}
		)
		if not self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_4") then
			break
		end
	end
end

function modifier_imba_gyrocopter_rocket_barrage_caster:OnDestory()
	if IsServer() then
		self.radius = nil
		self.rockets_per_second = nil
		self.rocket_damage = nil
	end
end

--DEBUFF
modifier_imba_gyrocopter_rocket_barrage_debuff = class({})

function modifier_imba_gyrocopter_rocket_barrage_debuff:IsDebuff()			return true end
function modifier_imba_gyrocopter_rocket_barrage_debuff:IsHidden() 			return false end
function modifier_imba_gyrocopter_rocket_barrage_debuff:IsPurgable() 		return true end
function modifier_imba_gyrocopter_rocket_barrage_debuff:IsPurgeException() 	return true end
function modifier_imba_gyrocopter_rocket_barrage_debuff:DeclareFunctions() 	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_imba_gyrocopter_rocket_barrage_debuff:GetModifierMagicalResistanceBonus() return (0 - self:GetAbility():GetSpecialValueFor("negative_resistance")) end


--gyrocopter_homing_missile  追踪导弹
--发射一枚会自动定位目标单位的追踪导弹。导弹发射后持续增加飞行速度，击中目标时造成伤害及眩晕。敌方单位可在导弹接近前将其击落。
--(毒瘤)0.3秒延迟后高速飞向目标，施法距离1500，速度1000，单体眩晕AOE伤害

--imba 定点飞弹：追踪导弹击中目标后，延时0.3S召唤导弹从空中打击目标区域内的敌方单位，造成一半伤害和短暂麻痹。
--Hero_Gyrocopter.HomingMissile.Enemy  Hero_Gyrocopter.HomingMissile.Destroy 
--Hero_Gyrocopter.HomingMissile.Target  Hero_Gyrocopter.HomingMissile

LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_caster","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_target","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)


imba_gyrocopter_homing_missile_d = class({})

function imba_gyrocopter_homing_missile_d:IsHiddenWhenStolen() 		return false end
function imba_gyrocopter_homing_missile_d:IsRefreshable() 			return true end
function imba_gyrocopter_homing_missile_d:IsStealable() 			return true end
function imba_gyrocopter_homing_missile_d:IsNetherWardStealable() 	return false end
function imba_gyrocopter_homing_missile_d:GetCastRange(location, target)
	return self:GetSpecialValueFor("max_distance")
end
function imba_gyrocopter_homing_missile_d:GetCooldown( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_cooldown")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_d:GetManaCost( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_manacost")
	else
		return self.BaseClass.GetManaCost( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_d:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_pos = caster:GetAbsOrigin()
	local health = self:GetSpecialValueFor("hero_damage") * self:GetSpecialValueFor("hits_to_kill_tooltip")
	local unit = CreateUnitByName("npc_dota_gyrocopter_homing_missile", caster_pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(unit, health, true)
	--飞行速度
	unit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed"))
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	--unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	--3s后开始飞行
	Timers:CreateTimer(self:GetSpecialValueFor("pre_flight_time") + caster:GetTalentValue("special_bonus_imba_gyrocopter_3"), function()
		unit:MoveToTargetToAttack(target)
		--导弹修饰器
		unit:AddNewModifier(caster, self, "modifier_imba_gyrocopter_homing_missile_caster", {duration = 20, hTarget = target:entindex()})
		--持续获取目标视野
		target:AddNewModifier(caster,self,"modifier_imba_gyrocopter_homing_missile_target",{duration = 20})
		return nil
	end)
end

function imba_gyrocopter_homing_missile_d:Missile_CallDown(hTarget,vlocation)
	--local target = EntIndexToHScript(hTarget)
	local target = hTarget
	if not target or target:TriggerStandardTargetSpell(self) then
		return
	end
	--导弹攻击到目标 造成眩晕和伤害
	if not target:IsMagicImmune() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		local damageTable = {
			victim 			= target,
			damage 			= self:GetAbilityDamage() + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		ApplyDamage(damageTable)
	end
	--音效
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
	--击中特效
	local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(explosion_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(explosion_pfx)
	--移除视野修饰器
	target:RemoveModifierByName("modifier_imba_gyrocopter_homing_missile_target")
	--获得视野
	self:CreateVisibilityNode(target:GetAbsOrigin(), 400, self:GetSpecialValueFor("enemy_vision_time"))
	--------------------------------------------------------------------------------------------------------
	--延时0.3S 召唤一个飞弹攻击
	--标记特效
	----------------------------------------------------
	local calldown_radius = self:GetSpecialValueFor("calldown_radius")
	local marker_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(marker_pfx, 0, vlocation)
	ParticleManager:SetParticleControl(marker_pfx, 1, Vector(calldown_radius, 1, calldown_radius * (-1)))
	ParticleManager:ReleaseParticleIndex(marker_pfx)
	----------------------------------------------------
	--标记音效
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	--飞弹特效
	local calldown_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_pfx, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_pfx, 1, vlocation)
	ParticleManager:SetParticleControl(calldown_pfx, 5, Vector(calldown_radius, calldown_radius, calldown_radius))
	ParticleManager:ReleaseParticleIndex(calldown_pfx)
	--飞弹音效
	EmitSoundOnLocationWithCaster(vlocation, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	Timers:CreateTimer(1.6,function()
			--AOE
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				vlocation, 
				nil, 
				self:GetSpecialValueFor("calldown_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for _, enemy in pairs(enemies) do
				--不会对魔免单位造成DEBUFF
				if not enemy:IsMagicImmune() then
					--减速麻痹
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("stun_duration")})
					--伤害
					ApplyDamage(
						{
						victim 			= enemy,
						damage 			= self:GetAbilityDamage()/2 + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self						
					}
					)
				end
			end
		return nil
	end)
end

imba_gyrocopter_homing_missile_c = class({})

function imba_gyrocopter_homing_missile_c:IsHiddenWhenStolen() 		return false end
function imba_gyrocopter_homing_missile_c:IsRefreshable() 			return true end
function imba_gyrocopter_homing_missile_c:IsStealable() 			return true end
function imba_gyrocopter_homing_missile_c:IsNetherWardStealable() 	return false end
function imba_gyrocopter_homing_missile_c:GetCastRange(location, target)
	return self:GetSpecialValueFor("max_distance")
end
function imba_gyrocopter_homing_missile_c:GetCooldown( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_cooldown")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_c:GetManaCost( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_manacost")
	else
		return self.BaseClass.GetManaCost( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_c:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_pos = caster:GetAbsOrigin()
	local health = self:GetSpecialValueFor("hero_damage") * self:GetSpecialValueFor("hits_to_kill_tooltip")
	local unit = CreateUnitByName("npc_dota_gyrocopter_homing_missile", caster_pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(unit, health, true)
	--飞行速度
	unit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed"))
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	--unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	--3s后开始飞行
	Timers:CreateTimer(self:GetSpecialValueFor("pre_flight_time") + caster:GetTalentValue("special_bonus_imba_gyrocopter_3"), function()
		unit:MoveToTargetToAttack(target)
		--导弹修饰器
		unit:AddNewModifier(caster, self, "modifier_imba_gyrocopter_homing_missile_caster", {duration = 20, hTarget = target:entindex()})
		--持续获取目标视野
		target:AddNewModifier(caster,self,"modifier_imba_gyrocopter_homing_missile_target",{duration = 20})
		return nil
	end)
end

function imba_gyrocopter_homing_missile_c:Missile_CallDown(hTarget,vlocation)
	--local target = EntIndexToHScript(hTarget)
	local target = hTarget
	if not target or target:TriggerStandardTargetSpell(self) then
		return
	end
	--导弹攻击到目标 造成眩晕和伤害
	if not target:IsMagicImmune() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		local damageTable = {
			victim 			= target,
			damage 			= self:GetAbilityDamage() + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		ApplyDamage(damageTable)
	end
	--音效
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
	--击中特效
	local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(explosion_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(explosion_pfx)
	--移除视野修饰器
	target:RemoveModifierByName("modifier_imba_gyrocopter_homing_missile_target")
	--获得视野
	self:CreateVisibilityNode(target:GetAbsOrigin(), 400, self:GetSpecialValueFor("enemy_vision_time"))
	--------------------------------------------------------------------------------------------------------
	--延时0.3S 召唤一个飞弹攻击
	--标记特效
	----------------------------------------------------
	local calldown_radius = self:GetSpecialValueFor("calldown_radius")
	local marker_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(marker_pfx, 0, vlocation)
	ParticleManager:SetParticleControl(marker_pfx, 1, Vector(calldown_radius, 1, calldown_radius * (-1)))
	ParticleManager:ReleaseParticleIndex(marker_pfx)
	----------------------------------------------------
	--标记音效
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	--飞弹特效
	local calldown_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_pfx, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_pfx, 1, vlocation)
	ParticleManager:SetParticleControl(calldown_pfx, 5, Vector(calldown_radius, calldown_radius, calldown_radius))
	ParticleManager:ReleaseParticleIndex(calldown_pfx)
	--飞弹音效
	EmitSoundOnLocationWithCaster(vlocation, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	Timers:CreateTimer(1.6,function()
			--AOE
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				vlocation, 
				nil, 
				self:GetSpecialValueFor("calldown_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for _, enemy in pairs(enemies) do
				--不会对魔免单位造成DEBUFF
				if not enemy:IsMagicImmune() then
					--减速麻痹
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("stun_duration")})
					--伤害
					ApplyDamage(
						{
						victim 			= enemy,
						damage 			= self:GetAbilityDamage()/2 + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self						
					}
					)
				end
			end
		return nil
	end)
end

imba_gyrocopter_homing_missile_b = class({})

function imba_gyrocopter_homing_missile_b:IsHiddenWhenStolen() 		return false end
function imba_gyrocopter_homing_missile_b:IsRefreshable() 			return true end
function imba_gyrocopter_homing_missile_b:IsStealable() 			return true end
function imba_gyrocopter_homing_missile_b:IsNetherWardStealable() 	return false end
function imba_gyrocopter_homing_missile_b:GetCastRange(location, target)
	return self:GetSpecialValueFor("max_distance")
end
function imba_gyrocopter_homing_missile_b:GetCooldown( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_cooldown")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_b:GetManaCost( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_manacost")
	else
		return self.BaseClass.GetManaCost( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_b:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_pos = caster:GetAbsOrigin()
	local health = self:GetSpecialValueFor("hero_damage") * self:GetSpecialValueFor("hits_to_kill_tooltip")
	local unit = CreateUnitByName("npc_dota_gyrocopter_homing_missile", caster_pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(unit, health, true)
	--飞行速度
	unit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed"))
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	--unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	--3s后开始飞行
	Timers:CreateTimer(self:GetSpecialValueFor("pre_flight_time") + caster:GetTalentValue("special_bonus_imba_gyrocopter_3"), function()
		unit:MoveToTargetToAttack(target)
		--导弹修饰器
		unit:AddNewModifier(caster, self, "modifier_imba_gyrocopter_homing_missile_caster", {duration = 20, hTarget = target:entindex()})
		--持续获取目标视野
		target:AddNewModifier(caster,self,"modifier_imba_gyrocopter_homing_missile_target",{duration = 20})
		return nil
	end)
end

function imba_gyrocopter_homing_missile_b:Missile_CallDown(hTarget,vlocation)
	--local target = EntIndexToHScript(hTarget)
	local target = hTarget
	if not target or target:TriggerStandardTargetSpell(self) then
		return
	end
	--导弹攻击到目标 造成眩晕和伤害
	if not target:IsMagicImmune() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		local damageTable = {
			victim 			= target,
			damage 			= self:GetAbilityDamage() + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		ApplyDamage(damageTable)
	end
	--音效
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
	--击中特效
	local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(explosion_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(explosion_pfx)
	--移除视野修饰器
	target:RemoveModifierByName("modifier_imba_gyrocopter_homing_missile_target")
	--获得视野
	self:CreateVisibilityNode(target:GetAbsOrigin(), 400, self:GetSpecialValueFor("enemy_vision_time"))
	--------------------------------------------------------------------------------------------------------
	--延时0.3S 召唤一个飞弹攻击
	--标记特效
	----------------------------------------------------
	local calldown_radius = self:GetSpecialValueFor("calldown_radius")
	local marker_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(marker_pfx, 0, vlocation)
	ParticleManager:SetParticleControl(marker_pfx, 1, Vector(calldown_radius, 1, calldown_radius * (-1)))
	ParticleManager:ReleaseParticleIndex(marker_pfx)
	----------------------------------------------------
	--标记音效
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	--飞弹特效
	local calldown_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_pfx, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_pfx, 1, vlocation)
	ParticleManager:SetParticleControl(calldown_pfx, 5, Vector(calldown_radius, calldown_radius, calldown_radius))
	ParticleManager:ReleaseParticleIndex(calldown_pfx)
	--飞弹音效
	EmitSoundOnLocationWithCaster(vlocation, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	Timers:CreateTimer(1.6,function()
			--AOE
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				vlocation, 
				nil, 
				self:GetSpecialValueFor("calldown_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for _, enemy in pairs(enemies) do
				--不会对魔免单位造成DEBUFF
				if not enemy:IsMagicImmune() then
					--减速麻痹
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("stun_duration")})
					--伤害
					ApplyDamage(
						{
						victim 			= enemy,
						damage 			= self:GetAbilityDamage()/2 + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self						
					}
					)
				end
			end
		return nil
	end)
end

imba_gyrocopter_homing_missile_a = class({})

function imba_gyrocopter_homing_missile_a:IsHiddenWhenStolen() 		return false end
function imba_gyrocopter_homing_missile_a:IsRefreshable() 			return true end
function imba_gyrocopter_homing_missile_a:IsStealable() 			return true end
function imba_gyrocopter_homing_missile_a:IsNetherWardStealable() 	return false end
function imba_gyrocopter_homing_missile_a:GetCastRange(location, target)
	return self:GetSpecialValueFor("max_distance")
end
function imba_gyrocopter_homing_missile_a:GetCooldown( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_cooldown")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_a:GetManaCost( iLevel )
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_helicopter_form_caster") then 
		return self:GetSpecialValueFor("ult_manacost")
	else
		return self.BaseClass.GetManaCost( self, iLevel )
	end
end

function imba_gyrocopter_homing_missile_a:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_pos = caster:GetAbsOrigin()
	local health = self:GetSpecialValueFor("hero_damage") * self:GetSpecialValueFor("hits_to_kill_tooltip")
	local unit = CreateUnitByName("npc_dota_gyrocopter_homing_missile", caster_pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(unit, health, true)
	--飞行速度
	unit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed"))
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	--unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	--3s后开始飞行
	Timers:CreateTimer(self:GetSpecialValueFor("pre_flight_time") + caster:GetTalentValue("special_bonus_imba_gyrocopter_3"), function()
		unit:MoveToTargetToAttack(target)
		--导弹修饰器
		unit:AddNewModifier(caster, self, "modifier_imba_gyrocopter_homing_missile_caster", {duration = 20, hTarget = target:entindex()})
		--持续获取目标视野
		target:AddNewModifier(caster,self,"modifier_imba_gyrocopter_homing_missile_target",{duration = 20})
		return nil
	end)
end

function imba_gyrocopter_homing_missile_a:Missile_CallDown(hTarget,vlocation)
	--local target = EntIndexToHScript(hTarget)
	local target = hTarget
	if not target or target:TriggerStandardTargetSpell(self) then
		return
	end
	--导弹攻击到目标 造成眩晕和伤害
	if not target:IsMagicImmune() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		local damageTable = {
			victim 			= target,
			damage 			= self:GetAbilityDamage() + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		ApplyDamage(damageTable)
	end
	--音效
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
	target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
	--击中特效
	local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(explosion_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(explosion_pfx)
	--移除视野修饰器
	target:RemoveModifierByName("modifier_imba_gyrocopter_homing_missile_target")
	--获得视野
	self:CreateVisibilityNode(target:GetAbsOrigin(), 400, self:GetSpecialValueFor("enemy_vision_time"))
	--------------------------------------------------------------------------------------------------------
	--延时0.3S 召唤一个飞弹攻击
	--标记特效
	----------------------------------------------------
	local calldown_radius = self:GetSpecialValueFor("calldown_radius")
	local marker_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(marker_pfx, 0, vlocation)
	ParticleManager:SetParticleControl(marker_pfx, 1, Vector(calldown_radius, 1, calldown_radius * (-1)))
	ParticleManager:ReleaseParticleIndex(marker_pfx)
	----------------------------------------------------
	--标记音效
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	--飞弹特效
	local calldown_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_pfx, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_pfx, 1, vlocation)
	ParticleManager:SetParticleControl(calldown_pfx, 5, Vector(calldown_radius, calldown_radius, calldown_radius))
	ParticleManager:ReleaseParticleIndex(calldown_pfx)
	--飞弹音效
	EmitSoundOnLocationWithCaster(vlocation, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	Timers:CreateTimer(1.6,function()
			--AOE
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				vlocation, 
				nil, 
				self:GetSpecialValueFor("calldown_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for _, enemy in pairs(enemies) do
				--不会对魔免单位造成DEBUFF
				if not enemy:IsMagicImmune() then
					--减速麻痹
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("stun_duration")})
					--伤害
					ApplyDamage(
						{
						victim 			= enemy,
						damage 			= self:GetAbilityDamage()/2 + self:GetSpecialValueFor("attr_scale") * self:GetCaster():GetStrength(),
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self						
					}
					)
				end
			end
		return nil
	end)
end

modifier_imba_gyrocopter_homing_missile_target = class({})

function modifier_imba_gyrocopter_homing_missile_target:IsDebuff()			return true end
function modifier_imba_gyrocopter_homing_missile_target:RemoveOnDeath() 	return true end
function modifier_imba_gyrocopter_homing_missile_target:IsHidden() 			return true end
function modifier_imba_gyrocopter_homing_missile_target:IsPurgable() 		return false end
function modifier_imba_gyrocopter_homing_missile_target:IsPurgeException()	return false end
function modifier_imba_gyrocopter_homing_missile_target:GetEffectName()		return "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf" end
function modifier_imba_gyrocopter_homing_missile_target:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_gyrocopter_homing_missile_target:CheckState() 			return {[MODIFIER_STATE_PROVIDES_VISION] = true} end

modifier_imba_gyrocopter_homing_missile_caster = class({})

function modifier_imba_gyrocopter_homing_missile_caster:IsDebuff()			return false end
function modifier_imba_gyrocopter_homing_missile_caster:IsHidden() 		return true end
function modifier_imba_gyrocopter_homing_missile_caster:IsPurgable() 		return false end
function modifier_imba_gyrocopter_homing_missile_caster:IsPurgeException() return false end
function modifier_imba_gyrocopter_homing_missile_caster:OnCreated(keys)
		self.speed = self:GetAbility():GetSpecialValueFor("speed") or 1000
	if IsServer() then
		self.hero_damage = self:GetAbility():GetSpecialValueFor("hero_damage") or 1000
		self.target = EntIndexToHScript(keys.hTarget)
		--音效
		self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile")
		self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Enemy")
		--导弹特效
		local missile_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(missile_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_fuse", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(missile_pfx, false, false, -1, false, false)
		--加速
		self:StartIntervalThink(0.2)
	end
end
--逐渐加速
function modifier_imba_gyrocopter_homing_missile_caster:OnIntervalThink()
	--目标提前被击杀
	if not IsServer() then return end
	if self.target:IsNull() or not self.target:IsAlive() then
		self:Destroy()
		return
	end
	--加速
	self:SetStackCount(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("acceleration"))
	--判断是否与目标碰撞
	if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= 200 or self.target:IsInvisible() then
		--导弹攻击到目标
		--self:GetAbility():Missile_CallDown(self.target:entindex(),self:GetParent():GetAbsOrigin())
		self:GetAbility():Missile_CallDown(self.target,self:GetParent():GetAbsOrigin())
		self:Destroy()
	end
end
--飞行和穿越单位状态
function modifier_imba_gyrocopter_homing_missile_caster:CheckState() return {[MODIFIER_STATE_FLYING] = true,[MODIFIER_STATE_NO_UNIT_COLLISION] = true,[MODIFIER_STATE_IGNORING_STOP_ORDERS] = true} end
function modifier_imba_gyrocopter_homing_missile_caster:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,MODIFIER_PROPERTY_MOVESPEED_LIMIT,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_gyrocopter_homing_missile_caster:GetModifierMoveSpeed_Absolute() return self.speed + self:GetStackCount() end
function modifier_imba_gyrocopter_homing_missile_caster:GetModifierMoveSpeed_Limit() return self.speed + self:GetStackCount() end
function modifier_imba_gyrocopter_homing_missile_caster:GetModifierHPRegenAmplify_Percentage() return -100 end
function modifier_imba_gyrocopter_homing_missile_caster:GetModifierIncomingDamage_Percentage() return -10000 end
function modifier_imba_gyrocopter_homing_missile_caster:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end
	--导弹被攻击
	local dmg = 1
	if keys.attacker:IsTrueHero() then 
		dmg = self.hero_damage
	elseif keys.attacker:IsBuilding() then
		dmg = self.hero_damage/2
	end
	if self:GetParent():GetHealth() - dmg <= 0 then
		self:Destroy()
		self:GetParent():Kill(nil, keys.attacker)
	else
		self:GetParent():SetHealth(self:GetParent():GetHealth() - dmg)
	end
end

function modifier_imba_gyrocopter_homing_missile_caster:OnDestroy()
	if IsServer() then
		self.hero_damage = nil 
		self.target = nil
		self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile")
		self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy")
		self:GetParent():RemoveSelf()
	end
end

--gyrocopter_helicopter_form 武装直升机形态
--矮人直升机进行武装展开后，以毁灭性的火力对区域目标进行打击。
--开启期间火箭弹幕，追踪导弹，高射火炮得到强化。
--获得攻击距离提升，攻击护甲穿透，获得飞行和穿越树林效果，但是攻击速度降低，移动速度降低5%abilityduration%%
--imba 强化火箭弹幕：火箭弹幕范围扩增至%abilityduration%,冷却减少至%%,耗蓝降低至%%
--imba 强化追踪导弹：冷却减少至%abilityduration%秒，耗蓝降低至%abilityduration%
--imba 强化高射火炮：攻击次数翻倍
--imba 侧翼机枪：额外获得一挺额外的侧翼机枪，攻击间隔%%，攻击范围%%，与神帐效果叠加
--imba 轰炸区：在武装展开持续期间，飞机每间隔%duration%向周围投下炸弹造成%abilityduration%伤害,%%abilityduration%%麻痹

LinkLuaModifier("modifier_imba_gyrocopter_helicopter_form_caster","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_helicopter_form_debuff","ability/abilities_lua/hero_gyrocopter.lua", LUA_MODIFIER_MOTION_NONE)

imba_gyrocopter_helicopter_form_a = class({})

function imba_gyrocopter_helicopter_form_a:IsHiddenWhenStolen()  	return false end
function imba_gyrocopter_helicopter_form_a:IsRefreshable()			return true end
function imba_gyrocopter_helicopter_form_a:IsStealable() 			return true end
function imba_gyrocopter_helicopter_form_a:IsNetherWardStealable() return false end
function imba_gyrocopter_helicopter_form_a:OnSpellStart()
	local caster = self:GetCaster()
	--音效
	caster:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
	--add modifier
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_gyrocopter_helicopter_form_caster", -- modifier name
		{ duration = self:GetDuration() + self:GetCaster():GetTalentValue("special_bonus_imba_gyrocopter_2")} -- kv
	)

	if caster:HasModifier("modifier_gyrocopter_flak_cannon") then 
		caster:SetModifierStackCount("modifier_gyrocopter_flak_cannon", nil, caster:GetModifierStackCount("modifier_gyrocopter_flak_cannon", nil) + 12)
	else
		local flak_ability = caster:FindAbilityByName("gyrocopter_flak_cannon")
		if flak_ability and flak_ability:GetLevel() > 0 then
			flak_ability:OnSpellStart() 
			caster:SetModifierStackCount("modifier_gyrocopter_flak_cannon", nil, caster:GetModifierStackCount("modifier_gyrocopter_flak_cannon", nil) + flak_ability:GetSpecialValueFor("max_attacks"))			
		end
	end
end

imba_gyrocopter_helicopter_form_s = class({})

function imba_gyrocopter_helicopter_form_s:IsHiddenWhenStolen()  	return false end
function imba_gyrocopter_helicopter_form_s:IsRefreshable()			return true end
function imba_gyrocopter_helicopter_form_s:IsStealable() 			return true end
function imba_gyrocopter_helicopter_form_s:IsNetherWardStealable() return false end
function imba_gyrocopter_helicopter_form_s:OnSpellStart()
	local caster = self:GetCaster()
	--音效
	caster:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
	--add modifier
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_gyrocopter_helicopter_form_caster", -- modifier name
		{ duration = self:GetDuration() + self:GetCaster():GetTalentValue("special_bonus_imba_gyrocopter_2")} -- kv
	)

	if caster:HasModifier("modifier_gyrocopter_flak_cannon") then 
		caster:SetModifierStackCount("modifier_gyrocopter_flak_cannon", nil, caster:GetModifierStackCount("modifier_gyrocopter_flak_cannon", nil) + 12)
	else
		local flak_ability = caster:FindAbilityByName("gyrocopter_flak_cannon")
		if flak_ability and flak_ability:GetLevel() > 0 then
			flak_ability:OnSpellStart() 
			caster:SetModifierStackCount("modifier_gyrocopter_flak_cannon", nil, caster:GetModifierStackCount("modifier_gyrocopter_flak_cannon", nil) + flak_ability:GetSpecialValueFor("max_attacks"))			
		end
	end
end

modifier_imba_gyrocopter_helicopter_form_caster = class({})

function modifier_imba_gyrocopter_helicopter_form_caster:IsDebuff()			return false end
function modifier_imba_gyrocopter_helicopter_form_caster:IsHidden() 			return false end
function modifier_imba_gyrocopter_helicopter_form_caster:IsPurgable() 		return false end
function modifier_imba_gyrocopter_helicopter_form_caster:IsPurgeException()  return false end
function modifier_imba_gyrocopter_helicopter_form_caster:GetEffectName() return "particles/units/heroes/hero_gyrocopter/helicopter_form_self_d.vpcf" end
function modifier_imba_gyrocopter_helicopter_form_caster:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_gyrocopter_helicopter_form_caster:OnCreated(keys)
	if IsServer() then 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.calldown_radius = self:GetAbility():GetSpecialValueFor("calldown_radius")
		self.calldown_damage = self:GetAbility():GetSpecialValueFor("calldown_damage")
		self.attr_scale = self:GetAbility():GetSpecialValueFor("attr_scale")
		if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_5") then 
			self.calldown_damage = self:GetCaster():GetTalentValue("special_bonus_imba_gyrocopter_5")
		end
		--武装特效
		----------------------------------
		self.marker_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.marker_pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.marker_pfx, 1, Vector(self.radius, 1, self.radius * (-1)))
		self:AddParticle(self.marker_pfx, false, false, -1, false, false)
		----------------------------------
		self:StartIntervalThink(1)
	end
end
--侧翼机枪 & 轰炸区
function modifier_imba_gyrocopter_helicopter_form_caster:OnIntervalThink()
	if not IsServer() then return end 
	--侧翼机枪
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
		FIND_FARTHEST, 
		false)
	for _, enemy in pairs(enemies) do
		--攻击一次
		if not enemy:IsInvisible() and not enemy:IsInvulnerable() then
			self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false) 
			break
		end
	end
	--轰炸区
	for _, enemy in pairs(enemies) do
		if not enemy:IsInvisible() and not enemy:IsInvulnerable() then
			--飞弹特效
			local calldown_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, enemy)
			ParticleManager:SetParticleControl(calldown_pfx, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
			ParticleManager:SetParticleControl(calldown_pfx, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(calldown_pfx, 5, Vector(calldown_radius, calldown_radius, calldown_radius))
			ParticleManager:ReleaseParticleIndex(calldown_pfx)
			--飞弹音效
			--EmitSoundOnLocationWithCaster(farthest_enemy:GetAbsOrigin(), "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
			--AOE
			local units = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				enemy:GetAbsOrigin(), 
				nil, 
				self.calldown_radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for _, unit in pairs(units) do
				--不会对魔免单位造成DEBUFF
				if not unit:IsMagicImmune() then
					--减速麻痹
					unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_paralyzed", {duration = 1})
					--伤害
					local damageTable = {
					victim 			= unit,
					damage 			= self.calldown_damage + self.attr_scale*self:GetCaster():GetStrength(),
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetParent(),
					ability 		= self:GetAbility()
					}
					ApplyDamage(damageTable)
				end
			end
			if not self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_5") then
				break
			end
		end
	end
end
--飞行和穿越树林效果
function modifier_imba_gyrocopter_helicopter_form_caster:CheckState() return {[MODIFIER_STATE_FLYING] = true,[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
--攻击距离提升 攻击速度降低 移动速度限制 抗性
function modifier_imba_gyrocopter_helicopter_form_caster:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_imba_gyrocopter_helicopter_form_caster:GetModifierAttackRangeBonus() return self:GetAbility():GetSpecialValueFor("attack_range") end
function modifier_imba_gyrocopter_helicopter_form_caster:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_speed_slow")) end
function modifier_imba_gyrocopter_helicopter_form_caster:GetModifierMoveSpeed_Absolute() 
	 if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_1") then 
	 	return 
	 end
		return self:GetAbility():GetSpecialValueFor("move_speed")  
end
function modifier_imba_gyrocopter_helicopter_form_caster:GetModifierMoveSpeed_Limit()
	 if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_1") then 
	 	return 
	 end
		return self:GetAbility():GetSpecialValueFor("move_speed")  
end
function modifier_imba_gyrocopter_helicopter_form_caster:GetModifierStatusResistanceStacking() return self:GetAbility():GetSpecialValueFor("status_resistance") end
--攻击穿透
function modifier_imba_gyrocopter_helicopter_form_caster:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not keys.target:IsAlive() then
		return
	end
	keys.target:AddNewModifier(self:GetCaster(), 
			self:GetAbility(), 
			"modifier_imba_gyrocopter_helicopter_form_debuff", 
			{duration = 3}
	)
end

--DEBUFF穿透
modifier_imba_gyrocopter_helicopter_form_debuff = class({})

function modifier_imba_gyrocopter_helicopter_form_debuff:IsDebuff()				return true end
function modifier_imba_gyrocopter_helicopter_form_debuff:IsHidden() 			return false end
function modifier_imba_gyrocopter_helicopter_form_debuff:IsPurgable() 			return false end
function modifier_imba_gyrocopter_helicopter_form_debuff:IsPurgeException() 	return false end
function modifier_imba_gyrocopter_helicopter_form_debuff:DeclareFunctions() 	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_gyrocopter_helicopter_form_debuff:GetModifierPhysicalArmorBonus() return (0 - self:GetAbility():GetSpecialValueFor("armor_penetration")) end