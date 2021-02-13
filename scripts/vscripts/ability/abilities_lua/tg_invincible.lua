

LinkLuaModifier("modifier_tg_jugg_inv", "ability/abilities_lua/TG_invincible.lua", LUA_MODIFIER_MOTION_NONE)

tg_jugg_inv_d= tg_jugg_inv_d or class({})

function tg_jugg_inv_d:IsHiddenWhenStolen() 
    return false 
end

function tg_jugg_inv_d:IsStealable() 
    return true 
end

function tg_jugg_inv_d:IsNetherWardStealable() 
    return true 
end

function tg_jugg_inv_d:IsRefreshable() 			
    return true 
end

-----------------------------------
--04-26- add Scepter abi bu M
--背包内容改变时
function tg_jugg_inv_d:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then 
        local jugg_swift_slash = self:GetCaster():FindAbilityByName("tg_jugg_swift_slash")
        -- add eggs abi by M 06-08
        local imba_juggernaut_swift_slash = self:GetCaster():FindAbilityByName("imba_juggernaut_swift_slash")
        if jugg_swift_slash then    
            jugg_swift_slash:SetHidden(false)
            jugg_swift_slash:SetLevel(self:GetLevel())
            -- add eggs abi by M 06-08
            if imba_juggernaut_swift_slash then 
                jugg_swift_slash:SetHidden(true)
            end 
        end
    else
        local jugg_swift_slash = self:GetCaster():FindAbilityByName("tg_jugg_swift_slash")
        if jugg_swift_slash then 
            jugg_swift_slash:SetHidden(true)
            jugg_swift_slash:SetLevel(0)
        end
    end
end
------------------------------------
function tg_jugg_inv_d:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("dur")
    if caster:HasScepter() then
        dur = dur + 1.0
    end
    if caster:HasModifier("modifier_tg_jugg_rush_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_rush_motion")
    end
    if caster:HasModifier("modifier_tg_jugg_back_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_back_motion")
    end
    target:TriggerSpellAbsorb(self)
    target:TriggerSpellReflect(self)

    EmitSoundOn("TG.jugginv", caster)
    EmitSoundOn("Hero_Juggernaut.ArcanaTrigger", caster)
    caster:AddNewModifier(caster, self, "modifier_tg_jugg_inv",{duration=dur+caster:TG_GetTalentValue("special_bonus_imba_jugg_8"),target = target:entindex()})

    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)

    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
end

function tg_jugg_inv_d:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return
    end
    if target:IsAlive() then
        self:GetCaster():PerformAttack(target, false, true, true, false, true, false, true)  
    end 
end

tg_jugg_inv_c= tg_jugg_inv_c or class({})

function tg_jugg_inv_c:IsHiddenWhenStolen() 
    return false 
end

function tg_jugg_inv_c:IsStealable() 
    return true 
end

function tg_jugg_inv_c:IsNetherWardStealable() 
    return true 
end

function tg_jugg_inv_c:IsRefreshable() 			
    return true 
end

-----------------------------------
--04-26- add Scepter abi bu M
--背包内容改变时
function tg_jugg_inv_c:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then 
        local jugg_swift_slash = self:GetCaster():FindAbilityByName("tg_jugg_swift_slash")
        -- add eggs abi by M 06-08
        local imba_juggernaut_swift_slash = self:GetCaster():FindAbilityByName("imba_juggernaut_swift_slash")
        if jugg_swift_slash then    
            jugg_swift_slash:SetHidden(false)
            jugg_swift_slash:SetLevel(self:GetLevel())
            -- add eggs abi by M 06-08
            if imba_juggernaut_swift_slash then 
                jugg_swift_slash:SetHidden(true)
            end 
        end
    else
        local jugg_swift_slash = self:GetCaster():FindAbilityByName("tg_jugg_swift_slash")
        if jugg_swift_slash then 
            jugg_swift_slash:SetHidden(true)
            jugg_swift_slash:SetLevel(0)
        end
    end
