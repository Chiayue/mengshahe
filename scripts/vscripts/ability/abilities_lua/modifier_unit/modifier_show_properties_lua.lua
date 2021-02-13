if modifier_show_properties_lua == nil then
    modifier_show_properties_lua = ({})
end

function modifier_show_properties_lua:IsHidden()
    return true -- 隐藏
end

function modifier_show_properties_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_show_properties_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_show_properties_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_magic_critical_lua", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_attack_critical_lua", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_extra_attack_scale_lua", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_reduce_attack_lua", {})
end

-- 魔法属性
LinkLuaModifier( "modifier_show_magic_critical_lua","ability/abilities_lua/modifier_unit/modifier_show_properties_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_show_magic_critical_lua == nil then
    modifier_show_magic_critical_lua = ({})
end

function modifier_show_magic_critical_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_show_magic_critical_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_show_magic_critical_lua:GetTexture(  )
    return "buff/mofabaoji"
end

function modifier_show_magic_critical_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.steamId = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())
end

function modifier_show_magic_critical_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

function modifier_show_magic_critical_lua:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_magic_critical"..tostring(self:GetCaster():GetPlayerOwnerID()), { magic_critical = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "magic_critical")})
    CustomNetTables:SetTableValue("dynamic_properties", "player_magic_critical_damage"..tostring(self:GetCaster():GetPlayerOwnerID()), { magic_critical_damage = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "magic_critical_damage")})
end

function modifier_show_magic_critical_lua:OnTooltip()
    local magic_critical = CustomNetTables:GetTableValue("dynamic_properties", "player_magic_critical"..tostring(self:GetCaster():GetPlayerOwnerID())) or { magic_critical = 0 }
	return magic_critical.magic_critical
end

function modifier_show_magic_critical_lua:OnTooltip2()
    local magic_critical_damage = CustomNetTables:GetTableValue("dynamic_properties", "player_magic_critical_damage"..tostring(self:GetCaster():GetPlayerOwnerID())) or { magic_critical_damage = 0 }
	return magic_critical_damage.magic_critical_damage*100
end


-- 物理属性
LinkLuaModifier( "modifier_show_attack_critical_lua","ability/abilities_lua/modifier_unit/modifier_show_properties_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_show_attack_critical_lua == nil then
    modifier_show_attack_critical_lua = ({})
end

function modifier_show_attack_critical_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_show_attack_critical_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_show_attack_critical_lua:GetTexture(  )
    return "buff/wulibaoji"
end

function modifier_show_attack_critical_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.steamId = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_attack_critical_lua", {})
end

function modifier_show_attack_critical_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

function modifier_show_attack_critical_lua:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_attack_critical"..tostring(self:GetCaster():GetPlayerOwnerID()), { attack_critical = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "attack_critical")})
    CustomNetTables:SetTableValue("dynamic_properties", "player_attack_critical_damage"..tostring(self:GetCaster():GetPlayerOwnerID()), { attack_critical_damage = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "attack_critical_damage")})
end

function modifier_show_attack_critical_lua:OnTooltip()
    local attack_critical = CustomNetTables:GetTableValue("dynamic_properties", "player_attack_critical"..tostring(self:GetCaster():GetPlayerOwnerID())) or { attack_critical = 0 }
	return attack_critical.attack_critical
end

function modifier_show_attack_critical_lua:OnTooltip2()
    local attack_critical_damage = CustomNetTables:GetTableValue("dynamic_properties", "player_attack_critical_damage"..tostring(self:GetCaster():GetPlayerOwnerID())) or { attack_critical_damage = 0 }
	return attack_critical_damage.attack_critical_damage*100
end

-- 伤害加成
LinkLuaModifier( "modifier_show_extra_attack_scale_lua","ability/abilities_lua/modifier_unit/modifier_show_properties_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_show_extra_attack_scale_lua == nil then
    modifier_show_extra_attack_scale_lua = ({})
end

function modifier_show_extra_attack_scale_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_show_extra_attack_scale_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_show_extra_attack_scale_lua:GetTexture(  )
    return "buff/shanghaizengjia"
end

function modifier_show_extra_attack_scale_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.steamId = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_extra_attack_scale_lua", {})
end

function modifier_show_extra_attack_scale_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_show_extra_attack_scale_lua:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_extra_attack_scale"..tostring(self:GetCaster():GetPlayerOwnerID()), { extra_attack_scale = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "extra_attack_scale")})
end

function modifier_show_extra_attack_scale_lua:OnTooltip()
    local extra_attack_scale = CustomNetTables:GetTableValue("dynamic_properties", "player_extra_attack_scale"..tostring(self:GetCaster():GetPlayerOwnerID())) or { extra_attack_scale = 0 }
	return extra_attack_scale.extra_attack_scale
end

-- 伤害降低
LinkLuaModifier( "modifier_show_reduce_attack_lua","ability/abilities_lua/modifier_unit/modifier_show_properties_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_show_reduce_attack_lua == nil then
    modifier_show_reduce_attack_lua = ({})
end

function modifier_show_reduce_attack_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_show_reduce_attack_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_show_reduce_attack_lua:GetTexture(  )
    return "buff/shanghaijianmian"
end

function modifier_show_reduce_attack_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.steamId = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_show_reduce_attack_lua", {})
end

function modifier_show_reduce_attack_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

function modifier_show_reduce_attack_lua:OnIntervalThink()
    CustomNetTables:SetTableValue("dynamic_properties", "player_reduce_attack_scale"..tostring(self:GetCaster():GetPlayerOwnerID()), { reduce_attack_scale = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "reduce_attack_scale")})
    CustomNetTables:SetTableValue("dynamic_properties", "player_reduce_attack_point"..tostring(self:GetCaster():GetPlayerOwnerID()), { reduce_attack_point = game_playerinfo:get_dynamic_properties_by_key(self.steamId, "reduce_attack_point")})
end

function modifier_show_reduce_attack_lua:OnTooltip()
    local reduce_attack_scale = CustomNetTables:GetTableValue("dynamic_properties", "player_reduce_attack_scale"..tostring(self:GetCaster():GetPlayerOwnerID())) or { reduce_attack_scale = 0 }
	return reduce_attack_scale.reduce_attack_scale
end

function modifier_show_reduce_attack_lua:OnTooltip2()
    local reduce_attack_point = CustomNetTables:GetTableValue("dynamic_properties", "player_reduce_attack_point"..tostring(self:GetCaster():GetPlayerOwnerID())) or { reduce_attack_point = 0 }
	return reduce_attack_point.reduce_attack_point
end