-- 宝物: 盛宴

if modifier_treasure_feast == nil then 
    modifier_treasure_feast = class({})
end

function modifier_treasure_feast:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_feast"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_feast:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_feast:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_feast:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_treasure_feast:OnAttackLanded(event)
    local parent = self:GetParent()
    local attacker = event.attacker
    if parent == attacker then
        parent:Heal(100, nil)
    end
end

