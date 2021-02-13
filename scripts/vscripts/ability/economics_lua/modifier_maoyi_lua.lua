require("global/global_var_func")
require("info/game_playerinfo")
require("global/msg")

modifier_maoyi_lua = class({})
--------------------------------------------------------------------------------

function modifier_maoyi_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_maoyi_lua:GetTexture()
    return "modifier_maoyi_lua"
end

function modifier_maoyi_lua:OnRefresh(params)
    if IsServer() then
        return self:IncrementStackCount	()
    end
end

function modifier_maoyi_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_maoyi_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_maoyi_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.opencollection = false
    self.caster = self:GetParent()
    self.steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
    self:StartIntervalThink(60)
end

function modifier_maoyi_lua:OnIntervalThink()
    local percent = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "maoyi_increase")
    local skill_level = self:GetStackCount()+global_var_func.extra_operate_level[self.caster:GetPlayerID()+1]["modifier_maoyi_lua"]
    local addvalue = math.ceil(skill_level*70)*(100+percent)/100
    game_playerinfo:set_player_gold(self.caster:GetPlayerID(),addvalue)
    -- game_playerinfo:update_player_economic(self.caster:GetPlayerID(), addvalue)
    PopupGoldGain(self.caster, addvalue)
    if self.opencollection then
        -- 开启珍藏
        if RollPercentage(50) then
            -- 给予珍藏道具
            self.caster:AddItemByName( "item_use_collection" )
        end
    end
end

function modifier_maoyi_lua:OnTooltip()
	return self:GetStackCount()*70*2
end

function modifier_maoyi_lua:IsHidden()
	return true
end