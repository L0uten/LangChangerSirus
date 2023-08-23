local AddOnName, Engine = ...
LoutenLib, LGCH = unpack(Engine)

LoutenLib:InitAddon("LangChanger", "Language Changer", "1.2")
LGCH:SetChatPrefixColor("c41f1f")
LGCH:SetRevision("2023", "08", "23", "00", "01", "00")
LGCH:LoadedFunction(function()
    LGCH_DB = LoutenLib:InitDataStorage(LGCH_DB)
    LGCH:PrintMsg("/lgch или /langchanger - настройки языков.")
    LGCH:PrintMsg("Нажмите ПКМ чтобы заблокировать или разблокировать окно.")
end)

SlashCmdList.LGCH = function(msg, editBox)
    msg = strlower(msg)
    if (#msg == 0) then
        if (LGCH.SettingsWindow:IsShown()) then
            LGCH.SettingsWindow:Close()
        else
            LGCH.SettingsWindow:Open()
        end
    elseif (msg == "hide" or msg == "show") then
        if (LGCH.LangFrame:IsShown()) then
            LGCH.LangFrame:Hide()
        else
            LGCH.LangFrame:Show()
        end
        LGCH_DB.Profiles[UnitName("player")].IsShown = LGCH.LangFrame:IsShown()
    end
end

SLASH_LGCH1 = "/lgch"
SLASH_LGCH2 = "/langchanger"

LGCH.LangList = {}
LGCH.ActualLangList = nil

LGCH.LangFrame = nil

LGCH.LangIndex = nil
LGCH.IsRenegade = nil
LGCH.Lang = nil

LGCH.LangLFGChange = CreateFrame("Frame")
LGCH.AddonReady = CreateFrame("Frame")
LGCH.ZoneChanged = CreateFrame("Frame")
LGCH.LangChangeList = CreateFrame("Frame")
LGCH.LangLFGChange.ForceStop = "none"


LGCH.AddonReady:SetScript("OnUpdate", function()
    if (GetNumLanguages()) then
        LGCH.AddonReady:SetScript("OnUpdate", nil)
        LGCH.InitLangs()
        LGCH.InitNewSettings()
        LGCH.InitActualLangsList()
        LGCH.RefreshSettings()
        LGCH.CreateDropDown(LGCH.GetDefaultLanguage())
        LGCH.SetLangs()
        LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.GetDefaultLanguage()) or 1
        LGCH.LangLFGChangeFunc()
        LGCH.Lang = LGCH.ActualLangList[LGCH.LangIndex] or LGCH.GetDefaultLanguage()
        LGCH.LangChangeList:RegisterEvent("LANGUAGE_LIST_CHANGED")
        LGCH.ZoneChanged:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    end
end)

LGCH.ZoneChanged:SetScript("OnEvent", function(s, e)
    if (e == "ZONE_CHANGED_NEW_AREA") then
        LGCH.GetDefaultLanguage()
        LGCH.ChangeLang(LGCH.ActualLangList[LGCH.LangIndex] or LGCH.GetDefaultLanguage())
    end
end)

