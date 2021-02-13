function wearForHero(params)
    --穿饰品
    local hero =params.caster
    local weartable = {
        "models/items/mars/mars_ti9_immortal_weapon/mars_ti9_immortal_weapon.vmdl",
        "models/items/mars/mars_blackstone_ares_off_hand/mars_blackstone_ares_off_hand.vmdl",
        "models/heroes/mars/mars_upper.vmdl",
        "models/items/mars/mars_blackstone_ares_legs/mars_blackstone_ares_legs.vmdl",
        "models/items/mars/mars_arena_champion_armor/mars_arena_champion_armor.vmdl",
    }
    WearForHero(weartable,hero)
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mars/mars_ti9_immortal/mars_ti9_immortal_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mars/mars_blackstone_ares/mars_blackstone_ares_shield.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[2] );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    params.caster:AddActivityModifier("attack_medium_range")

end

if modifier_fangyu_jihuo_add == nil then 
    modifier_fangyu_jihuo_add = class({})
end

function modifier_fangyu_jihuo_add:IsPurgable() return false end
function modifier_fangyu_jihuo_add:RemoveOnDeath() return true end
function modifier_fangyu_jihuo_add:IsHidden() return true end

function modifier_fangyu_jihuo_add:OnCreated(params)
    if IsServer() then
        self:GetParent():AddActivityModifier("bulwark")
    end
end


function modifier_fangyu_jihuo_add:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_fangyu_jihuo_add:GetModifierIncomingDamage_Percentage(params)
    if params.damage_type == DAMAGE_TYPE_MAGICAL or params.attacker:IsRangedAttacker() then
        self:GetAbility().rebound_damage.victim = params.attacker
        self:GetAbility().rebound_damage.damage = params.damage
        ApplyDamage( self:GetAbility().rebound_damage)
        return -70
    end
end

function modifier_fangyu_jihuo_add:OnDestroy()
    if IsServer() then
        self:GetParent():ClearActivityModifiers()
        self:GetParent():AddActivityModifier("attack_medium_range")
    end
end


