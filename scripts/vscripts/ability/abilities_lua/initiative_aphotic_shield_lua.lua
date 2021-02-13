--无光之盾--
initiative_aphotic_shield_lua = class({})

LinkLuaModifier("modifier_aphotic_shield","ability/abilities_lua/initiative_aphotic_shield_lua.lua",LUA_MODIFIER_MOTION_NONE)

function initiative_aphotic_shield_lua:GetCooldown(iLevel)   
    local cooldown = self.BaseClass.GetCooldown(self, iLevel)
    cooldown = cooldown - (GameRules:GetCustomGameDifficulty()-1)*1
    return cooldown
end
--施法开始
function initiative_aphotic_shield_lua:OnSpellStart()
    local caster = self:GetCaster()
    EmitSoundOn( "hero.attack.npc_dota_hero_antimage.manashield", self:GetCaster() )
    local friendlys = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        self,
        1000,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
        1,
        false
    )

    local hClosestTarget = nil
    local flClosestDist = 0.0
    -- 选取范围最近的1个单位
    if #friendlys > 0 then
        for _,friendly in pairs(friendlys) do
            if friendly ~= nil then
                local vToTarget = friendly:GetOrigin() - caster:GetOrigin()
                local flDistToTarget = vToTarget:Length()

                if hClosestTarget == nil or flDistToTarget < flClosestDist then
                    hClosestTarget = friendly
                    flClosestDist = flDistToTarget
                end		
            end
        end
    end
    if hClosestTarget ~= nil  then
        -- 变量
        local target = hClosestTarget--event.target
        self.hTarget = hClosestTarget
        if target:HasModifier("modifier_aphotic_shield") then
            target.AphoticShieldRemaining = nil
            target:RemoveModifierByName("modifier_aphotic_shield")
            ParticleManager:DestroyParticle(self.hTarget.ShieldParticle,false)
        end
        --添加修饰器
        hClosestTarget:AddNewModifier(caster,self, "modifier_aphotic_shield",{duration =  self:GetSpecialValueFor("duration"),target = hClosestTarget})
        --伤害吸收
        -- local max_damage_absorb = self:GetLevelSpecialValueFor("damage_absorb",event.ability:GetLevel() - 1)
        local max_damage_absorb = (GameRules:GetCustomGameDifficulty()-1)*200+self:GetSpecialValueFor("damage_absorb")+(global_var_func.current_round*50)*(GameRules:GetCustomGameDifficulty()-1)+200*global_var_func.current_round
        --防护罩尺寸
        local shield_size = 75 -- could be adjusted to model scale

        -- 强力驱散
        --移除正增益
        local RemovePositiveBuffs = false
        --移除减益
        local RemoveDebuffs = true

        local BuffsCreatedThisFrameOnly = false
        local RemoveStuns = true
        local RemoveExceptions = false
        target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
        -- 重置防护罩
        target.AphoticShieldRemaining = max_damage_absorb

        --粒子特效。需要等待一帧，以便旧粒子被摧毁
        Timers:CreateTimer(0.01, function() 
            target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
            ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))
            --设置粒子附着位置
            ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        end)
    end
end

--修饰器
modifier_aphotic_shield = class({})

function modifier_aphotic_shield:IsBuff()			return true end
function modifier_aphotic_shield:IsDebuff()				return true end
function modifier_aphotic_shield:IsHidden() 			return false end
function modifier_aphotic_shield:IsPurgable() 			return false end
function modifier_aphotic_shield:IsPurgeException() 	return false end

function modifier_aphotic_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end
function modifier_aphotic_shield:OnCreated(params)
    if IsServer() then
        self.hTarget = self:GetAbility().hTarget
       --设置计时器
       self:StartIntervalThink(0.03)
       --启动计时器
       self:OnIntervalThink()

    end
end
function modifier_aphotic_shield:OnIntervalThink()
    if(self.hTarget ~= nil) then
        self.hTarget.OldHealth = self.hTarget:GetHealth()
    end
end
function modifier_aphotic_shield:OnTakeDamage(keys)
    if keys.damage > self.hTarget.AphoticShieldRemaining then
        local newHealth = self.hTarget.OldHealth -  keys.damage + self.hTarget.AphoticShieldRemaining
        self.hTarget:SetHealth(newHealth)
        else
        local newHealth = self.hTarget.OldHealth			
        self.hTarget:SetHealth(newHealth)

    end
    self.hTarget.AphoticShieldRemaining =  self.hTarget.AphoticShieldRemaining-keys.damage
    if self.hTarget.AphoticShieldRemaining <= 0 then
        self.hTarget.AphoticShieldRemaining = nil
        self.hTarget:RemoveModifierByName("modifier_aphotic_shield")
    end
end

function modifier_aphotic_shield:OnDestroy()
	if not IsServer( ) then
        return
    end
    self.hTarget:EmitSound("hero.attack.npc_dota_hero_obsidian_destroyer")
    ParticleManager:DestroyParticle(self.hTarget.ShieldParticle,false)
    local enemies = FindUnitsInRadius(
        self:GetAbility():GetCaster():GetTeamNumber(),
        self.hTarget:GetOrigin(),
        self:GetAbility(),
        self:GetAbility():GetSpecialValueFor("damage_range"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
        1,
        false
    )

    if(#enemies > 0) then
        for a,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                if not IsServer() then
                    return
                end
                local damageTable = {
                    victim  =  enemy,
                    attacker = self.hTarget,
                    damage =  (GameRules:GetCustomGameDifficulty()-1)*200+self:GetAbility():GetSpecialValueFor("damage_absorb")+(global_var_func.current_round*50)*(GameRules:GetCustomGameDifficulty()-1)+200*global_var_func.current_round,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(),
                }
                if(damageTable.damage_type ~= nil) then
                    ApplyDamage(damageTable)
                end
            end
        end
    end
end

function modifier_aphotic_shield:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}
	return funcs
end
function modifier_aphotic_shield:GetModifierCooldownReduction_Constant()
    return self:GetAbility():GetCooldown(1)
end
 