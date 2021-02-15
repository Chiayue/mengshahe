-- 宝物： 王者辉煌

if modifier_treasure_king_brilliant == nil then 
    modifier_treasure_king_brilliant = class({})
end
function modifier_treasure_king_brilliant:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_king_brilliant"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_king_brilliant:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_king_brilliant:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_king_brilliant:OnCreated(params)
    if not IsServer() then
        return
    end
    if self:GetCaster():HasModifier("modifier_treasure_king_increases_damage") then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_treasure_king_increases_damage", {})
end

LinkLuaModifier("modifier_treasure_king_increases_damage","treasuresystem/treasure_lua/modifier_treasure_king_brilliant",LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_king_increases_damage == nil then 
    modifier_treasure_king_increases_damage = class({})
end
function modifier_treasure_king_increases_damage:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_king_increases_damage"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_king_increases_damage:IsHidden()
    return true --隐藏图标
end
function modifier_treasure_king_increases_damage:IsPurgable()
    return false -- 无法驱散
end
function modifier_treasure_king_increases_damage:RemoveOnDeath()
    return false -- 死亡不移除
end
function modifier_treasure_king_increases_damage:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end
function modifier_treasure_king_increases_damage:OnCreated(params)
    if not IsServer() then
        return
    end
    self.increases = 0
    self.equipment_num = 0
    self.current_value = 0
    self:StartIntervalThink(1)
end

function modifier_treasure_king_increases_damage:OnIntervalThink()  
    self.increases = 0
    self.equipment_num = 0
    if self:GetCaster():HasModifier("modifier_treasure_king_brilliant") then
        self.increases = self.increases + 15
    end
    if self:GetCaster():HasModifier("modifier_treasure_king_glory") then
        self.increases = self.increases + 25
    end
    if self.increases >= 40 then
        self.increases = self.increases + 40
    end

    for i=0, 5 do 
        local item1 = self:GetCaster():FindItemInInventory("item_custom_sword_wangzhe_"..i)
        local item2 = self:GetCaster():FindItemInInventory("item_custom_ring_wangzhe_"..i)
        local item3 = self:GetCaster():FindItemInInventory("item_custom_armor_wangzhe_"..i)
        if item1 then
            self.equipment_num = self.equipment_num + 1
        end
        if item2 then
            self.equipment_num = self.equipment_num + 1
        end
        if item3 then
            self.equipment_num = self.equipment_num + 1
        end
    end
    game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerID()), "extra_attack_scale", self.increases*self.equipment_num - self.current_value)
    self.current_value = self.increases*self.equipment_num 
end

-- function modifier_treasure_king_increases_damage:GetModifierTotalDamageOutgoing_Percentage()
--     if IsServer() then
--         return self.equipment_num * self.increases
--     end
-- end