require("global/global_var_func")
require("info/game_playerinfo")

LinkLuaModifier("modifier_prefix_anubis_attackspeed_lua","ability/abilities_lua/modifier_fix/modifier_prefix_anubis_lua",LUA_MODIFIER_MOTION_NONE )

-- 阿努比斯 【Anubis】
-- *2 每次释放技能都会提升自己30%暴击伤害，持续5秒
-- *3 提升80%暴击伤害

modifier_prefix_anubis_lua = class({})
--------------------------------------------------------------------------------

function modifier_prefix_anubis_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_prefix_anubis_lua:IsHidden()
    return true
end

function modifier_prefix_anubis_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_prefix_anubis_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_prefix_anubis_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.ability_name = {}
    table.insert(self.ability_name, kv.abilityname)
    -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
    self:IncrementStackCount()
    self.caster = self:GetParent()
    self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_prefix_anubis_lua,'used_ability'),self)
    self.useability_count = 0
    random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), self.ability_name[1], 1, "modifier_prefix_anubis_lua")
end

function modifier_prefix_anubis_lua:OnRefresh(kv)
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
            random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), value, 1, "modifier_prefix_anubis_lua")
        end
        if self:GetStackCount() <= 0 then
            -- 删除modifier
            self:Destroy()
        end
    end
end

function modifier_prefix_anubis_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    StopListeningToGameEvent(self.listenid)
end

function modifier_prefix_anubis_lua:used_ability(evt)
	-- print(" >>>>>>>>>>>>>>>>>>>>  used_ability: ")
    -- DeepPrintTable(evt)
    local ability_name = evt.abilityname
    if string.find(ability_name,"item_") or 
        string.find(ability_name,"currier_blink") then
        return
    end
    
    local hero = PlayerResource:GetPlayer(evt.PlayerID):GetAssignedHero()
    if hero==self.caster then
        -- 技能使用者和被动技能持有者是同一人
        -- print(" >>>>>>>>>>>>> modifier_prefix_anubis_lua GetStackCount: "..self:GetStackCount())
        if self:GetStackCount() == 2 then
            self.caster:AddNewModifier(self.caster, nil, "modifier_prefix_anubis_attackspeed_lua", {duration = 5, critical_damage = 0.5})
        elseif self:GetStackCount() == 3 then
            self.caster:AddNewModifier(self.caster, nil, "modifier_prefix_anubis_attackspeed_lua", {duration = 5, critical_damage = 1})
        end
    end
end

modifier_prefix_anubis_attackspeed_lua = class({})
--------------------------------------------------------------------------------

function modifier_prefix_anubis_attackspeed_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_prefix_anubis_attackspeed_lua:IsHidden()
    return true
end

function modifier_prefix_anubis_attackspeed_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_prefix_anubis_attackspeed_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.critical_damage = kv.critical_damage
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    game_playerinfo:set_dynamic_properties(self.steam_id, "attack_critical_damage", self.critical_damage)
end

function modifier_prefix_anubis_attackspeed_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    game_playerinfo:set_dynamic_properties(self.steam_id, "attack_critical_damage", -self.critical_damage)
end