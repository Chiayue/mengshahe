
LinkLuaModifier("modifier_passive_qiaqi_coming_lua","ability/abilities_lua/passive_qiaqi_coming_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_duwu_buff_lua","ability/abilities_lua/passive_qiaqi_coming_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_qiaqi_coming_lua_d = class({})
function passive_qiaqi_coming_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_qiaqi_coming_lua"
end

passive_qiaqi_coming_lua_c = class({})
function passive_qiaqi_coming_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_qiaqi_coming_lua"
end

passive_qiaqi_coming_lua_b = class({})
function passive_qiaqi_coming_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_qiaqi_coming_lua"
end

passive_qiaqi_coming_lua_a = class({})
function passive_qiaqi_coming_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_qiaqi_coming_lua"
end

passive_qiaqi_coming_lua_s = class({})
function passive_qiaqi_coming_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_qiaqi_coming_lua"
end

if modifier_passive_qiaqi_coming_lua == nil then
	modifier_passive_qiaqi_coming_lua = class({})
end

function modifier_passive_qiaqi_coming_lua:IsHidden()
    return true
end

function modifier_passive_qiaqi_coming_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_qiaqi_coming_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_qiaqi_coming_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_qiaqi_coming_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self:GetAbility():UseResources(false, false, true)
end

function modifier_passive_qiaqi_coming_lua:OnAttackLanded(params)
    -- DeepPrintTable(target)
    local percent = 0
    -- local percentvalue = 0
    local target = params.target
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
            return
        end
        if not self:GetAbility():IsCooldownReady() then
            return
        end

        local damage = caster:GetIntellect()*self:GetAbility():GetSpecialValueFor("scale") + self:GetAbility():GetSpecialValueFor("basedamage")
        if not target:HasModifier("modifier_duwu_buff_lua") then
            -- 添加恰奇
            target:AddNewModifier(target, self:GetAbility(), "modifier_duwu_buff_lua", {duration = 999999, space = self:GetAbility():GetSpecialValueFor("space"), damage = damage, attackid = caster:GetPlayerID()})

            self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("cooldown"))
        end
    end
    return
end

if modifier_duwu_buff_lua == nil then
	modifier_duwu_buff_lua = class({})
end

function modifier_duwu_buff_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_duwu_buff_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_duwu_buff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent();
    self.damage = params.damage
    self.space = params.space
    self.attackid = params.attackid
    self.team = self.caster:GetTeamNumber()
    self.attacker = PlayerResource:GetPlayer(self.attackid):GetAssignedHero()
    self:StartIntervalThink(self.space)

    -- local vDirection = self.caster:GetOrigin()
    -- vDirection.z = 0.0
    -- vDirection = vDirection:Normalized()
    -- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
    -- ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
    -- ParticleManager:ReleaseParticleIndex( nFXIndex )
    local nFXIndex = ParticleManager:CreateParticle( "particles/poison/pudge/pudge_swallow.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster ) -- 红鱼转圈
    
    self:AddParticle( nFXIndex, false, false, -1, false, true )
end

function modifier_duwu_buff_lua:OnIntervalThink(params)
    self.lastOrigin = self.caster:GetOrigin()

    local damage = {
        victim = self.caster,
        attacker = self.attacker,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self:GetAbility()
    }
    ApplyDamage( damage )
end

function modifier_duwu_buff_lua:OnDestroy(params)
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(-1)
    if not self.lastOrigin then
        return
    end
    -- 死亡传染给队友
    local targets = FindUnitsInRadius(self.team, self.lastOrigin, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    for i,unit in pairs(targets) do
        if unit~=self.caster then
            if not unit:HasModifier("modifier_duwu_buff_lua") then
                -- 添加恰奇
                unit:AddNewModifier(unit, self:GetAbility(), "modifier_duwu_buff_lua", {duration = 999999, space = self.space, damage = self.damage, attackid = self.attackid})
                return
            end
        end
    end
end