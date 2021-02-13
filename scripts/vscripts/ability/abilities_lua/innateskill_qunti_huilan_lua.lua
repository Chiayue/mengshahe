qunti_huilan_lua = class({})

--------------------------------------------------------------------------------

function qunti_huilan_lua:OnSpellStart()
    if IsServer() then
        local player_count = global_var_func.all_player_amount
        for i = 0, player_count-1 do
            local player = PlayerResource:GetPlayer(i)
            local hero = player:GetAssignedHero()

            hero:GiveMana(300)
        end 
    end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------