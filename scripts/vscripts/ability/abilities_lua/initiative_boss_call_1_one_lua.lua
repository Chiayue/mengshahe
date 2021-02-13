--挑战boss 蓄势一击
initiative_boss_call_1_one_lua = class({})
LinkLuaModifier("modifier_boss_call_1_one_prompt_lua","ability/abilities_lua/initiative_boss_call_1_one_lua",LUA_MODIFIER_MOTION_NONE)
function initiative_boss_call_1_one_lua:GetAOERadius()
    return 300
end
function initiative_boss_call_1_one_lua:OnSpellStart()
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_ATTACK)
    self.vPos = nil
	if self:GetCursorTarget() then
		self.vPos = self:GetCursorTarget():GetOrigin()
	else
		self.vPos = self:GetCursorPosition()
    end
    self.prompt = CreateModifierThinker(
		caster,
		self,
		"modifier_boss_call_1_one_prompt_lua",
        {
            duration = 1,
		}, 
		self.vPos,
		caster:GetTeamNumber(),
		false
    ) 
   Timers:CreateTimer(1,function ()
        caster:EmitSound("hero.attack.npc_dota_hero_bane")
        self.nFXIndexs = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", 
            PATTACH_CUSTOMORIGIN, 
            nil
        )
        ParticleManager:SetParticleControl(self.nFXIndexs, 0, self.vPos)
        local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeam(), 
            self.vPos, 
            nil, 
            300, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
            FIND_ANY_ORDER, 
            false
        )
        if #enemies > 0 then
            for a,enemy in pairs(enemies) do
                if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
                    local damageTable = {
                        victim  =  enemy,--
                        attacker = caster,
                        damage = 1000,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self,
                    }
                    ApplyDamage(damageTable)
                end
            end
        end         
   end)


end
modifier_boss_call_1_one_prompt_lua = class({})

function modifier_boss_call_1_one_prompt_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.nFXIndex = ParticleManager:CreateParticle(
                "particles/diy_particles/playercolorsmall.vpcf", 
                PATTACH_CUSTOMORIGIN, 
                nil
            )
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetAbility().vPos)
    self:AddParticle(self.nFXIndex, false, false, 15, false, false)
end

function modifier_boss_call_1_one_prompt_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end