LGCH.LangChangeList:SetScript("OnEvent", function (s, e)
    if (e == "LANGUAGE_LIST_CHANGED") then
        local tempLangList = {}
        for i = 1, GetNumLanguages() do
            tempLangList[i] = GetLanguageByIndex(i)
        end
        local diffLangs = LoutenLib:FindingDiffInTwoArray(tempLangList, LGCH.LangList)
        if (#diffLangs>0) then
            if (#LGCH.LangList>#tempLangList) then
                for i = 1, #diffLangs do
                    LGCH.LangFrame.DropDownList:RemoveElementByText(diffLangs[i])
                end
                LGCH.InitLangs()
                LGCH.InitActualLangsList()
                LGCH.SetLangs()
                if (LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.Lang)) then
                    LGCH.ChangeLang(LGCH.Lang)
                else
                    LGCH.ChangeLang(LGCH.GetDefaultLanguage())
                end
            elseif (#LGCH.LangList<#tempLangList) then
                LGCH.InitLangs()
                LGCH.InitActualLangsList()
                local i = #LGCH.LangFrame.DropDownList.Elements.DisplayOrders
                while (i > 0) do
                    LGCH.LangFrame.DropDownList:RemoveElementByIndex(i)
                    i = i - 1
                end
                for i = 1, #LGCH.ActualLangList do
                    LGCH.LangFrame.DropDownList:AddElement(LGCH.ActualLangList[i])
                end
                LGCH.SetLangs()
                LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.Lang)
                if (ChatMenu.chatFrame.editBox.language ~= LGCH.Lang) then
                    LGCH.ChangeLang(LGCH.Lang)
                end
            end
            LGCH.RefreshSettings()
        end
    end
end)

function LGCH.LangLFGChangeFunc()
    if (LGCH.IsRenegade) then
        LGCH.LangLFGChange:HookScript("OnUpdate", function ()
            if (ChatFrame1EditBox:IsShown()) then
                if (ChatFrame1EditBox:GetAttribute("chatType") == "CHANNEL") then
                    local id, name = GetChannelName(tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")))
                    if (tostring(name) == "Поиск спутников(О)") then
                        if (LGCH.LangLFGChange.ForceStop ~= "H") then
                            LGCH.LangLFGChange.ForceStop = "H"
                                if (ChatMenu.chatFrame.editBox.language == "орочий") then return end
                                LGCH.ChangeLang("орочий", false)
                                return
                        end
                    end
                    if (tostring(name) == "Поиск спутников(А)") then
                        if (LGCH.LangLFGChange.ForceStop ~= "A") then
                            LGCH.LangLFGChange.ForceStop = "A"
                                if (ChatMenu.chatFrame.editBox.language == "всеобщий") then return end
                                LGCH.ChangeLang("всеобщий", false)
                                return
                        end
                    end
                    if (tostring(name) == "Поиск спутников" and LGCH.GetDefaultLanguage() == "арго скорпидов") then
                        if (LGCH.LangLFGChange.ForceStop ~= "R") then
                            LGCH.LangLFGChange.ForceStop = "R"
                                if (ChatMenu.chatFrame.editBox.language == "арго скорпидов") then return end
                                LGCH.ChangeLang("арго скорпидов", false)
                                return
                        end
                    end
                    if (tostring(name) ~= "Поиск спутников(А)" and tostring(name) ~= "Поиск спутников(О)" and tostring(name) ~= "Поиск спутников") then
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

function LGCH.GetDefaultLanguage()
    -- Сирус сломал функцию GetDefaultLanguage() при входе в игру, так что такой вот костыль...
    if (UnitDebuff("player", "Ренегат") or LGCH.IsRenegade) then
        LGCH.IsRenegade = true
        return "арго скорпидов"
    elseif (UnitDebuff("player", "Орда")) then
        return "орочий"
    elseif (UnitDebuff("player", "Альянс")) then
        return "всеобщий"
    end
end

function LGCH.InitLangs()
    LGCH.LangList = {}
    for i = 1, GetNumLanguages() do
        LGCH.LangList[i] = GetLanguageByIndex(i)
    end
end

function LGCH.InitActualLangsList()
    LGCH.ActualLangList = {}
    for i = 1, #LGCH.LangList do
        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] or LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == nil) then
            LGCH.ActualLangList[#LGCH.ActualLangList+1] = LGCH.LangList[i]
            LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = true
        end
    end
    if (#LGCH.ActualLangList == 0 and LGCH.LangIndex) then
        LGCH.LangIndex = 1
    end
end

function LGCH.CreateDropDown(standartLang)
    LGCH_DB.Profiles[UnitName("player")].OpenTo = LGCH_DB.Profiles[UnitName("player")].OpenTo or "down"
    
    LGCH.LangFrame = LoutenLib:CreateNewFrame(ChatFrame1EditBox)
    if (not LGCH_DB.Profiles[UnitName("player")].IsShown) then
        LGCH.LangFrame:Hide()
    end
    LGCH.LangFrame.UnlockButton = LoutenLib:CreateNewFrame(LGCH.LangFrame)
    LGCH.LangFrame.UnlockButton:Hide()
    local langFrameWidth = 120
    
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

    LGCH.LangFrame:InitNewDropDownList(0,0,0,1, LGCH_DB.Profiles[UnitName("player")].OpenTo, "Button", standartLang, LGCH.ActualLangList, nil, nil,
                                                    function()
                                                        if (LGCH.LangFrame.UnlockButton:IsShown()) then
                                                            LGCH.LangFrame.UnlockButton:Hide()
                                                            LGCH.LangFrame:SetWidth(120)
                                                            LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown = false
                                                            LGCH.LangFrame:SetMovable(false)
                                                        else
                                                            LGCH.LangFrame.UnlockButton:Show()
                                                            LGCH.LangFrame:SetWidth(140)
                                                            LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown = true
                                                            LGCH.LangFrame:SetMovable(true)
                                                        end
                                                    end)
    
    if (LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown) then
        LGCH.LangFrame.UnlockButton:Show()
        langFrameWidth = 140
    else
        LGCH.LangFrame.UnlockButton:Hide()
        langFrameWidth = 120
    end
    LGCH.LangFrame:SetWidth(langFrameWidth)
    LGCH.LangFrame.DropDownButton:SetWidth(LGCH.LangFrame:GetWidth()-(langFrameWidth-120))
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
    LGCH.LangFrame.UnlockButton.Texture:SetTexture("Interface\\AddOns\\"..LGCH.Info.FileName.."\\textures\\drag.blp")
end

function LGCH.SetLangs()
    if (#LGCH.LangFrame.DropDownList.Elements == 0) then return end
    for i = 1, #LGCH.LangFrame.DropDownList.Elements.DisplayOrders do
        LGCH.LangFrame.DropDownList.Elements[LGCH.LangFrame.DropDownList.Elements.DisplayOrders[i]]:SetScript("OnMouseDown", function()
            local name
            if (ChatFrame1EditBox:GetAttribute("chatType") == "CHANNEL") then
                _, name = GetChannelName(tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")))
            end
            LGCH.ChangeLang(LGCH.ActualLangList[i], true, tostring(name))
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
        if (channelName == "Поиск спутников" and LGCH.GetDefaultLanguage() == "арго скорпидов") then
            LGCH.LangLFGChange.ForceStop = "R"
        end
        if (channelName ~= "Поиск спутников(А)" and channelName ~= "Поиск спутников(О)" and channelName ~= "Поиск спутников") then
            LGCH.LangLFGChange.ForceStop = "none"
        end
    end
    LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, lang)
    LGCH.LangFrame.DropDownButton.Text:SetText(lang)
    ChatMenu.chatFrame.editBox.language = lang
    LGCH.Lang = lang
    LGCH.LangFrame.DropDownList:Close()
end


















-- ChatFrame1EditBox
-- ChatFrame1EditBox:GetAttribute("channelTarget") -- ид канала
-- tonumber(ChatFrame1EditBox:GetAttribute("channelTarget")
-- ChatFrame1EditBox:GetAttribute("tellTarget") - имя игрока которому пишешь
-- ChatFrame1EditBox:GetAttribute("chatType") -- тип канала
-- RegisterEvent("LANGUAGE_LIST_CHANGED") -- ивент изменении списка языков
-- ChatFrame1EditBox:GetName()
