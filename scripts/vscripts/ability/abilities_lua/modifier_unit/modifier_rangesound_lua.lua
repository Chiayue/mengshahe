if modifier_rangesound_lua == nil then
    modifier_rangesound_lua = ({})
end

function modifier_rangesound_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_rangesound_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_rangesound_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_rangesound_lua:OnCreated(params)
    
end

function modifier_rangesound_lua:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
        local sound_name = "hero.attack."..params.attacker:GetUnitName()
        -- print(" >>>>>>>>>>>>>>>>>> sound_name: "..sound_name)
        self:GetParent():EmitSound(sound_name)
    end
end


function modifier_rangesound_lua:IsHidden()
    return true
end
