tg_jk_db_c=tg_jk_db_c or class({})
LinkLuaModifier("modifier_tg_jk_db_d_debuff", "ability/abilities_lua/tg_jk_db_d.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tg_jk_db_d_motion", "ability/abilities_lua/tg_jk_db_d.lua", LUA_MODIFIER_MOTION_NONE)
function tg_jk_db_c:IsHiddenWhenStolen() 
    return false 
end

function tg_jk_db_c:IsStealable() 
    return true 
end

function tg_jk_db_c:IsNetherWardStealable() 
    return true 
end

function tg_jk_db_c:IsRefreshable() 			
    return true 
end

function tg_jk_db_c:ProcsMagicStick() 			
    return true 
end

function tg_jk_db_c:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
	local curpos = caster:GetCursorPosition()
	local dir=TG_direction(curpos,casterpos)
	local distance =TG_distance(casterpos,curpos)
	local flydis = self:GetSpecialValueFor("flydis")
	if distance>flydis then
		distance=flydis
		end
	local duration = distance / 1400
	local wh = self:GetSpecialValueFor("wh")
	local dis = self:GetSpecialValueFor("dis")

	caster:AddNewModifier(caster, self, "modifier_tg_jk_db_d_motion", {duration = duration, direction = dir})
	EmitSoundOn( "Hero_Jakiro.DualBreath.Cast", caster )
	local Projectile = 
	{
		Ability = self,
		EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_fire.vpcf",
		vSpawnOrigin =casterpos,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(Projectile)

	local Projectile2 = 
	{
		Ability = self,
		EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_fire.vpcf",
		vSpawnOrigin =casterpos+caster:GetRightVector()*-100,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(Projectile2)

	local Projectile3 = 
	{
		Ability = self,
		EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_fire.vpcf",
		vSpawnOrigin =casterpos+caster:GetRightVector()*100,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(Projectile3)
end


function tg_jk_db_c:OnProjectileHit_ExtraData(target, location, kv)
	
	if not target then
		return
	end
	local disarmeddur=self:GetSpecialValueFor("disarmeddur")
	local attr_scale=self:GetSpecialValueFor("attr_scale")
	local dam=self:GetSpecialValueFor("dam")
	if not target:IsMagicImmune() then
		local damageTable = {
			victim = target,
			attacker =  self:GetCaster(),
			damage = dam + (self:GetCaster():GetStrength() * attr_scale),
			damage_type =DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = self,
			}
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage:"..damageTable.damage)
			ApplyDamage(damageTable)
	end
	target:AddNewModifier( self:GetCaster(), self, "modifier_tg_jk_db_d_debuff", {duration=disarmeddur} )
end