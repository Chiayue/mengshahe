GameRules.__vTimerNameTable__ = GameRules.__vTimerNameTable__ or {}
function Timer(delay, callback)
    if callback == nil then
        callback = delay -- 省略了为0的delay参数
        delay = 0
    end

    local timerName = DoUniqueString("timer")

    GameRules:GetGameModeEntity():SetContextThink(timerName,function()
        if GameRules.__vTimerNameTable__[timerName] then
            return callback()
        else
            return nil
        end
    end,delay)

    GameRules.__vTimerNameTable__[timerName] = true

    return timerName
end