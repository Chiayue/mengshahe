shurudaima_lua = class({})
LinkLuaModifier( "modifier_shurudaima_lua","ability/abilities_lua/innateskill_shurudaima_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function shurudaima_lua:GetIntrinsicModifierName()
	return "modifier_shurudaima_lua"
end

modifier_shurudaima_lua = class({})

function modifier_shurudaima_lua:OnCreated( kv )
    if IsServer() then
	    self.listenid = ListenToGameEvent("player_chat", Dynamic_Wrap(modifier_shurudaima_lua, "on_player_chated"), self)
    end
end

function modifier_shurudaima_lua:on_player_chated(event)
    if event.text == "FGNB" then
        if event.playerid == self:GetCaster():GetPlayerID() then
            if not GameRules:IsGamePaused() then
                if self:GetStackCount() < 250 then
                    self:IncrementStackCount()
                    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(),250)
                    SetBaseStrength(self:GetCaster(), 1)
                    SetBaseAgility(self:GetCaster(), 1)
                    SetBaseIntellect(self:GetCaster(), 1)
                    if self:GetStackCount() == 250 then
                        game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(),50000)
                    end
                end
            else
                send_error_tip(event.playerid,"error_nopause")
            end
        end
	end
end

function modifier_shurudaima_lua:OnDestroy()
    if IsServer() then
	    StopListeningToGameEvent(self.listenid)
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------升华技能----------------------------------------
sublime_shurudaima_lua = class({})

--------------------------------------------------------------------------------
LinkLuaModifier("modifier_sublime_shurudaima_lua","ability/abilities_lua/innateskill_shurudaima_lua",LUA_MODIFIER_MOTION_NONE )

function sublime_shurudaima_lua:GetIntrinsicModifierName()
	return "modifier_sublime_shurudaima_lua"
end

modifier_sublime_shurudaima_lua = class({})

function modifier_sublime_shurudaima_lua:OnCreated( kv )
    if IsServer() then
	    self.listenid = ListenToGameEvent("player_chat", Dynamic_Wrap(modifier_sublime_shurudaima_lua, "on_player_chated"), self)
    end
end

function modifier_sublime_shurudaima_lua:on_player_chated(event)
    if event.text == "FGSB" then
        if event.playerid == self:GetCaster():GetPlayerID() then
            if not GameRules:IsGamePaused() then
                if self:GetStackCount() < 100 then
                    self:IncrementStackCount()
                    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(),500)
                    SetBaseStrength(self:GetCaster(), 2)
                    SetBaseAgility(self:GetCaster(), 2)
                    SetBaseIntellect(self:GetCaster(), 2)
                end
            else
                send_error_tip(event.playerid,"error_nopause")
            end
        end
	end
end

function modifier_sublime_shurudaima_lua:OnDestroy()
    if IsServer() then
	    StopListeningToGameEvent(self.listenid)
    end
end