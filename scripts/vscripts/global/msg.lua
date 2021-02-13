POPUP_SYMBOL_PRE_PLUS = 0           --加号
POPUP_SYMBOL_PRE_MINUS = 1          --减号
POPUP_SYMBOL_PRE_SADFACE = 2        --悲伤的脸
POPUP_SYMBOL_PRE_BROKENARROW = 3    --断开的箭
POPUP_SYMBOL_PRE_SHADES = 4         --墨镜
POPUP_SYMBOL_PRE_MISS = 5           --MISS,丢失
POPUP_SYMBOL_PRE_EVADE = 6          --EVADE,回避
POPUP_SYMBOL_PRE_DENY = 7           --DENY,否决
POPUP_SYMBOL_PRE_ARROW = 8          --向上的箭头
 
POPUP_SYMBOL_POST_EXCLAMATION = 0   --无
POPUP_SYMBOL_POST_POINTZERO = 1     --".0"
POPUP_SYMBOL_POST_MEDAL = 2         --勋章
POPUP_SYMBOL_POST_DROP = 3          --水滴
POPUP_SYMBOL_POST_LIGHTNING = 4     --闪电
POPUP_SYMBOL_POST_SKULL = 5         --骷髅
POPUP_SYMBOL_POST_EYE = 6           --眼睛
POPUP_SYMBOL_POST_SHIELD = 7        --盾牌
POPUP_SYMBOL_POST_POINTFIVE = 8     --".5"
 
 
-- e.g. when healed by an ability
function PopupHealing(target, amount,lifetime)
    if lifetime == nil then lifetime = 1.0 end
    PopupNumbers(target, "heal", Vector(0, 255, 0), lifetime, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end
 
-- e.g. the popup you get when you suddenly take a large portion of your health pool in damage at once
function PopupDamage(target, amount)
    PopupNumbers(target, "damage", Vector(255, 0, 0), 1.0, amount, nil, POPUP_SYMBOL_POST_DROP)
end
 
function PopupMagicDamage( target, amount )
    PopupNumbers(target, "damage", Vector(0, 138, 255), 1.0, amount, nil, POPUP_SYMBOL_POST_DROP)
end

function PopupPoisonDamage( target, amount )
    PopupNumbers(target, "damage", Vector(49, 205, 44), 1.0, amount, nil, POPUP_SYMBOL_POST_DROP)
end

-- e.g. when dealing critical damage
function PopupCriticalDamage(target, amount)
    PopupNumbers(target, "crit", Vector(255, 0, 0), 1.0, amount, nil, POPUP_SYMBOL_POST_LIGHTNING)
end
 
-- e.g. when taking damage over time from a poison type spell
function PopupDamageOverTime(target, amount)
    PopupNumbers(target, "poison", Vector(215, 50, 248), 1.0, amount, nil, POPUP_SYMBOL_POST_EYE)
end
 
-- e.g. when blocking damage with a stout shield
function PopupDamageBlock(target, amount)
    PopupNumbers(target, "block", Vector(255, 255, 255), 1.0, amount, POPUP_SYMBOL_PRE_MINUS, nil)
end
 
-- e.g. when last-hitting a creep
function PopupGoldGain(target, amount)
    if amount < 1 then return end
    PopupNumbers(target, "gold", Vector(255, 200, 100), 1.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end

function PopupWoodGain(target, amount)
    if amount < 1 then return end
    PopupNumbers(target, "gold", Vector(55, 155, 55), 1.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end
-- e.g. when missing uphill
function PopupMiss(target)
    PopupNumbers(target, "miss", Vector(255, 0, 0), 1.0, nil, POPUP_SYMBOL_PRE_MISS, nil)
end
 
-- Customizable version.
function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_POINT, target) -- target:GetOwner()
    local digits = 0
    if number ~= nil then
        number = math.floor(number)
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end
    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 20))
    ParticleManager:SetParticleControl(pidx, 3, color)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroyPop"),
        function()
            ParticleManager:DestroyParticle(pidx,true)
        end,1)
end

function send_tips_message(playerID,message_text)
    local gameEvent = {}
    gameEvent["player_id"] = playerID
    gameEvent["locstring_value"]="升级啦"
    gameEvent["teamnumber"] =-1
    gameEvent["message"] = "{s:player_name}"..message_text
    FireGameEvent( "dota_combat_event_message", gameEvent )
end