function qicai_shi(params)
    local caster = params.caster
    local ability = params.ability
    game_playerinfo:change_player_wood(caster, ability:GetSpecialValueFor("jinzuan"))
    caster:RemoveAbility("gem_qicai_shi")
    caster:RemoveModifierByName("modifier_gem_qicai_shi_base")
end

function gold_shi(params)
    local caster = params.caster
    local ability = params.ability
    game_playerinfo:set_player_gold(caster:GetPlayerID(),ability:GetSpecialValueFor("gold_amount"))
    caster:RemoveAbility("gem_gold_shi")
    caster:RemoveModifierByName("modifier_gem_gold_shi")
end