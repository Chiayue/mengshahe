initiative_lichang_lua = class({})
initiative_lichang_lua_d = initiative_lichang_lua
initiative_lichang_lua_c = initiative_lichang_lua
initiative_lichang_lua_b = initiative_lichang_lua
initiative_lichang_lua_a = initiative_lichang_lua
initiative_lichang_lua_s = initiative_lichang_lua

LinkLuaModifier("modifier_initiative_lichang_lua","ability/abilities_lua/initiative_lichang_lua",LUA_MODIFIER_MOTION_NONE)

--范围
function initiative_lichang_lua:GetAOERadius()
	return 700
end
--开始施法
function initiative_lichang_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_lichang_lua",
		{
            duration = 10,
		}, 
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
end

----------------------------------------------------------------------------------------------------------------
modifier_initiative_lichang_lua = class({})

function modifier_initiative_lichang_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    local num = 0
    self.ability = self:GetAbility()
    self.cursor_position = self.ability:GetCursorPosition()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.attr_damage = self.ability:GetSpecialValueFor("attr_damage")
    self.damagetable = {                               
        attacker = self:GetCaster(),								 
        damage = self.damage+self:GetCaster():GetIntellect()*self.attr_damage,						 
        damage_type = DAMAGE_TYPE_MAGICAL,				 
    }
    Timers:CreateTimer(0.1, function()
        if num < 5 then
            local nFXIndex = ParticleManager:CreateParticle(
                "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_immortal_doppelganger_aoe.vpcf", 
                PATTACH_CUSTOMORIGIN, 
                nil
            )
            ParticleManager:SetParticleControl(nFXIndex, 0, self.cursor_position)
            self:AddParticle(nFXIndex, false, false, 15, false, false)
            self.enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self.cursor_position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
            for i=1,#self.enemies do 
                local center_positon = RotatePosition(self.cursor_position,QAngle(90, 180, 0),self.enemies[i]:GetOrigin()) 
                local knockbackModifierTable =
                {
                should_stun = 0.5,
                knockback_duration = 0.5,
                duration = 0.5,
                knockback_distance = -300,
                knockback_height = 100,
                center_x = center_positon.x,
                center_y = center_positon.y,
                center_z = center_positon.z
                }
                -- 敌人击飞   系统自带的击飞 modifier 
                self.enemies[i]:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackModifierTable )
            end
            self:StartIntervalThink(0.5)
            self:GetCaster():EmitSound("game.go_back")--调用音效
            num = num + 1
            return 0.7
        else
            return nil
        end
    end)
end

function modifier_initiative_lichang_lua:OnIntervalThink()  
    for i=1,#self.enemies do 
        self.damagetable.victim = self.enemies[i],
        ApplyDamage(self.damagetable) --对单位造成伤害，传入列表参数
    end
    self:StartIntervalThink(-1)
end