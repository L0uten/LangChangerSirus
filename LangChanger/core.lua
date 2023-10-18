local AddOnName, Engine = ...
local LoutenLib, LGCH = unpack(Engine)

local Init = CreateFrame("Frame")
Init:RegisterEvent("PLAYER_LOGIN")
Init:SetScript("OnEvent", function()
    LoutenLib:InitAddon("LangChanger", "Language Changer", "1.3.3")
    LGCH_DB = LoutenLib:InitDataStorage(LGCH_DB)
    LGCH:SetChatPrefixColor("c41f1f")
    LGCH:SetRevision("2023", "10", "18", "01", "00", "01")
    LGCH:LoadedFunction(function()
        LGCH:PrintMsg("/lgch или /langchanger - настройки языков.")
        LGCH:PrintMsg("Нажмите ПКМ чтобы заблокировать или разблокировать окно.")
    end)
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

LGCH.Events = CreateFrame("Frame")
LGCH.ForceStop = "none"

LGCH.Events:SetScript("OnUpdate", function ()
    if (GetNumLanguages()) then
        LGCH.Events:SetScript("OnUpdate", nil)
        LGCH.InitLangs()
        LGCH.InitNewSettings()
        LGCH.InitActualLangsList()
        LGCH.RefreshSettings()
        LGCH.CreateDropDown(LGCH.GetDefaultLanguage())
        LGCH.SetLangs()
        LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.GetDefaultLanguage()) or 1
        LGCH.Lang = LGCH.ActualLangList[LGCH.LangIndex] or LGCH.GetDefaultLanguage()
        LGCH.Events:RegisterEvent("LANGUAGE_LIST_CHANGED")
        LGCH.Events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    end
end)

LGCH.Events:SetScript("OnEvent", function (s, e)
    if (e == "ZONE_CHANGED_NEW_AREA") then
        LGCH.GetDefaultLanguage()
        LGCH.ChangeLang(LGCH.ActualLangList[LGCH.LangIndex] or LGCH.GetDefaultLanguage())
    end

    if (e == "LANGUAGE_LIST_CHANGED") then
        local tempLangList = {}
        for i = 1, GetNumLanguages() do
            tempLangList[i] = GetLanguageByIndex(i)
        end
        local diffLangs = LoutenLib:FindingDiffInTwoArray(tempLangList, LGCH.LangList)
        if (#diffLangs>0) then
            if (#LGCH.LangList>#tempLangList) then
                LGCH.ForceStop = "none"
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
                LGCH.ForceStop = "none"
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
                if (ChatMenu.chatFrame.editBox.language ~= LGCH.Lang) then
                    LGCH.ChangeLang(LGCH.Lang)
                end
            end
            LGCH.RefreshSettings()
        end
    end
end)

local _SendChatMessage = SendChatMessage
function SendChatMessage(...)
    local msg, chatType, language, channel = ...
    if (LGCH.IsRenegade) then
        if (chatType == "CHANNEL") then
            local _, name = GetChannelName(tonumber(channel))
            if (tostring(name) == "Поиск спутников(О)") then
                if (tostring(name) == "Поиск спутников(О)") then
                    if (LGCH.ForceStop ~= "H") then
                        LGCH.ForceStop = "H"
                        if (LGCH.Lang ~= "орочий") then
                            LGCH.ChangeLang("орочий", false)
                        end
                    end
                end
            elseif (tostring(name) == "Поиск спутников(А)") then
                if (LGCH.ForceStop ~= "A") then
                    LGCH.ForceStop = "A"
                        if (LGCH.Lang ~= "всеобщий") then
                            LGCH.ChangeLang("всеобщий", false)
                        end
                end
            elseif (tostring(name) == "Поиск спутников" and LGCH.GetDefaultLanguage() == "арго скорпидов") then
                if (LGCH.ForceStop ~= "R") then
                    LGCH.ForceStop = "R"
                        if (LGCH.Lang ~= "арго скорпидов") then
                            LGCH.ChangeLang("арго скорпидов", false)
                        end
                end
            elseif (tostring(name) ~= "Поиск спутников(А)" and tostring(name) ~= "Поиск спутников(О)" and tostring(name) ~= "Поиск спутников") then
                LGCH.ForceStop = "none"
            end
        end
        if (chatType == "RAID" or "RAID_WARNING" and IsInRaid()) then
            for i = 1, GetNumRaidMembers() do
                if (UnitDebuff("raid"..i, "Орда")) then
                    LGCH.ChangeLang("орочий", false)
                    break
                end
                if (UnitDebuff("raid"..i, "Альянс")) then
                    LGCH.ChangeLang("всеобщий", false)
                    break
                end
            end
        end
    end
    _SendChatMessage(msg, chatType, LGCH.Lang, channel)
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
    
    LGCH.LangFrame = LoutenLib:CreateNewFrame(UIParent)
    LGCH.LangFrame:Hide()
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
                                "CENTER", nil, "CENTER", 0, 0,
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

    if (LGCH_DB.Profiles[UnitName("player")].IsFirstStart == nil) then
        LGCH_DB.Profiles[UnitName("player")].IsFirstStart = true
    end
    for i = 1,10 do
        local frame = _G["ChatFrame"..i.."EditBox"]
        frame:SetScript("OnShow", function()
            if (LGCH_DB.Profiles[UnitName("player")].IsFirstStart) then
                LGCH_DB.Profiles[UnitName("player")].IsFirstStart = false
                LGCH:Notify("Ваше окно с языками находится по середине экрана, вы можете перемещать его куда вам удобно нажав ПКМ на него.")
            end

            if (LGCH_DB.Profiles[UnitName("player")].IsShown) then
                LGCH.LangFrame:Show()
            end
        end)
        frame:SetScript("OnHide", function()
            LGCH.LangFrame:Hide()
        end)
    end
    
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
            LGCH.ForceStop = "H"
        end
        if (channelName == "Поиск спутников(А)") then
            LGCH.ForceStop = "A"
        end
        if (channelName == "Поиск спутников" and LGCH.GetDefaultLanguage() == "арго скорпидов") then
            LGCH.ForceStop = "R"
        end
        if (channelName ~= "Поиск спутников(А)" and channelName ~= "Поиск спутников(О)" and channelName ~= "Поиск спутников") then
            LGCH.ForceStop = "none"
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
