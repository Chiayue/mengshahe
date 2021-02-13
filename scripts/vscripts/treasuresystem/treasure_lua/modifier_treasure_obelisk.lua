-- 宝物: 欧贝里斯克

LinkLuaModifier( "modifier_treasure_obelisk_aura","treasuresystem/treasure_lua/modifier_treasure_obelisk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_obelisk_fight","treasuresystem/treasure_lua/modifier_treasure_obelisk", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_obelisk == nil then 
    modifier_treasure_obelisk = class({})
end

function modifier_treasure_obelisk:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_obelisk"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_obelisk:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_obelisk:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_obelisk:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
    }
end

function modifier_treasure_obelisk:OnModifierAdded()
    local parent = self:GetParent()
    if parent:FindModifierByName("modifier_treasure_obelisk_1") and parent:FindModifierByName("modifier_treasure_obelisk_2") and parent:FindModifierByName("modifier_treasure_obelisk_3") and not parent:FindModifierByName("modifier_treasure_obelisk_aura") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_obelisk_aura", nil)
    end
end

-- function modifier_treasure_obelisk:OnCreated(params)
--     if not IsServer() then
--         return
--     end
--     self.caster = self:GetCaster()
    
--     if self.caster:FindModifierByName("modifier_treasure_obelisk_1") and 
--     self.caster:FindModifierByName("modifier_treasure_obelisk_2") and 
--     self.caster:FindModifierByName("modifier_treasure_obelisk_3") then
--         self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_obelisk_aura", {})
--     end
-- end

modifier_treasure_obelisk_aura = class({})

--------------------------------------------------------------------------------

function modifier_treasure_obelisk_aura:DeclareFunctions()
    local funcs = {
		
    }
    return funcs
end

function modifier_treasure_obelisk_aura:IsHidden()
    return true
end

function modifier_treasure_obelisk_aura:IsAura()
    return true
end

function modifier_treasure_obelisk_aura:IsAuraActiveOnDeath()
    return true
end

function modifier_treasure_obelisk_aura:GetAuraRadius()
    return 9000
end

function modifier_treasure_obelisk_aura:GetModifierAura()
    return "modifier_treasure_obelisk_fight"
end

function modifier_treasure_obelisk_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_treasure_obelisk_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_treasure_obelisk_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_treasure_obelisk_aura:OnCreated( kv )
    if not IsServer() then
        return
    end
end


modifier_treasure_obelisk_fight = class({})
--------------------------------------------------------------------------------

function modifier_treasure_obelisk_fight:IsHidden()
    return true
end

function modifier_treasure_obelisk_fight:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_treasure_obelisk_fight:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end


function modifier_treasure_obelisk_fight:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent();
    self.attack = self:GetCaster();
end

function modifier_treasure_obelisk_fight:OnTakeDamage(keys)
    if keys.unit ~= self.caster then
		return
    end
    if keys.attacker ~= self.attack then
		return
    end
    if keys.inflictor then
        -- 有技能对象则是受到技能伤害,没有就是普攻伤害
        if RollPercentage(10) then
            self.caster:Kill(nil, self.attack)
        end
    end
end