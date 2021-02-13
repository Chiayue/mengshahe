CreateEmptyTalents("earthshaker")

imba_earthshaker_fissure = class({})

function imba_earthshaker_fissure:IsHiddenWhenStolen() 		return false end
function imba_earthshaker_fissure:IsRefreshable() 			return true end
function imba_earthshaker_fissure:IsStealable() 			return true end
function imba_earthshaker_fissure:IsNetherWardStealable()	return true end
function imba_earthshaker_fissure:GetCastRange() return self:GetSpecialValueFor("fissure_range") end
function imba_earthshaker_fissure:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_earthshaker_3") then 
		return (cooldown - caster:GetTalentValue("special_bonus_imba_earthshaker_3"))
	end
	return cooldown
end

function imba_earthshaker_fissure:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local length = self:GetSpecialValueFor("fissure_range") + caster:GetCastRangeBonus()
	local pos0 = caster:GetAbsOrigin() + direction * 128
	local pos1 = caster:GetAbsOrigin() + direction * (length + 128)
	local angle = 360 / 1--self:GetSpecialValueFor("number")
	local total = (length / 80)
	local sound_name = "Hero_EarthShaker.Fissure"
	local pfx_name = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	-- if HeroItems:UnitHasItem(caster, "earthshaker/ti9_immortal") then
	-- 	pfx_name = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9_lvl2.vpcf"
	-- elseif HeroItems:UnitHasItem(caster, "totem_dragon.vmdl") then
		pfx_name = "particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_gravelmaw_gold.vpcf"
		sound_name = "Hero_EarthShaker.Gravelmaw.Cast"
	-- elseif HeroItems:UnitHasItem(caster, "eges_totem.vmdl") then
	-- 	pfx_name = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_egset.vpcf"
	-- end
	for i=0, (self:GetSpecialValueFor("number") - 1) do  
		local pos_start = pos0
		local pos_end = pos1
		if i ~= 0 then
			pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * i, 0), pos0)
			pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * i, 0), pos1)
		end
		local direc = (pos_end - pos_start):Normalized()
		direc.z = 0
		local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
		sound:EmitSound(sound_name)
		if i == 0 then
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, pos_start)
			ParticleManager:SetParticleControl(pfx, 1, pos_end)
			if caster:HasModifier("modifier_imba_earthshaker_enchant_totem_yidong") then
				ParticleManager:SetParticleControl(pfx, 2, Vector(0.5, 0, 0))
			else
				ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("fissure_duration"), 0, 0))
			end	
			ParticleManager:ReleaseParticleIndex(pfx)
			for j = 0, total do
				if caster:HasModifier("modifier_imba_earthshaker_enchant_totem_yidong") then
					local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 0.5, destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
					block:SetHullRadius(80)
				else
					local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
					block:SetHullRadius(80)
				end	
			end
			local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for k = 1, #enemy do
				if not enemy[k]:IsMagicImmune() then  
					enemy[k]:AddNewModifier(caster, self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
				else
					enemy[k]:AddNewModifier(caster, self, "modifier_imba_stunned", {duration = 1})	--对魔免造成1秒眩晕
				end	

				if self:GetCaster():HasAbility("imba_earthshaker_aftershock") then
					if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and not enemy[k]:IsMagicImmune() then --检测开关，添加沉默和锁闭
						enemy[k]:AddNewModifier(caster, self, "modifier_imba_silenced", {duration = self:GetSpecialValueFor("stun_duration") + 2 })
						enemy[k]:AddNewModifier(caster, self, "modifier_imba_muted", {duration = self:GetSpecialValueFor("stun_duration") + 2 })
					end
					if not enemy[k]:IsMagicImmune() then	
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
					end
					if enemy[k]:IsAttackImmune() then  --对虚无造成1.5倍伤害
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("damage") * 1.5, damage_type = self:GetAbilityDamageType(), ability = self})
					end
				end	
			end
		end
		--[[if i ~= 0 then
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, pos_start)
			ParticleManager:SetParticleControl(pfx, 1, pos_end)
			ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("secondary_duration"), 0, 0))
			ParticleManager:ReleaseParticleIndex(pfx)
			for j = 0, total do
				local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetSpecialValueFor("secondary_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
				block:SetHullRadius(80)
			end
			local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
			for k = 1, #enemy do
				enemy[k]:AddNewModifier(caster, self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("secondary_stun")})
				ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("secondary_damage"), damage_type = self:GetAbilityDamageType(), ability = self})
			end
		end]]
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, length * 1.3, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		FindClearSpaceForUnit(enemy[i], enemy[i]:GetAbsOrigin(), true)
		enemy[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})  --添加相位修饰器？
	end
	caster:EmitSound(sound_name)
