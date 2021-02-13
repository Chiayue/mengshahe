initiative_poison_circle_lua = class({})
initiative_poison_circle_lua_d = initiative_poison_circle_lua
initiative_poison_circle_lua_c = initiative_poison_circle_lua
initiative_poison_circle_lua_b = initiative_poison_circle_lua
initiative_poison_circle_lua_a = initiative_poison_circle_lua
initiative_poison_circle_lua_s = initiative_poison_circle_lua

LinkLuaModifier("modifier_poison_circle_lua_continuous_damage","ability/abilities_lua/initiative_poison_circle_lua.lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_poison_circle_lua:OnSpellStart()
        local caster = self:GetCaster()
        local target = self:GetCursorTarget()
        local location = self:GetCursorPosition()
        EmitSoundOn("hero.attack.npc_dota_hero_luna", caster)
        if target ~= nil and not target:IsMagicImmune() and not target:IsInvulnerable() then
                local target = target
                local caster = self:GetCaster()
                local enemies = FindUnitsInRadius(caster:GetTeamNumber(),target:GetOrigin(),self,450,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,1,false)
                if(#enemies > 0) then
                        for a,enemy in pairs(enemies) do
                                if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                                        local info = {
                                                EffectName = "particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch.vpcf",
                                                Ability = self,
                                                iMoveSpeed = 900,
                                                Source = caster,
                                                Target = enemy,
                                                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_HITLOCATION,
                                        }
                                        ProjectileManager:CreateTrackingProjectile(info)
                                end
                        end
                end
        end
end
--命中目标
function initiative_poison_circle_lua:OnProjectileHit(hTarget, vLocation)
    --body
        if hTarget ~= nil and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
                local target = hTarget
                local caster = self:GetCaster()
                local enemies = FindUnitsInRadius(caster:GetTeamNumber(),target:GetOrigin(),self,450,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,1,false)
                if(#enemies > 0) then
                        for a,enemy in pairs(enemies) do
                                if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                                        --添加修饰器
                                        enemy:AddNewModifier(caster,self, "modifier_poison_circle_lua_continuous_damage", {duration = 2})
                                end
                        end
                end
        end
end
-----------------------------------------------
--修饰器
modifier_poison_circle_lua_continuous_damage = class({})

function modifier_poison_circle_lua_continuous_damage:OnCreated()
        local scale = self:GetAbility():GetSpecialValueFor("scale")
        self.damage = self:GetAbility():GetSpecialValueFor("continuous_damage")+self:GetCaster():GetStrength()*scale
        if not IsServer() then
                return
	end
        --设置计时器
        self:StartIntervalThink(1)
        --启动计时器
        self:OnIntervalThink()
end
--伤害
function modifier_poison_circle_lua_continuous_damage:OnIntervalThink()
        local damageTable = {
            victim  =  self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility(),
        }
        if(damageTable.damage_type ~= nil) then
            ApplyDamage(damageTable)
        end
end

function modifier_poison_circle_lua_continuous_damage:IsDebuff()
        return true
end
function modifier_poison_circle_lua_continuous_damage:IsStunDebuff()
        return true
end

function modifier_poison_circle_lua_continuous_damage:CheckState()
        local state = {
            [MODIFIER_STATE_STUNNED] = true,
        }
        return state
end
function modifier_poison_circle_lua_continuous_damage:DeclareFunctions()
        local funcs = {
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION,--替换动画声明事件
        }
        return funcs
end
--加特效
function modifier_poison_circle_lua_continuous_damage:GetEffectName()
        return "particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_parent.vpcf"
end
function modifier_poison_circle_lua_continuous_damage:StatusEffectPriority() return 3 end
--替换动画
function modifier_poison_circle_lua_continuous_damage:GetOverrideAnimation(params)
        return ACT_DOTA_DISABLED
end
--------------------------------------------
