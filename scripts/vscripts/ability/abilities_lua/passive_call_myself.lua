LinkLuaModifier("modifier_passive_call_myself", "ability/abilities_lua/passive_call_myself.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_call_myself_state_think", "ability/abilities_lua/passive_call_myself.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_call_myself = class({})

function passive_call_myself:GetIntrinsicModifierName()
	return "modifier_passive_call_myself"
end

-------------------------------------------------------------

modifier_passive_call_myself = class({})

function modifier_passive_call_myself:CheckState()
	return {}
end

function modifier_passive_call_myself:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK,
    }
end

function modifier_passive_call_myself:OnAttack(params)
    if params.attacker == self.caster and params.attacker:IsRealHero() then
        if RollPercentage(10) and self.caster.illusion_count < 3 then
            local num = RandomInt(1, 3)
            if self.caster.illusion_count + num > 3 then
                num = 3 - self.caster.illusion_count
            end
            local illusions = CreateIllusions(
                self.caster,
                self.caster,
                {
                    outgoing_damage = 100,	-- 造成%的伤害
                    incoming_damage = 1000,	-- 受到%的伤害
                    -- bounty_base = 15,	-- 击杀获得15金钱
                    -- outgoing_damage_structure = 100,	-- 对建筑造成%伤害
                    -- outgoing_damage_roshan = 100,	-- 对肉山造成%伤害
                    duration = 5,
                }, 
                num, 
                50, 
                true, 
                true
            )
            for _,illusion in pairs(illusions) do
                illusion:SetBaseStrength(self.caster:GetBaseStrength())
                illusion:SetBaseAgility(self.caster:GetBaseAgility())
                illusion:SetBaseIntellect(self.caster:GetBaseIntellect())
                illusion:SetOwner(self.caster)
                illusion:AddNewModifier(self.caster, self.ability, "modifier_passive_call_myself_state_think", nil)
                self.caster.illusion_count = self.caster.illusion_count + 1
            end
        end
    end    
end

function modifier_passive_call_myself:IsHidden()
    return true
end

function modifier_passive_call_myself:IsPurgable()
    return false
end
 
function modifier_passive_call_myself:RemoveOnDeath()
    return true
end

function modifier_passive_call_myself:OnCreated(params)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
        self.caster.illusion_count = 0
        self:OnWore()
    end
end

function modifier_passive_call_myself:OnWore()
    if IsServer() then
        local item = nil 
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_arms/scifi_sniper_test_arms.vmdl"})
        item:FollowEntity(self.caster, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_back/scifi_sniper_test_back.vmdl"})
        ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_jetpack.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
        item:FollowEntity(self.caster, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_gun/scifi_sniper_test_gun.vmdl"})
        ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
        item:FollowEntity(self.caster, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_head/scifi_sniper_test_head.vmdl"})
        ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_head.vpcf", PATTACH_POINT_FOLLOW, item)
        item:FollowEntity(self.caster, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/scifi_sniper_test_shoulder/scifi_sniper_test_shoulder.vmdl"})
        item:FollowEntity(self.caster, true)
    end
end

-------------------------------------------------------------

modifier_passive_call_myself_state_think = class({})

function modifier_passive_call_myself_state_think:CheckState()
	return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

function modifier_passive_call_myself_state_think:DeclareFunctions()
	return {}
end

function modifier_passive_call_myself_state_think:IsHidden()
    return true
end

function modifier_passive_call_myself_state_think:IsPurgable()
    return false
end
 
function modifier_passive_call_myself_state_think:RemoveOnDeath()
    return true
end

function modifier_passive_call_myself_state_think:OnCreated(params)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability:GetCaster()
        self.parent = self:GetParent()
    end
end

function modifier_passive_call_myself_state_think:OnDestroy()
    if IsServer() then
        if self.caster.illusion_count > 0 then
            self.caster.illusion_count = self.caster.illusion_count - 1
        end
        UTIL_Remove(self.parent)
    end
end