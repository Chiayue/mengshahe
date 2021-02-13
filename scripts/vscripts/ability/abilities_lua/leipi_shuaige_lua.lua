leipi_shuaige_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_leipi_shuaige_lua","ability/abilities_lua/leipi_shuaige_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leipi_shuaige_debuff_lua","ability/abilities_lua/leipi_shuaige_lua", LUA_MODIFIER_MOTION_NONE )

function leipi_shuaige_lua:GetIntrinsicModifierName()
    return "modifier_leipi_shuaige_lua"
end

if modifier_leipi_shuaige_lua == nil then
	modifier_leipi_shuaige_lua = class({})
end

if modifier_leipi_shuaige_debuff_lua == nil then
	modifier_leipi_shuaige_debuff_lua = class({})
end

function modifier_leipi_shuaige_lua:IsHidden()
    return true -- 隐藏
end

function modifier_leipi_shuaige_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_leipi_shuaige_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_leipi_shuaige_lua:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local weartable = {
            "models/items/terrorblade/knight_of_foulfell_terrorblade_weapon/knight_of_foulfell_terrorblade_weapon.vmdl",
            "models/items/terrorblade/terrorblade_ti8_immortal_back/terrorblade_ti8_immortal_back.vmdl",
            "models/heroes/terrorblade/horns_arcana.vmdl",
            "models/items/terrorblade/knight_of_foulfell_terrorblade_armor/knight_of_foulfell_terrorblade_armor.vmdl"
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_back_ambient_ti8.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[2] );
        ParticleManager:SetParticleControl(nFXIndex, 15, Vector(255,0,0))
        ParticleManager:SetParticleControl(nFXIndex, 16, Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_l.vpcf", PATTACH_POINT_FOLLOW	,  hero );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_weapon_l", hero:GetOrigin(), true );
        ParticleManager:SetParticleControl(nFXIndex, 15, Vector(255,0,0))
        ParticleManager:SetParticleControl(nFXIndex, 16, Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_r.vpcf", PATTACH_POINT_FOLLOW	,  hero );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_weapon_r", hero:GetOrigin(), true );
        ParticleManager:SetParticleControl(nFXIndex, 15, Vector(255,0,0))
        ParticleManager:SetParticleControl(nFXIndex, 16, Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_body_arcana_horns.vpcf", PATTACH_POINT_FOLLOW	,  hero );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true );
        ParticleManager:SetParticleControl(nFXIndex, 15, Vector(255,0,0))
        ParticleManager:SetParticleControl(nFXIndex, 16, Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        self:StartIntervalThink(20)
    end
end

function modifier_leipi_shuaige_lua:OnIntervalThink()
    local caster = self:GetCaster();

    local vDirection = caster:GetOrigin()
    vDirection.z = 0.0
    vDirection = vDirection:Normalized()
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    
    SetBaseStrength(caster, 10)
    SetBaseAgility(caster, 10)
    SetBaseIntellect(caster, 10)

    local health = math.floor(caster:GetHealth()*0.5)

    caster:SetHealth(health)
    -- local damage = {
    --     victim = caster,
    --     attacker = caster,
    --     damage = caster:GetMaxHealth()*0.5,
    --     damage_type = DAMAGE_TYPE_PURE,
    --     ability = self:GetAbility()
    -- }
    -- ApplyDamage( damage )
    
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
