boss_god_metal_chop = class({})

function boss_god_metal_chop:OnSpellStart()
    self.target = self:GetCursorTarget()
    self.caster = self:GetCaster()
    self.caster.delay = 0
    self:MoveToPosition()
    self.caster:SetContextThink(DoUniqueString("CreateProjectile"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.delay = self.caster.delay + 0.1
        if self.caster.delay >= 1.3 then
            self:CreateProjectile()
            return nil
        end
        return 0.1
    end, 0)
end

function boss_god_metal_chop:MoveToPosition()
    local target_position = self.target:GetOrigin()
    local target_back_position = target_position + self.target:GetForwardVector() * 500
    target_back_position = RotatePosition(target_position, QAngle(0, 180, 0), target_back_position)
    FindClearSpaceForUnit(self.caster, target_back_position, true)
end

function boss_god_metal_chop:CreateProjectile()
    local info = {
        -- EffectName = "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf",
        EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
        Ability = self,
        fStartRadius = 10,
        fEndRadius = 300,
        fDistance = 2000,
        Source = self.caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO,
        vSpawnOrigin = self.caster:GetOrigin() + self.caster:GetForwardVector() * 300,
        fExpireTime = GameRules:GetGameTime() + 5,
    }
    local num = 3
    local position_table = {}
    local s_position = self.caster:GetOrigin()
    local forward = self.caster:GetForwardVector()
    for i = 1, num do
        local t_position = s_position + forward * 2100
        t_position = RotatePosition(s_position, QAngle(0, (i - num + 1) * 20, 0), t_position)
        info.vVelocity = (t_position - s_position):Normalized() * 600
        ProjectileManager:CreateLinearProjectile(info)
        local index = ParticleManager:CreateParticle( 
            "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", 
            PATTACH_CUSTOMORIGIN, 
            nil 
        )
        ParticleManager:SetParticleControl(index, 0, s_position + forward * 300)
        ParticleManager:SetParticleControl(index, 1, t_position)
        ParticleManager:SetParticleControl(index, 3, Vector(0, 4, 0))
        ParticleManager:ReleaseParticleIndex(index)
        table.insert(position_table, {
            s_position = s_position + forward * 300,
            t_position = t_position,
        })
    end
    self.caster.delay2 = 0
    self.caster:SetContextThink(DoUniqueString("earth_splitter"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        self.caster.delay2 = self.caster.delay2 + 1
        if self.caster.delay2 >= 5 then
            for i = 1, 3 do
                local enemies = FindUnitsInLine(
                    self.caster:GetTeamNumber(), 
                    position_table[1].s_position, 
                    position_table[1].t_position, 
                    nil, 
                    200, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE
                )
                for _, enemy in pairs(enemies) do
                    ApplyDamage({
                        victim = enemy,
                        attacker = self.caster,
                        damage = enemy:GetMaxHealth() / 3,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self,
                    })
                end
            end
            return nil
        end
        return 1
    end, 0)
end

function boss_god_metal_chop:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    if hTarget then
        ApplyDamage({
            victim = hTarget,
            attacker = self.caster,
            damage = hTarget:GetMaxHealth() / 5,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        })
        if not hTarget:FindModifierByName("modifier_boss_god_metal_spear") then
            hTarget:AddNewModifier(self.caster, self, "modifier_common_move_speed", {duration = 1})
            hTarget:SetOrigin(vLocation)
        end
    end
	return false
end