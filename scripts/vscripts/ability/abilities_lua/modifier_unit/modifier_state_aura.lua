if modifier_state_aura_damage_up == nil then
    modifier_state_aura_damage_up = ({})
end

function modifier_state_aura_damage_up:OnCreated(params)
    if IsServer() then

    end
end

function modifier_state_aura_damage_up:IsAura() return true end
function modifier_state_aura_damage_up:GetAuraDuration() return 1 end
function modifier_state_aura_damage_up:GetModifierAura() return "modifier_state_aura_damage_up_do" end
function modifier_state_aura_damage_up:GetAuraRadius() return 1000 end
function modifier_state_aura_damage_up:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_state_aura_damage_up:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_state_aura_damage_up:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP end
function modifier_state_aura_damage_up:IsHidden() return true end


if modifier_state_aura_damage_up_do == nil then
    modifier_state_aura_damage_up_do = ({})
end

function modifier_state_aura_damage_up_do:OnCreated(params)
    if IsServer() then
       
    end
end

function modifier_state_aura_damage_up_do:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_state_aura_damage_up_do:GetModifierDamageOutgoing_Percentage()
    return 100
end

if modifier_state_aura_attackspeed == nil then
    modifier_state_aura_attackspeed = ({})
end

function modifier_state_aura_attackspeed:IsAura() return true end
function modifier_state_aura_attackspeed:GetAuraDuration() return 1 end
function modifier_state_aura_attackspeed:GetModifierAura() return "modifier_state_aura_attackspeed_do" end
function modifier_state_aura_attackspeed:GetAuraRadius() return 1000 end
function modifier_state_aura_attackspeed:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_state_aura_attackspeed:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_state_aura_attackspeed:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP end
function modifier_state_aura_attackspeed:IsHidden() return true end



if modifier_state_aura_attackspeed_do == nil then
    modifier_state_aura_attackspeed_do = ({})
end


function modifier_state_aura_attackspeed_do:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_state_aura_attackspeed_do:GetModifierAttackSpeedBonus_Constant()
    return 70
end


if modifier_state_aura_armor == nil then
    modifier_state_aura_armor = ({})
end

function modifier_state_aura_armor:IsAura() return true end
function modifier_state_aura_armor:GetAuraDuration() return 1 end
function modifier_state_aura_armor:GetModifierAura() return "modifier_state_aura_armor_do" end
function modifier_state_aura_armor:GetAuraRadius() return 1000 end
function modifier_state_aura_armor:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_state_aura_armor:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_state_aura_armor:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP end
function modifier_state_aura_armor:IsHidden() return true end



if modifier_state_aura_armor_do == nil then
    modifier_state_aura_armor_do = ({})
end


function modifier_state_aura_armor_do:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_state_aura_armor_do:GetModifierPhysicalArmorBonus()
    return 50
end


if modifier_state_aura_ability == nil then
    modifier_state_aura_ability = ({})
end

function modifier_state_aura_ability:IsAura() return true end
function modifier_state_aura_ability:GetAuraDuration() return 1 end
function modifier_state_aura_ability:GetModifierAura() return "modifier_state_aura_ability_do" end
function modifier_state_aura_ability:GetAuraRadius() return 1000 end
function modifier_state_aura_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_state_aura_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_state_aura_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP end
function modifier_state_aura_ability:IsHidden() return true end



if modifier_state_aura_ability_do == nil then
    modifier_state_aura_ability_do = ({})
end


function modifier_state_aura_ability_do:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
    return funcs
end

function modifier_state_aura_ability_do:GetModifierSpellAmplify_Percentage()
    return 30
end