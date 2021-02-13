LinkLuaModifier("modifier_boss_god_earth_call", "ability/abilities_lua/boss_god_earth_call", LUA_MODIFIER_MOTION_BOTH)

----------------------------------------------------------------------------------

boss_god_earth_call = class({})

function boss_god_earth_call:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        
        self:SetContextThink("boss_god_earth_call", function ()
            if self:IsChanneling() then
                self:GetCaster():StartGestureWithFade(ACT_TINY_GROWL, 0.3, 0.3)
                EmitSoundOn("storegga.call", self.caster)
                return 1.2 
            end
            return nil
        end, 0)

        self.last_time = GameRules:GetGameTime()
        self:SetContextThink("boss_god_earth_call_think", function ()
            if self:IsChanneling() then
                if GameRules:GetGameTime() - self.last_time > 1 then
                    for _, hero in pairs(HeroList:GetAllHeroes()) do
                        if hero:IsAlive() then
                            if hero:IsMoving() then
                                self:CreateHammerParticle(hero:GetOrigin() + hero:GetForwardVector() * 200)
                            else
                                self:CreateHammerParticle(hero:GetOrigin())
                            end

                        end
                    end
                    self.last_time = GameRules:GetGameTime()
                end
                self:CreateHammerParticle(self:GetTargetPosition())
                return 0.1
            end
            return nil
        end, 0)
    end
end

function boss_god_earth_call:GetTargetPosition()
    local position = self.caster:GetOrigin()
    while true do
        local temp_int = RandomInt(500, 4000)
        local target_position = position + RandomVector(temp_int)
        if GridNav:CanFindPath(position, target_position) then
            return target_position
        end
    end
end

function boss_god_earth_call:CreateHammerParticle(position)
    local nFXIndex = ParticleManager:CreateParticle( 
        "particles/items4_fx/meteor_hammer_aoe.vpcf", 
        PATTACH_WORLDORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(nFXIndex, 0, position)
    ParticleManager:ReleaseParticleIndex(nFXIndex)

    self.caster:SetContextThink(DoUniqueString("boss_god_earth_call"), function ()
        local nFXIndex = ParticleManager:CreateParticle( 
            "particles/items4_fx/meteor_hammer_spell.vpcf", 
            PATTACH_WORLDORIGIN, 
            nil
        )
        ParticleManager:SetParticleControl(nFXIndex, 0, position + Vector(0, 0, 2000))
        ParticleManager:SetParticleControl(nFXIndex, 1, position)
        ParticleManager:SetParticleControl(nFXIndex, 2, Vector(0.5, 0, 0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        self:ApplyDamage(position)
        return nil
    end, 3.5)
end

function boss_god_earth_call:ApplyDamage(position)
    self.caster:SetContextThink(DoUniqueString("boss_god_earth_call"), function ()
        local enemies = FindUnitsInRadius(
            self.caster:GetTeamNumber(), 
            position, 
            nil, 
            450, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO, 
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
            FIND_ANY_ORDER, 
            false
        )
        for _, enemy in pairs(enemies) do
            ApplyDamage({
                victim = enemy,
                attacker = self:GetCaster(),
                damage = enemy:GetMaxHealth() * 0.2,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            })
            if enemy:IsAlive() then
                enemy:AddNewModifier(self.caster, self, "modifier_common_stun", { duration = 0.5 })
            end
        end
        return nil
    end, 0.5)
end