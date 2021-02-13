LinkLuaModifier("modifier_born_baby","ability/abilities_lua/passive_born_baby",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_born_baby_do","ability/abilities_lua/passive_born_baby",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
born_baby = class({})
function born_baby:GetIntrinsicModifierName()
	return "modifier_born_baby"
end

if modifier_born_baby == nil then
    modifier_born_baby = ({})
end

function modifier_born_baby:IsHidden() return true end
function modifier_born_baby:IsPurgable() return false end
function modifier_born_baby:RemoveOnDeath() return false end

function modifier_born_baby:OnCreated(params)
    if IsServer() then
        self:GetAbility().damage_info = {
            victim = nil,
            attacker = self:GetParent(),
            damage = 0,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
    end
end

function modifier_born_baby:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_born_baby:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
        if not params.target:HasModifier("modifier_born_baby_do") then
            params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_born_baby_do", {duration = 5})
        end
    end
end

--------------------------------------------------------

if modifier_born_baby_do == nil then
    modifier_born_baby_do = ({})
end

function modifier_born_baby_do:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_born_baby_do:OnCreated(params)
    if IsServer() then
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end
end

function modifier_born_baby_do:OnDeath(params)
    if params.unit == self:GetParent() then
        if RollPercentage(30) then
            local caster = self:GetCaster()
            local unit = CreateUnitByName("little_spider", caster:GetOrigin() + RandomVector(50), true, caster,caster:GetOwnerEntity(), caster:GetTeamNumber())
            local health = caster:GetIntellect()*20
            unit:SetBaseMaxHealth(health)
            unit:SetMaxHealth(health)
            unit:SetHealth(health)
            local damage_amount = (caster:GetAgility()+caster:GetStrength())* 2
            unit:SetBaseDamageMax(damage_amount)
            unit:SetBaseDamageMin(damage_amount)
            unit:SetOwner( caster )
            unit:SetControllableByPlayer(caster:GetPlayerID(), false)
            unit:AddNewModifier(caster, self:GetAbility(), "modifier_kill_self",{duration = 15,noParticle = true})
        end
    end
end


function modifier_born_baby_do:OnIntervalThink()
    self:GetAbility().damage_info.damage = self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
    self:GetAbility().damage_info.victim = self:GetParent()
    ApplyDamage(self:GetAbility().damage_info)
end