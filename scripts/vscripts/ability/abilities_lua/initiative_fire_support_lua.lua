initiative_fire_support_lua = class({})
initiative_fire_support_lua_d = initiative_fire_support_lua
initiative_fire_support_lua_c = initiative_fire_support_lua
initiative_fire_support_lua_b = initiative_fire_support_lua
initiative_fire_support_lua_a = initiative_fire_support_lua
initiative_fire_support_lua_s = initiative_fire_support_lua

LinkLuaModifier("modifier_initiative_wanjian1_lua","ability/abilities_lua/initiative_fire_support_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_wanjian2_lua","ability/abilities_lua/initiative_fire_support_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_fire_support_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_wanjian1_lua",
		nil, 
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_wanjian1_lua = class({})
function modifier_initiative_wanjian1_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.attr_damage = self:GetAbility():GetSpecialValueFor("attr_damage")
    self.num = self:GetAbility():GetSpecialValueFor("num")
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/unit_greevil/loot_greevil_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlForward( nFXIndex, 1, self:GetCaster():GetOrigin() )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    self:GetCaster():EmitSound("support.flares")--调用音效
    self:StartIntervalThink(1)
end

function modifier_initiative_wanjian1_lua:OnIntervalThink() 
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_wanjian2_lua",
		{damage = self.damage , attr_damage = self.attr_damage, num = self.num}, 
		self:GetCaster():GetOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
    )
    self:StartIntervalThink(-1)
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_wanjian2_lua = class({})

function modifier_initiative_wanjian2_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.count = 0
    self.num = kv.num
    self.damage = kv.damage
    self.attr_damage = kv.attr_damage
    self.enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
    self.damagetable = {                                
        attacker = self:GetCaster(),								 
        damage = self.damage + self:GetCaster():GetAgility() * self.attr_damage,
        damage_type = DAMAGE_TYPE_MAGICAL,				 
    }
    self:StartIntervalThink(0.02)
end

function modifier_initiative_wanjian2_lua:OnIntervalThink() 

    if self.count >= self.num or #self.enemies == 0 then
        self:StartIntervalThink(-1)
        return
    end 

    self.count = self.count + 1
    local target = math.random(1,#self.enemies)
    
    if self.enemies[target]:IsNull() ~= true and self.enemies[target]:IsAlive() == true then
        local index = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.enemies[target])
        ParticleManager:SetParticleControl(index, 0, self.enemies[target]:GetOrigin())
        ParticleManager:SetParticleControl(index, 1, self.enemies[target]:GetOrigin())
        self.damagetable.victim = self.enemies[target], 
        ApplyDamage(self.damagetable)
        -- self:GetCaster():EmitSound("support.arrow")--调用音效
    else 
        table.remove(self.enemies,target)
    end
end