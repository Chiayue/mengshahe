require("global/global_var_func")
require("info/game_playerinfo")

-- LinkLuaModifier("modifier_prefix_ra_multiple_spell_lua","ability/abilities_lua/modifier_fix/modifier_prefix_osiris_lua",LUA_MODIFIER_MOTION_NONE )

-- 欧西里斯 【Osiris】
-- *2 召唤物持续时间+50%
-- *3 你的召唤物死亡有20%几率复活

modifier_prefix_osiris_lua = class({})
--------------------------------------------------------------------------------

function modifier_prefix_osiris_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_prefix_osiris_lua:IsHidden()
    return true
end

function modifier_prefix_osiris_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_prefix_osiris_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_prefix_osiris_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.ability_name = {}
    table.insert(self.ability_name, kv.abilityname)
    -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
    self:IncrementStackCount()
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    -- self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_prefix_osiris_lua,'used_ability'),self)
    self.useability_count = 0

    self.durationtime_percent = 0       -- 持续时间增幅
    self.damage_percent = 0     -- 伤害增幅

    random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), self.ability_name[1], 1, "modifier_prefix_osiris_lua")
end

function modifier_prefix_osiris_lua:OnRefresh(kv)
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

        local durationtime_percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "call_unit_durationtime_percent")
        local damage_percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "call_unit_damage_percent")
        if durationtime_percent >= self.durationtime_percent then
            game_playerinfo:set_dynamic_properties(self.steam_id, "call_unit_durationtime_percent", -self.durationtime_percent)
        end
        if damage_percent >= self.damage_percent then
            game_playerinfo:set_dynamic_properties(self.steam_id, "call_unit_damage_percent", -self.damage_percent)
        end
        if self:GetStackCount() == 2 then
            self.durationtime_percent = 50
        elseif self:GetStackCount() ==3 then
            self.durationtime_percent = 50
            self.damage_percent = 50
        else
            self.durationtime_percent = 0
            self.damage_percent = 0
        end
        game_playerinfo:set_dynamic_properties(self.steam_id, "call_unit_durationtime_percent", self.durationtime_percent)
        game_playerinfo:set_dynamic_properties(self.steam_id, "call_unit_damage_percent", self.damage_percent)

        for key, value in ipairs(self.ability_name) do
            random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), value, 1, "modifier_prefix_osiris_lua")
        end
        if self:GetStackCount() <= 0 then
            -- 删除modifier
            self:Destroy()
        end
    end
end

function modifier_prefix_osiris_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    -- StopListeningToGameEvent(self.listenid)
end

function modifier_prefix_osiris_lua:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
    end
    self.abilityname = keys.ability:GetAbilityName()
    if string.find(self.abilityname,"item_") or 
        string.find(self.abilityname,"currier_blink") then
        return
    end
    if self.caster == keys.ability:GetCaster() then
        -- 使用技能的是本身的英雄
        if string.find(self.abilityname,"call_") then
            
        end
    end
end

