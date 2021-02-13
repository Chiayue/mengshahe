require("info/game_playerinfo")


max_wood_lua = class({})
LinkLuaModifier("modifier_max_wood_lua","ability/abilities_lua/innateskill_max_wood_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function max_wood_lua:GetIntrinsicModifierName()
	return "modifier_max_wood_lua"
end

modifier_max_wood_lua = class({})
--------------------------------------------------------------------------------

function modifier_max_wood_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_max_wood_lua:IsHidden()
    return true
end

function modifier_max_wood_lua:OnCreated( kv )
    if IsServer( ) then
        self.parent = self:GetParent()
        local item = nil
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/frostivus2018_invoker_keeper_of_magic_arms/frostivus2018_invoker_keeper_of_magic_arms.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/frostivus2018_invoker_keeper_of_magic_back/frostivus2018_invoker_keeper_of_magic_back.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/frostivus2018_invoker_keeper_of_magic_belt/frostivus2018_invoker_keeper_of_magic_belt.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/frostivus2018_invoker_keeper_of_magic_head/frostivus2018_invoker_keeper_of_magic_head.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/frostivus2018_invoker_keeper_of_magic_shoulder/frostivus2018_invoker_keeper_of_magic_shoulder.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/invoker/invoker_head.vmdl"})
        item:FollowEntity(self.parent, true)
    end
end

--------------------------------------------------------------------------------
--------------------------------升华技能----------------------------------------
sublime_max_wood_lua = class({})

--------------------------------------------------------------------------------
LinkLuaModifier("modifier_sublime_max_wood_lua","ability/abilities_lua/innateskill_max_wood_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sublime_attack","ability/abilities_lua/innateskill_max_wood_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sublime_health","ability/abilities_lua/innateskill_max_wood_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sublime_happy","ability/abilities_lua/innateskill_max_wood_lua",LUA_MODIFIER_MOTION_NONE )

function sublime_max_wood_lua:GetIntrinsicModifierName()
	return "modifier_sublime_max_wood_lua"
end

function sublime_max_wood_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.now_attack = game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()) * self:GetSpecialValueFor("damagescale")
    self.now_healthregen = game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()) * self:GetSpecialValueFor("healthscale")

    self.now_attack_2 = game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()) * self:GetSpecialValueFor("scale")
    self.now_healthregen_2 = game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()) * self:GetSpecialValueFor("scalehp")
    self.armor = self:GetSpecialValueFor("armor")
    self.duration = self:GetSpecialValueFor("duration")
    local self_modifier = self:GetCaster():FindModifierByName("modifier_sublime_max_wood_lua")
    
    if self_modifier:GetStackCount() < 5 then
        local randomindex = RandomInt(1,2)
        if randomindex==1 then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sublime_attack", {duration = self.duration})
            game_playerinfo:change_player_wood(self:GetCaster(), -game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()))
        else
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sublime_health", {duration = self.duration})
            game_playerinfo:change_player_wood(self:GetCaster(), -game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()))
        end
    else
        self_modifier:SetStackCount(0)
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sublime_happy", {duration = self.duration})
        game_playerinfo:change_player_wood(self:GetCaster(), -(game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID())*2))
    end
    self_modifier:IncrementStackCount()
end

modifier_sublime_max_wood_lua = class({})
--------------------------------------------------------------------------------

function modifier_sublime_max_wood_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

-- function modifier_sublime_max_wood_lua:IsHidden()
--     return true
-- end

function modifier_sublime_max_wood_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
end

-- 超火,增加攻击力
modifier_sublime_attack = class({})

function modifier_sublime_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_sublime_attack:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_sublime_attack:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_attack = self:GetAbility().now_attack})

    self:StartIntervalThink(-1)
end

function modifier_sublime_attack:GetModifierBaseAttack_BonusDamage()
    -- print(">>>>>>>>>>>>>>>   now_attack: "..self:GetAbility().now_attack)
	return self:GetAbility().now_attack
end

function modifier_sublime_attack:OnTooltip()
    local now_attack = CustomNetTables:GetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_attack = 0 }
	return now_attack.now_attack
end

-- 奶茶,增加回血速度
modifier_sublime_health = class({})

function modifier_sublime_health:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_sublime_health:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_sublime_health:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_healthregen = self:GetAbility().now_healthregen})

    self:StartIntervalThink(-1)
end

function modifier_sublime_health:GetModifierConstantHealthRegen()
    -- print(">>>>>>>>>>>>>>>   now_healthregen: "..self:GetAbility().now_healthregen)
    if not IsServer() then
        local now_healthregen = CustomNetTables:GetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_healthregen = 0 }
        return now_healthregen.now_healthregen
    end
	return self:GetAbility().now_healthregen
end

function modifier_sublime_health:OnTooltip()
    local now_healthregen = CustomNetTables:GetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_healthregen = 0 }
	return now_healthregen.now_healthregen
end

-- 快乐,双效,增加护甲
modifier_sublime_happy = class({})

function modifier_sublime_happy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

function modifier_sublime_happy:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_sublime_happy:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_attack = self:GetAbility().now_attack})

    CustomNetTables:SetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_healthregen = self:GetAbility().now_healthregen})

    self:StartIntervalThink(-1)
end

function modifier_sublime_happy:GetModifierBaseAttack_BonusDamage()
    -- print(">>>>>>>>>>>>>>>   now_healthregen: "..self:GetAbility().now_healthregen)
	return self:GetAbility().now_attack
end

function modifier_sublime_happy:GetModifierConstantHealthRegen()
    -- print(">>>>>>>>>>>>>>>   now_healthregen: "..self:GetAbility().now_healthregen)
    if not IsServer() then
        local now_healthregen = CustomNetTables:GetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_healthregen = 0 }
        return now_healthregen.now_healthregen
    end
	return self:GetAbility().now_healthregen
end

function modifier_sublime_happy:GetModifierPhysicalArmorBonus()
    return 50
end

function modifier_sublime_happy:OnTooltip()
    local now_attack = CustomNetTables:GetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_attack = 0 }
	return now_attack.now_attack
end

function modifier_sublime_happy:OnTooltip2()
    local now_healthregen = CustomNetTables:GetTableValue("dynamic_properties", "player_now_healthregen"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_healthregen = 0 }
	return now_healthregen.now_healthregen
end