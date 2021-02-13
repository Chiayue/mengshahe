if modifier_cast_ability == nil then 
    modifier_cast_ability = class({})
end

function modifier_cast_ability:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_cast_ability:OnCreated(params)
    if IsServer() then
        self.ability_table = {}
        for i=0,4 do
            local ability_name = "cast_ability_"..i
            if params[ability_name] then
                table.insert(self.ability_table,params[ability_name])
            end
        end
        self:StartIntervalThink(1)
    end
end

function modifier_cast_ability:OnIntervalThink()
    local unit = self:GetParent()
    if unit:IsAlive()  then
        for _,v in pairs(self.ability_table) do
            local ability = unit:FindAbilityByName(v)
            if  ability:IsFullyCastable() then
                local cast_type = ability:GetBehavior()
                if cast_type == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
                    unit:CastAbilityImmediately(ability,unit:GetEntityIndex())
                elseif cast_type == DOTA_ABILITY_BEHAVIOR_POINT then
                  
                end
            end
        end
    end
end

function modifier_cast_ability:IsHidden()
    return true    
 end

