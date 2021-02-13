-- 宝物： 法力乱流


if modifier_treasure_turbulence_mana == nil then 
    modifier_treasure_turbulence_mana = class({})
end

function modifier_treasure_turbulence_mana:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_turbulence_mana"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_turbulence_mana:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_turbulence_mana:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_turbulence_mana:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_treasure_turbulence_mana:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
end

function modifier_treasure_turbulence_mana:OnAbilityExecuted(params)
    if not IsServer( ) then
        return
    end
    local ability = params.ability
    local name = ability:GetAbilityName()
    if string.find(name, "item_") or string.find(name,"currier_blink") or name == "go_back" then
        return
    end
    if params.unit == self.caster then
        -- 判断技能是否本人释放
        if RollPercentage(25) then
            self.caster:SetMana(0)
        else
            self.caster:SetMana(self.caster:GetMaxMana())
        end
    end
end