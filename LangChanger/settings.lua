local AddOnName, Engine = ...
LoutenLib, LGCH = unpack(Engine)

function LGCH.InitNewSettings()
    if (LGCH_DB.Profiles[UnitName("player")].IsShown == nil) then
        LGCH_DB.Profiles[UnitName("player")].IsShown = true
    end
    if (LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown == nil) then
        LGCH_DB.Profiles[UnitName("player")].UnlockButtonIsShown = false
    end

    LGCH.SettingsWindow.MenuBar:AddNewBarButton("Настройка окна")
    LGCH.SettingsWindow.MenuBar:AddNewBarButton("Управление языками", true)
    LGCH_DB.Profiles[UnitName("player")].ActiveLangs = LGCH_DB.Profiles[UnitName("player")].ActiveLangs or {}

    local wi1 = LGCH.SettingsWindow:GetIndexByText("Настройка окна")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -30,
                                                                1,0,0,1)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1, "LEFT", 0,0, false, 14, "Вы можете поменять сторону открытия списка языков:")
    LGCH_DB.Profiles[UnitName("player")].OpenTo = LGCH_DB.Profiles[UnitName("player")].OpenTo or "down"
    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo:InitNewFrame(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info1, "TOPLEFT", 0, -20,
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
    for i = 1, #LGCH.LangList do
        if (LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] == nil) then
            LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]] = true
        end
    end
    

    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].OpenTo, "TOPLEFT", 0, -50,
                                                                1,0,0,1)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2, "LEFT", 0,0, false, 14, "Сбросить позицию окна с языками в центр:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info2, "TOPLEFT", 0, -20,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].ResetPos, "CENTER", 0,0, true, 11, "Сбросить")
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
                                                                1,0,0,1)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3, "LEFT", 0,0, false, 14, "Скрыть или показать окно:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info3, "TOPLEFT", 0, -20,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    if (LGCH_DB.Profiles[UnitName("player")].IsShown) then
        LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow, "CENTER", 0,0, true, 11, "Скрыть")
    else
        LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].HideOrShow, "CENTER", 0,0, true, 11, "Показать")
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
                                                                1,0,0,1)
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4, "LEFT", 0,0, false, 14, "Вы можете переместить окно с языками разблокировав его:")
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi1])
    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock:InitNewFrame2(120, 20,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi1].Info4, "TOPLEFT", 0, -20,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].red,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].green,
                                                                LGCH.SettingsWindow.WindowStylesInRGB[LGCH.SettingsWindow:GetStyle()].blue,
                                                                1, true)

    LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock:SetTextToFrame("CENTER", LGCH.SettingsWindow.MainPanel.Windows[wi1].Unlock, "CENTER", 0,0, true, 11, "Разблокировать")

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






    local wi2 = LGCH.SettingsWindow:GetIndexByText("Управление языками")
    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1 = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2], "TOPLEFT", 35, -30,
                                                                1,0,0,1)
    LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1:SetTextToFrame("LEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1, "LEFT", 0,0, false, 14, "Вы можете отключить/включить определенный язык:")
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton = LoutenLib:CreateNewFrame(LGCH.SettingsWindow.MainPanel.Windows[wi2])
    LGCH.SettingsWindow.MainPanel.Windows[wi2].OnAllButton:InitNewFrame2(100, 20,
                                                                        "TOPLEFT", LGCH.SettingsWindow.MainPanel.Windows[wi2].Info1, "TOPLEFT", 0, -20,
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
                                                                                        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[LoutenLib:IndexOf(LGCH.ActualLangList, LGCH.LangList[i])].CheckButton:SetChecked(false)
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
                                            
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:InitNewCheckButton(23, false, "", true, 11, function()end)
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 15,
        })
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetBackdropBorderColor(1,1,1,.1)
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Hide()
    end
end

function LGCH.RefreshSettings()
    local wi2 = LGCH.SettingsWindow:GetIndexByText("Управление языками")
    for i = 1, #LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB do
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Hide()
    end

    for i = 1, #LGCH.LangList do
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i]:Show()
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].Text:SetText(LGCH.LangList[i])
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetChecked(LGCH_DB.Profiles[UnitName("player")].ActiveLangs[LGCH.LangList[i]])
        LGCH.SettingsWindow.MainPanel.Windows[wi2].LangsCB[i].CheckButton:SetScript("OnClick", function()
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
