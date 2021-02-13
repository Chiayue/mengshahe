whirlwind=class({})
whirlwind_d=whirlwind
whirlwind_c=whirlwind


LinkLuaModifier("modifier_whirlwind_pa", "skills/whirlwind/whirlwind.lua", LUA_MODIFIER_MOTION_NONE)

function whirlwind:GetIntrinsicModifierName() 
    return "modifier_whirlwind_pa" 
end


function whirlwind:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
	if target==nil then
		return
    end

    if target:IsAlive() then
        local damageTable = {
            attacker = caster,
            victim = target,
            damage_type = DAMAGE_TYPE_PURE,
            damage =  self:GetSpecialValueFor("int_per")*0.01*caster:GetIntellect(),
            ability = self,
        }
        ApplyDamage(damageTable)
	    caster:PerformAttack(target, false, false, true, false, true, false, true)  
    end 
end

modifier_whirlwind_pa=class({})

function modifier_whirlwind_pa:IsHidden() 			
    return true 
end

function modifier_whirlwind_pa:IsPurgable() 			
    return false 
end

function modifier_whirlwind_pa:IsPurgeException() 	
    return false 
end

function modifier_whirlwind_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_whirlwind_pa:AllowIllusionDuplicate() 
    return false 
end

function modifier_whirlwind_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ch=self.ability:GetSpecialValueFor("ch")		
    self.wh=self.ability:GetSpecialValueFor("wh")	
    self.dis=self.ability:GetSpecialValueFor("dis")	
    self.sp=self.ability:GetSpecialValueFor("sp")	
    if not IsServer() then 
        return 
    end
end


function modifier_whirlwind_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self.parent  then
		return
    end
    if RollPseudoRandomPercentage(self.ability:GetSpecialValueFor("ch"),0,self.ability) then
        EmitSoundOn("Hero_Juggernaut.BladeDance.Arcana", self.caster) 
        local projectileTable = {
            Ability = self.ability,
            EffectName = "particles/tgp/whirlwind/whirlwind_m.vpcf",
            vSpawnOrigin = self.caster:GetAbsOrigin(),
            fDistance = self.ability:GetSpecialValueFor("dis"),
            fStartRadius = self.ability:GetSpecialValueFor("wh"),
            fEndRadius = self.ability:GetSpecialValueFor("wh"), 
            Source = self.caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            bProvidesVision = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC,
            vVelocity = self.caster:GetForwardVector()*self.ability:GetSpecialValueFor("sp")
        }
        ProjectileManager:CreateLinearProjectile( projectileTable )
    end
end

