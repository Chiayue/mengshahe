require("global/random_affix")
require("info/game_playerinfo")


-- 【森林】
-- *2 杀戮收入+30%
-- *3 杀戮收入+50%

modifier_suffix_forest_lua = class({})
--------------------------------------------------------------------------------

function modifier_suffix_forest_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_suffix_forest_lua:IsHidden()
    return true
end

function modifier_suffix_forest_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_suffix_forest_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_suffix_forest_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.ability_name = {}
    table.insert(self.ability_name, kv.abilityname)
    -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
    self:IncrementStackCount()
    self.caster = self:GetParent()
    self.useability_count = 0
    self.increase = 0    -- 增幅数值
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), self.ability_name[1], 2, "modifier_suffix_forest_lua")
end

function modifier_suffix_forest_lua:OnRefresh(kv)
    if IsServer() then
        -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
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
        local percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "shalu_increase")
        if percent > 0 then
            game_playerinfo:set_dynamic_properties(self.steam_id, "shalu_increase", -self.increase)
        end
        if self:GetStackCount() == 2 then
            self.increase = 30
        elseif self:GetStackCount() ==3 then
            self.increase = 50
        else
            self.increase = 0
        end
        game_playerinfo:set_dynamic_properties(self.steam_id, "shalu_increase", self.increase)
        
        for key, value in ipairs(self.ability_name) do
            random_affix:show_fix_description(self:GetStackCount(), self.caster:GetPlayerID(), value, 2, "modifier_suffix_forest_lua")
        end
        if self:GetStackCount() <= 0 then
            -- 删除modifier
            self:Destroy()
        end
    end
end

function modifier_suffix_forest_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
end