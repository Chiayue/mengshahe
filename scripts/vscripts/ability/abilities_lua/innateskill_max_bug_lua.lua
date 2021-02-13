require("info/game_playerinfo")

max_bug_lua = class({})
LinkLuaModifier("modifier_max_bug_lua","ability/abilities_lua/innateskill_max_bug_lua",LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_max_bug_lua_str","ability/abilities_lua/innateskill_max_bug_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_max_bug_lua_agi","ability/abilities_lua/innateskill_max_bug_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_max_bug_lua_int","ability/abilities_lua/innateskill_max_bug_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function max_bug_lua:GetIntrinsicModifierName()
	return "modifier_max_bug_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_max_bug_lua = class({})
--------------------------------------------------------------------------------

function modifier_max_bug_lua:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifier_max_bug_lua:IsHidden()
    return true
end

function modifier_max_bug_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_max_bug_lua_str", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_max_bug_lua_agi", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_max_bug_lua_int", {})
end

function modifier_max_bug_lua:hero_level_up(evt)
    local caster = self:GetAbility():GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
end


------------------------------------------------------------------------------------------------------

if modifier_max_bug_lua_str == nil then 
    modifier_max_bug_lua_str = class({})
end

function modifier_max_bug_lua_str:IsHidden()
    return true -- 隐藏
end

function modifier_max_bug_lua_str:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_max_bug_lua_str:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_max_bug_lua_str:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end

function modifier_max_bug_lua_str:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
    -- ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_max_bug_lua_str,'hero_level_up_str'),self)
end

function modifier_max_bug_lua_str:hero_level_up_str(evt)
    local caster = self:GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    -- 减少一半的成长属性
    if not RollPercentage(20) then
        caster:SetBaseStrength(caster:GetBaseStrength()-99)
    else
        if caster:FindModifierByName("modifier_treasure_nuyi") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetStrengthGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_decay_mana") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetStrengthGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_ra_1") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetStrengthGain()*0.12))
        end
        if caster:FindModifierByName("modifier_treasure_ra_2") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetStrengthGain()*0.15))
        end
        if caster:FindModifierByName("modifier_treasure_ra_3") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetStrengthGain()*0.18))
        end
    end
end

function modifier_max_bug_lua_str:GetModifierBonusStats_Strength()
    -- return -self:GetStackCount()
    return 0
end
------------------------------------------------------------------------------------------------------

if modifier_max_bug_lua_agi == nil then 
    modifier_max_bug_lua_agi = class({})
end

function modifier_max_bug_lua_agi:IsHidden()
    return true -- 隐藏
end

function modifier_max_bug_lua_agi:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_max_bug_lua_agi:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_max_bug_lua_agi:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_max_bug_lua_agi:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
    -- ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_max_bug_lua_agi,'hero_level_up_agi'),self)
end

function modifier_max_bug_lua_agi:hero_level_up_agi(evt)
    local caster = self:GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    -- 减少一半的成长属性
    if not RollPercentage(20) then
        caster:SetBaseAgility(caster:GetBaseAgility()-99)
    else
        if caster:FindModifierByName("modifier_treasure_nuyi") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetAgilityGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_decay_mana") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetAgilityGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_ra_1") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetAgilityGain()*0.12))
        end
        if caster:FindModifierByName("modifier_treasure_ra_2") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetAgilityGain()*0.15))
        end
        if caster:FindModifierByName("modifier_treasure_ra_3") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetAgilityGain()*0.18))
        end
    end
end

function modifier_max_bug_lua_agi:GetModifierBonusStats_Agility()
    -- return -self:GetStackCount()
    return 0
end
------------------------------------------------------------------------------------------------------

if modifier_max_bug_lua_int == nil then 
    modifier_max_bug_lua_int = class({})
end

function modifier_max_bug_lua_int:IsHidden()
    return true -- 隐藏
end

function modifier_max_bug_lua_int:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_max_bug_lua_int:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_max_bug_lua_int:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_max_bug_lua_int:OnCreated(params)
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
    -- ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_max_bug_lua_int,'hero_level_up_int'),self)
end

function modifier_max_bug_lua_int:hero_level_up_int(evt)
    local caster = self:GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    -- 减少一半的成长属性
    if not RollPercentage(20) then
        caster:SetBaseIntellect(caster:GetBaseIntellect()-99)
    else
        if caster:FindModifierByName("modifier_treasure_nuyi") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetIntellectGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_decay_mana") then
            self:SetStackCount(self:GetStackCount() + math.ceil(self:GetCaster():GetIntellectGain()*0.5))
        end
        if caster:FindModifierByName("modifier_treasure_ra_1") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetIntellectGain()*0.12))
        end
        if caster:FindModifierByName("modifier_treasure_ra_2") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetIntellectGain()*0.15))
        end
        if caster:FindModifierByName("modifier_treasure_ra_3") then
            self:SetStackCount(self:GetStackCount() - math.ceil(self:GetCaster():GetIntellectGain()*0.18))
        end
    end
end

function modifier_max_bug_lua_int:GetModifierBonusStats_Intellect()
    -- return -self:GetStackCount()
    return 0
end