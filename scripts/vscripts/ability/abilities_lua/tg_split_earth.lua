
LinkLuaModifier("modifier_tg_lh_se_debuff", "ability/abilities_lua/TG_split_earth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tg_lh_pn_jump", "ability/abilities_lua/TG_split_earth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tg_lh_pn_Changeon", "ability/abilities_lua/TG_split_earth.lua", LUA_MODIFIER_MOTION_NONE)

tg_lh_se_d=tg_lh_se_d or class({})

function tg_lh_se_d:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_se_d:IsStealable() 
    return true 
end

function tg_lh_se_d:IsNetherWardStealable() 
    return true 
end

function tg_lh_se_d:IsRefreshable() 			
    return true 
end

function tg_lh_se_d:ProcsMagicStick() 			
    return true 
end

function tg_lh_se_d:GetAOERadius() 			
    return self:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1")
end


function tg_lh_se_d:se(pl,ab,pos)
    pl:EmitSound("Hero_Leshrac.Split_Earth")
    local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)

    
    local  enemies = FindUnitsInRadius(pl:GetTeamNumber(), pos, nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    for _,target in pairs(enemies) do
        local damageTable = {
            victim = target,
            attacker = pl,
            damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
            damage_type = ab:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = ab,
            }
        ApplyDamage(damageTable)  
        target:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
    end   
    AddFOWViewer(pl:GetTeamNumber(), pos, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), ab:GetSpecialValueFor("stun"), true)  

    if self:GetCaster():HasScepter() then
       NUM=ab:GetSpecialValueFor("num")+1
      else
        NUM=ab:GetSpecialValueFor("num")
       end
    for i=1,NUM do
        if pl:HasModifier("modifier_tg_lh_pn_buff") and (pl:GetAbilityByIndex(2)~=nil and pl:GetAbilityByIndex(2):GetLevel()>0) then
        local X1= math.random(-1000,1000)
        local Y2= math.random(-1000,1000)
        local particle1 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,pl)
        ParticleManager:SetParticleControl(particle1, 0, pl:GetAbsOrigin() + Vector(X1, Y2, 1000))
        ParticleManager:SetParticleControl(particle1, 1, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        ParticleManager:SetParticleControl(particle1, 2, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        
        local  enemies = FindUnitsInRadius(pl:GetTeamNumber(),pl:GetAbsOrigin()+ Vector(X1, Y2, 0), nil, pl:GetAbilityByIndex(2):GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target in pairs(enemies) do
            pl:EmitSound("Hero_Leshrac.Lightning_Storm") 
            local damageTable = {
                attacker =  pl,
                victim = target,
                damage = ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ab
            }
            ApplyDamage(damageTable)
            target:AddNewModifier(pl, ab, "modifier_tg_lh_ls_debuff", {duration=pl:GetAbilityByIndex(2):GetSpecialValueFor("debufft")})
        end
    end
        local X= math.random(pl:GetAbsOrigin().x+1000,pl:GetAbsOrigin().x-1000)
        local Y= math.random(pl:GetAbsOrigin().y+1000,pl:GetAbsOrigin().y-1000)
        local particle2 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(particle2, 0, Vector(X,Y,pl:GetAbsOrigin().z))
        ParticleManager:SetParticleControl(particle2, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
        ParticleManager:ReleaseParticleIndex(particle2)
        local  enemies2 = FindUnitsInRadius(pl:GetTeamNumber(), Vector(X,Y,pl:GetAbsOrigin().z), nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target2 in pairs(enemies2) do
            local damageTable = {
                victim = target2,
                attacker = pl,
                damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = ab:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ab,
                }
            ApplyDamage(damageTable)  
            target2:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
        end   
    end  
end
function tg_lh_se_d:OnSpellStart()
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_tg_lh_pn_buff") then
        local pos=self:GetCursorPosition()
        local casterpos=caster:GetAbsOrigin()
        if pos==casterpos then
            pos=casterpos+caster:GetForwardVector()*10
        end
        local  dir =TG_direction(pos,casterpos)
        local  dis=self:GetSpecialValueFor("jump")
        local dur =dis/ 1400
        curpos=self:GetCursorPosition()
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_jump", {duration = dur, direction = dir})
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_Changeon", {duration = 1.5})
    else  
        self:se(caster,self,self:GetCursorPosition())
    end 
end


tg_lh_se_c=tg_lh_se_c or class({})

function tg_lh_se_c:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_se_c:IsStealable() 
    return true 
end

function tg_lh_se_c:IsNetherWardStealable() 
    return true 
end

function tg_lh_se_c:IsRefreshable() 			
    return true 
end

function tg_lh_se_c:ProcsMagicStick() 			
    return true 
end

function tg_lh_se_c:GetAOERadius() 			
    return self:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1")
end


function tg_lh_se_c:se(pl,ab,pos)
    pl:EmitSound("Hero_Leshrac.Split_Earth")
    local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)

    
    local  enemies = FindUnitsInRadius(pl:GetTeamNumber(), pos, nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    for _,target in pairs(enemies) do
        local damageTable = {
            victim = target,
            attacker = pl,
            damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
            damage_type = ab:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = ab,
            }
        ApplyDamage(damageTable)  
        target:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
    end   
    AddFOWViewer(pl:GetTeamNumber(), pos, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), ab:GetSpecialValueFor("stun"), true)  

    if self:GetCaster():HasScepter() then
       NUM=ab:GetSpecialValueFor("num")+1
      else
        NUM=ab:GetSpecialValueFor("num")
       end
    for i=1,NUM do
        if pl:HasModifier("modifier_tg_lh_pn_buff") and (pl:GetAbilityByIndex(2)~=nil and pl:GetAbilityByIndex(2):GetLevel()>0) then
        local X1= math.random(-1000,1000)
        local Y2= math.random(-1000,1000)
        local particle1 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,pl)
        ParticleManager:SetParticleControl(particle1, 0, pl:GetAbsOrigin() + Vector(X1, Y2, 1000))
        ParticleManager:SetParticleControl(particle1, 1, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        ParticleManager:SetParticleControl(particle1, 2, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        
        local  enemies = FindUnitsInRadius(pl:GetTeamNumber(),pl:GetAbsOrigin()+ Vector(X1, Y2, 0), nil, pl:GetAbilityByIndex(2):GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target in pairs(enemies) do
            pl:EmitSound("Hero_Leshrac.Lightning_Storm") 
            local damageTable = {
                attacker =  pl,
                victim = target,
                damage = ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ab
            }
            ApplyDamage(damageTable)
            target:AddNewModifier(pl, ab, "modifier_tg_lh_ls_debuff", {duration=pl:GetAbilityByIndex(2):GetSpecialValueFor("debufft")})
        end
    end
        local X= math.random(pl:GetAbsOrigin().x+1000,pl:GetAbsOrigin().x-1000)
        local Y= math.random(pl:GetAbsOrigin().y+1000,pl:GetAbsOrigin().y-1000)
        local particle2 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(particle2, 0, Vector(X,Y,pl:GetAbsOrigin().z))
        ParticleManager:SetParticleControl(particle2, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
        ParticleManager:ReleaseParticleIndex(particle2)
        local  enemies2 = FindUnitsInRadius(pl:GetTeamNumber(), Vector(X,Y,pl:GetAbsOrigin().z), nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target2 in pairs(enemies2) do
            local damageTable = {
                victim = target2,
                attacker = pl,
                damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = ab:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ab,
                }
            ApplyDamage(damageTable)  
            target2:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
        end   
    end  
end
function tg_lh_se_c:OnSpellStart()
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_tg_lh_pn_buff") then
        local pos=self:GetCursorPosition()
        local casterpos=caster:GetAbsOrigin()
        if pos==casterpos then
            pos=casterpos+caster:GetForwardVector()*10
        end
        local  dir =TG_direction(pos,casterpos)
        local  dis=self:GetSpecialValueFor("jump")
        local dur =dis/ 1400
        curpos=self:GetCursorPosition()
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_jump", {duration = dur, direction = dir})
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_Changeon", {duration = 1.5})
    else  
        self:se(caster,self,self:GetCursorPosition())
    end 
end


tg_lh_se_b=tg_lh_se_b or class({})

function tg_lh_se_b:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_se_b:IsStealable() 
    return true 
end

function tg_lh_se_b:IsNetherWardStealable() 
    return true 
end

function tg_lh_se_b:IsRefreshable() 			
    return true 
end

function tg_lh_se_b:ProcsMagicStick() 			
    return true 
end

function tg_lh_se_b:GetAOERadius() 			
    return self:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1")
end


function tg_lh_se_b:se(pl,ab,pos)
    pl:EmitSound("Hero_Leshrac.Split_Earth")
    local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)

    
    local  enemies = FindUnitsInRadius(pl:GetTeamNumber(), pos, nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    for _,target in pairs(enemies) do
        local damageTable = {
            victim = target,
            attacker = pl,
            damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
            damage_type = ab:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = ab,
            }
        ApplyDamage(damageTable)  
        target:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
    end   
    AddFOWViewer(pl:GetTeamNumber(), pos, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), ab:GetSpecialValueFor("stun"), true)  

    if self:GetCaster():HasScepter() then
       NUM=ab:GetSpecialValueFor("num")+1
      else
        NUM=ab:GetSpecialValueFor("num")
       end
    for i=1,NUM do
        if pl:HasModifier("modifier_tg_lh_pn_buff") and (pl:GetAbilityByIndex(2)~=nil and pl:GetAbilityByIndex(2):GetLevel()>0) then
        local X1= math.random(-1000,1000)
        local Y2= math.random(-1000,1000)
        local particle1 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,pl)
        ParticleManager:SetParticleControl(particle1, 0, pl:GetAbsOrigin() + Vector(X1, Y2, 1000))
        ParticleManager:SetParticleControl(particle1, 1, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        ParticleManager:SetParticleControl(particle1, 2, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        
        local  enemies = FindUnitsInRadius(pl:GetTeamNumber(),pl:GetAbsOrigin()+ Vector(X1, Y2, 0), nil, pl:GetAbilityByIndex(2):GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target in pairs(enemies) do
            pl:EmitSound("Hero_Leshrac.Lightning_Storm") 
            local damageTable = {
                attacker =  pl,
                victim = target,
                damage = ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ab
            }
            ApplyDamage(damageTable)
            target:AddNewModifier(pl, ab, "modifier_tg_lh_ls_debuff", {duration=pl:GetAbilityByIndex(2):GetSpecialValueFor("debufft")})
        end
    end
        local X= math.random(pl:GetAbsOrigin().x+1000,pl:GetAbsOrigin().x-1000)
        local Y= math.random(pl:GetAbsOrigin().y+1000,pl:GetAbsOrigin().y-1000)
        local particle2 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(particle2, 0, Vector(X,Y,pl:GetAbsOrigin().z))
        ParticleManager:SetParticleControl(particle2, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
        ParticleManager:ReleaseParticleIndex(particle2)
        local  enemies2 = FindUnitsInRadius(pl:GetTeamNumber(), Vector(X,Y,pl:GetAbsOrigin().z), nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target2 in pairs(enemies2) do
            local damageTable = {
                victim = target2,
                attacker = pl,
                damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = ab:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ab,
                }
            ApplyDamage(damageTable)  
            target2:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
        end   
    end  
end
function tg_lh_se_b:OnSpellStart()
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_tg_lh_pn_buff") then
        local pos=self:GetCursorPosition()
        local casterpos=caster:GetAbsOrigin()
        if pos==casterpos then
            pos=casterpos+caster:GetForwardVector()*10
        end
        local  dir =TG_direction(pos,casterpos)
        local  dis=self:GetSpecialValueFor("jump")
        local dur =dis/ 1400
        curpos=self:GetCursorPosition()
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_jump", {duration = dur, direction = dir})
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_Changeon", {duration = 1.5})
    else  
        self:se(caster,self,self:GetCursorPosition())
    end 
end


tg_lh_se_a=tg_lh_se_a or class({})

function tg_lh_se_a:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_se_a:IsStealable() 
    return true 
end

function tg_lh_se_a:IsNetherWardStealable() 
    return true 
end

function tg_lh_se_a:IsRefreshable() 			
    return true 
end

function tg_lh_se_a:ProcsMagicStick() 			
    return true 
end

function tg_lh_se_a:GetAOERadius() 			
    return self:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1")
end


function tg_lh_se_a:se(pl,ab,pos)
    pl:EmitSound("Hero_Leshrac.Split_Earth")
    local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)

    
    local  enemies = FindUnitsInRadius(pl:GetTeamNumber(), pos, nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
    for _,target in pairs(enemies) do
        local damageTable = {
            victim = target,
            attacker = pl,
            damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
            damage_type = ab:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = ab,
            }
        ApplyDamage(damageTable)  
        target:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
    end   
    AddFOWViewer(pl:GetTeamNumber(), pos, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), ab:GetSpecialValueFor("stun"), true)  

    if self:GetCaster():HasScepter() then
       NUM=ab:GetSpecialValueFor("num")+1
      else
        NUM=ab:GetSpecialValueFor("num")
       end
    for i=1,NUM do
        if pl:HasModifier("modifier_tg_lh_pn_buff") and (pl:GetAbilityByIndex(2)~=nil and pl:GetAbilityByIndex(2):GetLevel()>0) then
        local X1= math.random(-1000,1000)
        local Y2= math.random(-1000,1000)
        local particle1 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,pl)
        ParticleManager:SetParticleControl(particle1, 0, pl:GetAbsOrigin() + Vector(X1, Y2, 1000))
        ParticleManager:SetParticleControl(particle1, 1, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        ParticleManager:SetParticleControl(particle1, 2, pl:GetAbsOrigin()+ Vector(X1, Y2, 0))
        
        local  enemies = FindUnitsInRadius(pl:GetTeamNumber(),pl:GetAbsOrigin()+ Vector(X1, Y2, 0), nil, pl:GetAbilityByIndex(2):GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target in pairs(enemies) do
            pl:EmitSound("Hero_Leshrac.Lightning_Storm") 
            local damageTable = {
                attacker =  pl,
                victim = target,
                damage = ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ab
            }
            ApplyDamage(damageTable)
            target:AddNewModifier(pl, ab, "modifier_tg_lh_ls_debuff", {duration=pl:GetAbilityByIndex(2):GetSpecialValueFor("debufft")})
        end
    end
        local X= math.random(pl:GetAbsOrigin().x+1000,pl:GetAbsOrigin().x-1000)
        local Y= math.random(pl:GetAbsOrigin().y+1000,pl:GetAbsOrigin().y-1000)
        local particle2 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_se8.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(particle2, 0, Vector(X,Y,pl:GetAbsOrigin().z))
        ParticleManager:SetParticleControl(particle2, 1, Vector(ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), 0, 0))
        ParticleManager:ReleaseParticleIndex(particle2)
        local  enemies2 = FindUnitsInRadius(pl:GetTeamNumber(), Vector(X,Y,pl:GetAbsOrigin().z), nil, ab:GetSpecialValueFor("rd")+self:GetCaster():GetTalentValue("special_bonus_imba_lh_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
        for _,target2 in pairs(enemies2) do
            local damageTable = {
                victim = target2,
                attacker = pl,
                damage =  ab:GetSpecialValueFor("dam")+ab:GetSpecialValueFor("attr_scale")*pl:GetIntellect(),
                damage_type = ab:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ab,
                }
            ApplyDamage(damageTable)  
            target2:AddNewModifier(pl, ab, "modifier_tg_lh_se_debuff", {duration=ab:GetSpecialValueFor("stun")})
        end   
    end  
end
function tg_lh_se_a:OnSpellStart()
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_tg_lh_pn_buff") then
        local pos=self:GetCursorPosition()
        local casterpos=caster:GetAbsOrigin()
        if pos==casterpos then
            pos=casterpos+caster:GetForwardVector()*10
        end
        local  dir =TG_direction(pos,casterpos)
        local  dis=self:GetSpecialValueFor("jump")
        local dur =dis/ 1400
        curpos=self:GetCursorPosition()
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_jump", {duration = dur, direction = dir})
        caster:AddNewModifier(caster, self, "modifier_tg_lh_pn_Changeon", {duration = 1.5})
    else  
        self:se(caster,self,self:GetCursorPosition())
    end 
end

modifier_tg_lh_se_debuff=modifier_tg_lh_se_debuff or class({})

function modifier_tg_lh_se_debuff:IsDebuff()
    return true 
end
function modifier_tg_lh_se_debuff:IsPurgable() 			
    return false
end
function modifier_tg_lh_se_debuff:IsPurgeException() 		
    return true 
end
function modifier_tg_lh_se_debuff:IsHidden()				
    return false 
end

function modifier_tg_lh_se_debuff:CheckState()
    return 
    {
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_tg_lh_se_debuff:GetEffectName() 
	return "particles/generic_gameplay/generic_stunned.vpcf" 
end

function modifier_tg_lh_se_debuff:GetEffectAttachType() 
	return PATTACH_OVERHEAD_FOLLOW 
end

modifier_tg_lh_pn_jump=modifier_tg_lh_pn_jump or class({})

function modifier_tg_lh_pn_jump:IsBuff()
    return true 
end
function modifier_tg_lh_pn_jump:IsPurgable() 			
    return false
end
function modifier_tg_lh_pn_jump:IsPurgeException() 		
    return false 
end
function modifier_tg_lh_pn_jump:IsHidden()				
    return true 
end
function modifier_tg_lh_pn_jump:RemoveOnDeath()		
    return true 
end

function modifier_tg_lh_pn_jump:IsMotionController() 
	return true 
end

function modifier_tg_lh_pn_jump:GetMotionControllerPriority() 
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM 
end

function modifier_tg_lh_pn_jump:OnCreated(TG)
    if IsServer() then
        self:GetAbility():se(self:GetParent(),self:GetAbility(),curpos)
		self.direction = StringToVector(TG.direction)
		self.speed = 1400
		if not self:CheckMotionControllers() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_tg_lh_pn_jump:OnIntervalThink()
	local POS = self:GetParent():GetAbsOrigin() + self.direction * (self.speed / (1.0 / FrameTime()))
	POS = GetGroundPosition(POS, nil)
	self:GetParent():SetOrigin(POS)

end

function modifier_tg_lh_pn_jump:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.direction = nil
        self.speed = nil
        self:GetAbility():se(self:GetParent(),self:GetAbility(),self:GetParent():GetAbsOrigin())
	end
end

function modifier_tg_lh_pn_jump:CheckState()
    return 
    {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end


modifier_tg_lh_pn_Changeon=modifier_tg_lh_pn_Changeon or class({})
function modifier_tg_lh_pn_Changeon:IsBuff()
    return true 
end
function modifier_tg_lh_pn_Changeon:IsPurgable() 			
    return false
end
function modifier_tg_lh_pn_Changeon:IsPurgeException() 		
    return false 
end
function modifier_tg_lh_pn_Changeon:IsHidden()				
    return true 
end
function modifier_tg_lh_pn_Changeon:RemoveOnDeath()		
    return true 
end

function modifier_tg_lh_pn_Changeon:IsMotionController() 
	return true 
end

function modifier_tg_lh_pn_Changeon:OnCreated()
    if IsServer() then
    self:GetParent():StartGesture(ACT_DOTA_RUN)
end
end
function modifier_tg_lh_pn_Changeon:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_RUN)
	end
end

function modifier_tg_lh_pn_Changeon:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,		
	}

end

function modifier_tg_lh_pn_Changeon:GetModifierModelChange()
    return "models/items/courier/throe/throe_flying.vmdl" 
end
function modifier_tg_lh_pn_Changeon:GetModifierModelScale()
    return 300
end