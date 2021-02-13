---------------------------------------------------------------------------
-- 宝物：灵魂协议
---------------------------------------------------------------------------

if modifier_treasure_soul_agreements == nil then 
    modifier_treasure_soul_agreements = class({})
end

function modifier_treasure_soul_agreements:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_treasure_soul_agreements:GetModifierIncomingDamage_Percentage(event)
    if self:IsExistCallUnit() then
        local damage = event.original_damage * 0.5
        local damage_type = event.damage_type
        local parent = self:GetParent()
        for key, value in pairs(parent.call_unit) do
            if value:GetUnitName() ~= "shebang" and not value:IsInvulnerable() then
            local index = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse_flame.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(index, 0, parent:GetOrigin())
            ParticleManager:SetParticleControl(index, 1, value:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
            ApplyDamage({
                victim = value,
                attacker = parent,
                damage = damage,
                damage_type = event.damage_type,
            })
            end
        end
        return -50
    else
        return 0
    end
end

function modifier_treasure_soul_agreements:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_soul_agreements"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_soul_agreements:IsPurgable()
    return false
end
 
function modifier_treasure_soul_agreements:RemoveOnDeath()
    return false
end

function modifier_treasure_soul_agreements:IsExistCallUnit()
    local parent = self:GetParent()
    for key, value in pairs(parent.call_unit) do
        if value:GetUnitName() ~= "shebang" and not value:IsInvulnerable() then
            return true
        end
    end
    return false
end