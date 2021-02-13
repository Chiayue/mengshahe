boss_god_earth_slam = class({})

function boss_god_earth_slam:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.slam_channel_count = 0

        self.caster:SetContextThink(DoUniqueString("boss_god_earth_slam_channel_sound"), function ()
            self.index = ParticleManager:CreateParticle(
                "particles/heroes/boss/ursa_earthshock.vpcf",
                PATTACH_WORLDORIGIN,
                nil
            )
            local target_position = self.caster:GetOrigin() + self.caster:GetForwardVector() * 500
            ParticleManager:SetParticleControl(self.index, 0, target_position)
            ParticleManager:ReleaseParticleIndex(self.index)
            EmitSoundOn("storegga.slam.up", self.caster)
            return nil
        end,
        1)

        self.caster:SetContextThink(DoUniqueString("boss_god_earth_slam"), function ()
            if not self.caster:IsAlive() then
                ParticleManager:DestroyParticle(self.index , false)
                return nil
            end
            local index = ParticleManager:CreateParticle(
                "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf",
                PATTACH_WORLDORIGIN,
                nil
            )
            local target_position = self.caster:GetOrigin() + self.caster:GetForwardVector() * 500
            ParticleManager:SetParticleControl(index, 0, target_position)
            ParticleManager:ReleaseParticleIndex(index)
            EmitSoundOn("storegga.slam.down", self.caster)
            local enemies = FindUnitsInRadius(
                self.caster:GetTeamNumber(), 
                target_position, 
                nil, 
                600, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO, 
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
                FIND_CLOSEST, 
                false
            )
            for _, enemy in pairs(enemies) do
                if enemy:IsRealHero() then
                    ApplyDamage({
                        victim = enemy,
                        attacker = self.caster,
                        damage = enemy:GetMaxHealth() * 0.3,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
                        ability = self
                    })
                    enemy:AddNewModifier(self.caster, self, "modifier_common_stun", {duration = 1})
                    enemy:AddNewModifier(self.caster, self, "modifier_common_move_speed", {duration = 3})
                end
            end
            return nil
        end, 
        2.3)
    end
end