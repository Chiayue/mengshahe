require("items/lua_items_ability/item_ability")

if modifier_item_rune_yinshen == nil then 
    modifier_item_rune_yinshen = class({})
end

function modifier_item_rune_yinshen:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_INVISIBLE]    = false
    }
end

function modifier_item_rune_yinshen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_START ,
    }
    return funcs
end


function modifier_item_rune_yinshen:OnCreated( evt )
    if IsServer( ) then
        local wear = self:GetParent().wear_table
        if wear ~= nil then
            for k,v in pairs(wear) do 
                v:AddEffects((EF_NODRAW))
            end
        end
    end 
end

function modifier_item_rune_yinshen:GetModifierInvisibilityLevel(params)
    return 5
end

function modifier_item_rune_yinshen:OnAbilityStart( evt )
    if evt.caster == self:GetParent() then
		self:Destroy(  )
	end
end

function modifier_item_rune_yinshen:OnAttackLanded( evt)
    if evt.attacker == self:GetParent() then
		self:Destroy(  )
	end
end

function modifier_item_rune_yinshen:OnDestroy()
    if IsServer() then
        local wear = self:GetParent().wear_table
        if wear ~= nil then
            for k,v in pairs(wear) do 
                v:RemoveEffects(EF_NODRAW)
            end
        end
    end
end

function modifier_item_rune_yinshen:GetTexture()
    return "buff/energy6"
end