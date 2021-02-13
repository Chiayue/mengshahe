-- 宝物: 贸易家

if modifier_treasure_maoyi == nil then 
    modifier_treasure_maoyi = class({})
end

function modifier_treasure_maoyi:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_maoyi"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_maoyi:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_maoyi:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_maoyi:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_maoyi:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self.caster = self:GetCaster()
    self.steam_id = PlayerResource:GetSteamAccountID(self.caster:GetPlayerID())
    -- 贸易等级+5
    local level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"]
    global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"] = level + 5
end

function modifier_treasure_maoyi:OnRefresh(params)
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
    if self:GetStackCount() == 2 then
        -- 贸易等级+10，其他投资等级-10
        local level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"] = level + 5

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_touzi_lua"] = level - 10

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_lueduo_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_lueduo_lua"] = level - 10

        level = global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_shalu_lua"]
        global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_shalu_lua"] = level - 10
    elseif self:GetStackCount() == 3 then
        -- 当贸易等级到达100后，贸易收益+50%
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_maoyi:OnIntervalThink()
    local modifier = self.caster:FindModifierByName("modifier_maoyi_lua")
    if modifier then
        if (modifier:GetStackCount() + global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"]) >= 100 then
            -- 贸易开启珍藏系统
            modifier.opencollection = true
            self:StartIntervalThink(-1)
        end
    end
end