end

imba_earthshaker_aftershock = class({})
function imba_earthshaker_aftershock:IsHiddenWhenStolen() 		return true end
function imba_earthshaker_aftershock:IsRefreshable() 			return true end
function imba_earthshaker_aftershock:IsStealable() 				return false end
function imba_earthshaker_aftershock:IsNetherWardStealable()	return false end
function imba_earthshaker_aftershock:GetCastRange() 			return self:GetSpecialValueFor("aftershock_range") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_1") - self:GetCaster():GetCastRangeBonus() end
function imba_earthshaker_aftershock:ResetToggleOnRespawn() 	return false end
--[[function imba_earthshaker_aftershock:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:GetTalentValue("special_bonus_imba_earthshaker_1")
	local  Getcd = cooldown - Talent
	if caster:HasTalent("special_bonus_imba_earthshaker_1") then 
		return (Getcd)
	end
end]]
LinkLuaModifier("modifier_imba_earthshaker_aftershock", "hero/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_earthshaker_aftershock_huiyinbi", "hero/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)

function imba_earthshaker_aftershock:GetIntrinsicModifierName() return "modifier_imba_earthshaker_aftershock" end--是否默认拥有
function imba_earthshaker_aftershock:OnOwnerDied()
	self.toggle = self:GetToggleState()
end

function imba_earthshaker_aftershock:OnOwnerSpawned()
	if self.toggle == nil then
		self:ToggleAbility()
		self.toggle = true
	end
	if self.toggle ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_earthshaker_aftershock:OnToggle()
	self.toggle = self:GetToggleState()
	self:EndCooldown()
end



modifier_imba_earthshaker_aftershock = class({}) 

function modifier_imba_earthshaker_aftershock:IsDebuff()			return false end
function modifier_imba_earthshaker_aftershock:IsHidden() 			return true end
function modifier_imba_earthshaker_aftershock:IsPurgable() 		return false end
function modifier_imba_earthshaker_aftershock:IsPurgeException() 	return false end
function modifier_imba_earthshaker_aftershock:IsRefreshable() 			return true end
function modifier_imba_earthshaker_aftershock:IsHiddenWhenStolen() 		return true end
function modifier_imba_earthshaker_aftershock:IsRefreshable() 			return true end
function modifier_imba_earthshaker_aftershock:IsStealable() 				return false end
function modifier_imba_earthshaker_aftershock:IsNetherWardStealable()	return false end
function modifier_imba_earthshaker_aftershock:ResetToggleOnRespawn() 	return false end
function modifier_imba_earthshaker_aftershock:GetCastRange() 			return self:GetSpecialValueFor("aftershock_range") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_1")end
function modifier_imba_earthshaker_aftershock:DeclareFunctions() 
	return{MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}  
end

function modifier_imba_earthshaker_aftershock:OnOwnerDied() 
	self:GetParent():RemoveModifierByName("modifier_imba_earthshaker_aftershock")
end
function modifier_imba_earthshaker_aftershock:OnOwnerSpawned()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_aftershock", {})
end	
function modifier_imba_earthshaker_aftershock:OnDestroy()
	if self:GetParent():HasModifier("modifier_imba_earthshaker_aftershock") then
	self:GetParent():RemoveModifierByName("modifier_imba_earthshaker_aftershock")
end
end

function modifier_imba_earthshaker_aftershock:OnAbilityFullyCast( params )
	
	local onopen = self:GetCaster():HasAbility("imba_earthshaker_aftershock") and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState()
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_1")
	
	if IsServer() and not self:GetParent():PassivesDisabled() then
		--if self:GetParent():GetName() == "npc_dota_hero_earthshaker" then
			if self:GetParent():HasScepter() and params.ability:GetAbilityName() == "imba_earthshaker_enchant_totem"  then  --拥有a杖时 返回
				return
			end
			--print(params.ability:GetAbilityName())
			if params.unit ~= self:GetParent() or params.ability:IsItem() then 
				return 
			end
 			local IsTriggerByAbility = {
 				["wisp_spirits_in"] = true,
				["imba_kunkka_return"] = true,
				["imba_nyx_assassin_burrow"] = true,
				["imba_nyx_assassin_unburrow"] = true,
				["shadow_demon_shadow_poison_release"] = true,
				["imba_ember_spirit_activate_fire_remnant"] = true, 
				["imba_bane_nightmare_end"] = true,
				["morphling_morph_replicate"] = true,
				["ability_capture"] = true, 
			}
			if not IsTriggerByAbility[params.ability:GetAbilityName()] then
				
				self:CastAftershock()  --运行余震
				if IsServer() and not self:GetParent():PassivesDisabled() and not onopen and self:GetAbility():IsCooldownReady() then  --不在cd时运行地质形成
					if params.unit ~= self:GetParent() or params.ability:IsItem() then return end	
					self:Aftershockspecial() --运行地质生成
				end 
			end	
		--end	                  
	end
			
end
function modifier_imba_earthshaker_aftershock:Aftershockspecial()  --地质生成
		local caster = self:GetCaster()
		local direction = caster:GetForwardVector():Normalized()
		local length = self:GetAbility():GetSpecialValueFor("fissure_range") + caster:GetCastRangeBonus()
		local pos0 = caster:GetAbsOrigin() + direction * 128
		local pos1 = caster:GetAbsOrigin() + direction * (length + 128)
		local angle = 360 / self:GetAbility():GetSpecialValueFor("number")
		local total = (length / 80)
		local sound_name = "Hero_EarthShaker.Fissure"
		local pfx_name = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
		-- if HeroItems:UnitHasItem(caster, "earthshaker/ti9_immortal") then
		-- 	pfx_name = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9_lvl2.vpcf"
		-- elseif HeroItems:UnitHasItem(caster, "totem_dragon.vmdl") then
			pfx_name = "particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_gravelmaw_gold.vpcf"
			sound_name = "Hero_EarthShaker.Gravelmaw.Cast"
		-- elseif HeroItems:UnitHasItem(caster, "eges_totem.vmdl") then
		-- 	pfx_name = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_egset.vpcf"
		-- end

		Timers:CreateTimer(0.03, function()  --不同步运行各个沟壑效果，减少卡顿

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 1, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 1, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)
		Timers:CreateTimer(0.06, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 2, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 2, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0.15, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 3, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 3, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0.06, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 4, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 4, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0.03, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 5, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 5, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 6, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 6, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
			
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)		
		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, length * 1.3, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i=1, #enemy do
			FindClearSpaceForUnit(enemy[i], enemy[i]:GetAbsOrigin(), true)
			enemy[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
		end
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())  --运行后进入cd
		caster:EmitSound(sound_name)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_aftershock_huiyinbi", {duration = 2})  --添加回音壁修饰器（仅仅作为标识用）
end	
	
function modifier_imba_earthshaker_aftershock:CastAftershock()  --余震
	if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState()  then --全部打开
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		for _,enemy in pairs(enemies) do
			
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_paralyzed", {duration = self:GetAbility():GetSpecialValueFor("aftershock_stun_duration") * 2}) --2倍眩晕持续时间
				self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, true)			
		end
		Timers:CreateTimer(FrameTime(), function()self:PlayEffects()end)
	else
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)	
		for _,enemy in pairs(enemies) do
			
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_stunned", {duration = self:GetAbility():GetSpecialValueFor("aftershock_stun_duration")})
			ApplyDamage({attacker = self:GetCaster(), victim = enemy, damage = self:GetAbility():GetSpecialValueFor("aftershock_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
		end
		Timers:CreateTimer(FrameTime(), function()self:PlayEffects()end)
	end			
end

function modifier_imba_earthshaker_aftershock:PlayEffects()
	-- if not HeroItems:UnitHasItem(self:GetCaster(), "earthshaker_arcana") then
	local particle_cast = "particles/xiaoniu/earthshaker_aftershock.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	-- else
	-- local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )
	-- end	
end
modifier_imba_earthshaker_aftershock_huiyinbi = class({}) --回音壁修饰器
function modifier_imba_earthshaker_aftershock_huiyinbi:IsDebuff()			return false end
function modifier_imba_earthshaker_aftershock_huiyinbi:IsHidden() 			return true end
function modifier_imba_earthshaker_aftershock_huiyinbi:IsPurgable() 			return false end
function modifier_imba_earthshaker_aftershock_huiyinbi:IsPurgeException() 	return false end
	









imba_earthshaker_echo_slam	= class({})
--[[LinkLuaModifier("modifier_imba_earthshaker_echo_slam", "hero/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 

modifier_imba_earthshaker_echo_slam = class({}) 
function modifier_imba_earthshaker_echo_slam:IsDebuff()			return false end
function modifier_imba_earthshaker_echo_slam:IsHidden() 			return true end
function modifier_imba_earthshaker_echo_slam:IsPurgable() 			return false end
function modifier_imba_earthshaker_echo_slam:IsPurgeException() 	return false end
function modifier_imba_earthshaker_echo_slam:DeclareFunctions() 
	return{MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}  
end
function modifier_imba_earthshaker_echo_slam:OnAbilityFullyCast( params )
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("imba_earthshaker_echo_slam")
		if params.ability:GetAbilityName() == "imba_earthshaker_echo_slam" then
			params.ability:StartCooldown((params.ability:GetCooldown(-1)*0.1) * self:GetParent():GetCooldownReduction())
		end	
	end	
end]]		



function imba_earthshaker_echo_slam:IsHiddenWhenStolen() 		return false end
function imba_earthshaker_echo_slam:IsRefreshable() 			return true end
function imba_earthshaker_echo_slam:IsStealable() 			return true end
function imba_earthshaker_echo_slam:IsNetherWardStealable()	return true end
--function imba_earthshaker_echo_slam:GetIntrinsicModifierName() return "modifier_imba_earthshaker_echo_slam" end
function imba_earthshaker_echo_slam:GetCastRange() 			return self:GetSpecialValueFor("echo_slam_damage_echo_range") - self:GetCaster():GetCastRangeBonus() end
function imba_earthshaker_echo_slam:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local cooldown2 = self.BaseClass.GetCooldown(self, level) * 0.1
	local caster = self:GetCaster()
	if IsServer() and caster:HasAbility( "imba_earthshaker_aftershock")   then
	local huiyin = caster:FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and caster:FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState()
	if huiyin then 
		return cooldown2
	end
	end

	return cooldown
end

function imba_earthshaker_echo_slam:OnSpellStart()
	-- if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState() then
	-- 	return
	-- end	
	local hero_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("echo_slam_damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #hero_enemies > 0 then
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlam")
	else
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlamSmall")
	end
	Timers:CreateTimer(0.5, function()
		if self:GetCaster():GetName() == "npc_dota_hero_earthshaker" then
			if #hero_enemies == 2 then
				local random_response	= RandomInt(1, 4)
				if random_response >= 3 then random_response = random_response + 1 end				
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..random_response)
			elseif #hero_enemies >= 3 then
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_03")
			elseif #hero_enemies == 0 then
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..(RandomInt(6, 7)))
			end
		end
	end) 
	if self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock_huiyinbi")   then --检测是否2秒前释放了地质形成
		if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState() then
			echo_slam_range  = self:GetSpecialValueFor("echo_slam_damage_echo_range") * 1.6   --1.6倍范围
		else
			echo_slam_range  = self:GetSpecialValueFor("echo_slam_damage_echo_range") *1.3
		end
	else
			echo_slam_range  = self:GetSpecialValueFor("echo_slam_damage_echo_range")	
	end
	--print(echo_slam_range)		
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, echo_slam_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	local effect_counter = 0

	for _, enemy in pairs(enemies) do		
		local damageTable = {
			victim 			= enemy,
			damage 			= self:GetSpecialValueFor("echo_slam_initial_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		if enemy:IsTrueHero() then
		local pfx_screen = ParticleManager:CreateParticleForPlayer("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy, PlayerResource:GetPlayer(enemy:GetPlayerID()))
			ParticleManager:ReleaseParticleIndex(pfx_screen)
		end
		if echo_slam_range == self:GetSpecialValueFor("echo_slam_damage_echo_range") * 1.6 then  --产生1.6倍范围时，额外添加混乱麻痹效果
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("paralyzed_duration")})	
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_confuse", {duration = self:GetSpecialValueFor("confuse_duration")})
		end	
		ApplyDamage(damageTable)
		
		local echo_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), nil, echo_slam_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _, echo_enemy in pairs(echo_enemies) do
			if echo_enemy ~= enemy then
				echo_enemy:EmitSound("Hero_EarthShaker.EchoSlamEcho")				
				-- if not HeroItems:UnitHasItem(self:GetCaster(), "earthshaker_arcana") then   --是否拥有至宝
					ProjectileManager:CreateTrackingProjectile(
					{
						Target 				= echo_enemy,
						Source 				= enemy,
						Ability 			= self,
						EffectName 			= "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
						iMoveSpeed			= 1100,
						vSourceLoc 			= enemy:GetAbsOrigin(),
						bDrawsOnMinimap 	= false,
						bDodgeable 			= false,
						bIsAttack 			= false,
						bVisibleToEnemies 	= true,
						bReplaceExisting 	= false,
						flExpireTime 		= GameRules:GetGameTime() + 10.0,
						bProvidesVision 	= false,

						ExtraData = {
							damage = self:GetSpecialValueFor("echo_slam_echo_damage") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_4")
						}
					})
				-- else
					-- ProjectileManager:CreateTrackingProjectile(
					-- {
					-- 	Target 				= echo_enemy,
					-- 	Source 				= enemy,
					-- 	Ability 			= self,
					-- 	EffectName 			= "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_proj_v2.vpcf",
					-- 	iMoveSpeed			= 1100,
					-- 	vSourceLoc 			= enemy:GetAbsOrigin(),
					-- 	bDrawsOnMinimap 	= false,
					-- 	bDodgeable 			= false,
					-- 	bIsAttack 			= false,
					-- 	bVisibleToEnemies 	= true,
					-- 	bReplaceExisting 	= false,
					-- 	flExpireTime 		= GameRules:GetGameTime() + 10.0,
					-- 	bProvidesVision 	= false,

					-- 	ExtraData = {
					-- 		damage = self:GetSpecialValueFor("echo_slam_echo_damage") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_4")
					-- 	}
					-- })
				-- end



				if echo_enemy:IsRealHero() then --英雄反弹两次
					effect_counter = effect_counter + 1
					ProjectileManager:CreateTrackingProjectile(projectile)
					-- if HeroItems:UnitHasItem(self:GetCaster(), "earthshaker_arcana") then  --是否拥有至宝
						Timers:CreateTimer(0.1, function()
							local echo_slam_death_pfx = ParticleManager:CreateParticle(self:GetCaster().echo_slam_tgt_pfx or "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_ground_v2.vpcf", PATTACH_ABSORIGIN, echo_enemy)
							ParticleManager:SetParticleControl(echo_slam_death_pfx, 6, Vector(math.min(effect_counter, 1), math.min(effect_counter, 1), math.min(effect_counter, 1)))
							ParticleManager:SetParticleControl(echo_slam_death_pfx, 10, Vector(4, 0, 0)) -- earth particle duration
							ParticleManager:ReleaseParticleIndex(echo_slam_death_pfx)
						end)
					-- end	
				end
			end
		end
	end
	-- if not HeroItems:UnitHasItem(self:GetCaster(), "earthshaker_arcana") then  --是否拥有至宝
	-- 	local echo_slam_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- 	ParticleManager:SetParticleControl(echo_slam_particle, 10, Vector(4, 0, 0)) 
	-- 	ParticleManager:SetParticleControl(echo_slam_particle, 11, Vector(math.min(effect_counter, 1), math.min(effect_counter, 1), 0 )) 
	-- 	ParticleManager:ReleaseParticleIndex(echo_slam_particle)
	-- else 	
		local echo_slam_particle = ParticleManager:CreateParticle("particles/xiaoniu/earthshaker_arcana_echoslam_start_v2.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(echo_slam_particle, 10, Vector(4, 0, 0)) 
		ParticleManager:SetParticleControl(echo_slam_particle, 11, Vector(math.min(effect_counter, 1), math.min(effect_counter, 1), 0 )) 
		ParticleManager:ReleaseParticleIndex(echo_slam_particle)
	-- end	
end

function imba_earthshaker_echo_slam:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	if target and not target:IsMagicImmune() then
		local damageTable = {
			victim 			= target,
			damage 			= data.damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		
		ApplyDamage(damageTable)
	end
end



imba_earthshaker_enchant_totem = class({})
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff", "ability/abilities_lua/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_yidong", "ability/abilities_lua/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_atbo", "ability/abilities_lua/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_sabo", "ability/abilities_lua/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_cdbo", "ability/abilities_lua/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )

function imba_earthshaker_enchant_totem:IsDebuff()			return false end
function imba_earthshaker_enchant_totem:IsHidden() 			return true end
function imba_earthshaker_enchant_totem:IsPurgable() 			return false end
function imba_earthshaker_enchant_totem:IsPurgeException() 	return false end 
function imba_earthshaker_enchant_totem:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function imba_earthshaker_enchant_totem:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)  --减少强化图腾cd天赋
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_earthshaker_5") then 
		return (cooldown - caster:GetTalentValue("special_bonus_imba_earthshaker_5"))
	end
	return cooldown
end



function imba_earthshaker_enchant_totem:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT --a杖改变技能释放效果
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function imba_earthshaker_enchant_totem:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("Scepter_Range")
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

function imba_earthshaker_enchant_totem:CastFilterResultLocation(vLocation)  --缠绕不能释放
	if self:GetCaster():HasScepter() and self:GetCaster():IsRooted() then
		return UF_FAIL_CUSTOM
	end
end

function imba_earthshaker_enchant_totem:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_ability_disabled_by_root"
end

function imba_earthshaker_enchant_totem:CastFilterResultTarget(target)
	if target ~= self:GetCaster() then
		return UF_FAIL_OBSTRUCTED
	end
end

function imba_earthshaker_enchant_totem:OnAbilityPhaseStart()  --有a杖施法前摇为0
 
	if 	self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() then
		self:SetOverrideCastPoint(0)
	end
	
	return true  
end

function imba_earthshaker_enchant_totem:OnSpellStart()  
	--if IsServer() then 
	--	return 
	--end
	
	EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())	
	local pos = self:GetCursorPosition()

	if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() then   --拥有a杖时添加移动修饰器、不添加buff修饰器
		--local buff1 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetSpecialValueFor("buff_duration")})
		--local buff2 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")})
		--local buff3 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetSpecialValueFor("buff_duration")})
		if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_yidong", {duration = 0.6, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_yidong", {duration = 0.9, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
		end		
	else
		if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff") then  --添加前删除已经有的修饰器，达到刷新修饰器效果
			self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff")
		end
		if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_cdbo") then
			self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_cdbo")
		end
		if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_atbo") then
			self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_atbo")
		end
		if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_sabo") then
			self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_sabo")
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff", {duration = self:GetSpecialValueFor("buff_duration")})

		--local buff1 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetSpecialValueFor("buff_duration")})
		--local buff2 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")})
		--local buff3 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetSpecialValueFor("buff_duration")})
		

		if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() then  --根据开关自动施法状态添加不同的修饰器
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetSpecialValueFor("buff_duration")})
		end	


		if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")})
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")}):SetStackCount(self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")}):GetStackCount() + self:GetSpecialValueFor("buff_number") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_2"))
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetSpecialValueFor("buff_duration")})
		end


	--if 	self:GetCaster():HasScepter() and self:GetCaster() == self:GetCursorTarget() then
		--self:SetOverrideCastPoint(0)
		if self:GetCaster():HasModifier("modifier_imba_earthshaker_aftershock") and self:GetCaster():HasScepter() then  --如果有a并且对自身释放则播放余震和地质形成（190行）
			self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):CastAftershock()
			if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):IsCooldownReady() then
				self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):Aftershockspecial()
			end
		end
	self:SetOverrideCastPoint(GetAbilityKV("imba_earthshaker_enchant_totem", "AbilityCastPoint"))		--还原a杖施法前摇	
	--end		








	local pfx2 = ParticleManager:CreateParticle("particles/xiaoniu/earthshaker_totem_ti6_cast_ember.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(pfx2, 0, self:GetCaster(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx2)	
	end	
end
function imba_earthshaker_enchant_totem:OnAbilityFullyCast() 
	 
end	
function imba_earthshaker_enchant_totem:OnDestroy()	
end



modifier_imba_earthshaker_enchant_totem_buff_atbo = class({}) --攻击修饰器
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:DeclareFunctions()return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_EVENT_ON_ATTACK} end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:GetModifierBaseDamageOutgoing_Percentage()
	return (self:GetAbility():GetSpecialValueFor("at_bo"))
