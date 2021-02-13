

LinkLuaModifier( "modifier_space_broken_lua","ability/abilities_lua/initiative_space_broken_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_limit_speed_lua","ability/abilities_lua/initiative_space_broken_lua", LUA_MODIFIER_MOTION_NONE )
--空间破碎
initiative_space_broken_lua = class({})
initiative_space_broken_lua_d = initiative_space_broken_lua
initiative_space_broken_lua_c = initiative_space_broken_lua
initiative_space_broken_lua_b = initiative_space_broken_lua
initiative_space_broken_lua_a = initiative_space_broken_lua
initiative_space_broken_lua_s = initiative_space_broken_lua
--开始施法

function initiative_space_broken_lua:GetAOERadius()
	return 500
end
function initiative_space_broken_lua:OnSpellStart()
    local caster = self:GetCaster()
    CreateModifierThinker(
		self:GetCaster(), 
		self, 
		"modifier_space_broken_lua", 
		{
			duration = 5
		}, 
		self:GetCaster():GetOrigin(), 
		self:GetCaster():GetTeamNumber(), 
		false
    )
    EmitSoundOn( "bh", self:GetCaster() )
    self.index = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN,  caster)
    ParticleManager:SetParticleControl(self.index,01,Vector(425,425,0))
end
--buff
modifier_space_broken_lua = class({})

function modifier_space_broken_lua:IsHidden()
    return true
end
function modifier_space_broken_lua:OnCreated(kv)
    if not IsServer( ) then
        return
    end
    local caster = self:GetAbility():GetCaster()
    self.damage = self:GetAbility():GetSpecialValueFor("base_damage") + self:GetCaster():GetIntellect()* self:GetAbility():GetSpecialValueFor("int_scale")
    self.limitEnemys = {}
    self.count = 5
    self.coutt3 = 0
	--设置计时器时间
    self:StartIntervalThink(0.1)

end


function modifier_space_broken_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    self.coutt3 = self.coutt3 + 0.1
    self.count = self.count - 0.1
    if self.count  <= 0.1 then
        return
    end
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetOrigin(),
        self:GetAbility(),
        500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
        1,
        false
    )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) and ( not enemy:HasModifier("modifier_limit_speed_lua")) then
                enemy:AddNewModifier(caster,self:GetAbility(), "modifier_limit_speed_lua", {})
                self.limitEnemys[#self.limitEnemys + 1] = enemy
    
            end
        end
    end 
    if math.floor(self.coutt3/0.3) == 1 then
        self.coutt3 = 0
        if #enemies > 0 then
            for _,enemy in pairs(enemies) do
                if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() )  then
                    local damage = {
                        victim = enemy,
                        attacker = self:GetCaster(),
                        damage = self.damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility()
                    }
                    ApplyDamage( damage )
                end
            end
        end
    end 

end
function modifier_space_broken_lua:OnDestroy()
    if self:GetAbility().index ~=nil then
        ParticleManager:DestroyParticle(self:GetAbility().index, false)
        ParticleManager:ReleaseParticleIndex(self:GetAbility().index)
        for _,limitEnemy in pairs(self.limitEnemys) do
            limitEnemy:RemoveModifierByName("modifier_limit_speed_lua")    
        end
        self:GetParent():RemoveModifierByName("modifier_space_broken_lua")
    end

    UTIL_Remove( self:GetParent() )
end


--停止移动修饰器
modifier_limit_speed_lua = class({})

function modifier_limit_speed_lua:IsHidden()
    return true
end

function modifier_limit_speed_lua:IsStunDebuff()
        return true
end

function modifier_limit_speed_lua:CheckState()
        local state = {
            [MODIFIER_STATE_STUNNED] = true,
        }
        return state
end

function modifier_limit_speed_lua:DeclareFunctions()
        local funcs = {
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION,--替换动画声明事件
        }
        return funcs
end

--替换动画
function modifier_limit_speed_lua:GetOverrideAnimation(params)
        return ACT_DOTA_DISABLED
end