
LinkLuaModifier("modifier_passive_turbulence_magic_lua","ability/abilities_lua/passive_turbulence_magic_lua",LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier("modifier_maxmana_buff_lua","ability/abilities_lua/passive_turbulence_magic_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_turbulence_magic_lua_d = class({})
function passive_turbulence_magic_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_turbulence_magic_lua"
end

passive_turbulence_magic_lua_c = class({})
function passive_turbulence_magic_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_turbulence_magic_lua"
end

passive_turbulence_magic_lua_b = class({})
function passive_turbulence_magic_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_turbulence_magic_lua"
end

passive_turbulence_magic_lua_a = class({})
function passive_turbulence_magic_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_turbulence_magic_lua"
end

passive_turbulence_magic_lua_s = class({})
function passive_turbulence_magic_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_turbulence_magic_lua"
end

if modifier_passive_turbulence_magic_lua == nil then
	modifier_passive_turbulence_magic_lua = class({})
end


function modifier_passive_turbulence_magic_lua:IsHidden()
    return true
end

function modifier_passive_turbulence_magic_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_turbulence_magic_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_turbulence_magic_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_passive_turbulence_magic_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
    self.caster = self:GetAbility():GetCaster()
    self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_passive_turbulence_magic_lua,'used_ability'),self)
end

function modifier_passive_turbulence_magic_lua:used_ability(evt)
	-- print(" >>>>>>>>>>>>>>>>>>>>  used_ability: ")
    -- DeepPrintTable(evt)
    local ability_name = evt.abilityname
    if not string.find(ability_name,"item_") and not string.find(ability_name,"go_back") then
        -- 使用技能的地方
        local hero = PlayerResource:GetPlayer(evt.PlayerID):GetAssignedHero()
        if hero==self.caster then
            -- 技能使用者和被动技能持有者是同一人
            self.count = self:GetAbility():GetSpecialValueFor( "basecount" ) + math.floor(self.caster:GetAgility()/self:GetAbility():GetSpecialValueFor( "unit" ))
            self:StartIntervalThink(1)
        end
    end
end

function modifier_passive_turbulence_magic_lua:OnIntervalThink()
    self:IncrementStackCount();
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( nFXIndex, 0, self.caster:GetOrigin() )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    
    
    self:GetAbility():GetCaster():EmitSound("skill.bom2")

    -- local EffectName_1 = "particles/vr_env/killbanners/vr_killbanner_triplekill_e.vpcf" -- 
	-- local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	-- self:AddParticle(nFXIndex_1, false, false, -1, false, false)
    
    local targets = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    for i,unit in pairs(targets) do

        local damage = {
            victim = unit,
            attacker = self.caster,
            damage = self:GetAbility():GetSpecialValueFor("basedamage") + (self.caster:GetAgility()*self:GetAbility():GetSpecialValueFor("scale")),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
        -- print(">>>>>>>>>>> damage: "..damage.damage);
        ApplyDamage( damage )
    end
    if self.count <= self:GetStackCount() then
        self:SetStackCount(0)
        self:StartIntervalThink(-1)
    end
end
function modifier_passive_turbulence_magic_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    StopListeningToGameEvent(self.listenid)
end

-- if modifier_maxmana_buff_lua == nil then
-- 	modifier_maxmana_buff_lua = class({})
-- end

-- function modifier_maxmana_buff_lua:IsHidden()
--     return true
-- end

-- function modifier_maxmana_buff_lua:IsPurgable()
--     return false -- 无法驱散
-- end
 
-- function modifier_maxmana_buff_lua:RemoveOnDeath()
--     return false -- 死亡不移除
-- end

-- function modifier_maxmana_buff_lua:DeclareFunctions()
--     local funcs = {
--         MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
--     }
--     return funcs
-- end

-- function modifier_maxmana_buff_lua:OnCreated(params)
--     if not IsServer( ) then
--         return
--     end
--     -- self.percent = {}
--     self.maxmana = params.maxmana
--     -- table.insert(self.percent, params.percent)
-- end

-- function modifier_maxmana_buff_lua:OnRefresh(params)
--     if not IsServer( ) then
--         return
--     end
--     self.maxmana = params.maxmana
-- end

-- function modifier_maxmana_buff_lua:GetModifierExtraManaBonus()
--     if not IsServer( ) then
--         return
--     end
--     return self.maxmana
-- end