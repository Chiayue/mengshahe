LinkLuaModifier("modifier_boss_god_earth_avalanche", "ability/boss_ability/boss_god_earth_avalanche", LUA_MODIFIER_MOTION_NONE)

boss_god_earth_avalanche = class({})

function boss_god_earth_avalanche: OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()

        self.nChannelFX = ParticleManager:CreateParticle(
            "particles/act_2/storegga_channel.vpcf",
            PATTACH_WORLDORIGIN,
            nil
        )

        ParticleManager:SetParticleControl(
            self.nChannelFX, 
            0, 
            self.caster:GetOrigin() + self.caster:GetForwardVector() * 500
        )

        self:SetContextThink(DoUniqueString("stop_think"), function ()
            if not self:IsChanneling() then
                return nil
            end
            EmitSoundOn("storegga.avalanche", self.caster)
            return 1.2
        end, 0)

        self.hThinker = CreateModifierThinker(
            self:GetCaster(), 
            self, 
            "modifier_boss_god_earth_avalanche", 
            {
                duration = self:GetChannelTime()
            }, 
            self:GetCaster():GetOrigin(), 
            self:GetCaster():GetTeamNumber(), 
            false
        )
    end
end

function boss_god_earth_avalanche: OnChannelFinish(interrupted)
	if IsServer() then
        ParticleManager:DestroyParticle(self.nChannelFX, false)
        ParticleManager:ReleaseParticleIndex(self.nChannelFX)
        if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
        end
    end
end

------------------------------------------------------------------------------------

modifier_boss_god_earth_avalanche = class({})

function modifier_boss_god_earth_avalanche:IsHidden()
	return true
end

function modifier_boss_god_earth_avalanche:IsPurgable()
	return false
end

function modifier_boss_god_earth_avalanche:OnCreated(kv)
    if IsServer() then
		self.Avalanches = {}
        self:StartIntervalThink(0.5)
	end
end

function modifier_boss_god_earth_avalanche:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
        end

        for _, hero in pairs(HeroList:GetAllHeroes()) do
            if hero:IsAlive() then
                self.dir = (hero:GetOrigin() - self:GetCaster():GetOrigin()):Normalized() * 2
                local nFXIndex1 = ParticleManager:CreateParticle( 
                    "particles/creatures/storegga/storegga_avalanche.vpcf", 
                    PATTACH_CUSTOMORIGIN, 
                    nil 
                )
                ParticleManager:SetParticleControl(nFXIndex1, 0, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 500)
                ParticleManager:SetParticleControl(nFXIndex1, 1, Vector(250, 250, 250))
                ParticleManager:SetParticleControlForward(nFXIndex1, 0, self.dir)
                self:AddParticle( nFXIndex1, false, false, -1, false, false )
        
                table.insert(self.Avalanches, {
                    vCurPos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 500,
                    vDir = self.dir,
                    nFX = nFXIndex1,
                })

                self.dir = (self:GetCaster():GetOrigin() - hero:GetOrigin()):Normalized() * 2
                local nFXIndex2 = ParticleManager:CreateParticle( 
                    "particles/creatures/storegga/storegga_avalanche.vpcf", 
                    PATTACH_CUSTOMORIGIN, 
                    nil 
                )
                ParticleManager:SetParticleControl(nFXIndex2, 0, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 500)
                ParticleManager:SetParticleControl(nFXIndex2, 1, Vector(250, 250, 250))
                ParticleManager:SetParticleControlForward(nFXIndex2, 0, self.dir)
                self:AddParticle( nFXIndex2, false, false, -1, false, false )
        
                table.insert(self.Avalanches, {
                    vCurPos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 500,
                    vDir = self.dir,
                    nFX = nFXIndex2,
                })
            end
        end

		for _,ava in pairs (self.Avalanches) do
			local vNewPos = ava.vCurPos + ava.vDir * 250
			vNewPos.z = GetGroundHeight(vNewPos, self:GetCaster())
			ava.vCurPos = vNewPos
			ParticleManager:SetParticleControl(ava.nFX, 0, vNewPos)

			local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(), 
                vNewPos, 
                nil, 
                250, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO, 
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
                FIND_ANY_ORDER, 
                false 
            )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
					ApplyDamage({
						victim = enemy,
						attacker = self:GetCaster(),
						damage = enemy:GetMaxHealth() * 0.2,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					})
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_common_stun", { duration = 0.2 })
				end
			end
		end
	end
end
