function item_baoWu_book( event )
	local hHero = event.caster
	if hHero:IsHero() == false then
		hHero = event.caster:GetOwnerEntity()
	end
	local nPlayerID = hHero:GetPlayerID()
	local hItem = event.ability
	if not hItem.treasure_number then
		OpenTreasureWindow(nPlayerID, 3)
	else
		OpenTreasureWindow(nPlayerID, hItem.treasure_number)
	end
end