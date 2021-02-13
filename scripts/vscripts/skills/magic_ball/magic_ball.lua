magic_ball=class({})

LinkLuaModifier("modifier_magic_ball_self", "skills/magic_ball/magic_ball.lua", LUA_MODIFIER_MOTION_NONE)

function magic_ball:IsHiddenWhenStolen() 
    return false 
end

function magic_ball:IsStealable() 
    return true 
end

function magic_ball:IsRefreshable() 			
    return true 
end
 
function magic_ball:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local dur = self:GetSpecialValueFor("dur")
    EmitSoundOn("RoshanDT.Death2", caster) 
    EmitSoundOn("Hero_Phoenix.FireSpirits.Cast", caster) 
    local p1 = ParticleManager:CreateParticle("particles/neutral_fx/roshan_spawn.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(p1, 0, pos)
	ParticleManager:SetParticleControl(p1, 1, pos)
	ParticleManager:ReleaseParticleIndex(p1)
	local p2 = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(p2, 0, pos)
	ParticleManager:SetParticleControl(p2, 1, pos)
	ParticleManager:SetParticleControl(p2, 2, pos)
	ParticleManager:SetParticleControl(p2, 3, pos)
	ParticleManager:ReleaseParticleIndex(p2)
    caster:AddNewModifier(caster, self, "modifier_magic_ball_self", {duration=dur})
end


modifier_magic_ball_self=class({})

function modifier_magic_ball_self:IsPurgable() return false end

function modifier_magic_ball_self:IsPurgeException() return false end

function modifier_magic_ball_self:IsHidden() return false end

function modifier_magic_ball_self:IsDebuff()return false end

function modifier_magic_ball_self:RemoveOnDeath()return false end

function modifier_magic_ball_self:GetEffectAttachType()return PATTACH_OVERHEAD_FOLLOW end

function modifier_magic_ball_self:GetEffectName()return "particles/units/heroes/hero_demonartist/demonartist_soulchain_marker.vpcf" end

function modifier_magic_ball_self:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.int = self.ability:GetSpecialValueFor("int")
    self.i = self.ability:GetSpecialValueFor("i")
    self.damageTable =
    {
        attacker = self.caster,
        damage = self.caster:GetIntellect()*self.int,
        ability = self.ability,
        damage_type = DAMAGE_TYPE_MAGICAL
    }	
    if IsServer() then 
        self.team = self.caster:GetTeamNumber()
        self.ball=ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
           ParticleManager:SetParticleControl(self.ball, 1, Vector( 5, 0, 0 )  )
           ParticleManager:SetParticleControl(self.ball, 6, Vector( 5, 0, 0 ) )
           for i=0,6 do
               ParticleManager:SetParticleControl(self.ball, 8+i, Vector(1, 0, 0 ) )
           end
        self:AddParticle(self.ball, false, false, 100, false, false)
        local p=ParticleManager:CreateParticle("particles/econ/courier/courier_onibi/courier_onibi_yellow_ambient_fire_lvl18.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
           ParticleManager:SetParticleControl(p, 0, self.caster:GetAbsOrigin() )
           self:AddParticle(p, false, false, -1, false, false)
        local p1=ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
           ParticleManager:SetParticleControl(p1, 0, self.caster:GetAbsOrigin() )
           self:AddParticle(p1, false, false, -1, false, false)
        local p2 = ParticleManager:CreateParticle("particles/econ/events/ti6/mjollnir_shield_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
           ParticleManager:SetParticleControl(p2, 0, self.caster:GetAbsOrigin())
           self:AddParticle(p2, false, false, 15, false, false)
        self:OnIntervalThink()
        self:StartIntervalThink(self.i)
    end 
end

function modifier_magic_ball_self:OnIntervalThink()
    local p=ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/mk_arcana_spring_fire_base_expanding.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControl(p, 0, self.caster:GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex(p)
    local enemies = FindUnitsInRadius( self.team, self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies>0 then 
        self.caster:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
        for _,target in pairs(enemies) do
            if not target:IsMagicImmune() then 
                local p1=ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_death_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW,target)
                ParticleManager:SetParticleControl(p1, 0, target:GetAbsOrigin() )
                ParticleManager:ReleaseParticleIndex(p1)
                local Projectile = 
                {
                    Target = target,
                    Source = self.caster,
                    Ability = self.ability,	
                    EffectName = "particles/tgp/magic_ball/magic_ball.vpcf",
                    iMoveSpeed = 1000,
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,			
                    bDrawsOnMinimap = false,
                    bDodgeable = false,
                    bIsAttack = false,
                    bVisibleToEnemies = true,
                    bReplaceExisting = false,
                    flExpireTime = GameRules:GetGameTime() + 10,
                    bProvidesVision = false,	
                }
                ProjectileManager:CreateTrackingProjectile(Projectile)
                local p2 = ParticleManager:CreateParticle("particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_POINT_FOLLOW, target)
                ParticleManager:SetParticleControlEnt(p2, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(p2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(p2, 2, Vector(1,1,1))
                ParticleManager:ReleaseParticleIndex(p2)
                self.damageTable.victim = target
                ApplyDamage(self.damageTable)  
            end  
        end
    end
end