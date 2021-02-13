earth_fission=class({})
earth_fission_b=earth_fission
earth_fission_a=earth_fission

LinkLuaModifier("modifier_earth_fission_debuff", "skills/earth_fission/earth_fission.lua", LUA_MODIFIER_MOTION_NONE)

function earth_fission:IsHiddenWhenStolen() 
    return false 
end

function earth_fission:IsStealable() 
    return true 
end

function earth_fission:IsRefreshable() 			
    return true 
end

function earth_fission:OnSpellStart()
    local caster = self:GetCaster()
    local team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local target_pos = self:GetCursorPosition()
    local dis = 150
    local trample_num = self:GetSpecialValueFor("trample_num")
    local trample_rd = self:GetSpecialValueFor("trample_rd")
    local int_per=self:GetSpecialValueFor("int_per")
    local base_trample=self:GetSpecialValueFor("base_trample")	
    local fission_wh=self:GetSpecialValueFor("fission_wh")	
    local fission_time=self:GetSpecialValueFor("fission_time")	
    local base_fission=self:GetSpecialValueFor("base_fission")
    local fission_sp=self:GetSpecialValueFor("fission_sp")
    local stunned_dur=self:GetSpecialValueFor("stunned_dur")
    local stunned_dam=self:GetSpecialValueFor("stunned_dam")
    local stunned_pir=self:GetSpecialValueFor("stunned_pir")
    local base_pir=self:GetSpecialValueFor("base_pir")
    local cdir= GetDirection2D(target_pos,caster_pos)	
    local dir={0,0,0,0}	
    dir[1]=caster_pos+caster:GetForwardVector()*fission_sp
    dir[2]=caster_pos+caster:GetRightVector()*-fission_sp
    dir[3]=caster_pos+caster:GetForwardVector()*-fission_sp
    dir[4]=caster_pos+caster:GetRightVector()*fission_sp
    local damageTable =
    {
        attacker = caster,
        ability = self,
        damage_type = self:GetAbilityDamageType()
    }	
    EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster) 
    EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)
    for a=0,trample_num do
        local pos = caster_pos+cdir*dis
        local P= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl(P, 0,pos)
        ParticleManager:SetParticleControl(P, 1,Vector(1000,1000,1000))
        ParticleManager:SetParticleControl(P, 2,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(P, 3,pos)
        ParticleManager:ReleaseParticleIndex( P )
        dis=dis+300
        local enemies = FindUnitsInRadius(team, pos, nil, trample_rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        if #enemies>0 then  
            for _,target in pairs(enemies) do
                if not target:IsMagicImmune() then 
                    damageTable.victim = target
                    damageTable.damage = base_trample+caster:GetIntellect()*base_pir
                    -- ApplyDamage( damageTable )
                    target:AddNewModifier(caster, self, "modifier_stunned", {duration =stunned_dur})
                    target:AddNewModifier(caster, self, "modifier_earth_fission_debuff", {duration =stunned_dur ,stunned_dam =stunned_dam ,stunned_pir =stunned_pir})     
                end
            end
        end
    end 


    for a=1,#dir do
        local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl(p2, 0,caster_pos)
        ParticleManager:SetParticleControl(p2, 1,dir[a])
        ParticleManager:SetParticleControl(p2, 3,Vector(0,fission_time,0))
        ParticleManager:SetParticleControl(p2, 60,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(p2, 61,Vector(1,1,1))
        ParticleManager:ReleaseParticleIndex( p2 )
        Timers:CreateTimer(fission_time, function()
            EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster )
            local heros = FindUnitsInLine(
                team,
                caster_pos,
                dir[a], 
                caster, 
                fission_wh, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
                DOTA_UNIT_TARGET_FLAG_NONE)
            if #heros>0 then  
                for _,hero in pairs(heros) do
                    if not hero:IsMagicImmune() then 
                        damageTable.victim = hero
                        damageTable.damage = base_fission+caster:GetIntellect()*int_per
                        ApplyDamage(damageTable)
                    end
                end
            end
            return nil
        end)
    end 
end

modifier_earth_fission_debuff=class({})

function modifier_earth_fission_debuff:IsDebuff()
	return true 
end
function modifier_earth_fission_debuff:IsHidden()
	return false
end
function modifier_earth_fission_debuff:IsPurgable()
	return true
end
function modifier_earth_fission_debuff:IsPurgeException()
	return true
end
function modifier_earth_fission_debuff:OnCreated(params)
    if not IsServer() then
        return
    end
    self.stunned_dam = params.stunned_dam
    self.stunned_pir = params.stunned_pir
    self.damagetable = {
        victim = self:GetParent(),
        attacker = self:GetAbility():GetCaster(),
        damage = nil,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    self:StartIntervalThink(1)
end
function modifier_earth_fission_debuff:OnIntervalThink()
    self.damagetable.damage = self.stunned_dam+self:GetAbility():GetCaster():GetIntellect()*self.stunned_pir
    ApplyDamage(self.damagetable)
end

