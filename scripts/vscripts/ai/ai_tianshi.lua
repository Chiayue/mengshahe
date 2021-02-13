function Spawn( entityKeyValues )
    if not IsServer() then
		return
	end
    if thisEntity == nil then
		return
    end
    thisEntity:SetContextThink( "do_ability", do_ability, 0 )

end

function do_ability()
    local hero = thisEntity:GetOwner()
    local unit = thisEntity
    local ability_heal = unit:FindAbilityByName("tianshi_heal")
    local ability_fuhuo = unit:FindAbilityByName("tianshi_fuhuo")
    if unit:IsAlive() then
        if hero:IsAlive() then
            unit:MoveToNPC(hero)
            if ability_heal:IsFullyCastable() then
                unit:CastAbilityImmediately(ability_heal,unit:GetEntityIndex())
            end
        end
        if not hero:IsAlive() and ability_fuhuo and ability_fuhuo:IsFullyCastable() then
            unit:CastAbilityImmediately(ability_fuhuo,unit:GetEntityIndex())
        end
        return 1
    else
        return nil
    end
end