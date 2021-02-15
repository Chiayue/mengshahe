-- 考试系统
require("global/global_var_func")

if examsystem == nil then
    examsystem = class({})
end

local question_bank = {
    {
        question = "question_1",
        answers = {
            "answer_1_1",
            "answer_1_2",
            "answer_1_3",
        },
        answer = 3,
    },
    -- {
    --     question = "question_2",
    --     answers = {
    --         "answer_2_1",
    --         "answer_2_2",
    --         "answer_2_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_3",
    --     answers = {
    --         "answer_3_1",
    --         "answer_3_2",
    --         "answer_3_3",
    --     },
    --     answer = 1,
    -- },
    {
        question = "question_4",
        answers = {
            "answer_4_1",
            "answer_4_2",
            "answer_4_3",
        },
        answer = 3,
    },
    -- {
    --     question = "question_5",
    --     answers = {
    --         "answer_5_1",
    --         "answer_5_2",
    --         "answer_5_3",
    --     },
    --     answer = 1,
    -- },
    {
        question = "question_6",
        answers = {
            "answer_6_1",
            "answer_6_2",
            "answer_6_3",
        },
        answer = 2,
    },
    -- {
    --     question = "question_7",
    --     answers = {
    --         "answer_7_1",
    --         "answer_7_2",
    --         "answer_7_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_8",
        answers = {
            "answer_8_1",
            "answer_8_2",
            "answer_8_3",
        },
        answer = 3,
    },
    {
        question = "question_9",
        answers = {
            "answer_9_1",
            "answer_9_2",
            "answer_9_3",
        },
        answer = 1,
    },
    {
        question = "question_10",
        answers = {
            "answer_10_1",
            "answer_10_2",
            "answer_10_3",
        },
        answer = 2,
    },
    {
        question = "question_11",
        answers = {
            "answer_11_1",
            "answer_11_2",
            "answer_11_3",
        },
        answer = 1,
    },
    {
        question = "question_12",
        answers = {
            "answer_12_1",
            "answer_12_2",
            "answer_12_3",
        },
        answer = 2,
    },
    {
        question = "question_13",
        answers = {
            "answer_13_1",
            "answer_13_2",
            "answer_13_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_14",
    --     answers = {
    --         "answer_14_1",
    --         "answer_14_2",
    --         "answer_14_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_15",
    --     answers = {
    --         "answer_15_1",
    --         "answer_15_2",
    --         "answer_15_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_16",
    --     answers = {
    --         "answer_16_1",
    --         "answer_16_2",
    --         "answer_16_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_17",
    --     answers = {
    --         "answer_17_1",
    --         "answer_17_2",
    --         "answer_17_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_18",
    --     answers = {
    --         "answer_18_1",
    --         "answer_18_2",
    --         "answer_18_3",
    --     },
    --     answer = 2,
    -- },
    -- {
    --     question = "question_19",
    --     answers = {
    --         "answer_19_1",
    --         "answer_19_2",
    --         "answer_19_3",
    --     },
    --     answer = 1,
    -- },
    {
        question = "question_20",
        answers = {
            "answer_20_1",
            "answer_20_2",
            "answer_20_3",
        },
        answer = 1,
    },
    {
        question = "question_21",
        answers = {
            "answer_21_1",
            "answer_21_2",
            "answer_21_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_22",
    --     answers = {
    --         "answer_22_1",
    --         "answer_22_2",
    --         "answer_22_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_23",
    --     answers = {
    --         "answer_23_1",
    --         "answer_23_2",
    --         "answer_23_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_24",
    --     answers = {
    --         "answer_24_1",
    --         "answer_24_2",
    --         "answer_24_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_25",
    --     answers = {
    --         "answer_25_1",
    --         "answer_25_2",
    --         "answer_25_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_26",
    --     answers = {
    --         "answer_26_1",
    --         "answer_26_2",
    --         "answer_26_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_27",
    --     answers = {
    --         "answer_27_1",
    --         "answer_27_2",
    --         "answer_27_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_28",
    --     answers = {
    --         "answer_28_1",
    --         "answer_28_2",
    --         "answer_28_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_29",
    --     answers = {
    --         "answer_29_1",
    --         "answer_29_2",
    --         "answer_29_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_30",
    --     answers = {
    --         "answer_30_1",
    --         "answer_30_2",
    --         "answer_30_3",
    --     },
    --     answer = 1,
    -- },
    {
        question = "question_31",
        answers = {
            "answer_31_1",
            "answer_31_2",
            "answer_31_3",
        },
        answer = 2,
    },
    {
        question = "question_32",
        answers = {
            "answer_32_1",
            "answer_32_2",
            "answer_32_3",
        },
        answer = 2,
    },
    {
        question = "question_33",
        answers = {
            "answer_33_1",
            "answer_33_2",
            "answer_33_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_34",
    --     answers = {
    --         "answer_34_1",
    --         "answer_34_2",
    --         "answer_34_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_35",
    --     answers = {
    --         "answer_35_1",
    --         "answer_35_2",
    --         "answer_35_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_36",
    --     answers = {
    --         "answer_36_1",
    --         "answer_36_2",
    --         "answer_36_3",
    --     },
    --     answer = 1,
    -- },
    {
        question = "question_37",
        answers = {
            "answer_37_1",
            "answer_37_2",
            "answer_37_3",
        },
        answer = 2,
    },
    {
        question = "question_38",
        answers = {
            "answer_38_1",
            "answer_38_2",
            "answer_38_3",
        },
        answer = 1,
    },
    {
        question = "question_39",
        answers = {
            "answer_39_1",
            "answer_39_2",
            "answer_39_3",
        },
        answer = 2,
    },
    {
        question = "question_40",
        answers = {
            "answer_40_1",
            "answer_40_2",
            "answer_40_3",
        },
        answer = 1,
    },
    {
        question = "question_41",
        answers = {
            "answer_41_1",
            "answer_41_2",
            "answer_41_3",
        },
        answer = 3,
    },
    {
        question = "question_42",
        answers = {
            "answer_42_1",
            "answer_42_2",
            "answer_42_3",
        },
        answer = 2,
    },
    {
        question = "question_43",
        answers = {
            "answer_43_1",
            "answer_43_2",
            "answer_43_3",
        },
        answer = 2,
    },
    -- {
    --     question = "question_44",
    --     answers = {
    --         "answer_44_1",
    --         "answer_44_2",
    --         "answer_44_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_45",
    --     answers = {
    --         "answer_45_1",
    --         "answer_45_2",
    --         "answer_45_3",
    --     },
    --     answer = 3,
    -- },
    {
        question = "question_46",
        answers = {
            "answer_46_1",
            "answer_46_2",
            "answer_46_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_47",
    --     answers = {
    --         "answer_47_1",
    --         "answer_47_2",
    --         "answer_47_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_48",
        answers = {
            "answer_48_1",
            "answer_48_2",
            "answer_48_3",
        },
        answer = 3,
    },
    -- {
    --     question = "question_49",
    --     answers = {
    --         "answer_49_1",
    --         "answer_49_2",
    --         "answer_49_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_50",
    --     answers = {
    --         "answer_50_1",
    --         "answer_50_2",
    --         "answer_50_3",
    --     },
    --     answer = 3,
    -- },
    {
        question = "question_51",
        answers = {
            "answer_51_1",
            "answer_51_2",
            "answer_51_3",
        },
        answer = 2,
    },
    -- {
    --     question = "question_52",
    --     answers = {
    --         "answer_52_1",
    --         "answer_52_2",
    --         "answer_52_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_53",
        answers = {
            "answer_53_1",
            "answer_53_2",
            "answer_53_3",
        },
        answer = 1,
    },
    {
        question = "question_54",
        answers = {
            "answer_54_1",
            "answer_54_2",
            "answer_54_3",
        },
        answer = 3,
    },
    {
        question = "question_55",
        answers = {
            "answer_55_1",
            "answer_55_2",
            "answer_55_3",
        },
        answer = 2,
    },
    {
        question = "question_56",
        answers = {
            "answer_56_1",
            "answer_56_2",
            "answer_56_3",
        },
        answer = 3,
    },
    {
        question = "question_57",
        answers = {
            "answer_57_1",
            "answer_57_2",
            "answer_57_3",
        },
        answer = 1,
    },
    {
        question = "question_58",
        answers = {
            "answer_58_1",
            "answer_58_2",
            "answer_58_3",
        },
        answer = 2,
    },
    {
        question = "question_59",
        answers = {
            "answer_59_1",
            "answer_59_2",
            "answer_59_3",
        },
        answer = 2,
    },
    {
        question = "question_60",
        answers = {
            "answer_60_1",
            "answer_60_2",
            "answer_60_3",
        },
        answer = 3,
    },
    {
        question = "question_61",
        answers = {
            "answer_61_1",
            "answer_61_2",
            "answer_61_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_62",
    --     answers = {
    --         "answer_62_1",
    --         "answer_62_2",
    --         "answer_62_3",
    --     },
    --     answer = 3,
    -- },
    {
        question = "question_63",
        answers = {
            "answer_63_1",
            "answer_63_2",
            "answer_63_3",
        },
        answer = 2,
    },
    {
        question = "question_64",
        answers = {
            "answer_64_1",
            "answer_64_2",
            "answer_64_3",
        },
        answer = 1,
    },
    {
        question = "question_65",
        answers = {
            "answer_65_1",
            "answer_65_2",
            "answer_65_3",
        },
        answer = 2,
    },
    {
        question = "question_66",
        answers = {
            "answer_66_1",
            "answer_66_2",
            "answer_66_3",
        },
        answer = 3,
    },
    {
        question = "question_67",
        answers = {
            "answer_67_1",
            "answer_67_2",
            "answer_67_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_68",
    --     answers = {
    --         "answer_68_1",
    --         "answer_68_2",
    --         "answer_68_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_69",
    --     answers = {
    --         "answer_69_1",
    --         "answer_69_2",
    --         "answer_69_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_70",
        answers = {
            "answer_70_1",
            "answer_70_2",
            "answer_70_3",
        },
        answer = 1,
    },
    -- {
    --     question = "question_71",
    --     answers = {
    --         "answer_71_1",
    --         "answer_71_2",
    --         "answer_71_3",
    --     },
    --     answer = 2,
    -- },
    -- {
    --     question = "question_72",
    --     answers = {
    --         "answer_72_1",
    --         "answer_72_2",
    --         "answer_72_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_73",
        answers = {
            "answer_73_1",
            "answer_73_2",
            "answer_73_3",
        },
        answer = 3,
    },
    {
        question = "question_74",
        answers = {
            "answer_74_1",
            "answer_74_2",
            "answer_74_3",
        },
        answer = 2,
    },
    -- {
    --     question = "question_75",
    --     answers = {
    --         "answer_75_1",
    --         "answer_75_2",
    --         "answer_75_3",
    --     },
    --     answer = 1,
    -- },
    -- {
    --     question = "question_76",
    --     answers = {
    --         "answer_76_1",
    --         "answer_76_2",
    --         "answer_76_3",
    --     },
    --     answer = 3,
    -- },
    -- {
    --     question = "question_77",
    --     answers = {
    --         "answer_77_1",
    --         "answer_77_2",
    --         "answer_77_3",
    --     },
    --     answer = 2,
    -- },
    {
        question = "question_78",
        answers = {
            "answer_78_1",
            "answer_78_2",
            "answer_78_3",
        },
        answer = 3,
    },
    {
        question = "question_79",
        answers = {
            "answer_79_1",
            "answer_79_2",
            "answer_79_3",
        },
        answer = 1,
    },
    {
        question = "question_80",
        answers = {
            "answer_80_1",
            "answer_80_2",
            "answer_80_3",
        },
        answer = 3,
    },
}

local currentquestion = {}
local lastquestion = 1
function examsystem:InitExamSystem()
    -- 开始答题系统,设置定时器,检测是否正在考试
    Timers:CreateTimer(10, function (arg1, arg2, arg3)
        self:OnExamSystemThink()
        return 10
    end)
end

function examsystem:OnExamSystemThink()
    if global_var_func.isexaming==1 then
        for i = 0, global_var_func.all_player_amount - 1 do
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"close_select_answer",{})
        end
        global_var_func.isexaming = 0
        return
    end
    if RollPercentage(25) then
        global_var_func.isexaming = 1
        EmitGlobalSound("game.kaoshi")
        local randomindex = RandomInt(1, #question_bank)
        currentquestion = question_bank[randomindex]
        for i = 0, global_var_func.all_player_amount - 1 do
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"show_exam_select",currentquestion)
        end
    end
end

function examsystem:CallExamAnswer(data)
    -- 响应考试答案
    local player_id = data.PlayerID
    local answer_index = tonumber(data.answer)
    -- print(">>>>>>>>>>>>> currentquestion.answer: "..currentquestion.answer)
    if answer_index == currentquestion.answer then
        -- 回答正确
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        global_var_func.isexaming = 0
        if hero then
            send_tips_message(player_id, "抢答成功,获得属性提升")
            
            SetBaseStrength(hero, 30)
            SetBaseAgility(hero, 30)
            SetBaseIntellect(hero, 30)

            if PlayerResource:GetSelectedHeroName(player_id) == "npc_dota_hero_grimstroke" then
                SetBaseStrength(hero, 15)
                SetBaseAgility(hero, 15)
                SetBaseIntellect(hero, 15)
            end
        end
        for i = 0, global_var_func.all_player_amount - 1 do
            if player_id ~= i then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"close_select_answer",{})
            end
        end
    end
end

function examsystem:test_sendshow_exam()
    local randomindex = RandomInt(1, #question_bank)
    if lastquestion==randomindex then
        randomindex = randomindex + 1
        if randomindex > #question_bank then
            randomindex = 1
        end
    end
    currentquestion = question_bank[randomindex]
    for i = 0, global_var_func.all_player_amount - 1 do
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"show_exam_select",question_bank[randomindex])
    end
end