initiative_blitzkrieg_lua = class({})
initiative_blitzkrieg_lua_d = initiative_blitzkrieg_lua
initiative_blitzkrieg_lua_c = initiative_blitzkrieg_lua
initiative_blitzkrieg_lua_b = initiative_blitzkrieg_lua
initiative_blitzkrieg_lua_a = initiative_blitzkrieg_lua
initiative_blitzkrieg_lua_s = initiative_blitzkrieg_lua

LinkLuaModifier("modifier_initiative_blitzkrieg_lua","ability/abilities_lua/initiative_blitzkrieg_lua",LUA_MODIFIER_MOTION_NONE)

--施法
function initiative_blitzkrieg_lua:OnSpellStart()
	self.victim = {}
	local caster = self:GetCaster() 
	local caster_postion = caster:GetOrigin()
	local speed = 2700
	local target_postion = nil
	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("attr_damage")
	if self:GetCursorTarget() then
		target_postion = self:GetCursorTarget():GetOrigin()
	else
		target_postion = self:GetCursorPosition()
	end
	local distance = math.abs(math.sqrt((caster_postion.x-target_postion.x)*(caster_postion.x-target_postion.x)+(caster_postion.y-target_postion.y)*(caster_postion.y-target_postion.y)))
	local center_positon = RotatePosition(target_postion, QAngle(90, 180, 0), target_postion) 
	local knockbackModifierTable =
					{
					should_stun = 1,
					knockback_duration = 0.3,
					duration = 0.3,
					knockback_distance = -distance,
					knockback_height = 1,
					center_x = center_positon.x,
					center_y = center_positon.y,
					center_z = center_positon.z
					}
	-- 系统自带的击飞 modifier 
	caster:AddNewModifier(caster, self, "modifier_knockback", knockbackModifierTable )

	local vDirection = target_postion - caster_postion	
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()	
	speed = speed * ( distance / ( distance - 100 ) )
-- ParticleManager:CreateParticle( "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile_sparkles.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	local info = {
		-- EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile_sparkles.vpcf",
		Ability = self,
		vSpawnOrigin = caster_postion, 
		fStartRadius = 300,
		fEndRadius = 300,
		vVelocity = vDirection * speed,
		fDistance = distance,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )

	Timers:CreateTimer( 0.5,function()
		for i=1, #self.victim do
			ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.victim[i] )
			ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.victim[i] )
			local damagetable = {
				victim = self.victim[i],                                 
				attacker = caster,								 
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,				 
			}
			ApplyDamage(damagetable)				
		end
		self:GetCaster():EmitSound("Imba.void.OnAttackLanded")--调用音效
		return nil
	end
	)
end	

function initiative_blitzkrieg_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget then
		self.victim[#self.victim + 1] = hTarget
		hTarget:AddNewModifier(hTarget, self, "modifier_initiative_blitzkrieg_lua", {duration = 1})--调用修饰器
	end
end

--BUFF
modifier_initiative_blitzkrieg_lua = class({})

function modifier_initiative_blitzkrieg_lua:IsHidden()
	return true
end
function modifier_initiative_blitzkrieg_lua:IsDebuff()
	return false
end
function modifier_initiative_blitzkrieg_lua:IsPurgable()
	return false
end
function modifier_initiative_blitzkrieg_lua:IsPurgeException()
	return false
end
function modifier_initiative_blitzkrieg_lua:IsStunDebuff()
	return false
end
function modifier_initiative_blitzkrieg_lua:AllowIllusionDuplicate()
	return false
end
function modifier_initiative_blitzkrieg_lua:RemoveOnDeath()
	return false
end

function modifier_initiative_blitzkrieg_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		}
	return state
end
