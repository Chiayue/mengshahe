if modifier_wood_call_settlement == nil then
    modifier_wood_call_settlement = ({})
end


function modifier_wood_call_settlement:OnDestroy()
    if IsServer() then
        local isClear = true
        local ability = self:GetAbility()
        for k,v in ipairs(self:GetParent().call_unit) do
            if not v:IsNull() and v:IsAlive() then
                isClear = false
            end
        end
        self:GetParent().call_unit = nil
        if not isClear then
            local controlPlayerId = RandomInt(0, global_var_func.all_player_amount-1)
            local hero = PlayerResource:GetPlayer(controlPlayerId):GetAssignedHero()
            local duration = 10
            if global_var_func.all_player_amount > 1 then
                local randomHeroTable = {}
                for i=0,global_var_func.all_player_amount-1 do 
                    if PlayerResource:GetPlayer(i) and i~= controlPlayerId then
                        local onLineHero = PlayerResource:GetPlayer(i):GetAssignedHero()
                        if onLineHero then
                            onLineHero:AddNewModifier(self:GetParent(),ability , "modifier_wood_call_attack_by_friendly", {duration=duration})
                            table.insert(randomHeroTable,onLineHero)
                        end
                    end
                end
                ability.forceAttackUnit =  randomHeroTable[RandomInt(1, #randomHeroTable)]
                if ability.forceAttackUnit then
                    hero:AddNewModifier(self:GetParent(),ability , "modifier_wood_call_dominated",  {duration=duration})
                    -- print("do attack")
                else
                    hero:AddNewModifier(self:GetParent(), ability, "modifier_common_stun", {duration=10})
                end
            else
                -- local damage_info = {
                --     victim = hero,
                --     attacker = self:GetParent(),
                --     damage = hero:ge,
                --     damage_type = DAMAGE_TYPE_MAGICAL,
                --     ability = ability
                -- }
                -- ApplyDamage(damage_info)
                hero:AddNewModifier(self:GetParent(), ability, "modifier_common_stun", {duration=10})
            end
        end
    end
end

--强制攻击

if modifier_wood_call_dominated == nil then
    modifier_wood_call_dominated = ({})
end 

function modifier_wood_call_dominated:CheckState()
    local states = {
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
    }
    return states
end

function modifier_wood_call_dominated:OnCreated(params)
    if IsServer() then
        ExecuteOrderFromTable(
			{
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self:GetAbility().forceAttackUnit:entindex()
			}
		)
        self:GetParent():SetForceAttackTarget(self:GetAbility().forceAttackUnit )
    end
end

function modifier_wood_call_dominated: OnDestroy()
    if IsServer() then
        self:GetParent():SetForceAttackTarget(nil)
    end
end

--可被友方攻击

if modifier_wood_call_attack_by_friendly == nil then
    modifier_wood_call_attack_by_friendly = ({})
end 

function modifier_wood_call_dominated:CheckState()
    local states = {
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
    }
    return states
end