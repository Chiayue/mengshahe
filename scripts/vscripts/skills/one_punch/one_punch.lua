one_punch=class({})


LinkLuaModifier("modifier_one_punch_pa", "skills/one_punch/one_punch.lua", LUA_MODIFIER_MOTION_NONE)

function one_punch:GetIntrinsicModifierName() 
    return "modifier_one_punch_pa" 
end


modifier_one_punch_pa=class({})

function modifier_one_punch_pa:IsHidden() 			
    return true 
end

function modifier_one_punch_pa:IsPurgable() 			
    return false 
end

function modifier_one_punch_pa:IsPurgeException() 	
    return false 
end

function modifier_one_punch_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_one_punch_pa:AllowIllusionDuplicate() 
    return false 
end


function modifier_one_punch_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_one_punch_pa:OnCreated() 
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.rg=self.ability:GetSpecialValueFor("rg")		
    self.wh=self.ability:GetSpecialValueFor("wh")	
    self.hp=self.ability:GetSpecialValueFor("hp")	
    self.str_per=self.ability:GetSpecialValueFor("str_per")	
    self.int_per=self.ability:GetSpecialValueFor("int_per")	
    self.agi_per=self.ability:GetSpecialValueFor("agi_per")	
    self.damageTable = {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self.ability,
    }
    self.Knockback ={
        should_stun = false,
        knockback_duration = 1,
        duration = 1,
        knockback_distance = 1,
        knockback_height = 300,
    }
    if not IsServer() then 
        return 
    end
    self.team=self.parent:GetTeamNumber()

end


function modifier_one_punch_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
    end
	if tg.attacker ~= self.parent  then
		return
    end
    local pos=self.parent:GetAbsOrigin()
    local enemies = FindUnitsInLine(self.team, pos,pos+self.parent:GetForwardVector()*self.ability:GetSpecialValueFor("rg"), self.parent, self.ability:GetSpecialValueFor("wh"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    if #enemies>0 then 
        EmitSoundOn("Hero_Tusk.WalrusPunch.Target", self.caster) 
        for _,target in pairs(enemies) do
            if target~=tg.target then 
                self.parent:PerformAttack(target, false, false, true, false, true, false, true)  
            end
            local tpos=target:GetAbsOrigin()
            self.Knockback.center_x = tpos.x
            self.Knockback.center_y = tpos.y
            self.Knockback.center_z = tpos.z
            target:AddNewModifier(self.parent,self.ability, "modifier_knockback", self.Knockback)
            if self.parent~=nil and self.parent:GetHealth()<=self.parent:GetMaxHealth()*self.ability:GetSpecialValueFor("hp")*0.01 then
                local p= ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf", PATTACH_ABSORIGIN,self.parent)
                ParticleManager:SetParticleControl(p, 0,pos)
                ParticleManager:SetParticleControl(p, 2,pos)
                ParticleManager:ReleaseParticleIndex( p )
                self.damageTable.damage=self.parent:GetIntellect()*self.ability:GetSpecialValueFor("int_per")*0.01+self.parent:GetStrength()*self.ability:GetSpecialValueFor("str_per")*0.01+self.parent:GetAgility()*self.ability:GetSpecialValueFor("agi_per")*0.01
                self.damageTable.victim=target
                ApplyDamage(self.damageTable)
            end
        end
    end
end