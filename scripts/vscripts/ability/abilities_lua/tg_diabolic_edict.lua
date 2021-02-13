
LinkLuaModifier("modifier_tg_lh_de_buff", "ability/abilities_lua/TG_diabolic_edict.lua", LUA_MODIFIER_MOTION_NONE)

tg_lh_de_b=tg_lh_de_b or class({})

function tg_lh_de_b:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_de_b:IsStealable() 
    return true 
end

function tg_lh_de_b:IsNetherWardStealable() 
    return true 
end

function tg_lh_de_b:IsRefreshable() 			
    return true 
end

function tg_lh_de_b:ProcsMagicStick() 			
    return true 
end

function tg_lh_de_b:OnSpellStart()
    if self:GetCaster():IsAlive() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_de_buff", {duration=self:GetSpecialValueFor("dur")})
    end
end

tg_lh_de_a=tg_lh_de_a or class({})

function tg_lh_de_a:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_de_a:IsStealable() 
    return true 
end

function tg_lh_de_a:IsNetherWardStealable() 
    return true 
end

function tg_lh_de_a:IsRefreshable() 			
    return true 
end

function tg_lh_de_a:ProcsMagicStick() 			
    return true 
end

function tg_lh_de_a:OnSpellStart()
    if self:GetCaster():IsAlive() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_de_buff", {duration=self:GetSpecialValueFor("dur")})
    end
end

tg_lh_de_s=tg_lh_de_s or class({})

function tg_lh_de_s:IsHiddenWhenStolen() 
    return false 
end

function tg_lh_de_s:IsStealable() 
    return true 
end

function tg_lh_de_s:IsNetherWardStealable() 
    return true 
end

function tg_lh_de_s:IsRefreshable() 			
    return true 
end

function tg_lh_de_s:ProcsMagicStick() 			
    return true 
end

function tg_lh_de_s:OnSpellStart()
    if self:GetCaster():IsAlive() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tg_lh_de_buff", {duration=self:GetSpecialValueFor("dur")})
    end
end

modifier_tg_lh_de_buff=modifier_tg_lh_de_buff or class({})

function modifier_tg_lh_de_buff:IsBuff()
    return true 
end
function modifier_tg_lh_de_buff:IsPurgable() 			
    return false
end
function modifier_tg_lh_de_buff:IsPurgeException() 		
    return false 
end
function modifier_tg_lh_de_buff:IsHidden()				
    return false 
end


function modifier_tg_lh_de_buff:OnCreated()	
    if IsServer() then
        -- self.particle1 = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_de1.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("de"))
    end
end
function modifier_tg_lh_de_buff:OnIntervalThink()
    if IsServer() then
        local  enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)		
        if enemies ~= nil then
            local attr_scale = self:GetAbility():GetSpecialValueFor("attr_scale")
            for _,target in pairs(enemies) do
                local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_deenemy5.vpcf", PATTACH_ABSORIGIN_FOLLOW,target)
                local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW,target)
                
                self:GetCaster():EmitSound("Hero_Leshrac.Diabolic_Edict")
                if target:IsBuilding() then
                    d= (self:GetAbility():GetSpecialValueFor("dam")+self:GetCaster():GetIntellect()*attr_scale)*2
                else
                    d= self:GetAbility():GetSpecialValueFor("dam")+self:GetCaster():GetIntellect()*attr_scale
                    if target:GetMana()>0 and target:IsRealHero() then
                        target:ReduceMana(self:GetAbility():GetSpecialValueFor("mana"))
                        -- if self:GetCaster():HasModifier("modifier_tg_lh_pn_buff") then
                        --     self:GetCaster():SetMana(self:GetCaster():GetMana()+self:GetAbility():GetSpecialValueFor("mana"))
                        -- end
                    end
                end
                local damageTable = {
                    attacker =  self:GetCaster(),
                    victim = target,
                    damage = d,
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    ability = self:GetAbility()
                }
                ApplyDamage(damageTable)
            end
        end
    end
end

function modifier_tg_lh_de_buff:OnDestroy()	
    if IsServer() then
        if self.particle1~=nil then
            ParticleManager:DestroyParticle(self.particle1, false)
            self.particle1=nil
        end		
        StopSoundOn("Hero_Leshrac.Diabolic_Edict",self:GetCaster())
    end	
end

