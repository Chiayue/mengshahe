if modifier_wood_fenshen == nil then
    modifier_wood_fenshen = ({})
end

function modifier_wood_fenshen:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_wood_fenshen:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_wood_fenshen:IsHidden()
    return true 
end

function modifier_wood_fenshen:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_wood_fenshen:OnCreated(params)
    if IsServer() then
        self.other_unit = EntIndexToHScript(params.other_index)
    end
end

function modifier_wood_fenshen:OnDeath(params)
    if IsServer() then
        if self.other_unit:IsAlive() then
            self.other_unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wood_fenshen_check", {other_index = self:GetParent():GetEntityIndex()})
        end
    end
end


if modifier_wood_fenshen_check == nil then
    modifier_wood_fenshen_check = ({})
end

function modifier_wood_fenshen_check:IsPurgable()
    return false -- 无法驱散
end

function modifier_wood_fenshen_check:OnCreated(params)
    if IsServer() then
       self.time_count = 1
       self.other_unit = EntIndexToHScript(params.other_index)
       self.other_unit:SetUnitCanRespawn(true)
       self:StartIntervalThink(1)
    end
end

function modifier_wood_fenshen_check:OnIntervalThink()
    if self.time_count >= 20 then
        self.other_unit:RespawnUnit()
        self.other_unit:SetHealth(self:GetParent():GetMaxHealth() * 0.25)
        self.other_unit.call_anthor = false
        self:Destroy()
    end
    self.time_count = self.time_count + 1
end

function modifier_wood_fenshen_check:OnDestroy()
    if IsServer() then
        self.other_unit:SetUnitCanRespawn(false)
        if self.time_count < 20 then
            Timers:CreateTimer({
                endTime = 2, 
                callback = function()
                    UTIL_Remove(self:GetParent())
                end
            })
        end
    end
end