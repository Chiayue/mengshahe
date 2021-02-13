if modifier_mechanical_modification_add == nil then 
    modifier_mechanical_modification_add = class({})
end

function modifier_mechanical_modification_add:IsPurgable() return false end
function modifier_mechanical_modification_add:RemoveOnDeath() return false end
function modifier_mechanical_modification_add:IsHidden() return false end

function modifier_mechanical_modification_add:OnCreated(params)
	if IsServer() then
		self:SetStackCount(0)
    end
end


function modifier_mechanical_modification_add:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS ,
    }
    return funcs
end

function modifier_mechanical_modification_add:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end
