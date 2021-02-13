function Spawn( entityKeyValues )
    if not IsServer() then
		return
	end
    if thisEntity == nil then
		return
    end
    thisEntity.sz_cast75 = true
    thisEntity.sz_cast50 = true
    thisEntity.call_anthor = true
    thisEntity:SetContextThink( "do_ability", do_ability, 0 )

end

function do_ability()
    local unit = thisEntity
    if unit:IsChanneling() then
        return 2
    end 
    if unit:IsAlive() then
        if thisEntity.sz_cast75 or thisEntity.sz_cast50 then
            local max_health = thisEntity:GetMaxHealth()
            local current_health = thisEntity:GetHealth()
            if (current_health >  max_health * 0.5 and current_health < max_health * 0.75) or current_health < max_health * 0.5 then
                local shengzhang = unit:FindAbilityByName("fengkuangshengzhang")
                if shengzhang:IsFullyCastable() then
                    unit:CastAbilityNoTarget(shengzhang,unit:GetEntityIndex())
                    return 2
                end
            end
        end
        if thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.8 then
            local zhongzi = unit:FindAbilityByName("jishengzhongzi")
            if zhongzi:IsFullyCastable() then
                unit:CastAbilityNoTarget(zhongzi,unit:GetEntityIndex())
                return 2
            end
            local shujingtuji = unit:FindAbilityByName("shujingtuji")
            if shujingtuji:IsFullyCastable() then
                unit:CastAbilityNoTarget(shujingtuji,unit:GetEntityIndex())
                return 2
            end
        end
        if thisEntity.call_anthor and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.25 then
            local shenwaihuashen = unit:FindAbilityByName("shenwaihuashen")
            if shenwaihuashen and shenwaihuashen:IsFullyCastable() then
                unit:CastAbilityNoTarget(shenwaihuashen,unit:GetEntityIndex())
                thisEntity.call_anthor = false
                return 2
            end
        end
        return 2
    else
        return nil
    end
end