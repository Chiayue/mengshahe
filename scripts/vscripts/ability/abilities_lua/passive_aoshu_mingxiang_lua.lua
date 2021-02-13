
LinkLuaModifier("modifier_passive_aoshu_mingxiang_lua","ability/abilities_lua/passive_aoshu_mingxiang_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_maxmana_buff_lua","ability/abilities_lua/passive_aoshu_mingxiang_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_aoshu_mingxiang_lua_d = class({})
function passive_aoshu_mingxiang_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_aoshu_mingxiang_lua"
end

passive_aoshu_mingxiang_lua_c = class({})
function passive_aoshu_mingxiang_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_aoshu_mingxiang_lua"
end

passive_aoshu_mingxiang_lua_b = class({})
function passive_aoshu_mingxiang_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_aoshu_mingxiang_lua"
end

passive_aoshu_mingxiang_lua_a = class({})
function passive_aoshu_mingxiang_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_aoshu_mingxiang_lua"
end

if modifier_passive_aoshu_mingxiang_lua == nil then
	modifier_passive_aoshu_mingxiang_lua = class({})
end


function modifier_passive_aoshu_mingxiang_lua:IsHidden()
    return true
end

function modifier_passive_aoshu_mingxiang_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_aoshu_mingxiang_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_aoshu_mingxiang_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_passive_aoshu_mingxiang_lua:OnCreated(params)
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
    self.maxmana = 0
    self.caster = self:GetAbility():GetCaster()
    self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_passive_aoshu_mingxiang_lua,'used_ability'),self)
end

function modifier_passive_aoshu_mingxiang_lua:used_ability(evt)
	-- print(" >>>>>>>>>>>>>>>>>>>>  used_ability: ")
    -- DeepPrintTable(evt)
    local ability_name = evt.abilityname
    if not RollPercentage(100 - self:GetAbility():GetSpecialValueFor( "chance" )) or
        string.find(ability_name,"item_") or 
        string.find(ability_name,"go_back") then
        return
    end
    
    -- 使用技能的地方
    local hero = PlayerResource:GetPlayer(evt.PlayerID):GetAssignedHero()
    if hero==self.caster then
        -- 技能使用者和被动技能持有者是同一人
        -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
        hero:GiveMana(self:GetAbility():GetSpecialValueFor( "mana" ))
        self.maxmana = self.maxmana + self:GetAbility():GetSpecialValueFor( "maxmana" )
        self.caster:AddNewModifier( self.caster, nil, "modifier_maxmana_buff_lua", {duration = 9999999, maxmana = self.maxmana} )
    end
end

function modifier_passive_aoshu_mingxiang_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    local modif = self.caster:FindModifierByName("modifier_maxmana_buff_lua")
    if modif then
        modif:Destroy();
    end
    StopListeningToGameEvent(self.listenid)
end

if modifier_maxmana_buff_lua == nil then
	modifier_maxmana_buff_lua = class({})
end

function modifier_maxmana_buff_lua:IsHidden()
    return true
end

function modifier_maxmana_buff_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_maxmana_buff_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_maxmana_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
    }
    return funcs
end

function modifier_maxmana_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- self.percent = {}
    self.maxmana = params.maxmana
    -- table.insert(self.percent, params.percent)
end

function modifier_maxmana_buff_lua:OnRefresh(params)
    if not IsServer( ) then
        return
    end
    self.maxmana = params.maxmana
end

function modifier_maxmana_buff_lua:GetModifierExtraManaBonus()
    if not IsServer( ) then
        return
    end
    return self.maxmana
end