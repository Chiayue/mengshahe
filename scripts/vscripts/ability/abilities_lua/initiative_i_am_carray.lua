function apply_buff(params)
	local caster = params.caster
	local player 
	local hero 
	for i=0,3 do
		player = PlayerResource:GetPlayer(i)
		if player then
			hero = player:GetAssignedHero()
			if hero ~= caster then
				hero:AddNewModifier(caster, params.ability, "modifier_i_am_carray_invulnerable", {})
			end
		end
	end
	caster:AddNewModifier(caster, params.ability, "modifier_i_am_carray", {})
	if math.random(1,2) == 1 then
		caster:EmitSound("xiaotuantuan.suweisuwei")--调用音效 
	else
		caster:EmitSound("paopaoyang.shouting")--调用音效 
	end
	
end

function remove_buff(params)
	local caster = params.caster
	caster:RemoveModifierByName("modifier_i_am_carray")
	local player 
	local hero 
	for i=0,3 do
		player = PlayerResource:GetPlayer(i)
		if player then
			hero = player:GetAssignedHero()
			if hero ~= caster then
				hero:RemoveModifierByName("modifier_i_am_carray_invulnerable")
			end
		end
	end
	caster:StopSound("xiaotuantuan.suweisuwei")
	caster:StopSound("paopaoyang.shouting")
end

LinkLuaModifier( "modifier_i_am_carray", "ability/abilities_lua/initiative_i_am_carray.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_i_am_carray_invulnerable", "ability/abilities_lua/initiative_i_am_carray.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if modifier_i_am_carray == nil then
	modifier_i_am_carray = ({})
end

function modifier_i_am_carray:OnCreated(params)
	self:StartIntervalThink(1)
end

function modifier_i_am_carray:OnIntervalThink()
	if IsServer() then
		local hero = self:GetParent()
		SetBaseAgility(hero, 2)
		SetBaseStrength(hero, 2)
		SetBaseIntellect(hero, 2)
	end
end

if modifier_i_am_carray_invulnerable == nil then
	modifier_i_am_carray_invulnerable = ({})
end

function modifier_i_am_carray_invulnerable:IsHidden() return false end

function modifier_i_am_carray_invulnerable:CheckState() 
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end