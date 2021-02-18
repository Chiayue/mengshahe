---------------------------------------------------------------------------
-- 宝物：疾风之道
---------------------------------------------------------------------------

if modifier_treasure_rapid_tao == nil then 
    modifier_treasure_rapid_tao = class({})
end

function modifier_treasure_rapid_tao:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_rapid_tao"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_rapid_tao:IsHidden()
    return false
end

function modifier_treasure_rapid_tao:IsPurgable()
    return false
end
 
function modifier_treasure_rapid_tao:RemoveOnDeath()
    return false
end

function modifier_treasure_rapid_tao:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_rapid_tao:GetModifierBonusStats_Agility()
    return self.increase
end

function modifier_treasure_rapid_tao:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_rapid_sword")
        parent:RemoveModifierByName("modifier_treasure_rapid_dagger")
        parent:RemoveModifierByName("modifier_treasure_rapid_bayonet")
        self.increase = math.ceil((self:GetParent():GetStrength()+480)*0.4+480)
    end
end