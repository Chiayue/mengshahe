---------------------------------------------------------------------------
-- 宝物：百变怪
---------------------------------------------------------------------------

if modifier_treasure_keep_changing == nil then 
    modifier_treasure_keep_changing = class({})
end

function modifier_treasure_keep_changing:GetTexture()
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_keep_changing:IsHidden()
    if self:GetStackCount() > 0 then
        return true
    end
    return false
end

function modifier_treasure_keep_changing:IsPurgable()
    return false
end

function modifier_treasure_keep_changing:RemoveOnDeath()
    return false
end

function modifier_treasure_keep_changing:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(60)
    end
end

function modifier_treasure_keep_changing:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local exclude = {
            "modifier_treasure_pot_of_greed",
            "modifier_treasure_angel_gift",
            "modifier_treasure_devil_transaction",
            "modifier_treasure_convoy",
            "modifier_treasure_center_challenge",
            "modifier_treasure_stratholme_task",
            "modifier_treasure_curse_box",
            "modifier_treasure_oracle_test",
        }
        local mdf_table = treasuresystem:get_averagerandomtreasures(parent:GetPlayerID(), 1)
        if next(mdf_table) ~= nil then
            local mdf_name = mdf_table[1]
            for _, value in pairs(exclude) do
                if value == mdf_name then
                    self:SetStackCount(0)
                    self:StartIntervalThink(1)
                    return
                end
            end
            self:SetStackCount(1)
            parent:RemoveModifierByName(mdf_name)
            parent:AddNewModifier(parent, nil, mdf_name, {duration = 60})
            self:StartIntervalThink(60)
        else
            self:SetStackCount(0)
            self:StartIntervalThink(-1)
        end
    end
end