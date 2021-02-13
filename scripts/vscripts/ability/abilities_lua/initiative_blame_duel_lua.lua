CreateEmptyTalents("centaur")
--决斗
LinkLuaModifier("modifier_blame_duel_caster", "ability/abilities_lua/initiative_blame_duel_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blame_duel_enemy", "ability/abilities_lua/initiative_blame_duel_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blame_duel_dummy", "ability/abilities_lua/initiative_blame_duel_lua", LUA_MODIFIER_MOTION_NONE)

initiative_blame_duel_lua = class({})

function initiative_blame_duel_lua:IsHiddenWhenStolen() 		return false end
function initiative_blame_duel_lua:IsRefreshable() 			return true  end
function initiative_blame_duel_lua:IsStealable() 				return true  end
function initiative_blame_duel_lua:IsNetherWardStealable() 	return true end

function initiative_blame_duel_lua:GetCastRange(vLocation, hTarget) return 200 + (GameRules:GetCustomGameDifficulty()-1)*50 end

function initiative_blame_duel_lua:OnSpellStart()
	local caster = self:GetCaster()
	-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Centaur.HoofStomp", caster)
	EmitSoundOn( "hero.attack.npc_dota_hero_legion_commander", self:GetCaster() )
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	for i=0,6 do
		ParticleManager:SetParticleControl(pfx, i, caster:GetAbsOrigin())
	end
	ParticleManager:SetParticleControl(pfx, 1, Vector(200 + (GameRules:GetCustomGameDifficulty()-1)*50, 200 + (GameRules:GetCustomGameDifficulty()-1)*50, 200 + (GameRules:GetCustomGameDifficulty()-1)*50))
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 200 + (GameRules:GetCustomGameDifficulty()-1)*50, false)
	CreateModifierThinker(caster, self, "modifier_blame_duel_dummy", {duration = self:GetSpecialValueFor("pit_duration")+(GameRules:GetCustomGameDifficulty()-1)*1}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end


modifier_blame_duel_dummy = class({})

function modifier_blame_duel_dummy:IsAura() return true end
function modifier_blame_duel_dummy:GetAuraDuration() return 0.1 end
function modifier_blame_duel_dummy:GetModifierAura() return "modifier_blame_duel_caster" end
--返回该光环尝试应用其增益的父级周围的范围。
function modifier_blame_duel_dummy:GetAuraRadius() return 200 + (GameRules:GetCustomGameDifficulty()-1)*50 end
function modifier_blame_duel_dummy:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_blame_duel_dummy:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_blame_duel_dummy:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_blame_duel_dummy:GetAuraEntityReject(unit)
	if unit ~= self:GetCaster() then
		return true
	end
	return false
end

function modifier_blame_duel_dummy:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/hero/centaur/centaur_hoof_stomp_arena.vpcf", PATTACH_CUSTOMORIGIN, nil)
		for i=0,7 do
			ParticleManager:SetParticleControl(pfx, i, self:GetParent():GetAbsOrigin())
		end
		self:AddParticle(pfx, false, false, 15, false, false)

		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			self, 
			200 + (GameRules:GetCustomGameDifficulty()-1)*50, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, 
			false
		)
		local hClosestTarget = nil
		local flClosestDist = 0.0
		-- 选取范围最近的1个单位
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil then
					local vToTarget = enemy:GetOrigin() - self:GetParent():GetOrigin()
					local flDistToTarget = vToTarget:Length()
	
					if hClosestTarget == nil or flDistToTarget < flClosestDist then
						hClosestTarget = enemy
						flClosestDist = flDistToTarget
					end		
				end
			end
		end
		local target = hClosestTarget
		if target ~=nil then
			--GetRemainingTime获得剩余时间
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_blame_duel_enemy", {duration = self:GetRemainingTime()})
		end
		
	end
end


modifier_blame_duel_caster = class({})

function modifier_blame_duel_caster:IsDebuff()				return false end
function modifier_blame_duel_caster:IsHidden() 			return false end
function modifier_blame_duel_caster:IsPurgable() 			return false end
function modifier_blame_duel_caster:IsPurgeException() 	return false end

function modifier_blame_duel_caster:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}
	return state
end

modifier_blame_duel_enemy = class({})

function modifier_blame_duel_enemy:IsDebuff()			return true end
function modifier_blame_duel_enemy:IsHidden() 			return true end
function modifier_blame_duel_enemy:IsPurgable() 		return true end
function modifier_blame_duel_enemy:IsPurgeException() 	return true end
function modifier_blame_duel_enemy:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}
	return state
end

function modifier_blame_duel_enemy:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end
function modifier_blame_duel_enemy:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_blame_duel_enemy:OnIntervalThink()
	if not self:GetCaster() or not self:GetAbility() or not self then
		return
	end
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > 200 + (GameRules:GetCustomGameDifficulty()-1)*50 then
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * 200 + (GameRules:GetCustomGameDifficulty()-1)*50
		--净空
		FindClearSpaceForUnit(self:GetParent(), pos, true)
	end
end
function modifier_blame_duel_enemy:OnDeath(params)

    if not IsServer( ) then
        return
    end
    local attacker = params.attacker
    attacker:Heal(attacker:GetMaxHealth()*0.3, self:GetAbility())

end

