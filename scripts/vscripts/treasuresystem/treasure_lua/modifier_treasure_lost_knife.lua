---------------------------------------------------------------------------
-- 宝物：遗失之物 - 生锈的小刀
---------------------------------------------------------------------------

if modifier_treasure_lost_knife == nil then 
    modifier_treasure_lost_knife = class({})
end

function modifier_treasure_lost_knife:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_knife"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_knife:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_treasure_lost_knife:OnAttackLanded(event)
    local parent = self:GetParent()
    if event.attacker == parent then
        event.target:AddNewModifier(parent, nil, "modifier_treasure_lost_knife_buff", {duration = 10})
    end
end

function modifier_treasure_lost_knife:IsPurgable()
    return false
end
 
function modifier_treasure_lost_knife:RemoveOnDeath()
    return false
end

------------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_lost_knife_buff","treasuresystem/treasure_lua/modifier_treasure_lost_knife", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_lost_knife_buff == nil then 
    modifier_treasure_lost_knife_buff = class({})
end

function modifier_treasure_lost_knife_buff:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_lost_knife_buff:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = 2000,
        damage_type = DAMAGE_TYPE_PURE,
    })
end

function modifier_treasure_lost_knife_buff:IsHidden()
    return true
end