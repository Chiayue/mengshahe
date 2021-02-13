tg_jk_db_d=tg_jk_db_d or class({})
LinkLuaModifier("modifier_tg_jk_db_d_debuff", "ability/abilities_lua/tg_jk_db_d.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tg_jk_db_d_motion", "ability/abilities_lua/tg_jk_db_d.lua", LUA_MODIFIER_MOTION_NONE)
function tg_jk_db_d:IsHiddenWhenStolen() 
    return false 
end

function tg_jk_db_d:IsStealable() 
    return true 
end

function tg_jk_db_d:IsNetherWardStealable() 
    return true 
end

function tg_jk_db_d:IsRefreshable() 			
    return true 
end

function tg_jk_db_d:ProcsMagicStick() 			
    return true 
end

function tg_jk_db_d:OnSpellStart()
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


function tg_jk_db_d:OnProjectileHit_ExtraData(target, location, kv)
	
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

modifier_tg_jk_db_d_motion = modifier_tg_jk_db_d_motion or class({})

function modifier_tg_jk_db_d_motion:IsDebuff()			
	return false 
end

function modifier_tg_jk_db_d_motion:IsHidden() 			
	return false 
end

function modifier_tg_jk_db_d_motion:IsPurgable() 		
	return false 
end

function modifier_tg_jk_db_d_motion:IsPurgeException() 	
	return false 
end



function modifier_tg_jk_db_d_motion:OnCreated(tg)
	if IsServer() then
		self.direction = StringToVector(tg.direction)
		self.speed =  1400
		if not self:CheckMotionControllers() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_tg_jk_db_d_motion:OnIntervalThink()

    self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + self.direction * (self.speed / (1/ FrameTime())))

end

function modifier_tg_jk_db_d_motion:OnDestroy()

	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.direction = nil
	self.speed = nil
end


function modifier_tg_jk_db_d_motion:CheckState() 
	return 
	{
		[MODIFIER_STATE_INVULNERABLE] = true, 
		[MODIFIER_STATE_STUNNED] = true
	} 
end

function modifier_tg_jk_db_d_motion:IsMotionController() 
	return true 
end

function modifier_tg_jk_db_d_motion:GetMotionControllerPriority() 
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH 
end


modifier_tg_jk_db_d_debuff=modifier_tg_jk_db_d_debuff or class({})
function modifier_tg_jk_db_d_debuff:IsDebuff()
    return true 
end
function modifier_tg_jk_db_d_debuff:IsPurgable() 			
    return false
end
function modifier_tg_jk_db_d_debuff:IsPurgeException() 		
    return true 
end
function modifier_tg_jk_db_d_debuff:IsHidden()				
    return false 
end



function modifier_tg_jk_db_d_debuff:GetEffectName()	
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_tg_jk_db_d_debuff:GetEffectAttachType()	
   return PATTACH_OVERHEAD_FOLLOW
end



function modifier_tg_jk_db_d_debuff:CheckState()
    return
     {
            [MODIFIER_STATE_DISARMED] = true,
    }
end

function modifier_tg_jk_db_d_debuff:OnCreated(params)
    if not IsServer() then
        return
    end
    self.stunned_dam = self:GetAbility():GetSpecialValueFor("debuff_dam")
    self.stunned_pir = self:GetAbility():GetSpecialValueFor("debuff_scale")
    self.damagetable = {
        victim = self:GetParent(),
        attacker = self:GetAbility():GetCaster(),
        damage = nil,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    self:StartIntervalThink(1)
end
function modifier_tg_jk_db_d_debuff:OnIntervalThink()
    self.damagetable.damage = self.stunned_dam + self:GetCaster():GetStrength() * self.stunned_pir
    ApplyDamage(self.damagetable)
end
