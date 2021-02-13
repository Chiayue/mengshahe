-- 宝物： 拉的翼神龙

LinkLuaModifier( "modifier_treasure_ra_kill","treasuresystem/treasure_lua/modifier_treasure_ra", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_ra == nil then 
    modifier_treasure_ra = class({})
end
function modifier_treasure_ra:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_ra"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_ra:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_ra:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_ra:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_ra:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    
    if self.caster:FindModifierByName("modifier_treasure_ra_1") and 
    self.caster:FindModifierByName("modifier_treasure_ra_2") and 
    self.caster:FindModifierByName("modifier_treasure_ra_3") then
        self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_ra_kill", {})
    end
end


------------------------------------------------------------------------------------------------------

if modifier_treasure_ra_kill == nil then 
    modifier_treasure_ra_kill = class({})
end

function modifier_treasure_ra_kill:IsHidden()
    return true -- 隐藏
end

function modifier_treasure_ra_kill:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_ra_kill:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_ra_kill:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_treasure_ra_kill:OnCreated(params)
    if not IsServer() then
        return
    end
    local monster_count = 0
    if self:GetCaster():GetPlayerID()==0 then
        monster_count = #global_var_func.player_0_current_count
    elseif self:GetCaster():GetPlayerID()==1 then
        monster_count = #global_var_func.player_1_current_count
    elseif self:GetCaster():GetPlayerID()==2 then
        monster_count = #global_var_func.player_2_current_count
    elseif self:GetCaster():GetPlayerID()==3 then
        monster_count = #global_var_func.player_3_current_count
    end
    self:SetStackCount(math.ceil(monster_count*0.3))
    ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_treasure_ra_kill,'killed_monster'),self)
end

function modifier_treasure_ra_kill:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_ra_kill:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_ra_kill:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_ra_kill:killed_monster(evt)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
    if hero~=self:GetCaster() then
        -- 怪必须是自己击杀的
        return
    end
    local monster_count = 0
    if self:GetCaster():GetPlayerID()==0 then
        monster_count = #global_var_func.player_0_kill_count
    elseif self:GetCaster():GetPlayerID()==1 then
        monster_count = #global_var_func.player_1_kill_count
    elseif self:GetCaster():GetPlayerID()==2 then
        monster_count = #global_var_func.player_2_kill_count
    elseif self:GetCaster():GetPlayerID()==3 then
        monster_count = #global_var_func.player_3_kill_count
    end
    self:SetStackCount(math.ceil(monster_count*0.3))
end