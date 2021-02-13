LinkLuaModifier("modifier_boss_finally_ability_1", "ability/boss_ability/boss_finally_ability_1", LUA_MODIFIER_MOTION_NONE)

boss_finally_ability_1 = class({})

function boss_finally_ability_1:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.caster.boss_finally_ability_1_delay = 0
        self.caster.boss_finally_ability_1_count = 0
        self.caster:SetContextThink(DoUniqueString("boss_finally_ability_1"), function ()
            if GameRules:IsGamePaused() then
                return 1
            end
            self.caster.boss_finally_ability_1_delay = self.caster.boss_finally_ability_1_delay + 0.1
            if (self.caster.boss_finally_ability_1_delay >= 0.2 and self.caster.boss_finally_ability_1_count == 0) 
            or (self.caster.boss_finally_ability_1_delay >= 0.8 and self.caster.boss_finally_ability_1_count == 1) then
                local position = self.caster:GetOrigin()
                local enemies = FindUnitsInLine(
                    self.caster:GetTeamNumber(),
                    position,
                    position + self.caster:GetForwardVector() * 800, 
                    nil, 
                    800, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE
                )
                for _, enemy in pairs(enemies) do
                    if IsAlive(enemy) then
                        ApplyDamage({
                            victim = enemy,
                            attacker = self.caster,
                            damage = 2000,
                            damage_type = DAMAGE_TYPE_PHYSICAL,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE,
                            ability = self,
                        })
                        if IsAlive(enemy) then
                            local mdf = enemy:FindModifierByName("modifier_boss_finally_ability_1")
                            if mdf then
                                local num = mdf:GetStackCount()
                                if num < 10  then
                                    mdf:SetStackCount(num + 1)
                                end
                                mdf:SetDuration(20, true)
                            else
                                enemy:AddNewModifier(self.caster, self, "modifier_boss_finally_ability_1", {duration = 20})
                            end  
                        end
                    end
                end
                self.caster.boss_finally_ability_1_count = self.caster.boss_finally_ability_1_count + 1
                if self.caster.boss_finally_ability_1_count >= 2 then
                    return nil
                end
            end
            return 0.1
        end, 0)
    end
end

--------------------------------------------------------------------------

modifier_boss_finally_ability_1 = class({})

function modifier_boss_finally_ability_1:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_boss_finally_ability_1:GetModifierIncomingDamage_Percentage()
    return self:GetStackCount() * 10
end

function modifier_boss_finally_ability_1:IsHidden()
	return false
end

function modifier_boss_finally_ability_1:IsPurgable()
    return false
end

function modifier_boss_finally_ability_1:RemoveOnDeath()
	return true
end

function modifier_boss_finally_ability_1:OnCreated(table)
    if IsServer() then
        self:SetStackCount(1)
    end
end