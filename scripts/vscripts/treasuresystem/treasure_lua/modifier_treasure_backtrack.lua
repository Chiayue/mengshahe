---------------------------------------------------------------------------
-- 宝物：回到过去
---------------------------------------------------------------------------

if modifier_treasure_backtrack == nil then 
    modifier_treasure_backtrack = class({})
end

function modifier_treasure_backtrack:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_backtrack"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_backtrack:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
end

function modifier_treasure_backtrack:GetModifierAvoidDamage(params)
    if RollPercentage(20) then
        local index = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetParent())
        local position = self:GetParent():GetOrigin()
        ParticleManager:SetParticleControl(index, 0, position)
        ParticleManager:SetParticleControl(index, 15, Vector(255, 0, 0))
        ParticleManager:SetParticleControl(index, 16, Vector(255, 0, 0))
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(index, true)
            ParticleManager:ReleaseParticleIndex(index)
        end)
        return 1
    else 
        return 0
    end
end

function modifier_treasure_backtrack:IsPurgable()
    return false
end
 
function modifier_treasure_backtrack:RemoveOnDeath()
    return false
end