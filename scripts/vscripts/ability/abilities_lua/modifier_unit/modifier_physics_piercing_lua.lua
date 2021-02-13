

if modifier_physics_piercing_lua == nil then 
    modifier_physics_piercing_lua = ({})
end

function modifier_physics_piercing_lua:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_physics_piercing_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:SetStackCount(kv.count)
end

function modifier_physics_piercing_lua:OnAttackStart(event)
    if event.attacker == self:GetParent() then
        if not event.target or event.target:IsNull() then
            -- body
            return
        end
        if event.target:IsAlive() then
            event.target:AddNewModifier(event.attacker, nil, "modifier_physics_piercing_lua_armor", {duration = 3})
        end
    end
end

function modifier_physics_piercing_lua:IsHidden()
    return true
end

function modifier_physics_piercing_lua:IsPurgable()
    return false
end
 
function modifier_physics_piercing_lua:IsPurgable()
    return false
end
 
function modifier_physics_piercing_lua:RemoveOnDeath()
    return false
end

---------------------------------------------------------------------

LinkLuaModifier( "modifier_physics_piercing_lua_armor","ability/abilities_lua/modifier_unit/modifier_physics_piercing_lua", LUA_MODIFIER_MOTION_NONE )

modifier_physics_piercing_lua_armor = class({})

function modifier_physics_piercing_lua_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_physics_piercing_lua_armor:IsHidden()
    return true
end

function modifier_physics_piercing_lua_armor:GetModifierPhysicalArmorBonus()
	return -self:GetCaster():GetModifierStackCount("modifier_physics_piercing_lua", self:GetCaster())
end

function modifier_physics_piercing_lua_armor:GetTexture()
    return "buff/desolator"
end

function modifier_physics_piercing_lua_armor:IsPurgable()
    return false
end