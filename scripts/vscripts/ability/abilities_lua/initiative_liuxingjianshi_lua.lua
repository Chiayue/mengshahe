initiative_liuxingjianshi_lua = class({})
initiative_liuxingjianshi_lua_d = initiative_liuxingjianshi_lua
initiative_liuxingjianshi_lua_c = initiative_liuxingjianshi_lua
initiative_liuxingjianshi_lua_b = initiative_liuxingjianshi_lua
initiative_liuxingjianshi_lua_a = initiative_liuxingjianshi_lua
initiative_liuxingjianshi_lua_s = initiative_liuxingjianshi_lua

LinkLuaModifier("modifier_initiative_liuxingjianshi1_lua","ability/abilities_lua/initiative_liuxingjianshi_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_liuxingjianshi2_lua","ability/abilities_lua/initiative_liuxingjianshi_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_liuxingjianshi_slow_down_lua","ability/abilities_lua/initiative_liuxingjianshi_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_liuxingjianshi_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_liuxingjianshi1_lua",
        {
            duration = 10,
		},  
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_liuxingjianshi1_lua = class({})
function modifier_initiative_liuxingjianshi1_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.attr_damage = self:GetAbility():GetSpecialValueFor("attr_damage")
    self.num = self:GetAbility():GetSpecialValueFor("num")
    self:StartIntervalThink(1)
end

function modifier_initiative_liuxingjianshi1_lua:OnIntervalThink() 
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_liuxingjianshi2_lua",
		{damage = self.damage , attr_damage = self.attr_damage, num = self.num}, 
		self:GetCaster():GetOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
    )
    self:StartIntervalThink(-1)
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_liuxingjianshi2_lua = class({})

function modifier_initiative_liuxingjianshi2_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.count = 0
    self.num = kv.num
    self.damage = kv.damage
    self.attr_damage = kv.attr_damage
    self.enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
    self:StartIntervalThink(0.125)
end

function modifier_initiative_liuxingjianshi2_lua:OnIntervalThink() 

    if self.count >= self.num or #self.enemies == 0 then
        self:StartIntervalThink(-1)
        return
    end 

    self.count = self.count + 1
    local target = math.random(1,#self.enemies)
    
    if self.enemies[target]:IsAlive() == true then
        local index = ParticleManager:CreateParticle( "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_proj_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.enemies[target])
        ParticleManager:SetParticleControl(index, 0, self.enemies[target]:GetOrigin())
        ParticleManager:SetParticleControl(index, 1, self.enemies[target]:GetOrigin())
        local damagetable = {
            victim = self.enemies[target],                                 
            attacker = self:GetCaster(),								 
            damage = self.damage + self:GetCaster():GetStrength() * self.attr_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,				 
        }
        ApplyDamage(damagetable)
        self:GetCaster():EmitSound("support.arrow")--调用音效
        self.enemies[target]:AddNewModifier(self:GetCaster(), self, "modifier_initiative_liuxingjianshi_slow_down_lua", {duration = 3})
    else 
        table.remove(self.enemies,target)
    end
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_liuxingjianshi_slow_down_lua = class({})

function modifier_initiative_liuxingjianshi_slow_down_lua:IsDebuff()
	return true 
end
function modifier_initiative_liuxingjianshi_slow_down_lua:IsHidden()
	return true
end
function modifier_initiative_liuxingjianshi_slow_down_lua:IsPurgable()
	return false
end
function modifier_initiative_liuxingjianshi_slow_down_lua:IsPurgeException()
	return false
end
function modifier_initiative_liuxingjianshi_slow_down_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end
function modifier_initiative_liuxingjianshi_slow_down_lua:OnCreated(kv)
    if not IsServer() then
        return
	end
end
function modifier_initiative_liuxingjianshi_slow_down_lua:GetModifierMoveSpeedBonus_Percentage(params)
	return -40
end