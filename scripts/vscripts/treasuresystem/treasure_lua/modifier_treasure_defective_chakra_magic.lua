---------------------------------------------------------------------------
-- 宝物：不完美的查克拉魔法
---------------------------------------------------------------------------

if modifier_treasure_defective_chakra_magic == nil then 
    modifier_treasure_defective_chakra_magic = class({})
end

function modifier_treasure_defective_chakra_magic:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_defective_chakra_magic"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_defective_chakra_magic:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_defective_chakra_magic:OnAbilityExecuted(params)
    if IsServer() then
        local hAbility = params.ability
        local ability_name = hAbility:GetAbilityName()
        if game_playerinfo:get_player_active(self.steam_id) == ability_name or game_playerinfo:get_player_chaos(self.steam_id) == ability_name or self.parent:GetAbilityByIndex(1) == ability_name then
            Timers(function()
                hAbility:EndCooldown()
                local time = hAbility:GetCooldownTimeRemaining() + self:CustomRoll()
                if time > 0 then
                    hAbility:StartCooldown(time)
                end
            end) 
        end
    end
end

function modifier_treasure_defective_chakra_magic:IsPurgable()
    return false
end
 
function modifier_treasure_defective_chakra_magic:RemoveOnDeath()
    return false
end

function modifier_treasure_defective_chakra_magic:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.steam_id = PlayerResource:GetSteamAccountID(self.parent:GetPlayerID())
    end
end

function modifier_treasure_defective_chakra_magic:CustomRoll()
    local random = RandomInt(1, 100)
    if random >= 1 and random <= 30 then
        return -5
    end
    if random >= 31 and random <= 50 then
        return -6
    end
    if random >= 51 and random <= 60 then
        return -7
    end
    if random >= 61 and random <= 65 then
        return -8
    end
    if random >= 66 and random <= 68 then
        return -9
    end
    if random >= 69 and random <= 70 then
        return -10
    end
    if random >= 71 and random <= 80 then
        return 0
    end
    if random >= 81 and random <= 90 then
        return 5
    end
    if random >= 91 and random <= 100 then
        return 10
    end
end