require("global/global_var_func")
require("info/game_playerinfo")

-- LinkLuaModifier("modifier_prefix_ra_multiple_spell_lua","ability/abilities_lua/modifier_fix/modifier_prefix_ra_lua",LUA_MODIFIER_MOTION_NONE )

-- 拉【Ra】
-- *2 每释放一次技能增加自己6%多重施法概率，超过100%替换为多一次施法，该效果每30秒重置一次
-- *3 15%

modifier_prefix_ra_lua = class({})
--------------------------------------------------------------------------------

function modifier_prefix_ra_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
    return funcs
end

function modifier_prefix_ra_lua:IsHidden()
    return true
end

function modifier_prefix_ra_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_prefix_ra_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_prefix_ra_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.ability_name = {}
    table.insert(self.ability_name, kv.abilityname)
    -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
    self:IncrementStackCount()
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    -- self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_prefix_ra_lua,'used_ability'),self)
    self.useability_count = 0
    random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), self.ability_name[1], 1, "modifier_prefix_ra_lua")
end

function modifier_prefix_ra_lua:OnRefresh(kv)
    if IsServer() then
        if kv.type == 1 then
            self:IncrementStackCount()  -- 增加层数
            table.insert(self.ability_name, kv.abilityname)
        elseif kv.type == 2 then
            self:DecrementStackCount()  -- 减少层数
            for i = 1, #self.ability_name do
                if self.ability_name[i]==kv.abilityname then
                    table.remove(self.ability_name, i)
                    break
                end
            end
        end
        
        for key, value in ipairs(self.ability_name) do
            random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), value, 1, "modifier_prefix_ra_lua")
        end
        if self:GetStackCount() <= 0 then
            -- 删除modifier
            self:Destroy()
        end
    end
end

function modifier_prefix_ra_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    -- StopListeningToGameEvent(self.listenid)
    game_playerinfo:clear_dynamic_properties(self.steam_id, "temp_multiple_spell")
end

function modifier_prefix_ra_lua:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
    end
    self.abilityname = keys.ability:GetAbilityName()
    if string.find(self.abilityname,"item_") or 
        string.find(self.abilityname,"currier_blink") then
        return
    end
    if self.caster == keys.ability:GetCaster() then
        -- print(" >>>>>>>>>>>> abilityname: "..self.abilityname)
        self.ability_behavior = keys.ability:GetBehavior()
        self.target = keys.ability:GetCursorTarget()
        self.pos = keys.ability:GetCursorPosition()
        self.cost = keys.cost
        if RollPercentage(game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "temp_multiple_spell")) then
            -- 触发多重施法
            keys.ability:EndCooldown()
            self.caster:GiveMana(self.cost)
            self:StartIntervalThink(0.5)
        else
            if self:GetStackCount() == 2 then
                game_playerinfo:set_dynamic_properties(self.steam_id, "temp_multiple_spell", 6)
                -- self.caster:AddNewModifier(self.caster, nil, "modifier_prefix_ra_multiple_spell_lua", {duration = 5, critical_damage = 6})
            elseif self:GetStackCount() == 3 then
                game_playerinfo:set_dynamic_properties(self.steam_id, "temp_multiple_spell", 15)
                -- self.caster:AddNewModifier(self.caster, nil, "modifier_prefix_ra_multiple_spell_lua", {duration = 5, critical_damage = 15})
            end
        end
    end
end

function modifier_prefix_ra_lua:OnIntervalThink()
    local ability = self.caster:FindAbilityByName(self.abilityname)
    game_playerinfo:clear_dynamic_properties(self.steam_id, "temp_multiple_spell")
    if (bit.band(self.ability_behavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED) or (bit.band(self.ability_behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) == DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) then
        self:StartIntervalThink(-1)
        -- print(">>>>>>>>>>>>> return >>>>>>>>>>>>>>>>>>: "..self.ability_behavior)
        return
    end
    -- self.caster:CastAbilityImmediately(ability, self.caster:GetEntityIndex())
    if (bit.band(self.ability_behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT) then
        -- 技能为点施法
        -- print(self.pos)
        self.pos.x = self.pos.x - 100
        -- print(self.pos)
        self.caster:CastAbilityOnPosition(self.pos, ability, self.caster:GetEntityIndex())
    elseif (bit.band(self.ability_behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
        -- print(">>>>>>>>>>>>> target >>>>>>>>>>>>>>>>>>: "..self.ability_behavior)
        self.caster:CastAbilityOnTarget(self.target, ability, self.caster:GetEntityIndex())
    else
        -- print(">>>>>>>>>>>>> immediately >>>>>>>>>>>>>>>>>>: "..self.ability_behavior)
        self.caster:CastAbilityImmediately(ability, self.caster:GetEntityIndex())
    end
    
    -- ability:OnSpellStart()
    
    -- print(" >>>>>>>>>>>>> multiple_spell !!>>>>>>>>>>>>>>>>>: "..self.abilityname)
    self:StartIntervalThink(-1)
end
