initiative_cross_lua = class({})
initiative_cross_lua_d = initiative_cross_lua
initiative_cross_lua_c = initiative_cross_lua
initiative_cross_lua_b = initiative_cross_lua
initiative_cross_lua_a = initiative_cross_lua
initiative_cross_lua_s = initiative_cross_lua

LinkLuaModifier("modifier_initiative_cross_lua_d","ability/abilities_lua/initiative_cross_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_cross_lua_c","ability/abilities_lua/initiative_cross_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_cross_lua_b","ability/abilities_lua/initiative_cross_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_cross_lua_a","ability/abilities_lua/initiative_cross_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_cross_lua_s","ability/abilities_lua/initiative_cross_lua",LUA_MODIFIER_MOTION_NONE)

function initiative_cross_lua:OnSpellStart()

	self.width_initial = 100
	self.width_end = 100
	self.speed = self:GetSpecialValueFor("speed")
	self.distance = self:GetSpecialValueFor("distance")
	self.damage = {
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetAgility()*self:GetSpecialValueFor("attr_damage"),	
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
--目标与英雄的直线方向找5个技能交叉点坐标的距离
	local center_distance = {0,200,400,600,800}
--英雄左右两边的找10个技能发射点坐标的距离
	local orso_distance = {100,200,300,400,500}

	local a = self:GetCursorPosition()
	local b = self:GetCaster():GetOrigin()
	local length = 0
	local c1 = self:GetCaster():GetOrigin()
	local c2 = self:GetCaster():GetOrigin()
---英雄左右两边的技能发射点同距离为一组循环5次
	for i=1,5 do 
		local offset = self:GetCursorPosition()
--根据英雄面朝方向确定交叉点的坐标
		if a.x-b.x < 0 then
			offset.x = a.x-center_distance[i]*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
			offset.y = a.y-center_distance[i]*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
		else
			offset.x = a.x+center_distance[i]*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
			offset.y = a.y+center_distance[i]*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
		end 
--根据交叉点坐标确定英雄左右两边的技能发射坐标	
		length = orso_distance[i]
		c1.x = b.x+(length*(offset.y-b.y)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c1.y = b.y-(length*(offset.x-b.x)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c2.x = b.x-(length*(offset.y-b.y)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c2.y = b.y+(length*(offset.x-b.x)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
--技能发射反向
		local vDirection1 = offset - c1	
		vDirection1.z = 0.0
		vDirection1 = vDirection1:Normalized()
		local vDirection2 = offset - c2	
		vDirection2.z = 0.0
		vDirection2 = vDirection2:Normalized()	
		self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )
--释放技能特效
		local info1 = {
			EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
			Ability = self,
			vSpawnOrigin = c1, 
			fStartRadius = self.width_initial,
			fEndRadius = self.width_end,
			vVelocity = vDirection1 * self.speed,
			fDistance = self.distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}
		ProjectileManager:CreateLinearProjectile( info1 )	
		local info2 = {
			EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
			Ability = self,
			vSpawnOrigin = c2, 
			fStartRadius = self.width_initial,
			fEndRadius = self.width_end,
			vVelocity = vDirection2 * self.speed,
			fDistance = self.distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}
		ProjectileManager:CreateLinearProjectile( info2 )
	end 

	self:GetCaster():EmitSound("cross.bolt")--调用音效
end

function initiative_cross_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		self.damage.victim = hTarget,
		ApplyDamage( self.damage )

		if self:GetAbilityName() == "initiative_cross_lua_d" then
			if hTarget:HasModifier("modifier_initiative_cross_lua_d") and hTarget:IsAlive() then
				ApplyDamage( self.damage )
			else
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_initiative_cross_lua_d", {duration = 1,reduction = self:GetSpecialValueFor("reduction")})--调用修饰器
			end
		elseif self:GetAbilityName() == "initiative_cross_lua_c" then
			if hTarget:HasModifier("modifier_initiative_cross_lua_c") and hTarget:IsAlive() then
				ApplyDamage( self.damage )
			else
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_initiative_cross_lua_c", {duration = 1,reduction = self:GetSpecialValueFor("reduction")})--调用修饰器
			end
		elseif self:GetAbilityName() == "initiative_cross_lua_b" then
			if hTarget:HasModifier("modifier_initiative_cross_lua_b") and hTarget:IsAlive() then
				ApplyDamage( self.damage )
			else
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_initiative_cross_lua_b", {duration = 1,reduction = self:GetSpecialValueFor("reduction")})--调用修饰器
			end
		elseif self:GetAbilityName() == "initiative_cross_lua_a" then
			if hTarget:HasModifier("modifier_initiative_cross_lua_a") and hTarget:IsAlive() then
				ApplyDamage( self.damage )
			else
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_initiative_cross_lua_a", {duration = 1,reduction = self:GetSpecialValueFor("reduction")})--调用修饰器
			end
		elseif self:GetAbilityName() == "initiative_cross_lua_s" then
			if hTarget:HasModifier("modifier_initiative_cross_lua_s") and hTarget:IsAlive() then
				ApplyDamage( self.damage )
			else
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_initiative_cross_lua_s", {duration = 1,reduction = self:GetSpecialValueFor("reduction")})--调用修饰器
			end
		end 
 	end
end


if modifier_initiative_cross_lua == nil then
    modifier_initiative_cross_lua = class({})
    modifier_initiative_cross_lua_d = modifier_initiative_cross_lua
    modifier_initiative_cross_lua_c = modifier_initiative_cross_lua
    modifier_initiative_cross_lua_b = modifier_initiative_cross_lua
    modifier_initiative_cross_lua_a = modifier_initiative_cross_lua
    modifier_initiative_cross_lua_s = modifier_initiative_cross_lua
end

function modifier_initiative_cross_lua:IsDebuff()
	return false 
end
function modifier_initiative_cross_lua:IsHidden()
	return true
end
function modifier_initiative_cross_lua:IsPurgable()
	return false
end
function modifier_initiative_cross_lua:IsPurgeException()
	return false
end
function modifier_initiative_cross_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end
function modifier_initiative_cross_lua:OnCreated(kv)
    if not IsServer() then
        return
	end
	self.reduction = kv.reduction
end
function modifier_initiative_cross_lua:GetModifierMoveSpeedBonus_Percentage(params)
	return self.reduction
end