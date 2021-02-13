---------------------------------------------------------------------------
-- 宝物：自私医师
---------------------------------------------------------------------------

if modifier_treasure_selfish_doctor == nil then 
    modifier_treasure_selfish_doctor = class({})
end

function modifier_treasure_selfish_doctor:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_selfish_doctor"
    end
    return "buff/modifier_treasure_keep_changing"
end
 
function modifier_treasure_selfish_doctor:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_treasure_selfish_doctor:GetModifierExtraHealthBonus(event)
    return self:GetStackCount() * 500
end

function modifier_treasure_selfish_doctor:IsPurgable()
    return false
end

function modifier_treasure_selfish_doctor:RemoveOnDeath()
    return false
end

function modifier_treasure_selfish_doctor:OnCreated(kv)
    if IsServer() then
        self.current_round = global_var_func.current_round
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_selfish_doctor:OnIntervalThink()
    if self.current_round < global_var_func.current_round then
        self.current_round = global_var_func.current_round
        self:IncrementStackCount()
        local parent = self:GetParent()
        parent:CalculateStatBonus(true)
        parent:Heal(500, nil)
        for _, hero in pairs(HeroList:GetAllHeroes()) do
            if IsAlive(hero) then
                local index = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_RENDERORIGIN_FOLLOW, hero)
                ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                if hero ~= parent then
                    ApplyDamage({
                        victim = hero,
                        attacker = parent,
                        damage = hero:GetMaxHealth() * 0.1,
                        damage_type = DAMAGE_TYPE_PURE,
                    })
                end
            end
        end
    end
end