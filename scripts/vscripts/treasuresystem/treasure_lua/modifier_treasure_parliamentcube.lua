-- 宝物: 评议团魔方

LinkLuaModifier( "modifier_treasure_parliamentcube_attack","treasuresystem/treasure_lua/modifier_treasure_parliamentcube", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_parliamentcube_armor","treasuresystem/treasure_lua/modifier_treasure_parliamentcube", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_parliamentcube == nil then 
    modifier_treasure_parliamentcube = class({})
end

function modifier_treasure_parliamentcube:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_parliamentcube"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_parliamentcube:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_parliamentcube:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_parliamentcube:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_parliamentcube:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.current_round = global_var_func.current_round
    self.caster = self:GetCaster()
    self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_parliamentcube_attack", {})
    self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_parliamentcube_armor", {})
end

function modifier_treasure_parliamentcube:OnIntervalThink()
    if self.current_round < global_var_func.current_round then
        -- 不是当前轮数
        self.current_round = global_var_func.current_round
        if RollPercentage(70) then
            local attackmodifier = self.caster:FindModifierByName("modifier_treasure_parliamentcube_attack")
            if attackmodifier then
                attackmodifier:SetStackCount(attackmodifier:GetStackCount() + RandomInt(100, 500))
            end
        end
        if RollPercentage(70) then
            local armormodifier = self.caster:FindModifierByName("modifier_treasure_parliamentcube_armor")
            if armormodifier then
                armormodifier:SetStackCount(armormodifier:GetStackCount() + RandomInt(1, 3))
            end
        end
    end
end

------------------------------
if modifier_treasure_parliamentcube_attack == nil then 
    modifier_treasure_parliamentcube_attack = class({})
end

function modifier_treasure_parliamentcube_attack:GetTexture()
    return "buff/xuanyun"
end

function modifier_treasure_parliamentcube_attack:IsHidden()
    return true -- 隐藏
end

function modifier_treasure_parliamentcube_attack:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_parliamentcube_attack:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_parliamentcube_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_treasure_parliamentcube_attack:OnCreated(params)
    if not IsServer() then
        return
    end
end

function modifier_treasure_parliamentcube_attack:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end


------------------------------
if modifier_treasure_parliamentcube_armor == nil then 
    modifier_treasure_parliamentcube_armor = class({})
end

function modifier_treasure_parliamentcube_armor:GetTexture()
    return "buff/xuanyun"
end

function modifier_treasure_parliamentcube_armor:IsHidden()
    return true -- 隐藏
end

function modifier_treasure_parliamentcube_armor:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_parliamentcube_armor:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_parliamentcube_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_treasure_parliamentcube_armor:OnCreated(params)
    if not IsServer() then
        return
    end
end

function modifier_treasure_parliamentcube_armor:GetModifierPhysicalArmorBonus()
    return self:GetStackCount()
end