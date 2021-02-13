config_enum=class({})

--------------------------------------------------------------------------------------------
-- 实体类型标记枚举（可组合）
--------------------------------------------------------------------------------------------
DOTA_UNIT_TYPE_FLAG_NONE             = 0        -- 啥也不是
DOTA_UNIT_TYPE_FLAG_CREEP            = 1        -- 小怪
DOTA_UNIT_TYPE_FLAG_BOSS             = 2        -- Boss
DOTA_UNIT_TYPE_FLAG_ELITE            = 4        -- 精英
DOTA_UNIT_TYPE_FLAG_ABILITY          = 8        -- 带技能
DOTA_UNIT_TYPE_FLAG_CALL             = 16       -- 召唤
DOTA_UNIT_TYPE_FLAG_FINALLY          = 32       -- 最终
DOTA_UNIT_TYPE_FLAG_UPGRADE_ITEM     = 64       -- 升级物品
DOTA_UNIT_TYPE_FLAG_MELEE            = 128      -- 近战
DOTA_UNIT_TYPE_FLAG_RANGE            = 256      -- 远程
DOTA_UNIT_TYPE_FLAG_TANK             = 512      -- 肉逼
DOTA_UNIT_TYPE_FLAG_DPS              = 1024     -- 输出
DOTA_UNIT_TYPE_FLAG_NO_ATTACK        = 2048     -- 不攻击
DOTA_UNIT_TYPE_FLAG_TEMP             = 4096     -- 临时，指定时间后会消失
DOTA_UNIT_TYPE_FLAG_SON              = 8192     -- 单位召唤出来的儿子
DOTA_UNIT_TYPE_FLAG_ILLUSION         = 16384     -- 分身
DOTA_UNIT_TYPE_FLAG_GOLD             = 32768     -- 金钱
DOTA_UNIT_TYPE_FLAG_AURA             = 65536     -- 带光环
DOTA_UNIT_TYPE_FLAG_GENERAL          = 131072     -- 普通
DOTA_UNIT_TYPE_FLAG_OPERATION        = 262144     -- 运营
DOTA_UNIT_TYPE_FLAG_WORLD            = 524288     -- 世界
DOTA_UNIT_TYPE_FLAG_DIFFICULTY_1     = 1048576     -- 普通
DOTA_UNIT_TYPE_FLAG_DIFFICULTY_2     = 2097152     -- 困难
DOTA_UNIT_TYPE_FLAG_DIFFICULTY_3     = 4194304     -- 疯狂
DOTA_UNIT_TYPE_FLAG_TALENT           = 8388608     -- 天赋

-- 目标单位只要符合给定的多个类型中的一个即返回true
function ContainUnitTypeFlag(unit, ...)
    local flag = unit.unit_type_flag
    if not flag then
        return false
    end
    local flags = {...}
    for _, flag2 in pairs(flags) do
        if flag2 <= 0 then
            goto continue
        end
        local flag1 = flag
        if flag1 == flag2 then
            return true
        elseif flag1 <= flag2 then
            goto continue
        else
            -- 转二进制字符串
            local str1 = ""
            local str2 = ""
            while (flag1 > 0 and flag2 > 0) do
                if flag1 > 0 then
                    if (flag1 % 2 == 1) then
                        str1 = str1 .. "1"
                    else
                        str1 = str1 .. "0"
                    end
                    flag1 = math.modf(flag1 / 2)
                end
                if flag2 > 0 then
                    if (flag2 % 2 == 1) then
                        str2 = str2 .. "1"
                    else
                        str2 = str2 .. "0"
                    end
                    flag2 = math.modf(flag2 / 2)
                end
            end
            str1 = string.reverse(str1)
            str2 = string.reverse(str2)
            -- 判定
            local len1 = string.len(str1)
            local len2 = string.len(str2)
            for i = 1, len2 do
                local index = i * -1
                if string.sub(str2, index, index) == "1" then
                    if string.sub(str1, index, index) == "0" then
                        goto continue
                    end
                end
            end
            return true
        end
        ::continue::
    end
    return false
end

-- 追加单位类型标识
function AppendUnitTypeFlag(unit, flag)
    if unit.unit_type_flag then
        unit.unit_type_flag = unit.unit_type_flag + flag
    else
        unit.unit_type_flag = flag
    end
end

--------------------------------------------------------------------------------------------
-- 自定义游戏阶段枚举
--------------------------------------------------------------------------------------------
DOTA_GAME_STEP_NONE                         = 0        -- 未进行游戏阶段
DOTA_GAME_STEP_GENERAL                      = 1        -- 常规游戏阶段
DOTA_GAME_STEP_FINALLY_BOSS                 = 2        -- 关底BOSS
DOTA_GAME_STEP_GAME_OVER                    = 3        -- 游戏已结束
