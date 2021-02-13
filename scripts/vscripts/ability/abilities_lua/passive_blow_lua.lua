passive_blow_lua = class({})

LinkLuaModifier("modifier_passive_blow_lua","ability/abilities_lua/passive_blow_lua",LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier("modifier_passive_blow_crit_lua","ability/abilities_lua/passive_blow_lua",LUA_MODIFIER_MOTION_NONE )

function passive_blow_lua:GetIntrinsicModifierName()
	return "modifier_passive_blow_lua"
end

if modifier_passive_blow_lua == nil then
    modifier_passive_blow_lua = class({})
end

function modifier_passive_blow_lua:IsHidden()
    return false -- 不隐藏
end

function modifier_passive_blow_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_blow_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_blow_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_blow_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START ,
    }
    return funcs
end

function modifier_passive_blow_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.ability = self:GetAbility()
end

function modifier_passive_blow_lua:OnAttackStart(params)
    if IsServer( ) then
        local caster = self:GetCaster()
        if params.attacker == caster then
            local random = math.random(1,100)
            if random <= self.ability:GetSpecialValueFor("chance") + GameRules:GetCustomGameDifficulty()*5 then
                caster:AddNewModifier(caster, nil, "modifier_critical_strike", { critical_damage = self.ability:GetSpecialValueFor("times") ,duration = 1})
                -- caster:AddNewModifier(caster, nil, "modifier_passive_blow_crit_lua", {duration = 1})
            end
        end
    end
end 

-- if modifier_passive_blow_crit_lua == nil then
--     modifier_passive_blow_crit_lua = class({})
-- end

-- function modifier_passive_blow_crit_lua:IsHidden()
--     return true 
-- end

-- function modifier_passive_blow_crit_lua:DeclareFunctions()
--     local funcs = {
--         MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE ,
--     }
--     return funcs
-- end

-- function modifier_passive_blow_crit_lua:OnCreated(params)
--     if not IsServer( ) then
--         return
--     end
-- end

-- --爆伤
-- function modifier_passive_blow_crit_lua:GetModifierPreAttack_CriticalStrike(params)
--     return 200
-- end 
