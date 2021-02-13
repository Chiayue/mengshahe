
LinkLuaModifier("modifier_passive_mingyun_gutou_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_add_str_buff_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_add_agi_buff_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_add_xixue_buff_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_add_str_show_buff_layer_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_add_agi_show_buff_layer_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_add_xixue_show_buff_layer_lua","ability/abilities_lua/passive_mingyun_gutou_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_mingyun_gutou_lua_d = class({})
function passive_mingyun_gutou_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_mingyun_gutou_lua"
end

passive_mingyun_gutou_lua_c = class({})
function passive_mingyun_gutou_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_mingyun_gutou_lua"
end

passive_mingyun_gutou_lua_b = class({})
function passive_mingyun_gutou_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_mingyun_gutou_lua"
end

passive_mingyun_gutou_lua_a = class({})
function passive_mingyun_gutou_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_mingyun_gutou_lua"
end

passive_mingyun_gutou_lua_s = class({})
function passive_mingyun_gutou_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_mingyun_gutou_lua"
end

if modifier_passive_mingyun_gutou_lua == nil then
	modifier_passive_mingyun_gutou_lua = class({})
end

function modifier_passive_mingyun_gutou_lua:IsHidden()
    return true
end

function modifier_passive_mingyun_gutou_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_mingyun_gutou_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_mingyun_gutou_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_mingyun_gutou_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_passive_mingyun_gutou_lua:OnAttackLanded(params)
    -- DeepPrintTable(target)
    local percent = 0
    -- local percentvalue = 0
    local target = params.target
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
            return
        end
        local type = RandomInt(1,3)
        local duration = self:GetAbility():GetSpecialValueFor("duration")
        local addvalue = self:GetAbility():GetSpecialValueFor("addvalue")
        if type==1 then
            -- 增加智力
            caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_add_str_buff_lua", {duration = duration, addvalue = addvalue})
        elseif type==2 then
            -- 增加敏捷
            caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_add_agi_buff_lua", {duration = duration, addvalue = addvalue})
        else
            -- 增加吸血
            caster:AddNewModifier(caster, self:GetAbility(), "modifier_passive_add_xixue_buff_lua", {duration = duration, addvalue = addvalue})
        end
    end
    return
end

if modifier_passive_add_str_buff_lua == nil then
	modifier_passive_add_str_buff_lua = class({})
end

function modifier_passive_add_str_buff_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_passive_add_str_buff_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_add_str_buff_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_add_str_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS ,
    }
    return funcs
end

function modifier_passive_add_str_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.intellect = params.addvaluei
    -- self:IncrementStackCount()
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_add_str_show_buff_layer_lua", {duration = 999999})
end

function modifier_passive_add_str_buff_lua:OnDestroy()
    if not IsServer( ) then
        return
    end

    local showmodifier = self:GetParent():FindModifierByName("modifier_add_str_show_buff_layer_lua")
    if showmodifier then
        showmodifier:SetStackCount(showmodifier:GetStackCount() - 1)
        if showmodifier:GetStackCount() <= 0 then
            showmodifier:Destroy()
        end
    end
end

function modifier_passive_add_str_buff_lua:GetModifierBonusStats_Intellect()
	return self.intellect
end

if modifier_passive_add_agi_buff_lua == nil then
	modifier_passive_add_agi_buff_lua = class({})
end

function modifier_passive_add_agi_buff_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_passive_add_agi_buff_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_add_agi_buff_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_add_agi_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_passive_add_agi_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.agility = params.addvalue
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_add_agi_show_buff_layer_lua", {duration = 999999})
end

function modifier_passive_add_agi_buff_lua:OnDestroy()
    if not IsServer( ) then
        return
    end

    local showmodifier = self:GetParent():FindModifierByName("modifier_add_agi_show_buff_layer_lua")
    if showmodifier then
        showmodifier:SetStackCount(showmodifier:GetStackCount() - 1)
        if showmodifier:GetStackCount() <= 0 then
            showmodifier:Destroy()
        end
    end
end

function modifier_passive_add_agi_buff_lua:GetModifierBonusStats_Agility()
	return self.agility
end

if modifier_passive_add_xixue_buff_lua == nil then
	modifier_passive_add_xixue_buff_lua = class({})
end

function modifier_passive_add_xixue_buff_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_add_xixue_buff_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_add_xixue_buff_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
 
function modifier_passive_add_xixue_buff_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_passive_add_xixue_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    self.xixue = params.addvalue
    game_playerinfo:set_dynamic_properties(self.steam_id, "attack_heal", self.xixue)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_add_xixue_show_buff_layer_lua", {duration = 999999})
    -- print(" >>>>>>>>>>>>> now xixue: "..game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "attack_heal"))
end

function modifier_passive_add_xixue_buff_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    game_playerinfo:set_dynamic_properties(self.steam_id, "attack_heal", -self.xixue)
    local showmodifier = self:GetParent():FindModifierByName("modifier_add_xixue_show_buff_layer_lua")
    if showmodifier then
        showmodifier:SetStackCount(showmodifier:GetStackCount() - 1)
        if showmodifier:GetStackCount() <= 0 then
            showmodifier:Destroy()
        end
    end
    -- print(" >>>>>>>>>>>>> now xixue: "..game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "attack_heal"))
end

if modifier_add_str_show_buff_layer_lua == nil then
	modifier_add_str_show_buff_layer_lua = class({})
end

function modifier_add_str_show_buff_layer_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_add_str_show_buff_layer_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_add_str_show_buff_layer_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end

function modifier_add_str_show_buff_layer_lua:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end

if modifier_add_agi_show_buff_layer_lua == nil then
	modifier_add_agi_show_buff_layer_lua = class({})
end

function modifier_add_agi_show_buff_layer_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_add_agi_show_buff_layer_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_add_agi_show_buff_layer_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end

function modifier_add_agi_show_buff_layer_lua:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end

if modifier_add_xixue_show_buff_layer_lua == nil then
	modifier_add_xixue_show_buff_layer_lua = class({})
end

function modifier_add_xixue_show_buff_layer_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_add_xixue_show_buff_layer_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_add_xixue_show_buff_layer_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end

function modifier_add_xixue_show_buff_layer_lua:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    self:IncrementStackCount()
end