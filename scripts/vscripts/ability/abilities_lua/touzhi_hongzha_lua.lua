LinkLuaModifier( "modifier_touzhi_hongzha_lua", "ability/abilities_lua/touzhi_hongzha_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if touzhi_hongzha_lua == nil then
	touzhi_hongzha_lua = class({})
end

function touzhi_hongzha_lua:GetIntrinsicModifierName()
 	return "modifier_touzhi_hongzha_lua"
end
--------------------------------------------------
if modifier_touzhi_hongzha_lua == nil then
	modifier_touzhi_hongzha_lua = class({})
end

function modifier_touzhi_hongzha_lua:IsHidden()
	return true
end

function modifier_touzhi_hongzha_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_touzhi_hongzha_lua:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	-- DeepPrintTable(params)
	local hTarget = params.target
	local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
	local abil_damage = params.original_damage
	-- local str = self:GetCaster():GetStrength()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		hTarget:GetOrigin(), 
		hTarget, 
		aoe, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)
	-- print(">>>>>>>>>>>>  aoe: "..aoe)
	-- print(">>>>>>>>>>>>  abil_damage: "..abil_damage)
	-- print(">>>>>>>>>>>>  #enemies: "..#enemies)
	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = abil_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage( damage )
		end
	end
end

-----------------------------
