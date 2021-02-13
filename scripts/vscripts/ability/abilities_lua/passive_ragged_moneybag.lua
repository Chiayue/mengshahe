function wearCloth(params)
	local wearTable = {
		"models/heroes/meepo/pack.vmdl",
	}
	WearForHero(wearTable,params.caster)
	params.caster:AddNewModifier(params.caster, params.ability, "modifier_ragged_moneybag_money", {})
end

function remove_money_bag(params)
	local caster = params.caster
	if not caster:IsHero() then
		caster = caster:GetOwner()
	end
	local time = GameRules:GetDOTATime(false, false)
	if not caster.chanceTable then
		caster.chanceTable = {5,10}
	end
	if 600 < time and time <= 1200 then
		caster.chanceTable[1] = 10
		caster.chanceTable[2] = 30
	elseif 1200 < time then
		caster.chanceTable[1] = 15
		caster.chanceTable[2] = 40
	end
	local ability = params.ability
	if caster.money_bag_index and caster.money_bag_index == ability:GetEntityIndex() then
		return
	end
	caster.money_bag_index = ability:GetEntityIndex()
	caster.award_gold = 0
	local chance = RandomInt(0, 100)
	if chance < caster.chanceTable[1] then
		caster.award_gold = 10000 
	elseif caster.chanceTable[1] <= chance  and chance < caster.chanceTable[2] then
		caster.award_gold = 1000
	else
		caster.award_gold = 100
	end
	game_playerinfo:set_player_gold(caster:GetPlayerID(),caster.award_gold)
	UTIL_Remove(ability)
end


LinkLuaModifier( "modifier_ragged_moneybag_money", "ability/abilities_lua/passive_ragged_moneybag.lua",LUA_MODIFIER_MOTION_NONE )

if modifier_ragged_moneybag_money == nil then
	modifier_ragged_moneybag_money = ({})
end

function modifier_ragged_moneybag_money:IsHidden() return true end
function modifier_ragged_moneybag_money:RemoveOnDeath() return false end
function modifier_ragged_moneybag_money:IsPurgable() return false end


function modifier_ragged_moneybag_money:OnCreated(params)
	if IsServer() then
		self.award_gold = 0
		self:StartIntervalThink(20)
	end	
end

function modifier_ragged_moneybag_money:OnIntervalThink()
	local item = CreateItem("item_consum_money_bag", nil, nil)
	CreateItemOnPositionForLaunch(self:GetParent():GetOrigin()+RandomVector(100),item)
end	
