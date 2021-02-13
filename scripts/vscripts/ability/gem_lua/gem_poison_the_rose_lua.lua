gem_poison_the_rose_lua = class({})
LinkLuaModifier("modifier_poison_the_rose","ability/gem_lua/gem_poison_the_rose_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_poison_the_rose_lua:GetIntrinsicModifierName()
	return "modifier_poison_the_rose"
end

if modifier_poison_the_rose == nil then
	modifier_poison_the_rose = class({})
end

function modifier_poison_the_rose:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_poison_the_rose:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_poison_the_rose:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_RESPAWN,
    }
    return funcs
end

function modifier_poison_the_rose:OnCreated(kv)
    -- self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
    -- print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
    if not IsServer( ) then
        return
    end
    -- self:StartIntervalThink( 0.01 )
    local hTarget = self:GetAbility():GetCaster()
    -- local attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    -- print(">>>>>>>>>>> speed OnCreated: "..attack_speed)
    -- 增加攻速BUFF
    hTarget:AddNewModifier( 
        hTarget, 
        self:GetAbility(), 
        "modifier_attack_speed_lua", 
        { duration = 9999999 } 
    )

    -- 增加吸血量
    hTarget:AddNewModifier( 
        hTarget, 
        self:GetAbility(), 
        "modifier_heath_hp_lua", 
        { duration = 9999999 } 
    )
end

-- function modifier_poison_the_rose:OnIntervalThink()
--     self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
--     print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
--     self:StartIntervalThink( -1 )
-- end

function modifier_poison_the_rose:OnRespawn(params)
    if not IsServer( ) then
        return
    end
    -- if params.unit == self:GetParent() then
    --     -- 判断重生对象是否是自己
    --     -- local hTarget = params.target
    --     -- local kv = {}
    --     -- 增加攻速BUFF
    --     params.unit:AddNewModifier( 
    --         self:GetAbility():GetCaster(), 
    --         self:GetAbility(), 
    --         "modifier_attack_speed_lua", 
    --         { duration = 9999999 } 
    --     )

    --     -- 增加吸血量
    --     params.unit:AddNewModifier( 
    --         self:GetAbility():GetCaster(), 
    --         self:GetAbility(), 
    --         "modifier_heath_hp_lua", 
    --         { duration = 9999999 } 
    --     )
    --     -- CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_xinsheng_qiangzhuang_buff_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
    -- end
end

function modifier_poison_the_rose:OnAttack( params )
    -- DeepPrintTable(evt)
    -- local attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    -- print(">>>>>>>>>>> speed OnRespawn: "..attack_speed)
    if params then
        local damage_hp = self:GetAbility():GetSpecialValueFor( "damage_hp" ) or 0
        if damage_hp~=0 then
            local caster = params.attacker -- 这是一个实体
            if caster == self:GetParent() then
                local hp = caster:GetMaxHealth() * damage_hp
                -- 攻击扣血
                local damage = {
                    victim = self:GetParent(),
                    attacker = self:GetParent(),
                    damage = hp,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility()
                }
                -- print(">>>>>>>>>>> damage: "..damage.damage);
                ApplyDamage( damage )
            end
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
