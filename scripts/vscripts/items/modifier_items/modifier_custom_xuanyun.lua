
if modifier_custom_xuanyun == nil then 
    modifier_custom_xuanyun = class({})
end


function modifier_custom_xuanyun:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_custom_xuanyun:GetTexture()
    return "buff/xuanyun"
end

function modifier_custom_xuanyun:CheckState()
    local states = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return states
end

function modifier_custom_xuanyun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_custom_xuanyun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

