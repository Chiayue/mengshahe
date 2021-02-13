---------------------------------------------------------------------------
-- 宝物：遗失之物 - 残破小镜
---------------------------------------------------------------------------

if modifier_treasure_lost_mirror == nil then 
    modifier_treasure_lost_mirror = class({})
end

function modifier_treasure_lost_mirror:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_mirror"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_mirror:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_treasure_lost_mirror:OnAttackLanded(event)
    local parent = self:GetParent()
    if event.target == parent then
        ApplyDamage({
            victim = event.attacker,
            attacker = parent,
            damage = 1000,
            damage_type = event.damage_type,
        }) 
    end
end

function modifier_treasure_lost_mirror:IsPurgable()
    return false
end
 
function modifier_treasure_lost_mirror:RemoveOnDeath()
    return false
end