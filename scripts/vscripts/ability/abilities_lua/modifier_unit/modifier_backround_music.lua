if modifier_backround_music == nil then
    modifier_backround_music = ({})
end

local music_list = {
    {"game.background.xunhuanbgm", 245,},
    -- {"game.background.Mario", 152,},
    -- {"game.background.hundouluo", 152,},
}

function modifier_backround_music:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_backround_music:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_backround_music:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_backround_music:OnCreated(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_backround_music:OnRefresh(params)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_backround_music:OnIntervalThink()
    local randomindex = RandomInt(1, #music_list)
    local music_info = music_list[randomindex]
    if self.nowmusic then
        StopGlobalSound(self.nowmusic)
    end
    EmitGlobalSound(music_info[1])
    self.nowmusic = music_info[1]
    global_var_func.background_musicplayer = self.nowmusic
    self:StartIntervalThink(music_info[2])
end
