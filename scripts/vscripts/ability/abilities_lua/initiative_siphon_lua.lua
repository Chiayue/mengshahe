initiative_siphon_lua = class({})
initiative_siphon_lua_d = initiative_siphon_lua
initiative_siphon_lua_c = initiative_siphon_lua
initiative_siphon_lua_b = initiative_siphon_lua
initiative_siphon_lua_a = initiative_siphon_lua
initiative_siphon_lua_s = initiative_siphon_lua

LinkLuaModifier("modifier_initiative_siphon_lua","ability/abilities_lua/initiative_siphon_lua",LUA_MODIFIER_MOTION_NONE)
--技能开始
function initiative_siphon_lua:OnAbilityPhaseStart()
	self.caster	= self:GetCaster()
	self.enemies = FindUnitsInRadius(self.caster:GetTeam(), self.caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #self.enemies == 0 then
		send_error_tip(self.caster:GetPlayerID(),"范围内没有有效目标")
		return false
	end 
	return true
end
--施法
function initiative_siphon_lua:OnSpellStart()
	self.caster = self:GetCaster() 
	--local target = self:GetCursorTarget() 
	local damagetable = {                               
		attacker = self.caster,								 
		-- damage = self:GetSpecialValueFor("scale")+self.caster:GetIntellect()*self:GetSpecialValueFor("attr_scale"),
		damage_type = DAMAGE_TYPE_MAGICAL,				 
	}
	for i=1,self:GetSpecialValueFor("targetNum") do
		if self.enemies[i] then 
			ProjectileManager:CreateTrackingProjectile(
				{
					Target			= self.enemies[i],
					Source			= self.caster,
					Ability			= self,
					EffectName		= "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf",
					iMoveSpeed		= 3000,
				})

			Timers:CreateTimer(1.5, function()
				damagetable.victim = self.enemies[i]
				damagetable.damage = self:GetSpecialValueFor("scale") + self.enemies[i]:GetHealth()*self:GetSpecialValueFor("attr_scale")/100,
				self.caster:Heal(self:GetSpecialValueFor("heal")+self.caster:GetIntellect()*self:GetSpecialValueFor("attr_heal"), self)
				self.enemies[i]:AddNewModifier(self.caster, self, "modifier_initiative_siphon_lua", {duration = self:GetSpecialValueFor("stun_time")})--调用修饰器
				ApplyDamage(damagetable) --对单位造成伤害，传入列表参数
			end)
		end
	end
end	
--技能命中
function initiative_siphon_lua:OnProjectileHit(hTarget, vLocation)
	-- if hTarget then
	-- 	local damagetable = {
	-- 		victim = hTarget,                                 
	-- 		attacker = self.caster,								 
	-- 		-- damage = self:GetSpecialValueFor("scale")+self.caster:GetIntellect()*self:GetSpecialValueFor("attr_scale"),
	-- 		damage = hTarget:GetHealth()*self:GetSpecialValueFor("attr_scale")/100,	
	-- 		damage_type = DAMAGE_TYPE_MAGICAL,				 
	-- 	}
	-- 	self.caster:Heal(self:GetSpecialValueFor("heal")+self.caster:GetIntellect()*self:GetSpecialValueFor("attr_heal"), self)
	-- 	ApplyDamage(damagetable) --对单位造成伤害，传入列表参数
		-- if hTarget == self.caster then
		-- 	self.caster:Heal(self:GetSpecialValueFor("heal")+self.caster:GetIntellect()*self:GetSpecialValueFor("attr_heal"), self)
		-- 	--ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground",PATTACH_OVERHEAD_FOLLOW,hTarget)--调用特效
		-- 	--self.caster:EmitSound("pig.sound_2")--调用音效
		-- else
		-- 	ProjectileManager:CreateTrackingProjectile(
		-- 		{
		-- 			Target 			= self.caster,
		-- 			Source 			= hTarget,
		-- 			Ability 		= self,
		-- 			EffectName		= "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_egset.vpcf",
		-- 			iMoveSpeed		= 1000,
		-- 		})
		-- 	hTarget:AddNewModifier(self.caster, self, "modifier_initiative_siphon_lua", {duration = self:GetSpecialValueFor("stun_time")})--调用修饰器
		-- 	ApplyDamage(damagetable) --对单位造成伤害，传入列表参数
		-- end
	-- end
end
--BUFF
modifier_initiative_siphon_lua = class({})

function modifier_initiative_siphon_lua:IsDebuff()
	return true
end

function modifier_initiative_siphon_lua:IsStunDebuff()
	return true
end

function modifier_initiative_siphon_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		}
	return state
end