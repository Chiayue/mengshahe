kaiban_gongsi_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_kaiban_gongsi_lua","ability/abilities_lua/innateskill_kaiban_gongsi_lua", LUA_MODIFIER_MOTION_NONE )

function kaiban_gongsi_lua:OnSpellStart()
    local playerID = self:GetCaster():GetPlayerID()
    local hero = self:GetCaster()
    local maxnumber = self:GetSpecialValueFor("maxnumber")
    local spacetime = self:GetSpecialValueFor("spacetime")
    local health = self:GetSpecialValueFor("health")
    local golden = self:GetSpecialValueFor("golden")
    if #build_record >= maxnumber then
        send_error_tip(playerID, "error_buildLimit")
        self:EndCooldown()
        return
    end
    if game_playerinfo:get_player_wood(playerID) < golden then
        send_error_tip(playerID, "error_nogolden")
        self:EndCooldown()
        return
    end
    local build = createbuild(playerID)
    build:SetBaseMaxHealth(hero:GetMaxHealth()*health)
    build:SetMaxHealth(hero:GetMaxHealth()*health)
    build:Heal(hero:GetMaxHealth()*health, build)

    table.insert(build_record, build:GetUnitName())
    game_playerinfo:change_player_wood(hero, -golden)
    build:AddNewModifier(hero, self, "modifier_kaiban_gongsi_lua", {duration = 999999, spacetime = spacetime})
end

if modifier_kaiban_gongsi_lua == nil then
	modifier_kaiban_gongsi_lua = class({})
end


function modifier_kaiban_gongsi_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self.spacetime = params.spacetime
    self.hero = self:GetCaster()
    self.ability = self:GetAbility()
    self:StartIntervalThink(self.spacetime)
end

function modifier_kaiban_gongsi_lua:OnIntervalThink()
    game_playerinfo:set_player_gold(self.hero:GetPlayerID(),self.hero:GetLevel()*10)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