end

function modifier_imba_earthshaker_enchant_totem_buff_atbo:GetModifierAttackRangeBonus() 
	return (75) 
end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnCreated()
	--self:SetStackCount("modifier_imba_earthshaker_enchant_totem_buff_atbo", self, self:GetAbility():GetSpecialValueFor("buff_number") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_2"))
end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnAttack( keys )
local caster = self:GetCaster()
if IsServer() then
	if keys.attacker == caster then
			local current_stacks = self:GetStackCount()

			if current_stacks > 1 then
				self:SetStackCount(self:GetStackCount() - 1)
			else
				self:Destroy()
			end
		end
	end
end	



modifier_imba_earthshaker_enchant_totem_buff_sabo = class({}) --技能增强修饰器
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:DeclareFunctions()return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:GetModifierSpellAmplify_Percentage()
	local caster = self:GetCaster() 
	
	if caster:HasTalent("special_bonus_imba_earthshaker_5") then
		return (self:GetAbility():GetSpecialValueFor("sa_bo") * 1.5)
	end
	return (self:GetAbility():GetSpecialValueFor("sa_bo"))	
end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:OnCreated()
	--self:SetStackCount("modifier_imba_earthshaker_enchant_totem_buff_sabo", self, self:GetAbility():GetSpecialValueFor("buff_number") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_2"))
end
--[[function modifier_imba_earthshaker_enchant_totem_buff_sabo:OnAbilityFullyCast( keys )
local caster = self:GetCaster()
if IsServer() then
	--if self:GetParent() == caster then
			local current_stacks = self:GetStackCount()

			if current_stacks > 0 then
				self:SetStackCount(self:GetStackCount() - 1)
			else
				Timers:CreateTimer(2, function()
				self:Destroy()
			end)
		end
	--end	
end	
end]]
modifier_imba_earthshaker_enchant_totem_buff_cdbo = class({}) --减少cd修饰器
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:DeclareFunctions()return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:GetModifierPercentageCooldown()
	local caster = self:GetCaster() 
	
	if caster:HasTalent("special_bonus_imba_earthshaker_5") then
		return  (self:GetAbility():GetSpecialValueFor("cd_bo") * 1.5)
	end
	return (self:GetAbility():GetSpecialValueFor("cd_bo"))
end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:OnCreated()
	--self:SetModifierStackCount("modifier_imba_earthshaker_enchant_totem_buff_cdbo", self, self:GetAbility():GetSpecialValueFor("buff_number") + self:GetCaster():GetTalentValue("special_bonus_imba_earthshaker_2"))
end
--[[function modifier_imba_earthshaker_enchant_totem_buff_cdbo:OnAbilityFullyCast( keys )
local caster = self:GetCaster()
if IsServer() then
	--if self:GetParent() == caster then
			local current_stacks = self:GetStackCount()

			if current_stacks > 1 then
				self:SetStackCount(self:GetStackCount() - 1)
			else
				self:Destroy()
			end
		end
	--end
end	]]

modifier_imba_earthshaker_enchant_totem_buff = class({})
function modifier_imba_earthshaker_enchant_totem_buff:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff:IsHidden() 			return true end
function modifier_imba_earthshaker_enchant_totem_buff:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff:DeclareFunctions()
	return {
--		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, 
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, 
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
--		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, 
--		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
--		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_START,
	}  
end
function modifier_imba_earthshaker_enchant_totem_buff:GetOverrideAnimation()return ACT_DOTA_CAST_ABILITY_2 end




function modifier_imba_earthshaker_enchant_totem_buff:GetModifierBaseDamageOutgoing_Percentage() 
	--if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() then
	--	return (self:GetParent():GetSpecialValueFor("at_bo")) 
	--end	
end
   			
 





function modifier_imba_earthshaker_enchant_totem_buff:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		EmitSoundOn( "Hero_EarthShaker.Totem.Attack", params.target )
		--self:GetParent():RemoveGesture(ACT_DOTA_ATTACK)
		--self:GetParent():StartGesture(ACT_DOTA_ATTACK)
		--self:Destroy()
	end
end


function modifier_imba_earthshaker_enchant_totem_buff:OnCreated( kv )
	if IsServer() then
		self:PlayEffects()
	end
end
function modifier_imba_earthshaker_enchant_totem_buff:OnAttackStart()
--self:GetParent():StartGesture(ACT_DOTA_ATTACK)
end
--function modifier_imba_earthshaker_enchant_totem_buff:GetOverrideAnimation()return ACT_DOTA_ATTACK_STATUE end	


function modifier_imba_earthshaker_enchant_totem_buff:PlayEffects() 
 
	-- if HeroItems:UnitHasItem(self:GetCaster(), "earthshaker/ti6_immortal_bracer") then
		particle_cast ="particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_buff_ti6_combined.vpcf"
	-- else
		-- particle_cast ="particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"	
	-- end

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), 
		true 
	)

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	local effect_cast = ParticleManager:CreateParticle( self:GetParent().enchant_totem_cast_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

modifier_imba_earthshaker_enchant_totem_yidong = class({})  --移动修饰器
function modifier_imba_earthshaker_enchant_totem_yidong:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_yidong:IsHidden() 			return true end
function modifier_imba_earthshaker_enchant_totem_yidong:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_yidong:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_yidong:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_imba_earthshaker_enchant_totem_yidong:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_earthshaker_enchant_totem_yidong:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_earthshaker_enchant_totem_yidong:CheckState()  return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_earthshaker_enchant_totem_yidong:IsMotionController() return true end
function modifier_imba_earthshaker_enchant_totem_yidong:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_imba_earthshaker_enchant_totem_yidong:GetActivityTranslationModifiers()
	return "ultimate_scepter"
end

function modifier_imba_earthshaker_enchant_totem_yidong:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

function modifier_imba_earthshaker_enchant_totem_yidong:OnCreated(keys)
	if IsServer() then	
		-- if HeroItems:UnitHasItem(self:GetCaster(), "earthshaker_arcana") then
			self.blur_effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap_v2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )	
		-- end
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:GetParent():MoveToPosition(self.pos)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length() / (self:GetDuration() / FrameTime() - 2)
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()	
		end
		
	self:GetCaster():FindAbilityByName("imba_earthshaker_fissure"):SetOverrideCastPoint(0)  --飞跃时沟壑前摇为0
	if self:GetParent():HasAbility("imba_earthshaker_echo_slam") then
			self:GetParent():FindAbilityByName("imba_earthshaker_echo_slam"):SetActivated(false)  --飞跃时回音击不可用
		end	
	end
