langrensha_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_langrensha_lua_wear","ability/abilities_lua/innateskill_langrensha_lua", LUA_MODIFIER_MOTION_NONE )

function langrensha_lua:OnSpellStart()
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
    -- GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(true)
    GameRules:GetGameModeEntity():SetThink("daytime", self, "daytime", 10)
    
    for i = 0, (global_var_func.all_player_amount-1) do
        local hTarget = PlayerResource:GetPlayer(i):GetAssignedHero()
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_langrensha_lua", { duration = 10 } )
    end
    self:GetCaster():EmitSound("langrensha.langrensha")
end

function langrensha_lua:daytime()
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    -- GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(false)
    local playercount = global_var_func.all_player_amount
    local kill_index = RandomInt(0, playercount-1)
    local player_hero = PlayerResource:GetPlayer(kill_index):GetAssignedHero()
    SetBaseAgility(player_hero, 20)
    SetBaseStrength(player_hero, 20)
    SetBaseIntellect(player_hero, 20)
    local caster = self:GetCaster();
    SetBaseAgility(caster, 10)
    SetBaseStrength(caster, 10)
    SetBaseIntellect(caster, 10)
    player_hero:Kill(nil, caster)
    return nil
end

function langrensha_lua:GetIntrinsicModifierName()
    return "modifier_langrensha_lua_wear"
end

if modifier_langrensha_lua_wear == nil then
	modifier_langrensha_lua_wear = class({})
end
function modifier_langrensha_lua_wear:IsHidden() return true end
function modifier_langrensha_lua_wear:RemoveOnDeath() return false end

function modifier_langrensha_lua_wear:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local weartable = {
           "models/items/lycan/blood_moon_hunter_armor/blood_moon_hunter_armor.vmdl",
           "models/items/lycan/blood_moon_hunter_belt/blood_moon_hunter_belt.vmdl",
           "models/items/lycan/blood_moon_hunter_head/blood_moon_hunter_head.vmdl",
           "models/items/lycan/blood_moon_hunter_shoulder/blood_moon_hunter_shoulder.vmdl",
           "models/items/lycan/blood_moon_hunter_weapon/blood_moon_hunter_weapon.vmdl",
           "models/heroes/lycan/lycan_head.vmdl",
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lycan/blood_moon/lycan_blood_moon_belt_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[2] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[2], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[2], PATTACH_POINT_FOLLOW, "attach_necro", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[2], PATTACH_POINT_FOLLOW, "attach_dummy", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lycan/blood_moon/lycan_blood_moon_weapon_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[5] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[5], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_l_blade_01", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_l_blade_02", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_l_blade_03", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_r_blade_01", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 5, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_r_blade_02", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_r_blade_03", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lycan/blood_moon/lycan_blood_moon_shapeshift_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero);
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_blade_center", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero, PATTACH_POINT_FOLLOW, "attach_blade_l", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero, PATTACH_POINT_FOLLOW, "attach_blade_r", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero, PATTACH_POINT_FOLLOW, "attach_l_eye", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 5, hero, PATTACH_POINT_FOLLOW, "attach_r_eye", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
