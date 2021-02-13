LinkLuaModifier( "modifier_dianran_lua", "ability/abilities_lua/innateskill_dianran_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_active_xianjing_lua","ability/abilities_lua/innateskill_dianran_lua.lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------
--Abilities
if dianran_lua == nil then
	dianran_lua = class({})
end

function dianran_lua:GetIntrinsicModifierName()
 	return "modifier_dianran_lua"
end
--------------------------------------------------
if modifier_dianran_lua == nil then
	modifier_dianran_lua = class({})
end

function modifier_dianran_lua:IsHidden()
    return true
end

function modifier_dianran_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_dianran_lua:OnAttackLanded(params)
    if not IsServer( ) then
        return
    end
    if params.attacker ~= self:GetParent() then
		return
    end
    self.chance = self:GetAbility():GetSpecialValueFor( "chance" )

    if not RollPercentage(self.chance) then
        return
    end

    local hTarget = params.target
    local kv = {}
	CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_active_xianjing_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )

end

function modifier_dianran_lua:OnCreated(params)
	if IsServer() then
		self.parent = self:GetParent()
		local item = nil
		local index = nil
		
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
			model = "models/items/broodmother/witchs_grasp_back/witchs_grasp_back.vmdl",
		})
		item:FollowEntity(self.parent, true)
		index = ParticleManager:CreateParticle("particles/econ/items/broodmother/bm_fall20_witches_grasp/bm_fall20_witches_grasp_back_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
		ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_center", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_mid", item:GetOrigin(), true)
	
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
			model = "models/items/broodmother/witchs_grasp_head/witchs_grasp_head.vmdl",
		})
		item:FollowEntity(self.parent, true)
		index = ParticleManager:CreateParticle("particles/econ/items/broodmother/bm_fall20_witches_grasp/bm_fall20_witches_grasp_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
		ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_candle", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_center_head", item:GetOrigin(), true)
	
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
			model = "models/items/broodmother/witchs_grasp_legs/witchs_grasp_legs.vmdl",
		})
		item:FollowEntity(self.parent, true)
	
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
			model = "models/items/broodmother/witchs_grasp_misc/witchs_grasp_misc.vmdl",
		})
		item:FollowEntity(self.parent, true)
		index = ParticleManager:CreateParticle("particles/econ/items/broodmother/bm_fall20_witches_grasp/bm_fall20_witches_grasp_misc_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
		ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_candle_01", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_candle_02", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 2, item, PATTACH_POINT_FOLLOW, "attach_candle_03", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 3, item, PATTACH_POINT_FOLLOW, "attach_candle_04", item:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 4, item, PATTACH_POINT_FOLLOW, "attach_candle_05", item:GetOrigin(), true)

	end
end
-----------------------------

modifier_active_xianjing_lua = class({})

--------------------------------------------------------------------------------

function modifier_active_xianjing_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_xianjing_lua:OnCreated( kv )
    if IsServer() then
        -- DeepPrintTable(self:GetAbility())
        self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
        self.space_time = self:GetAbility():GetSpecialValueFor( "space_time" )
        self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
        self.bonuses_scale = self:GetAbility():GetSpecialValueFor("bonuses_scale")
        self.attribute_type = self:GetAbility():GetSpecialValueFor("attribute_type")
        self.Caster = self:GetCaster()
		
		-- EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self.Caster )
		
		-- local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cinside.vpcf", PATTACH_WORLDORIGIN, self.Caster, self.Caster:GetTeamNumber() )
		-- ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, 1 ) )
        -- ParticleManager:ReleaseParticleIndex( nFXIndex )
		
		self:SetStackCount(1)
		self:StartIntervalThink( self.space_time )
	end
end

--------------------------------------------------------------------------------

function modifier_active_xianjing_lua:OnIntervalThink()
	if IsServer() then
		
		self:SetStackCount(self:GetStackCount() + 1)
		-- self:GetParent():CalculateStatBonus()
		
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local att_value = self.Caster:GetIntellect()+self.Caster:GetAgility()+self.Caster:GetStrength();
		
					if self.attribute_type == 0 then
						att_value = self.Caster:GetStrength();
					elseif self.attribute_type == 1 then
                        att_value = self.Caster:GetAgility();
                    elseif self.attribute_type == 2 then
                        att_value = self.Caster:GetIntellect();
					end
					local damage = {
						victim = enemy,
						attacker = self.Caster,
						damage = att_value * self.bonuses_scale,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility()
					}
					-- print(">>>>>>>>>>>>> damage: "..damage.damage);
					-- enemy:AddNewModifier( self.Caster, self:GetAbility(), "modifier_active_point_magical_lua", { duration = self.duration } )
					ApplyDamage( damage )
				end
			end
		end

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self.Caster )
		
		self.index = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cinside.vpcf", PATTACH_WORLDORIGIN, self.Caster, self.Caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( self.index, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.index, 1, Vector( self.radius, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( self.index )

		if self.duration < self:GetStackCount() then
            self:Destroy()
		end
		-- UTIL_Remove( self:GetParent() )
	end
end

function modifier_active_xianjing_lua:OnDestroy()
	if not IsServer() then
		return
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------