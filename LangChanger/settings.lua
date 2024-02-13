local AddOnName, Engine = ...
local LoutenLib, LGCH = unpack(Engine)

function LGCH.InitNewSettings()
    LGCH.SettingsWindow.MenuBar:AddNewBarButton("Настройка окна")
    LGCH.SettingsWindow.MenuBar:AddNewBarButton("Управление языками", true)
    LGCH.SettingsWindow.MenuBar:AddNewBarButton("Автоматическая смена языка")

    local wi1 = LGCH.SettingsWindow:GetMenuBarButtonIndexByText("Настройка окна")
    local wi2 = LGCH.SettingsWindow:GetMenuBarButtonIndexByText("Управление языками")
    local wi3 = LGCH.SettingsWindow:GetMenuBarButtonIndexByText("Автоматическая смена языка")
    
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -20-(LGCH.SettingsWindow.MainPanel.Windows[wi1].Title:GetHeight()),
                                                                1,0,0,0)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1, "LEFT", 0,0, false, 13, "Вы можете поменять сторону открытия списка языков:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo:InitNewFrame(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1, "TOPLEFT", 0, -15,
                                                                0,0,0,1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo:InitNewDropDownList(  LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                            LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                            LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            LGCH_DB.Profiles[UnitName("player")].OpenTo, "Button",
                                                                "Открывать в:",
                                                                {"Вверх", "Вниз"},
                                                                {function()
                                                                    LGCH.LangFrame.DropDownList:ChangeSideToOpen("up")
                                                                    LGCH_DB.Profiles[UnitName("player")].OpenTo = "up"
                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo.DropDownList:Close()
                                                                end,
                                                                function()
                                                                    LGCH.LangFrame.DropDownList:ChangeSideToOpen("down")
                                                                    LGCH_DB.Profiles[UnitName("player")].OpenTo = "down"
                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo.DropDownList:Close()
                                                                end})
    

    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2, "LEFT", 0,0, false, 13, "Сбросить позицию окна с языками в центр:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2, "TOPLEFT", 0, -15,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos, "CENTER", 0,0, true, 10, "Сбросить")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos:InitNewButton2(LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                        1, nil, function()
                                                                            LGCH.LangFrame:ClearAllPoints()
                                                                            LGCH.LangFrame:SetPoint("CENTER", nil, "CENTER", 0,0)
                                                                            LGCH_DB.Profiles[UnitName("player")].FramePositions = {LGCH.LangFrame:GetPoint()}
                                                                        end)

    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3, "LEFT", 0,0, false, 13, "Скрыть или показать окно:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3, "TOPLEFT", 0, -15,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    if (LGCH_DB.Profiles[UnitName("player")].IsShown) then
        LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow, "CENTER", 0,0, true, 10, "Скрыть")
    else
        LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow, "CENTER", 0,0, true, 10, "Показать")
    end
    LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:InitNewButton2(LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                        1, nil, function()
                                                                            if (LGCH_DB.Profiles[UnitName("player")].IsShown) then
                                                                                LGCH.LangFrame:Hide()
                                                                                LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow.Text:SetText("Показать")
                                                                            else
                                                                                LGCH.LangFrame:Show()
                                                                                LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow.Text:SetText("Скрыть")
                                                                            end
                                                                            LGCH_DB.Profiles[UnitName("player")].IsShown = not LGCH_DB.Profiles[UnitName("player")].IsShown
                                                                        end)
                                                                        
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4, "LEFT", 0,0, false, 13, "Вы можете переместить окно с языками разблокировав его:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4, "TOPLEFT", 0, -15,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock, "CENTER", 0,0, true, 10, "Разблокировать")

    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock:InitNewButton2(LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                        LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                        1, nil, function()
                                                                            if (LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown) then
                                                                                LGCH.LangFrame.UnlockButton:Hide()
                                                                                LGCH.LangFrame:SetWidth(120)
                                                                                LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown = false
                                                                                LGCH.LangFrame:SetMovable(false)
                                                                                LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock.Text:SetText("Разблокировать")
                                                                            else
                                                                                LGCH.LangFrame.UnlockButton:Show()
                                                                                LGCH.LangFrame:SetWidth(140)
                                                                                LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown = true
                                                                                LGCH.LangFrame:SetMovable(true)
                                                                                LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock.Text:SetText("Заблокировать")
                                                                            end
                                                                        end)







    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2], "TOPLEFT", 35, -20-(LGCH.SettingsWindow.MainPanel.Windows[wi2].Title:GetHeight()),
                                                                1,0,0,0)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1, "LEFT", 0,0, false, 13, "Вы можете отключить/включить определенный язык:")
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton:InitNewFrame2(100, 20,
                                                                        "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1, "TOPLEFT", 0, -15,
                                                                        50, 168, 82, 1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton, "CENTER", 0,0, true, 10, "Включить все")
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton:InitNewButton2(50, 168, 82, 1, 
                                                                                function()
                                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(false)
                                                                                    for i = 1, #LGCH.LangList do
                                                                                        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == false) then
                                                                                            LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = true
                                                                                            LGCH.InitActualLangsList()
                                                                                            LGCH.LangFrame.DropDownList:AddElementByOrder(LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i]), LGCH.LangList[i])
                                                                                            LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i])].CheckButton:SetChecked(true)
                                                                                        end
                                                                                    end
                                                                                    LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.GetDefaultLanguage()) or 1
                                                                                    LGCH.SetLangs()
                                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(true)
                                                                                end)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OffAllButton = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OffAllButton:InitNewFrame2(100, 20,
                                                                        "LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton, "RIGHT", 20, 0,
                                                                        168, 50, 50, 1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OffAllButton:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi2].OffAllButton, "CENTER", 0,0, true, 10, "Отключить все")
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OffAllButton:InitNewButton2(168, 50, 50, 1, 
                                                                                function()
                                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(false)
                                                                                    for i = 1, #LGCH.LangList do
                                                                                        if (LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i])].CheckButton) then
                                                                                            LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i])].CheckButton:SetChecked(false)
                                                                                        end
                                                                                    end
                                                                                    for i = 1, #LGCH.LangList do
                                                                                        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == true) then
                                                                                            LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = false
                                                                                            LGCH.InitActualLangsList()
                                                                                            LGCH.LangFrame.DropDownList:RemoveElementByText(LGCH.LangList[i])
                                                                                        end
                                                                                    end
                                                                                    LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.GetDefaultLanguage()) or 1
                                                                                    LGCH.SetLangs()
                                                                                    LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(true)
                                                                                end)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB = {}

    for i = 1, 18 do
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i] = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:InitNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2]:GetWidth(), 30,
                                            "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton, "TOPLEFT", 0, -(30*i),
                                            0,0,0,0, true, false, nil)
                                            
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:InitNewCheckButton(18, false, "", true, 10, function()end)
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Hide()
    end










    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangRaidCB = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi3])
    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangRaidCB:InitNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi3]:GetWidth(), 30,
                                                                            "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi3], "TOPLEFT", 35, -20-(LGCH.SettingsWindow.MainPanel.Windows[wi3].Title:GetHeight()),
                                                                            0,0,0,0, true, false, nil)
                                            
    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangRaidCB:InitNewCheckButton(18, LGCH_DB.Profiles[UnitName("player")].AutoLangRaid, "Автоматически менять язык в РЕЙДЕ на подходящий", true, 10, function()
        LGCH_DB.Profiles[UnitName("player")].AutoLangRaid = not LGCH_DB.Profiles[UnitName("player")].AutoLangRaid
    end)

    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangPartyCB = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi3])
    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangPartyCB:InitNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi3]:GetWidth(), 30,
                                                                            "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangRaidCB, "TOPLEFT", 0, -30,
                                                                            0,0,0,0, true, false, nil)
                                            
    LGCH.SettingsWindow.MainPanel.Windows[wi3].AutoLangPartyCB:InitNewCheckButton(18, LGCH_DB.Profiles[UnitName("player")].AutoLangParty, "Автоматически менять язык в ГРУППЕ на подходящий", true, 10, function()
        LGCH_DB.Profiles[UnitName("player")].AutoLangParty = not LGCH_DB.Profiles[UnitName("player")].AutoLangParty
    end)
end

function LGCH.RefreshSettings()
    local wi2 = LGCH.SettingsWindow:GetMenuBarButtonIndexByText("Управление языками")
    for i = 1, #LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB do
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Hide()
    end

    for i = 1, #LGCH.LangList do
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Show()
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].Text:SetText(LGCH.LangList[i])
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetChecked(LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]])
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetFunctionOnClick(function()
                LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(false)
                LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = not LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]]
                LGCH.InitActualLangsList()
                if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == false) then
                    LGCH.LangFrame.DropDownList:RemoveElementByText(LGCH.LangList[i])
                else
                    LGCH.LangFrame.DropDownList:AddElementByOrder(LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i]), LGCH.LangList[i])
                end
                LGCH.LangIndex = LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.GetDefaultLanguage()) or 1
                LGCH.SetLangs()
                LGCH.SettingsWindow.MainPanel.Windows[wi2]:EnableMouse(true)
        end)
    end
end
