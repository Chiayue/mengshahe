LinkLuaModifier( "modifier_is_in_ground", "ability/abilities_lua/passive_in_ground.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_on_ground_heal", "ability/abilities_lua/passive_in_ground.lua",LUA_MODIFIER_MOTION_NONE )

function DoSpellStart(params)
    local caster = params.caster
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/nyx_assassin/nyx_assassin_ti6_witness/nyx_assassin_impale_ti6_witness.vpcf", PATTACH_WORLDORIGIN	, nil );
    ParticleManager:SetParticleControl(nFXIndex, 0,caster:GetOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 3,caster:GetOrigin())
    caster.in_ground_particle = nFXIndex
    caster:AddNewModifier(caster, params.ability, "modifier_is_in_ground", {duration = 3})
    caster:AddEffects((EF_NODRAW))
    for _,v in pairs(caster.wear_table) do 
        v:AddEffects((EF_NODRAW))
    end
end

function wear_cloth(params)
    local caster = params.caster
    local wearTable = {
        "models/items/nerubian_assassin/ti6_immortal/mesh/ti6_immortal_nyx_weapon_model.vmdl",
        -- "models/items/nerubian_assassin/shards_of_meteorite_back/shards_of_meteorite_back.vmdl",
        "models/items/nerubian_assassin/nyx_ti9_immortal_back/nyx_ti9_immortal_back.vmdl",
    }
    WearForHero(wearTable,caster)
    --附着特效
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_ambient.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[2] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_crystal_l_outer", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_crystal_r_outer", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/nyx_assassin/nyx_ti10_cavern_crawl/nyx_ti10_weapon_2ndstyle.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[2] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_gem_r_fx", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_gem_l_fx", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
end


if modifier_is_in_ground == nil then
    modifier_is_in_ground = ({})
end

function modifier_is_in_ground:OnCreated(params)
end

function modifier_is_in_ground:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
    return funcs
end


function modifier_is_in_ground:GetModifierInvisibilityLevel(params)
    return 60
end

function modifier_is_in_ground:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true, --缴械
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
		[MODIFIER_STATE_NO_HEALTH_BAR] = true, --生命条
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true, -- 不执行命令
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true, -- 无小地图
        [MODIFIER_STATE_UNSELECTABLE] = true, -- 不可选
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, -- 无碰撞
        [MODIFIER_STATE_INVISIBLE] = true, -- 隐身
        [MODIFIER_STATE_ROOTED] = true, -- 缠绕
	}
end

function modifier_is_in_ground:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        caster:RemoveEffects(EF_NODRAW)
        for _,v in pairs(caster.wear_table) do 
            v:RemoveEffects(EF_NODRAW)
        end
        ParticleManager:DestroyParticle(caster.in_ground_particle, true)
        ParticleManager:ReleaseParticleIndex(caster.in_ground_particle)
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_on_ground_heal", {duration = 7})
    end
end

function modifier_is_in_ground:GetModifierHealthRegenPercentage()
    return 30
end

if modifier_on_ground_heal == nil then
    modifier_on_ground_heal = ({})
end

function modifier_on_ground_heal:OnCreated(params)
    if IsServer() then
        local caster = self:GetParent()
        self.send_heal = caster:GetMaxHealth() * 0.3 / 7
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end
end

function modifier_on_ground_heal:OnIntervalThink()
    self:GetParent():Heal(self.send_heal, self:GetParent())
end
