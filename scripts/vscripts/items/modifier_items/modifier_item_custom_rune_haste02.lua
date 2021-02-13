require("items/lua_items_ability/item_ability")

if modifier_item_custom_rune_haste02 == nil then 
    modifier_item_custom_rune_haste02 = class({})
end

function modifier_item_custom_rune_haste02:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end


function modifier_item_custom_rune_haste02:OnCreated( evt )
    if IsServer( ) then
        local steam_id =  PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()) 
        game_playerinfo:set_dynamic_properties(steam_id, "magic_critical", 80)
        self:GetParent().dynamic_properties["magic_critical"] = game_playerinfo:get_dynamic_properties(steam_id)["magic_critical"]
    end 
end

function modifier_item_custom_rune_haste02:GetTexture()
    return "buff/energy8"
end

function modifier_item_custom_rune_haste02:OnDestroy()
    if IsServer() then
        local steam_id =  PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID()) 
        game_playerinfo:set_dynamic_properties(steam_id, "magic_critical", -80)
        self:GetParent().dynamic_properties["magic_critical"] = game_playerinfo:get_dynamic_properties(steam_id)["magic_critical"]
    end
end

function modifier_item_custom_rune_haste02:OnAttackStart(evt)
    if evt.attacker == self:GetParent() then
        if RollPercentage(80) then
            evt.attacker:AddNewModifier(evt.attacker,nil,"modifier_critical_strike", {Duration=20,critical_damage = 3})
        end
    end
end