
LinkLuaModifier("modifier_passive_withered_attack_lua","ability/abilities_lua/passive_withered_attack_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_withered_attack_debuff_lua","ability/abilities_lua/passive_withered_attack_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_withered_attack_lua_d = class({})
function passive_withered_attack_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_withered_attack_lua"
end

passive_withered_attack_lua_c = class({})
function passive_withered_attack_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_withered_attack_lua"
end

if modifier_passive_withered_attack_lua == nil then
	modifier_passive_withered_attack_lua = class({})
end


function modifier_passive_withered_attack_lua:IsHidden()
    return false
end

function modifier_passive_withered_attack_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_withered_attack_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_withered_attack_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_withered_attack_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_passive_withered_attack_lua:OnAttackLanded(params)
    -- DeepPrintTable(target)
    local percent = 0
    -- local percentvalue = 0
    local target = params.target
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_GENERAL) or ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_OPERATION) then
            -- target:SetMaxHealth(target:GetMaxHealth()*(1-tonumber(string.format("%.2f",0.5*self:GetAbility():GetSpecialValueFor("percent")))))
            -- print(" >>>>>>>>>>>　GetMaxHealth: "..target:GetMaxHealth())
            -- print(" >>>>>>>>>>>percent: "..tonumber(string.format("%.2f",0.5*self:GetAbility():GetSpecialValueFor("percent"))))
            -- local modifier = target:FindModifierByName("modifier_withered_attack_debuff_lua")
            -- if not modifier then
            -- table.insert(self.percent, (1-tonumber(string.format("%.2f",0.5*self:GetAbility():GetSpecialValueFor("percent")))))
            -- table.insert(self.percent, (1-0.5*self:GetAbility():GetSpecialValueFor("percent")))
            percent = 0.5*self:GetAbility():GetSpecialValueFor("percent")
                -- target:AddNewModifier( target, nil, "modifier_withered_attack_debuff_lua", {duration = 9999999, percent = (1-tonumber(string.format("%.2f",0.5*self:GetAbility():GetSpecialValueFor("percent"))))} )
            -- else
            --     -- modifier:IncrementStackCount()
            --     table.insert(modifier.percent, params.percent)
            -- end
        else
            -- target:SetMaxHealth(target:GetMaxHealth()*(1-tonumber(string.format("%.2f",self:GetAbility():GetSpecialValueFor("percent")))))
            -- local modifier = target:FindModifierByName("modifier_withered_attack_debuff_lua")
            -- if not modifier then
            -- table.insert(self.percent, (1-self:GetAbility():GetSpecialValueFor("percent")))
            percent = self:GetAbility():GetSpecialValueFor("percent")
                -- target:AddNewModifier( target, nil, "modifier_withered_attack_debuff_lua", {duration = 9999999, percent = (1-tonumber(string.format("%.2f",self:GetAbility():GetSpecialValueFor("percent"))))} )
            -- else
            --     -- modifier:IncrementStackCount()
            --     table.insert(modifier.percent, params.percent)
            -- end
        end
        -- for i = 1, #self.percent do
        --     if percentvalue==0 then
        --         percentvalue = self.percent[i]
        --     else
        --         percentvalue = percentvalue*(self.percent[i])
        --     end
        -- end
        -- print(" >>>>>>>>>>>>>>> OnAttackLanded percent: "..percentvalue)
        
        local modifier = target:FindModifierByName("modifier_withered_attack_debuff_lua")
        if not modifier then
            percent = percent*100
            target:AddNewModifier( target, nil, "modifier_withered_attack_debuff_lua", {duration = 9999999, percent = percent} )
        else
            local modifpercent = 1-(modifier.percentvalue*0.01)
            percent = (1-(modifpercent*(1-percent)))*100
            target:AddNewModifier( target, nil, "modifier_withered_attack_debuff_lua", {duration = 9999999, percent = percent} )
        end
    end
    return
end



if modifier_withered_attack_debuff_lua == nil then
	modifier_withered_attack_debuff_lua = class({})
end


function modifier_withered_attack_debuff_lua:IsHidden()
    return false
end

function modifier_withered_attack_debuff_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_withered_attack_debuff_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_withered_attack_debuff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }
    return funcs
end

function modifier_withered_attack_debuff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- self.percent = {}
    self.percentvalue = params.percent
    -- table.insert(self.percent, params.percent)
end

function modifier_withered_attack_debuff_lua:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    self.percentvalue = params.percent
end

function modifier_withered_attack_debuff_lua:GetModifierExtraHealthPercentage()
    if not IsServer( ) then
        return
    end
    return -self.percentvalue
end
