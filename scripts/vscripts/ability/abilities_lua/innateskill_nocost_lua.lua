
LinkLuaModifier("modifier_nocost_lua","ability/abilities_lua/innateskill_nocost_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
nocost_lua = class({})
function nocost_lua:GetIntrinsicModifierName()
	return "modifier_nocost_lua"
end

if modifier_nocost_lua == nil then
	modifier_nocost_lua = class({})
end


function modifier_nocost_lua:IsHidden()
    return true
end

function modifier_nocost_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_nocost_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_nocost_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_nocost_lua:OnCreated(params)
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
    self.maxmana = 0
    self.caster = self:GetAbility():GetCaster()
    self.listenid = ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(modifier_nocost_lua,'used_ability'),self)
end

function modifier_nocost_lua:used_ability(evt)
	-- print(" >>>>>>>>>>>>>>>>>>>>  used_ability: ")
    -- DeepPrintTable(evt)
    local ability_name = evt.abilityname
    if not RollPercentage(self:GetAbility():GetSpecialValueFor( "chance" )) or
        string.find(ability_name,"item_") or 
        string.find(ability_name,"currier_blink") then
        return
    end
    
    -- 使用技能的地方
    local hero = PlayerResource:GetPlayer(evt.PlayerID):GetAssignedHero()
    if hero==self.caster then
        -- 技能使用者和被动技能持有者是同一人
        -- print(" >>>>>>>>>>>>>>> ability_name: "..ability_name)
        local ability = hero:FindAbilityByName(ability_name)
        hero:GiveMana(ability:GetManaCost(ability:GetLevel()))

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        self:GetCaster():EmitSound("xiyi.tianfu")
    end
end

function modifier_nocost_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    StopListeningToGameEvent(self.listenid)
end