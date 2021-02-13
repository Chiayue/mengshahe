if modifier_temporary_property == nil then 
    modifier_temporary_property = class({})
end

function modifier_temporary_property:IsPurgable()
    return false -- 无法驱散
end

function modifier_temporary_property:GetTexture()
    return "s14"
end


function modifier_temporary_property:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end


function modifier_temporary_property:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self.strength = evt.strength or 0
    self.stack_limit = evt.stack_limit
end

function modifier_temporary_property:OnRefresh(evt)
    if not IsServer( ) then
        return
    end 
    if self.stack_limit then
        if self:GetStackCount() < self.stack_limit then
            self:IncrementStackCount()
        end
    end
    local stack_count = self:GetStackCount() or 1
    if evt.strength then 
        self.strength = evt.strength * stack_count
    end
end

function modifier_temporary_property:GetModifierBonusStats_Strength(params)
    return self.strength or 0
end

