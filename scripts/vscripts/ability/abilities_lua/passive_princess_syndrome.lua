LinkLuaModifier("modifier_passive_princess_syndrome", "ability/abilities_lua/passive_princess_syndrome.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_princess_syndrome_attribute_gain", "ability/abilities_lua/passive_princess_syndrome.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_princess_syndrome = class({})

function passive_princess_syndrome:GetIntrinsicModifierName()
	return "modifier_passive_princess_syndrome"
end

-------------------------------------------------------------

modifier_passive_princess_syndrome = class({})

function modifier_passive_princess_syndrome:CheckState()
	return {}
end

function modifier_passive_princess_syndrome:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_passive_princess_syndrome:GetModifierIncomingDamage_Percentage(params)
    if params.attacker:GetUnitName() ~= "npc_dota_hero_naga_siren" then
        local count, hero_table = GetOtherHeroAliveCount(self.parent)
        if count > 0 then
            local damage = params.original_damage * 0.3 / count
            for _, hero in pairs(hero_table) do
                local index = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse_flame.vpcf", PATTACH_WORLDORIGIN, nil)
                ParticleManager:SetParticleControl(index, 0, self.parent:GetOrigin())
                ParticleManager:SetParticleControl(index, 1, hero:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                ApplyDamage({
                    victim = hero,
                    attacker = self.parent,
                    damage = damage,
                    damage_type = params.damage_type,
                    damage_flags = params.damage_flags,
                    ability = self.ability,
                })
            end
            return -30
        else
            return 0
        end
    end
    return 0
end

function modifier_passive_princess_syndrome:IsHidden()
    return true
end

function modifier_passive_princess_syndrome:IsPurgable()
    return false
end
 
function modifier_passive_princess_syndrome:RemoveOnDeath()
    return false
end

function modifier_passive_princess_syndrome:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        for _, hero in pairs(HeroList:GetAllHeroes()) do
            hero:AddNewModifier(self.parent, self.ability, "modifier_passive_princess_syndrome_attribute_gain", nil)
        end
        ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(modifier_passive_princess_syndrome, "OnPlayerGainedLevel"), self)
        ListenToGameEvent("entity_killed", Dynamic_Wrap(modifier_passive_princess_syndrome, "OnEntityKilled"), self)
        -- self:OnWore()
    end
end

-- function modifier_passive_princess_syndrome:OnWore()
--     if IsServer() then
--         local item = nil 
--         item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_arms/scifi_sniper_test_arms.vmdl"})
--         item:FollowEntity(self.caster, true)
--         item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_back/scifi_sniper_test_back.vmdl"})
--         ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_jetpack.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
--         item:FollowEntity(self.caster, true)
--         item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_gun/scifi_sniper_test_gun.vmdl"})
--         ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
--         item:FollowEntity(self.caster, true)
--         item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_head/scifi_sniper_test_head.vmdl"})
--         ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_head.vpcf", PATTACH_POINT_FOLLOW, item)
--         item:FollowEntity(self.caster, true)
--         item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_shoulder/scifi_sniper_test_shoulder.vmdl"})
--         item:FollowEntity(self.caster, true)
--     end
-- end

function modifier_passive_princess_syndrome:OnPlayerGainedLevel(event)
    if IsServer() then
        local mdf = self.parent:FindModifierByName("modifier_passive_princess_syndrome_attribute_gain")
        mdf:SetStackCount(mdf:GetStackCount() + 8) 
    end
end

function modifier_passive_princess_syndrome:OnEntityKilled(event)
    if IsServer() then
        local dead = EntIndexToHScript(event.entindex_killed)
        if dead and dead:IsRealHero() and dead ~= self.parent then
            local attacker = EntIndexToHScript(event.entindex_attacker)
            if attacker and attacker == self.parent then
                local mdf = dead:FindModifierByName("modifier_passive_princess_syndrome_attribute_gain")
                if mdf then
                    mdf:SetStackCount(mdf:GetStackCount() + 20)
                else
                    dead:SetContextThink(DoUniqueString("modifier_passive_princess_syndrome_attribute_gain"), function ()
                        if dead:IsAlive() then
                            mdf = dead:AddNewModifier(self.parent, self.ability, "modifier_passive_princess_syndrome_attribute_gain", nil)
                            mdf:SetStackCount(mdf:GetStackCount() + 20)
                            return nil
                        end
                        return 1
                    end, 0)
                end
            end
        end
    end
end

-------------------------------------------------------------

modifier_passive_princess_syndrome_attribute_gain = class({})

function modifier_passive_princess_syndrome_attribute_gain:CheckState()
	return {}
end

function modifier_passive_princess_syndrome_attribute_gain:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_passive_princess_syndrome_attribute_gain:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_passive_princess_syndrome_attribute_gain:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_passive_princess_syndrome_attribute_gain:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_passive_princess_syndrome_attribute_gain:IsHidden()
    return true
end

function modifier_passive_princess_syndrome_attribute_gain:IsPurgable()
    return false
end
 
function modifier_passive_princess_syndrome_attribute_gain:RemoveOnDeath()
    return false
end

function modifier_passive_princess_syndrome_attribute_gain:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
    end
end