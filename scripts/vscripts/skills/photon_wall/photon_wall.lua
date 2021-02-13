photon_wall=class({})
photon_wall_b=photon_wall
photon_wall_a=photon_wall

LinkLuaModifier("modifier_photon_wall", "skills/photon_wall/photon_wall.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_photon_wall_pw", "skills/photon_wall/photon_wall.lua", LUA_MODIFIER_MOTION_NONE)

function photon_wall:IsHiddenWhenStolen() 
    return false 
end

function photon_wall:IsStealable() 
    return true 
end

function photon_wall:IsRefreshable() 			
    return true 
end

function photon_wall:OnSpellStart()
    local caster = self:GetCaster()
    local pos = self:GetCursorPosition()
    local duration=self:GetSpecialValueFor("duration") 
    EmitSoundOn( "Hero_Dark_Seer.Wall_of_Replica_Start", caster )
    self.int_per=self:GetSpecialValueFor("int_per")
    self.base_dam=self:GetSpecialValueFor("base_dam")	
    self.damageTable = {
		attacker = caster,
		damage_type =DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = self,
		}
    CreateModifierThinker(caster, self, "modifier_photon_wall", {duration = duration}, pos, caster:GetTeamNumber(), false)
    CreateModifierThinker(caster, self, "modifier_photon_wall_pw", {duration = duration}, pos, caster:GetTeamNumber(), false)
end

function photon_wall:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return 
    end
    local caster = self:GetCaster()
    if not target:IsMagicImmune()  then 
        self.damageTable.victim = target		
        self.damageTable.damage = self.base_dam+caster:GetBaseDamageMax()*self.int_per
        ApplyDamage(self.damageTable)
    end
end

modifier_photon_wall= class({})

function modifier_photon_wall:IsHidden() 			
    return true 
end

function modifier_photon_wall:IsPurgable() 			
    return false 
end

function modifier_photon_wall:IsPurgeException() 	
    return false 
end

function modifier_photon_wall:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster = self:GetCaster()
    self.rg=self.ability:GetSpecialValueFor("rg")/2
    self.wh=self.ability:GetSpecialValueFor("wh")
    if IsServer() then 
        self.pos=self.parent:GetAbsOrigin()
        self.team=self.caster:GetTeam()
        self.start_pos=self.pos+self.caster:GetRightVector()*self.rg
        self.end_pos=self.pos+self.caster:GetRightVector()*-self.rg
        local P = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_WORLDORIGIN,nil)
        ParticleManager:SetParticleControl(P,0,self.start_pos)
        ParticleManager:SetParticleControl(P,1,self.end_pos)
        ParticleManager:SetParticleControl(P,2,Vector(1,1,0))
        ParticleManager:SetParticleControl(P,60,Vector(255,206,120))
        ParticleManager:SetParticleControl(P,61,Vector(1,0,0))
        self:AddParticle( P, false, false, -1, false, false )   
        self:OnIntervalThink()
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_photon_wall:OnIntervalThink()
    local enemies = FindUnitsInLine(self.team,  self.start_pos, self.end_pos, self.caster, self.wh, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
    if #enemies>0 then 
    for _,tar in pairs(enemies) do
            if not tar:IsMagicImmune() then 
                if not tar:HasModifier("modifier_knockback") then
                    Knockback ={
                        should_stun = false,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 400,
                        knockback_height = 100,
                        center_x =  tar:GetAbsOrigin().x+tar:GetForwardVector(),
                        center_y =  tar:GetAbsOrigin().y+tar:GetRightVector(),
                        center_z =  tar:GetAbsOrigin().z
                    }
                    tar:AddNewModifier(tar,self.ability, "modifier_knockback", Knockback)
                end
            end 
        end
    end  
end




modifier_photon_wall_pw=class({})

function modifier_photon_wall_pw:IsHidden() 			
    return true 
end

function modifier_photon_wall_pw:IsPurgable() 			
    return false 
end

function modifier_photon_wall_pw:IsPurgeException() 	
    return false 
end

function modifier_photon_wall_pw:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.interval=self.ability:GetSpecialValueFor("interval")
    self.dis=self.ability:GetSpecialValueFor("dis")
    self.wh2=self.ability:GetSpecialValueFor("wh2")
    if IsServer() then 
        self.pos=self.parent:GetAbsOrigin()
        self.dir=GetDirection2D( self.pos, self.caster:GetAbsOrigin())
        self.team=self.caster:GetTeam()  
        self:StartIntervalThink(self.interval)
    end
end

function modifier_photon_wall_pw:OnIntervalThink()
    EmitSoundOn( "Ability.Powershot", self.parent )
    local projectileTable =
	{
		EffectName ="particles/tgp/photon_wall/photon_wall_m.vpcf",
		Ability = self.ability,
		vSpawnOrigin =self.pos,
		vVelocity =self.dir*1000,
		fDistance =self.dis,
		fStartRadius = self.wh2,
		fEndRadius = self.wh2,
		Source = self.caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )  
end