end
------------------------------------
function tg_jugg_inv_c:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("dur")
    if caster:HasScepter() then
        dur = dur + 1.0
    end
    if caster:HasModifier("modifier_tg_jugg_rush_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_rush_motion")
    end
    if caster:HasModifier("modifier_tg_jugg_back_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_back_motion")
    end
    target:TriggerSpellAbsorb(self)
    target:TriggerSpellReflect(self)

    EmitSoundOn("TG.jugginv", caster)
    EmitSoundOn("Hero_Juggernaut.ArcanaTrigger", caster)
    caster:AddNewModifier(caster, self, "modifier_tg_jugg_inv",{duration=dur+caster:TG_GetTalentValue("special_bonus_imba_jugg_8"),target = target:entindex()})

    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)

    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
end

function tg_jugg_inv_c:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return
    end
    if target:IsAlive() then
        self:GetCaster():PerformAttack(target, false, true, true, false, true, false, true)  
    end 
end

modifier_tg_jugg_inv=modifier_tg_jugg_inv or class({})

function modifier_tg_jugg_inv:IsHidden()				
    return false 
end

function modifier_tg_jugg_inv:IsBuff()				
    return true 
end

function modifier_tg_jugg_inv:IsPurgable() 			
    return false 
end

function modifier_tg_jugg_inv:IsPurgeException() 	
    return false 
end

function modifier_tg_jugg_inv:GetStatusEffectName()  
    return "particles/status_fx/status_effect_omnislash.vpcf" 
end

function modifier_tg_jugg_inv:StatusEffectPriority() 
    return 100 
end


