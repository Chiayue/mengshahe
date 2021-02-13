-- 宝物： 投资家

if modifier_treasure_touzi == nil then 
    modifier_treasure_touzi = class({})
end
function modifier_treasure_touzi:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_touzi"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_touzi:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_touzi:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_touzi:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_touzi:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self.caster = self:GetCaster()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    -- 投资等级+5
    local level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"]
    global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"] = level + 5
end

function modifier_treasure_touzi:OnRefresh(params)
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
    if self:GetStackCount() == 2 then
        -- 投资等级+10，其他投资等级-10
        local level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"] = level + 5

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"] = level - 10

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_lueduo_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_lueduo_lua"] = level - 10

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_shalu_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_shalu_lua"] = level - 10
    elseif self:GetStackCount() == 3 then
        -- 当投资等级到达100后，投资收益+50%
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_touzi:OnIntervalThink()
    local modifier = self.caster:FindModifierByName("modifier_touzi_lua")
    if modifier then
        if (modifier:GetStackCount() + global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"]) >= 100 then
            -- 投资收益增加50%
            game_playerinfo:set_dynamic_properties(self.steam_id, "touzi_increase", 50)
            self:StartIntervalThink(-1)
        end
    end
end