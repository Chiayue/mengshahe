LinkLuaModifier("modifier_passive_purification", "ability/abilities_lua/passive_purification.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_purification = class({})

function passive_purification:GetIntrinsicModifierName()
	return "modifier_passive_purification"
end

-------------------------------------------------------------

modifier_passive_purification = class({})

function modifier_passive_purification:CheckState()
	return {}
end

function modifier_passive_purification:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK,
    }
end

function modifier_passive_purification:OnAttack(params)
    if params.attacker == self.caster then
        if RollPercentage(30) and (GameRules:GetGameTime() - self.time > 1) then
            self.time = GameRules:GetGameTime()
            local index = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(index, 0, self.caster:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
            local damage = (self.caster:GetAgility() + self.caster:GetStrength()) * 4
            local enemies = FindUnitsInRadius(
                self.caster:GetTeamNumber(), 
                self.caster:GetOrigin(), 
                nil, 
                500, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_ALL, 
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST, 
                false
            )
            local count = 0
            for _, enemy in pairs(enemies) do
                ApplyDamage({
                    victim = enemy,
                    attacker = self.caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    ability = self.ability,
                })
                count = count + 1
                if count >= 4 then
                    break
                end
            end
            self.caster:Heal(damage * 0.5, self.caster)
        end
    end    
end

function modifier_passive_purification:IsHidden()
    return true
end

function modifier_passive_purification:IsPurgable()
    return false
end
 
function modifier_passive_purification:RemoveOnDeath()
    return true
end

function modifier_passive_purification:OnCreated(params)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self:GetCaster()
        self.time = GameRules:GetGameTime()
    end
end