function modifier_tg_jugg_inv:OnCreated(tg)
    if not IsServer() then
        return
    end
        local i=self:GetAbility():GetSpecialValueFor("dami")
        self.kills=0
        self.target = EntIndexToHScript(tg.target)
        local caster=self:GetParent()
        caster:SetForwardVector(TG_direction(self.target:GetAbsOrigin(),caster:GetAbsOrigin()))
        caster:SetAttacking(self.target)
        caster:SetForceAttackTarget(self.target)
        local dam=(caster:GetDisplayAttackSpeed()+ caster:GetIdealSpeedNoSlows())/self:GetAbility():GetSpecialValueFor("attr_scale")
        --print("inv damag--->attackspeed  movespeed dam",caster:GetDisplayAttackSpeed(),caster:GetIdealSpeedNoSlows(),dam)
        local rd=self:GetAbility():GetSpecialValueFor("rd")+caster:TG_GetTalentValue("special_bonus_imba_jugg_7")
        caster:SetAbsOrigin( self.target:GetAbsOrigin())
        local p= ParticleManager:CreateParticle("particles/tg_pfx/heros/jugg/inv1.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.target)
        ParticleManager:SetParticleControl(p,0, self.target:GetAbsOrigin())
        Timers:CreateTimer(1.5, function()
            ParticleManager:DestroyParticle(p, false)
            p=nil
			return nil
		end)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,rd , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for _, target in pairs(enemies) do
            local damageTable = {
                victim = target,
                attacker =caster,
                damage =dam ,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_NONE, 
                ability = self:GetAbility(), 
                }
            if target:IsAlive() and not target:IsAttackImmune() then
                ApplyDamage(damageTable)
            end
        end
        self:StartIntervalThink(i)
end

function modifier_tg_jugg_inv:OnIntervalThink()
    local caster=self:GetParent()
    EmitSoundOn("Hero_Juggernaut.Attack", caster)
    local X= math.random(self.target:GetAbsOrigin().x+1000,self.target:GetAbsOrigin().x-1000)
    local Y= math.random(self.target:GetAbsOrigin().y+1000,self.target:GetAbsOrigin().y-1000)
    local pos= Vector(X,Y,self.target:GetAbsOrigin().z)
    FindClearSpaceForUnit(caster, pos, true)
    local dir= TG_direction(self.target:GetAbsOrigin(),caster:GetAbsOrigin())
    dir.z=0
    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1,  self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2,  self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)

    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1,  self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2,  self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)

    caster:SetForwardVector(dir)
    caster:SetAttacking(self.target)
    caster:SetForceAttackTarget(self.target)
    local pfx_tgt = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx_tgt, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_tgt, 1, self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx_tgt)
    local pfx_trail = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx_trail, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_trail, 1, self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx_trail)
    local info = 
	{
		Ability = self:GetAbility(),
		EffectName = "particles/tg_pfx/heros/jugg/bjump1.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 2000,
		fStartRadius = 200,
		fEndRadius =200,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5,
		bDeleteOnHit = true,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
    ProjectileManager:CreateLinearProjectile(info)

    if caster:HasModifier("modifier_tg_jugg_back_motion") then
       self:StartIntervalThink( -1 )
         caster:RemoveModifierByName("modifier_tg_jugg_inv")
     end
end

function modifier_tg_jugg_inv:OnDestroy()
    if not IsServer() then
        return
    end
    if self.kills>0 then
        local pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter.vpcf", PATTACH_OVERHEAD_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(pfx, 1, Vector(1, self.kills, 0))
        ParticleManager:SetParticleControl(pfx, 2, Vector(#tostring( self.kills), 0, 0))
        ParticleManager:ReleaseParticleIndex(pfx)
    end
        self.kills=nil
        self.target=nil
        self:GetParent():SetForceAttackTarget(nil)
        EmitSoundOn("inv", self:GetParent())
        if PseudoRandom:RollPseudoRandom(self:GetAbility(), 25) then
            EmitSoundOn("juggernaut_jug_arc_taunt_01", self:GetParent())
        end
end


function modifier_tg_jugg_inv:OnHeroKilled(tg)
	if not IsServer() then
		return
    end
	if tg.attacker == self:GetParent() and tg.target:IsTrueHero() then
        self.kills = self.kills + 1
        if self.target==nil or not self.target:IsAlive() then
            self.target=nil
            local enemies = FindUnitsInRadius(tg.attacker:GetTeamNumber(), tg.attacker:GetAbsOrigin(), nil,1000 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            if enemies~=nil then
                 self.target=enemies[RandomInt(1, #enemies)]
              if self.target==nil then
                  if tg.attacker:HasModifier("modifier_tg_jugg_inv") then
                    self:StartIntervalThink(-1)
                    tg.attacker:RemoveModifierByName("modifier_tg_jugg_inv")                   
                    return
                    end
              end
            elseif tg.attacker:HasModifier("modifier_tg_jugg_inv") then
                self:StartIntervalThink(-1)
                tg.attacker:RemoveModifierByName("modifier_tg_jugg_inv")
                return
            end
    end
	end
end

function modifier_tg_jugg_inv:CheckState() 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
    } 
end

function modifier_tg_jugg_inv:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_EVENT_ON_HERO_KILLED, 
    } 
end

function modifier_tg_jugg_inv:GetModifierMoveSpeed_Absolute() 
    return 1 
end

function modifier_tg_jugg_inv:GetOverrideAnimation() 
    return ACT_DOTA_OVERRIDE_ABILITY_4 
end

--04-26 add Scepter abi bu MysticBug
------------------------------------

tg_jugg_swift_slash = class({})


function tg_jugg_swift_slash:IsHiddenWhenStolen() 
    return false 
end

function tg_jugg_swift_slash:IsStealable() 
    return true 
end

function tg_jugg_swift_slash:IsNetherWardStealable() 
    return true 
end

function tg_jugg_swift_slash:IsRefreshable()            
    return true 
end

function tg_jugg_swift_slash:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("duration")
    if caster:HasModifier("modifier_tg_jugg_rush_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_rush_motion")
    end
    if caster:HasModifier("modifier_tg_jugg_back_motion") then
        caster:RemoveModifierByName("modifier_tg_jugg_back_motion")
    end
    target:TriggerSpellAbsorb(self)
    target:TriggerSpellReflect(self)

    EmitSoundOn("TG.jugginv", caster)
    EmitSoundOn("Hero_Juggernaut.ArcanaTrigger", caster)
    caster:AddNewModifier(caster, self, "modifier_tg_jugg_inv",{duration=dur,target = target:entindex()})

    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)

    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
end

function tg_jugg_swift_slash:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return
    end
    if target:IsAlive() then
        self:GetCaster():PerformAttack(target, false, true, true, false, true, false, true)  
    end 
end