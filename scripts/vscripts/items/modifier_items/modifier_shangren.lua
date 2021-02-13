if modifier_shangren == nil then 
    modifier_shangren = class({})
end

function modifier_shangren:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_shangren:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_shangren:IsHidden()
    return true    
end



function modifier_shangren:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_shangren:OnCreated( evt )
    if  IsServer( ) then
        self:StartIntervalThink(10)
    end 
end

function modifier_shangren:OnIntervalThink()
    -- self:GetParent():StartGesture(ACT_DOTA_IDEL)
end

function modifier_shangren:CheckState()
    local states = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
    return states
end