end
function modifier_imba_earthshaker_enchant_totem_yidong:EnchantTotemLand()
	if IsServer() then
		if self.enchant_totem_land_commenced then
			return nil
		end

		if self.blur_effect then
			ParticleManager:DestroyParticle(self.blur_effect, false)
			ParticleManager:ReleaseParticleIndex(self.blur_effect)
		end
		self.enchant_totem_land_commenced = true
	end	
end
function modifier_imba_earthshaker_enchant_totem_yidong:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1)
	local height = 600
	--local pos = self:GetParent():GetCursorPosition()
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.distance, nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	--self:GetParent():MoveToPosition(pos)
	self:GetParent():SetOrigin(next_pos)
end

function modifier_imba_earthshaker_enchant_totem_yidong:OnDestroy()  --移动到目的地后添加buff修饰器（190行）
	if IsServer() then
		self:GetParent():MoveToPositionAggressive(self.pos)
		self:EnchantTotemLand()
			if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff") then
				self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff")
			end
			if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_cdbo") then
				self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_cdbo")
			end
			if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_atbo") then
				self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_atbo")
			end
			if  self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_buff_sabo") then
				self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_enchant_totem_buff_sabo")
			end	
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})



		if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
			--[[self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):SetStackCount(self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):GetStackCount() + self:GetAbility():GetSpecialValueFor("buff_number") + self:GetParent():GetTalentValue("special_bonus_imba_earthshaker_2"))]]
		end	


		if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetAutoCastState() then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):SetStackCount(self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):GetStackCount() + self:GetAbility():GetSpecialValueFor("buff_number") + self:GetParent():GetTalentValue("special_bonus_imba_earthshaker_2"))
		else
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
			--[[self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):SetStackCount(self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")}):GetStackCount() + self:GetAbility():GetSpecialValueFor("buff_number") + self:GetParent():GetTalentValue("special_bonus_imba_earthshaker_2"))]]
		end
			local pfx2 = ParticleManager:CreateParticle("particles/xiaoniu/earthshaker_totem_ti6_cast_ember.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(pfx2, 0, self:GetCaster(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx2)




			if self:GetParent():HasModifier("modifier_imba_earthshaker_aftershock") then  --移动到目的地后添加余震和地质形成修饰器（190行）
				self:GetParent():FindModifierByName("modifier_imba_earthshaker_aftershock"):CastAftershock()
				if not self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):GetToggleState() and self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):IsCooldownReady() then
					self:GetParent():FindModifierByName("modifier_imba_earthshaker_aftershock"):Aftershockspecial()
				end
			end	
		
			self:GetAbility():SetOverrideCastPoint(GetAbilityKV("imba_earthshaker_enchant_totem", "AbilityCastPoint"))  --移动后还原图腾施法前摇
			self:GetCaster():FindAbilityByName("imba_earthshaker_fissure"):SetOverrideCastPoint(GetAbilityKV("imba_earthshaker_fissure", "AbilityCastPoint")) --移动后还原沟壑施法前摇
			if self:GetParent():HasAbility("imba_earthshaker_echo_slam") then
				self:GetParent():FindAbilityByName("imba_earthshaker_echo_slam"):SetActivated(true)  --移动后可用回音击
			end			 	
	end
end 