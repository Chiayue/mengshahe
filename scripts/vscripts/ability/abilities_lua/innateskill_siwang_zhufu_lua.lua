LinkLuaModifier( "modifier_siwang_zhufu_lua","ability/abilities_lua/innateskill_siwang_zhufu_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

siwang_zhufu_lua = class({})

-- function siwang_zhufu_lua:GetAOERadius()
-- 	return 1100
-- end

--------------------------------------------------------------------------------

function siwang_zhufu_lua:OnSpellStart()
	self.target_unit = self:GetCursorTarget()
	if self.target_unit == self:GetCaster() then
		send_error_tip(self:GetCaster():GetPlayerID(), "error_targetnoself")
		self:EndCooldown()
		return
	end
	self.time = self:GetSpecialValueFor( "time" )
	local kv = {duration = self.time, attackID = self:GetCaster():GetPlayerID()}
	
	self.target_unit:AddNewModifier(self.target_unit, self, "modifier_siwang_zhufu_lua", kv)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster, self, "modifier_big_jump_lua", {time = self.time-0.5, x = self:GetCursorPosition().x, y = self:GetCursorPosition().y, z = self:GetCursorPosition().z})
end

-- function siwang_zhufu_lua:GetIntrinsicModifierName()
-- 	return "modifier_siwang_zhufu_lua"
-- end

--------------------------------------------------------------------------------

if modifier_siwang_zhufu_lua == nil then
	modifier_siwang_zhufu_lua = class({})
end


function modifier_siwang_zhufu_lua:IsHidden()
    return true
end

function modifier_siwang_zhufu_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_siwang_zhufu_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_siwang_zhufu_lua:OnCreated( kv )
    if not IsServer() then
        return
	end
	self.attackID = kv.attackID
	-- 创建头顶特效
	self.index = ParticleManager:CreateParticle( "particles/diy_particles/skeleton.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
	-- local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/ambient13.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 红鱼转圈
	self:AddParticle( self.index, false, false, -1, false, true )
	ParticleManager:SetParticleControl(self.index, 0, Vector(0, 0, 50))
end

function modifier_siwang_zhufu_lua:OnDeath(params)
	if not IsServer() then
        return
	end
	if params.unit == self:GetParent() and params.unit:IsHero() then
        -- 判断死亡对象是否是自己,是否是英雄
		local selfID = params.unit:GetPlayerID()
		local selflevel = params.unit:GetLevel()
		for i = 0, global_var_func.all_player_amount - 1 do
			if selfID ~= i then
				if self.attackID==i then
					local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
					game_playerinfo:set_player_gold(i, selflevel*2000)

					SetBaseStrength(hero, selflevel*2)
					SetBaseAgility(hero, selflevel*2)
					SetBaseIntellect(hero, selflevel*2)
				else
					local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
					game_playerinfo:set_player_gold(i, selflevel*1000)
					
					SetBaseStrength(hero, selflevel*1)
					SetBaseAgility(hero, selflevel*1)
					SetBaseIntellect(hero, selflevel*1)
				end
			end

		end
		ParticleManager:DestroyParticle(self.index, true)
		ParticleManager:ReleaseParticleIndex(self.index)
    end
end