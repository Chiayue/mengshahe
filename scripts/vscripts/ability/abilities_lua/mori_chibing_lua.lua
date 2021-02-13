mori_chibing_lua = class({})
LinkLuaModifier( "modifier_mori_chibing_lua","ability/abilities_lua/mori_chibing_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "moidfier_mori_chibing_wear","ability/abilities_lua/mori_chibing_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function mori_chibing_lua:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
        if not ContainUnitTypeFlag(hTarget, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL) then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function mori_chibing_lua:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return 800
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function mori_chibing_lua:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
        if hTarget:IsAlive() then
            local unit_name = hTarget:GetUnitName()
            if not ContainUnitTypeFlag(hTarget, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL) or unit_name=="xiaoyanmo" or unit_name=="task_coin" or unit_name=="task_box" then
                return
            end
            self.now_health = hTarget:GetHealth()*(self:GetSpecialValueFor( "health_percent" )/100)
            self.now_attack = hTarget:GetBaseDamageMax()*(self:GetSpecialValueFor( "attack_percent" )/100)
            -- if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_mori_chibing_lua", { duration = self:GetSpecialValueFor( "duration" ) } )
            -- end
            -- 给英雄添加属性
            local damagehealth = hTarget:GetMaxHealth()
            local damage = {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = damagehealth + 100,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self
            }
            -- print(">>>>>>>>>>> damage: "..damage.damage);
            ApplyDamage( damage )
		end
	end
end

function mori_chibing_lua:GetIntrinsicModifierName()
    return "moidfier_mori_chibing_wear"
end

if moidfier_mori_chibing_wear == nil then
    moidfier_mori_chibing_wear = class({})
end

function moidfier_mori_chibing_wear:IsHidden() return true end
function moidfier_mori_chibing_wear:RemoveOnDeath() return false end
function moidfier_mori_chibing_wear:OnCreated(params)
    if IsServer() then
        -- local hero = self:GetParent()
        -- local weartable = {
        --     "models/items/ursa/hat_alpine.vmdl",
        --     "models/items/ursa/swift_claw_ursa_arms/ursa_swift_claw.vmdl",
        --     "models/items/ursa/pants_alpine.vmdl",
        --     "models/items/ursa/ti9_cavern_crawl_ursa_arms/ti9_cavern_crawl_ursa_arms.vmdl",
        --     "models/items/ursa/scarf_alpine.vmdl"
        -- }
        -- WearForHero(weartable,self:GetParent())
        -- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_swift_claw/ursa_swift_claw_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[2] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[2], PATTACH_POINT_FOLLOW, "attach_elbow_L", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[2], PATTACH_POINT_FOLLOW, "attach_elbow_R", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)

        local hero = self:GetParent()
        local wearTable = {
            "models/items/doom/doom_the_fallen_head/doom_the_fallen_head.vmdl",
            "models/items/doom/doom_the_fallen_arms/doom_the_fallen_arms.vmdl",
            "models/items/doom/ti8_doom_obsidian_overlord_back/ti8_doom_obsidian_overlord_back.vmdl",
            "models/items/doom/doom_the_fallen_belt/doom_the_fallen_belt.vmdl",
            "models/items/doom/doom_the_fallen_shoulder/doom_the_fallen_shoulder.vmdl",
            "models/items/doom/doom_the_fallen_tail/doom_the_fallen_tail.vmdl",
            "models/items/doom/doom_the_fallen_weapon/doom_the_fallen_weapon.vmdl",
        }
        WearForHero(wearTable,hero)
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_obsidian/doom_obsidian_wings_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[3] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_head.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[1], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_belt.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[4] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[4], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_shoulder.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[5] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_shoulder_r_fx", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_shoulder_l_fx", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_weapon.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[5] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_weapon_fx", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 26, hero.wear_table[5], PATTACH_POINT_FOLLOW	, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end


if modifier_mori_chibing_lua == nil then
	modifier_mori_chibing_lua = class({})
end

function modifier_mori_chibing_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

-- function modifier_mori_chibing_lua:IsHidden()
--     return false
-- end

function modifier_mori_chibing_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_mori_chibing_lua:OnIntervalThink()
    self:GetCaster():Heal(self:GetAbility().now_health, self:GetAbility())
    CustomNetTables:SetTableValue("dynamic_properties", "player_now_health"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_health = self:GetAbility().now_health})

    CustomNetTables:SetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID()), { now_attack = self:GetAbility().now_attack})

    self:StartIntervalThink(-1)
end

function modifier_mori_chibing_lua:GetModifierExtraHealthBonus()
    -- print(">>>>>>>>>>>>>>>   now_health: "..self:GetAbility().now_health)
    return self:GetAbility().now_health
end

function modifier_mori_chibing_lua:GetModifierBaseAttack_BonusDamage()
    -- print(">>>>>>>>>>>>>>>   now_attack: "..self:GetAbility().now_attack)
	return self:GetAbility().now_attack
end

function modifier_mori_chibing_lua:OnTooltip()
    local now_health = CustomNetTables:GetTableValue("dynamic_properties", "player_now_health"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_health = 0 }
	return now_health.now_health
end

function modifier_mori_chibing_lua:OnTooltip2()
    local now_attack = CustomNetTables:GetTableValue("dynamic_properties", "player_now_attack"..tostring(self:GetAbility():GetCaster():GetPlayerOwnerID())) or { now_attack = 0 }
	return now_attack.now_attack
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
