require("global/global_var_func")
require("info/game_playerinfo")

-- LinkLuaModifier("modifier_prefix_ra_multiple_spell_lua","ability/abilities_lua/modifier_fix/modifier_prefix_horus_lua",LUA_MODIFIER_MOTION_NONE )

-- 荷鲁斯 【Horus】
-- *2 敌人身上每种异常状态增加15%对其造成的伤害
-- *3 40%

modifier_prefix_horus_lua = class({})
--------------------------------------------------------------------------------

function modifier_prefix_horus_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_prefix_horus_lua:IsHidden()
    return true
end

function modifier_prefix_horus_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_prefix_horus_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_prefix_horus_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.ability_name = {}
    table.insert(self.ability_name, kv.abilityname)
    -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
    self:IncrementStackCount()
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    -- self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_prefix_horus_lua,'used_ability'),self)
    self.useability_count = 0
    self.increase = 0    -- 增幅数值
    random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), self.ability_name[1], 1, "modifier_prefix_horus_lua")
end

function modifier_prefix_horus_lua:OnRefresh(kv)
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
        local percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "abnormal_damage_scale")
        if percent > 0 then
            game_playerinfo:set_dynamic_properties(self.steam_id, "abnormal_damage_scale", -self.increase)
        end
        if self:GetStackCount() == 2 then
            self.increase = 15
        elseif self:GetStackCount() ==3 then
            self.increase = 40
        else
            self.increase = 0
        end
        game_playerinfo:set_dynamic_properties(self.steam_id, "abnormal_damage_scale", self.increase)
        
        for key, value in ipairs(self.ability_name) do
            random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), value, 1, "modifier_prefix_horus_lua")
        end
        if self:GetStackCount() <= 0 then
            -- 删除modifier
            self:Destroy()
        end
    end
end

function modifier_prefix_horus_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    -- StopListeningToGameEvent(self.listenid)
end
