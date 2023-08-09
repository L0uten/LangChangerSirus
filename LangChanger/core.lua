local AddOnName, Engine = ...
local LoutenLib, LGCH = unpack(Engine)

LoutenLib:InitAddon("LangChanger", "Language Changer", "1.0")
LGCH:SetChatPrefixColor("c41f1f")
LGCH:SetRevision("2023", "08", "09", "01", "02", "00")
LGCH:LoadedFunction(function()
    LGCH_DB = LoutenLib:InitDataStorage(LGCH_DB)
    LGCH:PrintMsg("/lgch или /langchanger - настройки языков.")
    LGCH:PrintMsg("/lgch show | hide - показать или скрыть окно.")
    LGCH:PrintMsg("/lgch reset - сбросить позицию окна в центр экрана.")
    LGCH:PrintMsg("Нажмите ПКМ чтобы заблокировать или разблокировать окно.")
end)

SlashCmdList.LGCH = function(msg, editBox)
    msg = strlower(msg)
    if (#msg == 0) then
        if (LGCH.Settings:IsShown()) then
            LGCH.Settings:Hide()
        else
            LGCH.Settings:Show()
        end
    elseif (msg == "hide" or msg == "show") then
        if (LGCH.LangFrame:IsShown()) then
            LGCH.LangFrame:Hide()
        else
            LGCH.LangFrame:Show()
        end
    elseif (msg == "reset") then
        LGCH.LangFrame:ClearAllPoints()
        LGCH.LangFrame:SetPoint("CENTER", nil, "CENTER", 0,0)
        LGCH_DB.Profiles[UnitName("player")].FramePositions = {LGCH.LangFrame:GetPoint()}
    end
end

SLASH_LGCH1 = "/lgch"
SLASH_LGCH2 = "/langchanger"

LGCH.LangList = {}
LGCH.ActualLangList = nil

LGCH.LangFrame = nil
LGCH.Settings = nil

LGCH.LangIndex = nil

LGCH.LangLFGChange = CreateFrame("Frame")
LGCH.LangLFGChange.ForceStop = "none"
function LGCH.LangLFGChangeFunc()
    if (UnitDebuff("player", "Ренегат")) then
        LGCH.LangLFGChange:HookScript("OnUpdate", function ()
            if (ChatFrame1EditBox:IsShown()) then
                if (ChatFrame1EditBox:GetAttribute("chatType") == "CHANNEL") then
                    local id, name = GetChannelName(tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")))
                    if (tostring(name) == "Поиск спутников(О)") then
                        if (LGCH.LangLFGChange.ForceStop ~= "H") then
                            LGCH.LangLFGChange.ForceStop = "H"
                                if (LanguageMenu:GetParent().chatFrame.editBox.language == "орочий") then return end
                                LGCH.ChangeLang("орочий", false)
                                return
                        end
                    end
                    if (tostring(name) == "Поиск спутников(А)") then
                        if (LGCH.LangLFGChange.ForceStop ~= "A") then
                            LGCH.LangLFGChange.ForceStop = "A"
                                if (LanguageMenu:GetParent().chatFrame.editBox.language == "всеобщий") then return end
                                LGCH.ChangeLang("всеобщий", false)
                                return
                        end
                    end
                    if (tostring(name) ~= "Поиск спутников(А)" and tostring(name) ~= "Поиск спутников(О)") then
                        LGCH.LangLFGChange.ForceStop = "none"
                        return
                    end
                else
                    LGCH.LangLFGChange.ForceStop = "none"
                end
            end
        end)
    end
end

LGCH.AddonReady = CreateFrame("Frame")
LGCH.AddonReady:SetScript("OnUpdate", function()
    if (GetNumLanguages()) then
        LGCH.AddonReady:SetScript("OnUpdate", nil)
        LGCH.InitLangs()
        LGCH.InitSettings()
        LGCH.InitActualLangsList()
        LGCH.CreateDropDown(LGCH.GetDefaultLanguage())
        LGCH.SetLangs()
        for i = 1, #LGCH.ActualLangList do
            if (LGCH.GetDefaultLanguage() == LGCH.ActualLangList[i]) then
                LGCH.LangIndex = i
                break
            end
            LGCH.LangIndex = 1
        end
        LGCH.LangLFGChangeFunc()
    end
end)

function LGCH.GetDefaultLanguage()
    -- Сирус сломал функцию GetDefaultLanguage() при входе в игру, так что такой вот костыль...
    if (UnitDebuff("player", "Ренегат")) then
        return "арго скорпидов"
    elseif (UnitDebuff("player", "Орда")) then
        return "орочий"
    elseif (UnitDebuff("player", "Альянс")) then
        return "всеобщий"
    end
end

function LGCH.InitLangs()
    for i = 1, GetNumLanguages() do
        LGCH.LangList[i] = GetLanguageByIndex(i)
    end
end

function LGCH.InitActualLangsList()
    for i = 1, #LGCH.LangList do
        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]]) then
            LGCH.ActualLangList = LGCH.ActualLangList or {}
            LGCH.ActualLangList[#LGCH.ActualLangList+1] = LGCH.LangList[i]
        end
    end
    LGCH.ActualLangList = LGCH.ActualLangList or {LGCH.GetDefaultLanguage()}
end

function LGCH.CreateDropDown(standartLang)
    LGCH.LangFrame = LoutenLib:CreateNewFrame(ChatFrame1EditBox)
    LGCH.LangFrame.UnlockButton = LoutenLib:CreateNewFrame(LGCH.LangFrame)
    local langFrameWidth = 140
    if (LGCH_DB.Profiles[UnitName("player")].UnluckButtonIsShown ~= nil) then
        if (LGCH_DB.Profiles[UnitName("player")].UnluckButtonIsShown) then
            LGCH.LangFrame.UnlockButton:Show()
            langFrameWidth = 140
        else
            LGCH.LangFrame.UnlockButton:Hide()
            langFrameWidth = 120
        end
    end
    if (LGCH_DB.Profiles[UnitName("player")].FramePositions) then
        LGCH.LangFrame:InitNewFrame(langFrameWidth, 20,
                                LGCH_DB.Profiles[UnitName("player")].FramePositions[1],
                                LGCH_DB.Profiles[UnitName("player")].FramePositions[2],
                                LGCH_DB.Profiles[UnitName("player")].FramePositions[3],
                                LGCH_DB.Profiles[UnitName("player")].FramePositions[4],
                                LGCH_DB.Profiles[UnitName("player")].FramePositions[5],
                                0,0,0,.735, true, true, function()
                                    LGCH_DB.Profiles[UnitName("player")].FramePositions = {LGCH.LangFrame:GetPoint()}
                                end)
    else
        LGCH.LangFrame:InitNewFrame(langFrameWidth, 20,
                                "LEFT", ChatFrame1EditBox, "LEFT", 2, -(ChatFrame1EditBox:GetHeight()-5),
                                0,0,0,.735, true, true, function()
                                    LGCH_DB.Profiles[UnitName("player")].FramePositions = {LGCH.LangFrame:GetPoint()}
                                end)
    end
    LGCH.LangFrame:InitNewDropDownList2(LGCH.LangFrame:GetWidth()-(langFrameWidth-120),LGCH.LangFrame:GetHeight(), 1, 1,
                                        0,0,0,1,
                                        LGCH.ActualLangList, standartLang, nil,
                                        "Button", nil, function()
                                            if (LGCH.LangFrame.UnlockButton:IsShown()) then
                                                LGCH.LangFrame.UnlockButton:Hide()
                                                LGCH.LangFrame:SetWidth(120)
                                                LGCH_DB.Profiles[UnitName("player")].UnluckButtonIsShown = false
                                                LGCH.LangFrame:SetMovable(false)
                                            else
                                                LGCH.LangFrame.UnlockButton:Show()
                                                LGCH.LangFrame:SetWidth(140)
                                                LGCH_DB.Profiles[UnitName("player")].UnluckButtonIsShown = true
                                                LGCH.LangFrame:SetMovable(true)
                                            end
                                        end)

    LGCH.LangFrame:EnableMouseWheel(1)
    LGCH.LangFrame:SetScript("OnMouseWheel", function(s,d)
        if (LGCH.LangIndex-d > 0 and LGCH.LangIndex-d <= #LGCH.ActualLangList) then
            LGCH.LangIndex = LGCH.LangIndex-d
            local name
            if (ChatFrame1EditBox:GetAttribute("chatType") == "CHANNEL") then
                _, name = GetChannelName(tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")))
            end
            LGCH.ChangeLang(LGCH.ActualLangList[LGCH.LangIndex], true, tostring(name))
        end
    end)
    LGCH.LangFrame.UnlockButton:InitNewFrame(15, 15,
                                            "RIGHT", LGCH.LangFrame, "RIGHT", -2.5,0,
                                            0,1,0,1, false, false, nil)
    LGCH.LangFrame.UnlockButton.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\drag.blp")
end

function LGCH.SetLangs()
    for i = 1, #LGCH.LangFrame.DropDownList.Elements do
        LGCH.LangFrame.DropDownList.Elements[i]:SetScript("OnMouseDown", function()
            local name
            if (ChatFrame1EditBox:GetAttribute("chatType") == "CHANNEL") then
                _, name = GetChannelName(tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")))
            end
            LGCH.ChangeLang(LGCH.ActualLangList[i], true, tostring(name))
            LGCH.LangIndex = i
        end)
    end
end

function LGCH.ChangeLang(lang, isForced, channelName)
    if (isForced) then
        if (channelName == "Поиск спутников(О)") then
            LGCH.LangLFGChange.ForceStop = "H"
        end
        if (channelName == "Поиск спутников(А)") then
            LGCH.LangLFGChange.ForceStop = "A"
        end
        if (channelName ~= "Поиск спутников(А)" and channelName ~= "Поиск спутников(О)") then
            LGCH.LangLFGChange.ForceStop = "none"
        end
    end
    LGCH.LangFrame.DropDownButton.Text:SetText(lang)
    LanguageMenu:GetParent().chatFrame.editBox.language = lang
    LGCH.LangFrame.CloseDD()
end

function LGCH.InitSettings()
    LGCH.Settings = LoutenLib:CreateNewFrame(UIParent)
    LGCH.Settings:Hide()
    LGCH_DB.Profiles[UnitName("player")].ActiveLangs = LGCH_DB.Profiles[UnitName("player")].ActiveLangs or {}
    LGCH.Settings:InitNewFrame(160, #LGCH.LangList*30+60,
                                "CENTER", nil, "CENTER", 0,0,
                                0,0,0,.4, true, true, nil)
    LGCH.Settings:TextureToBackdrop(true, 2, 3, .95, .82, 0, 1, 0,0,0,1)
    LGCH.Settings:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1
    });
    LGCH.Settings:SetBackdropColor(0,0,0,1);
    LGCH.Settings:SetBackdropBorderColor(.95, .82, 0, .7);
    LGCH.Settings.LangsCB = {}
    for i = 1, #LGCH.LangList do
        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == nil) then
            LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = true
        end

        LGCH.Settings.LangsCB[i] = LoutenLib:CreateNewFrame(LGCH.Settings)
        LGCH.Settings.LangsCB[i]:InitNewFrame(LGCH.Settings:GetWidth(), 30,
                                            "TOP", LGCH.Settings, "TOP", 10, -(30*i),
                                            0,0,0,0, true, false, nil)
                                            
        LGCH.Settings.LangsCB[i]:InitNewCheckButton(23, LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]], LGCH.LangList[i], true, 11,
            function()
                LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = not LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]]
                LGCH.ActualLangList = nil
                LGCH.InitActualLangsList()
                LGCH.LangFrame:WipeDropDownList()
                LGCH.CreateDropDown(LanguageMenu:GetParent().chatFrame.editBox.language)
                LGCH.SetLangs()
            end)
        LGCH.Settings.LangsCB[i].CheckButton:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 15,
        });
        LGCH.Settings.LangsCB[i].CheckButton:SetBackdropBorderColor(1,1,1,.1);
    end
    LGCH.Settings.CloseButton = LoutenLib:CreateNewFrame(LGCH.Settings)
    LGCH.Settings.CloseButton:InitNewFrame2(18, 18,
                                            "TOPRIGHT", LGCH.Settings, "TOPRIGHT", 0,0,
                                            230, 26, 23, 1, true, false, nil)
    LGCH.Settings.CloseButton:InitNewButton2(230, 26, 23, 1,
                                            nil, function()
                                                LGCH.Settings:Hide()
                                            end)
    LGCH.Settings.CloseButton:SetTextToFrame("CENTER", LGCH.Settings.CloseButton, "CENTER", -1,3, true, 15, "x")
end



























-- ChatFrame1EditBox
-- ChatFrame1EditBox:GetAttribute("channelTarget") -- ид канала
-- tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")
-- ChatFrame1EditBox:GetAttribute("tellTarget") - имя игрока которому пишешь
-- ChatFrame1EditBox:GetAttribute("chatType") -- тип канала
-- RegisterEvent("LANGUAGE_LIST_CHANGED") -- ивент изменении списка языков
-- ChatFrame1EditBox:GetName()


