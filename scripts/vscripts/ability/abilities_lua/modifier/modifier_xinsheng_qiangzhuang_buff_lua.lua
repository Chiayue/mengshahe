require("info/game_playerinfo")


modifier_xinsheng_qiangzhuang_buff_lua = class({})
--------------------------------------------------------------------------------

modifier_xinsheng_qiangzhuang_buff_lua = class({})

function modifier_xinsheng_qiangzhuang_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_xinsheng_qiangzhuang_buff_lua:IsHidden()
    return false
end

function modifier_xinsheng_qiangzhuang_buff_lua:OnCreated( kv )
    -- print(">>>>>>>>>>>>>>>> modifier_xinsheng_qiangzhuang_buff_lua !!!")
    
    -- self:SetStackCount(1)
    -- self:StartIntervalThink( self.space_time )
end

function modifier_xinsheng_qiangzhuang_buff_lua:GetModifierPhysicalArmorBonus(params )
    return 200
end

function modifier_xinsheng_qiangzhuang_buff_lua:GetModifierDamageOutgoing_Percentage(params)
    return 50
end