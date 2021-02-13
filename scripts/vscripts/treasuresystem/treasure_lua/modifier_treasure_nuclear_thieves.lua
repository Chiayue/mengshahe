-- 宝物: 盗贼灵核


if modifier_treasure_nuclear_thieves == nil then 
    modifier_treasure_nuclear_thieves = class({})
end

function modifier_treasure_nuclear_thieves:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_nuclear_thieves"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_nuclear_thieves:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_nuclear_thieves:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_nuclear_thieves:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_treasure_nuclear_thieves:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self:StartIntervalThink(1)
    local steam_id = PlayerResource:GetSteamAccountID( self.caster:GetPlayerID() )
    game_playerinfo:set_dynamic_properties(steam_id, "reduce_attack_scale", -40)
    game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", 100)
end

function modifier_treasure_nuclear_thieves:OnIntervalThink()
    self.caster:ReduceMana(3)
end

function modifier_treasure_nuclear_thieves:GetModifierDamageOutgoing_Percentage()
	return 100
end


