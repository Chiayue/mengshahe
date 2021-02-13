---------------------------------------------------------------------------
-- 宝物：过载
---------------------------------------------------------------------------

if modifier_treasure_overload == nil then 
    modifier_treasure_overload = class({})
end
function modifier_treasure_overload:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_overload"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_overload:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_SPENT_MANA,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_treasure_overload:OnSpentMana(params)
    if params.cost > 0 then
        local parent = self:GetParent()
        local cur_mana = parent:GetMana()
        if cur_mana > 300 then
            self.extra_mana = 300
        else
            self.extra_mana = cur_mana
        end
        local index = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_overcharge_ti7.vpcf", PATTACH_ROOTBONE_FOLLOW, parent)
        Timers:CreateTimer(0.2, function()
            ParticleManager:DestroyParticle(index, true)
            ParticleManager:ReleaseParticleIndex(index)
        end)
        self:GetParent():ReduceMana(300) 
    end
end

function modifier_treasure_overload:GetModifierSpellAmplify_Percentage(params)
    return self.extra_mana
end

function modifier_treasure_overload:IsPurgable()
    return false
end
 
function modifier_treasure_overload:RemoveOnDeath()
    return false
end