-- 宝物: 战士灵核


if modifier_treasure_nuclear_warrior == nil then 
    modifier_treasure_nuclear_warrior = class({})
end

function modifier_treasure_nuclear_warrior:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_nuclear_warrior"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_nuclear_warrior:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_nuclear_warrior:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_nuclear_warrior:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_treasure_nuclear_warrior:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self:StartIntervalThink(1)
    local steam_id = PlayerResource:GetSteamAccountID( self.caster:GetPlayerID() )
    game_playerinfo:set_dynamic_properties(steam_id, "add_armor", 25)
end

function modifier_treasure_nuclear_warrior:OnIntervalThink()
    self.caster:ReduceMana(3)
end

function modifier_treasure_nuclear_warrior:GetModifierDamageOutgoing_Percentage()
	return -50
end

function modifier_treasure_nuclear_warrior:GetModifierPhysical_ConstantBlock(params)
    if params.target == self:GetCaster() then
        return 100
    end
    return 0
end

function modifier_treasure_nuclear_warrior:GetModifierPhysicalArmorBonus()
    return 25
end
