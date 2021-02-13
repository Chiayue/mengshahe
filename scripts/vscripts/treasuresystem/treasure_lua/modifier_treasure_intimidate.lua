---------------------------------------------------------------------------
-- 宝物：恫吓
---------------------------------------------------------------------------

if modifier_treasure_intimidate == nil then 
    modifier_treasure_intimidate = class({})
end

function modifier_treasure_intimidate:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_intimidate"
    end
    return "buff/modifier_treasure_keep_changing"
end
 
function modifier_treasure_intimidate:OnCreated(kv)
    if IsServer() then
        local start_corner = "start_corner_"
        local playerid = self:GetParent():GetPlayerID() + 1
        while true do
            local random_index = RandomInt(1, 4)
            if playerid ~= random_index then
                if random_index == 1 then
                    start_corner = start_corner.."a"
                elseif random_index == 2 then
                    start_corner = start_corner.."b"
                elseif random_index == 3 then
                    start_corner = start_corner.."c"
                elseif random_index == 4 then
                    start_corner = start_corner.."d"
                end
                break
            end
        end
        global_var_func.corner[playerid].start_corner = start_corner
        global_var_func.intimidate[playerid] = true

    end
end
 
function modifier_treasure_intimidate:OnDestroy()
    if IsServer() then
        local start_corner = "start_corner_"
        local playerid = self:GetParent():GetPlayerID() + 1
        if playerid == 1 then
            start_corner = start_corner.."a"
        elseif playerid == 2 then
            start_corner = start_corner.."b"
        elseif playerid == 3 then
            start_corner = start_corner.."c"
        elseif playerid == 4 then
            start_corner = start_corner.."d"
        end
        global_var_func.corner[playerid].start_corner = start_corner
        global_var_func.intimidate[playerid] = false
    end
end

function modifier_treasure_intimidate:IsPurgable()
    return false
end
 
function modifier_treasure_intimidate:RemoveOnDeath()
    return false
end