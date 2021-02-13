modifier_base_get_gold = class({})

function modifier_base_get_gold:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_base_get_gold:OnTakeDamage(event)
    if event.damage > 0 then
        local attacker = event.attacker
        local target = event.unit
        local parent = self:GetParent()
        if (attacker == parent or attacker:GetOwner() == parent) and target:GetTeamNumber() ~= parent:GetTeamNumber() then
            if parent and not parent:IsNull() and parent:IsAlive() then
                local pindex = ParticleManager:CreateParticle( "particles/diy_particles/gold.vpcf", PATTACH_OVERHEAD_FOLLOW, target );
                ParticleManager:SetParticleControlEnt( pindex, 0, nil, PATTACH_OVERHEAD_FOLLOW, "",target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( pindex, 1, nil, PATTACH_OVERHEAD_FOLLOW, "", parent:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex(pindex)
            end
            local gold_rod_bounty = 1
            local damage_gold_base =  global_var_func.damage_gold_base
            for i = 0, 4 do
                local j = 4 - i
                local item = parent:FindItemInInventory("item_custom_gold_rod_"..j)
                if item then
                    gold_rod_bounty = gold_rod_bounty + tonumber(item:GetSpecialValueFor("gain_gold_speed")) / 100
                    damage_gold_base = damage_gold_base + j + 1
                    break
                end
            end
            -- 秒杀奖励
            if event.damage >= target:GetMaxHealth() then
                gold_rod_bounty = gold_rod_bounty * 3
            end
            game_playerinfo:set_player_gold(parent:GetPlayerID(),damage_gold_base * gold_rod_bounty) 
        end 
    end
end

function modifier_base_get_gold:IsHidden()
	return true
end

function modifier_base_get_gold:IsPurgable()
    return false
end

function modifier_base_get_gold:RemoveOnDeath()
    return false
end