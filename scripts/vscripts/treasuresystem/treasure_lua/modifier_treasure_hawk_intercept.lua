---------------------------------------------------------------------------
-- 宝物：白雕塞努
---------------------------------------------------------------------------

if modifier_treasure_hawk_intercept == nil then 
    modifier_treasure_hawk_intercept = class({})
end

function modifier_treasure_hawk_intercept:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_treasure_hawk_intercept:OnRespawn(event)
    if event.unit == self:GetParent() then
        self:CallHawk()
    end
end

function modifier_treasure_hawk_intercept:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_hawk_intercept"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_hawk_intercept:IsPurgable()
    return false
end
 
function modifier_treasure_hawk_intercept:RemoveOnDeath()
    return false
end

function modifier_treasure_hawk_intercept:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        self:CallHawk()
    end
end

function modifier_treasure_hawk_intercept:OnDestroy()
    if IsServer() then
        self:GetParent().unit_1:ForceKill(false)
    end
end

function modifier_treasure_hawk_intercept:CallHawk(params)
    if IsServer() then
        local parent = self:GetParent()
        local unit = CreateUnitByName("hawk", parent:GetOrigin() - parent:GetForwardVector() * 400, true, parent, parent:GetPlayerOwner(), parent:GetTeamNumber())
        parent.unit_1 = unit
        unit:SetOwner(parent)
        unit:AddNewModifier(parent, nil, "modifier_treasure_hawk_intercept_thinker", nil)
    end
end

--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_hawk_intercept_thinker","treasuresystem/treasure_lua/modifier_treasure_hawk_intercept", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_hawk_intercept_thinker == nil then 
    modifier_treasure_hawk_intercept_thinker = class({})
end

function modifier_treasure_hawk_intercept_thinker:CheckState()
	return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY ] = true,
    }
end

function modifier_treasure_hawk_intercept_thinker:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_DEATH ,
    }
end

function modifier_treasure_hawk_intercept_thinker:OnDeath(event)
    local parent = self:GetParent()
    local hero = parent:GetOwner()
    if event.unit == hero then
        parent:ForceKill(false)
    end
end

function modifier_treasure_hawk_intercept_thinker:GetModifierAvoidDamage(event)
    return 1
end

function modifier_treasure_hawk_intercept_thinker:OnAttackStart(event)
    local parent = self:GetParent()
    local hero = parent:GetOwner()
    local attacker = event.attacker
    if event.target == hero and attacker:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
        if self:CanIntercept(event.attacker) then
            attacker:Stop()
            attacker:MoveToTargetToAttack(parent)
            attacker.transfer_attack = true
        end
        return
    end
    if event.target == parent then
        if attacker:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK and attacker.transfer_attack then
            attacker.transfer_attack = false
            return
        end
        attacker:Stop()
        attacker:MoveToTargetToAttack(hero)
        return
    end
end

function modifier_treasure_hawk_intercept_thinker:IsHidden()
    return true
end
 
function modifier_treasure_hawk_intercept_thinker:IsPurgable()
    return false
end
 
function modifier_treasure_hawk_intercept_thinker:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        local p_position = parent:GetOrigin()
        parent.t_position = p_position
        local hero = parent:GetOwner()
        local h_position = hero:GetOrigin()
        self:OnIntervalThink()
        self:StartIntervalThink(0.1)
    end
end

function modifier_treasure_hawk_intercept_thinker:OnIntervalThink()
    local parent = self:GetParent()
    local p_position = parent:GetOrigin()
    local hero = parent:GetOwner()
    local h_position = hero:GetOrigin()
    local len_1 = (h_position - p_position):Length2D()
    if len_1 > 450 then
        parent:MoveToNPC(hero)
        return
    end
    if len_1 < 420 and len_1 > 400 then
        parent.t_position = RotatePosition(h_position, QAngle(0, 10, 0), h_position + (p_position - h_position):Normalized() * 400)
        parent:MoveToPosition(parent.t_position)
        return
    end
    if len_1 < 390 then
        if hero:IsMoving() then
            if parent:IsMoving() then
                parent:Stop()
            end
            return
        end
        parent.t_position = RotatePosition(h_position, QAngle(0, 10, 0), h_position + (p_position - h_position):Normalized() * 400)
        parent:MoveToPosition(parent.t_position)
        return
    end
    local len_2 = (parent.t_position - p_position):Length2D()
    if len_2 < 50 then
        parent.t_position = RotatePosition(h_position, QAngle(0, 10, 0), parent.t_position)
        parent:MoveToPosition(parent.t_position)
        return
    end
    if not parent:IsMoving() then
        parent:MoveToPosition(parent.t_position)
        return
    end
end

function modifier_treasure_hawk_intercept_thinker:CanIntercept(attacker)
    local a_position = attacker:GetOrigin()
    local parent = self:GetParent()
    local p_position = parent:GetOrigin()
    local hero = parent:GetOwner()
    local h_position = hero:GetOrigin()
    local angle_a = VectorToAngles((a_position - h_position):Normalized()).y
    local angle_p = VectorToAngles((p_position - h_position):Normalized()).y
    local diff = AngleDiff(angle_a, angle_p)
    if diff >= 25 and diff <= 60 then
        return true
    end
    return false
end