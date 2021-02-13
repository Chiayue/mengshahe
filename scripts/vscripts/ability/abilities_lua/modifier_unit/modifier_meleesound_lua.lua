if modifier_meleesound_lua == nil then
    modifier_meleesound_lua = ({})
end

function modifier_meleesound_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_meleesound_lua:OnCreated(params)
    
end

function modifier_meleesound_lua:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
        local sound_name = "hero.attack."..params.attacker:GetUnitName()
        -- print(" >>>>>>>>>>>>>>>>>> sound_name: "..sound_name)
        self:GetParent():EmitSound(sound_name)
    end
end


function modifier_meleesound_lua:IsHidden()
    return true
end

function modifier_meleesound_lua:RemoveOnDeath()
    return false
end