fuwang_lua = class({})

LinkLuaModifier( "modifier_fuwang_lua_wear","ability/abilities_lua/fuwang_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

-- function fuwang_lua:OnSpellStart()
--     local caster = self:GetCaster()
--     game_playerinfo:set_player_gold(caster:GetPlayerID(),500 + caster:GetLevel()*500)
--     caster:AddNewModifier( caster, self, "modifier_active_point_magical_lua", { duration = 7.0 } )
-- end

function fuwang_lua:GetIntrinsicModifierName()
    return "modifier_fuwang_lua_wear"
end

if modifier_fuwang_lua_wear==nil then
    modifier_fuwang_lua_wear = ({})
end


function modifier_fuwang_lua_wear:IsHidden() return true end
function modifier_fuwang_lua_wear:RemoveOnDeath() return false end

function modifier_fuwang_lua_wear:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        -- local weartable = {
        --   "models/items/axe/generic_blinkdag/generic_blinkdag.vmdl",
        --   "models/items/axe/molten_claw/molten_claw.vmdl",
        --   "models/items/axe/shout_mask/shout_mask.vmdl",
        --   "models/items/axe/axe_cape/axe_cape.vmdl",
        -- }
        -- WearForHero(weartable,self:GetParent())
        -- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_helm_shoutmask/axe_shout_mask_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[3] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_eye_l", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_eye_r", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_mouth", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_armor_molten_claw/axe_molten_claw_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[2] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[2], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[2], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_cinder/axe_cinder_ambient_alt.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[4] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[4], PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 7, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 9, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 10, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)

        local weartable = {
              "models/heroes/axe/head2.vmdl",
              "ti9_jungle_axe_belt",
            }
        WearForHero(weartable,self:GetParent())
        hero:AddActivityModifier('jog')

        self.damageTable = {
            attacker = hero,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility(),
        }
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function modifier_fuwang_lua_wear:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_fuwang_lua_wear:OnAttackLanded(params)
    if IsServer( ) then
        local hero = self:GetParent()
        if params.attacker == hero then
            local enemies = FindUnitsInRadius(
                    hero:GetTeamNumber(),
                    params.target:GetAbsOrigin(),
                    nil,
                    300,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                    FIND_ANY_ORDER, 
                    false
                )
            if #enemies > 0 then
                for i=1, #enemies do
                    if enemies[i] ~= params.target then
                        self.damageTable.damage = params.original_damage
                        self.damageTable.victim = enemies[i]
                        ApplyDamage(self.damageTable)
                    end
                end
            end
        end
    end
end 