local AddOnName, Engine = ...
Engine[1] = {}
Engine[2] = {}
Engine[3] = {}
Engine[4] = {}
Engine[5] = {}
Engine[6] = {}
Engine[7] = {}
Engine[8] = {}
_G[AddOnName] = Engine

local dropdownlists = {}
local streams = {}

Engine[1].LibVersion = "1.2a"



Engine[1].CreateNewFrame = function(s, parent)
    local uiFrame
    if (parent.ScrollChild) then
        uiFrame = CreateFrame("Frame", nil, parent.ScrollChild)
    else
        uiFrame = CreateFrame("Frame", nil, parent)
    end

    function uiFrame:InitNewFrame(  width, height,
                                    point, pointParent, pointTo, pointX, pointY,
                                    redColorBg, greenColorBg, blueColorBg, alphaColorBg,
                                    enableMouse,
                                    movable, functionOnDragStop)

        self:SetSize(width, height)
        if (pointParent) then
            if (pointParent.ScrollChild) then
                self:SetPoint(point, pointParent.ScrollChild, pointTo, pointX, pointY)
            else
                self:SetPoint(point, pointParent, pointTo, pointX, pointY)
            end
        else
            self:SetPoint(point, pointParent, pointTo, pointX, pointY)
        end
        self.Texture = self:CreateTexture()
        self.Texture:SetAllPoints()
        self.Texture:SetTexture(redColorBg, greenColorBg, blueColorBg, alphaColorBg) -- 0.735 alpha = 1 tooltip alpha
        self:EnableMouse(enableMouse)
        self:SetMovable(movable)

        if (movable) then
            self:RegisterForDrag("LeftButton")
            self:SetScript("OnDragStart", self.StartMoving)
            self:SetScript("OnDragStop", function()
                self:StopMovingOrSizing()
                if (functionOnDragStop) then functionOnDragStop() end
            end)
        end
    end

    function uiFrame:InitNewFrame2(  width, height,
                                    point, pointParent, pointTo, pointX, pointY,
                                    redColorBg, greenColorBg, blueColorBg, alphaColorBg,
                                    enableMouse,
                                    movable, functionOnDragStop)
        local function setupColor(color)
            local colorButton
            if (color > 255) then
                colorButton = 1
            else
                colorButton = color/255 - 0.1
                if (colorButton < 0) then colorButton = 0 end
            end
            return colorButton
        end
        redColorBg = setupColor(redColorBg)
        greenColorBg = setupColor(greenColorBg)
        blueColorBg = setupColor(blueColorBg)
        
        self:SetSize(width, height)
        if (pointParent) then
            if (pointParent.ScrollChild) then
                self:SetPoint(point, pointParent.ScrollChild, pointTo, pointX, pointY)
            else
                self:SetPoint(point, pointParent, pointTo, pointX, pointY)
            end
        else
            self:SetPoint(point, pointParent, pointTo, pointX, pointY)
        end
        self.Texture = self:CreateTexture()
        self.Texture:SetAllPoints()
        self.Texture:SetTexture(redColorBg, greenColorBg, blueColorBg, alphaColorBg) -- 0.735 alpha = 1 tooltip alpha
        self:EnableMouse(enableMouse)
        self:SetMovable(movable)

        if (movable) then
            self:RegisterForDrag("LeftButton")
            self:SetScript("OnDragStart", self.StartMoving)
            self:SetScript("OnDragStop", function()
                self:StopMovingOrSizing()
                if (functionOnDragStop) then functionOnDragStop() end
            end)
        end
    end

    function uiFrame:InitNewButton( redColorOnEnter, greenColorOnEnter, blueColorOnEnter, alphaColorOnEnter,
                                    redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alphaColorOnLeave,
                                    redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown, alphaColorOnMouseDown,
                                    redColorOnMouseUp, greenColorOnMouseUp, blueColorOnMouseUp, alphaColorOnMouseUp,
                                    functionOnMouseDown, functionOnMouseUp, functionOnMouseDownRight, functionOnMouseUpRight)

        self:SetScript("OnEnter", function ()
            if (self:IsTexture()) then
                self.Texture:SetTexture(redColorOnEnter, greenColorOnEnter, blueColorOnEnter, alphaColorOnEnter)
            else
                self:SetBackdropColor(redColorOnEnter, greenColorOnEnter, blueColorOnEnter, alphaColorOnEnter)
            end
        end)

        self:SetScript("OnLeave", function ()
            if (not self.IsPressed) then
                if (self:IsTexture()) then
                    self.Texture:SetTexture(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alphaColorOnLeave)
                else
                    self:SetBackdropColor(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alphaColorOnLeave)
                end
            end
        end)

        self:SetScript("OnMouseDown", function (s, b)
            self.IsPressed = true
            if (self:IsTexture()) then
                self.Texture:SetTexture(redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown, alphaColorOnMouseDown)
            else
                self:SetBackdropColor(redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown, alphaColorOnMouseDown)
            end
            if (b == "LeftButton") then  
                if (functionOnMouseDown) then
                    functionOnMouseDown()
                    if (not self:IsShown()) then
                        self.IsPressed = false
                    end
                end
            end
            if (b == "RightButton") then
                if (functionOnMouseDownRight) then
                    functionOnMouseDownRight()
                    if (not self:IsShown()) then
                        self.IsPressed = false
                    end
                end
            end
        end)

        self:SetScript("OnMouseUp", function (s, b)
            self.IsPressed = false
            if (self:IsMouseOver()) then
                self.Texture:SetTexture(redColorOnMouseUp, greenColorOnMouseUp, blueColorOnMouseUp, alphaColorOnMouseUp)
            else
                self.Texture:SetTexture(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alphaColorOnMouseUp)
            end
            if (b == "LeftButton") then if (functionOnMouseUp) then functionOnMouseUp() end end
            if (b == "RightButton") then if (functionOnMouseUpRight) then functionOnMouseUpRight() end end
        end)
    end

    function uiFrame:InitNewButton2(red, green, blue, alpha,
                                    functionOnMouseDown, functionOnMouseUp, functionOnMouseDownRight, functionOnMouseUpRight)
        local  redColorOnEnter, greenColorOnEnter, blueColorOnEnter,
        redColorOnLeave, greenColorOnLeave, blueColorOnLeave,
        redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown,
        redColorOnMouseUp, greenColorOnMouseUp, blueColorOnMouseUp
        local function setupColor(color)
            local colorButton, colorOnEnter, colorOnLeave, colorOnMouseDown, colorOnMouseUp
            if (color > 255) then
                colorButton = 1
            else
                colorButton = color/255 - 0.1
                if (colorButton < 0) then colorButton = 0 end
            end

            colorOnEnter = colorButton + 0.1
            if (colorOnEnter > 1) then colorOnEnter = 1 end

            colorOnLeave = colorButton

            colorOnMouseDown = colorButton + 0.05
            if (colorOnMouseDown < 0) then colorOnMouseDown = 0 end

            colorOnMouseUp = colorButton + 0.1
            if (colorOnMouseUp > 1) then colorOnMouseUp = 1 end

            return colorOnEnter, colorOnLeave, colorOnMouseDown, colorOnMouseUp
        end

        redColorOnEnter, redColorOnLeave, redColorOnMouseDown, redColorOnMouseUp = setupColor(red)
        greenColorOnEnter, greenColorOnLeave, greenColorOnMouseDown, greenColorOnMouseUp = setupColor(green)
        blueColorOnEnter, blueColorOnLeave, blueColorOnMouseDown, blueColorOnMouseUp = setupColor(blue)

        self:SetScript("OnEnter", function ()
            if (self:IsTexture()) then
                self.Texture:SetTexture(redColorOnEnter, greenColorOnEnter, blueColorOnEnter, alpha)
            else
                self:SetBackdropColor(redColorOnEnter, greenColorOnEnter, blueColorOnEnter, alpha)
            end
        end)

        self:SetScript("OnLeave", function ()
            if (not self.IsPressed) then
                if (self:IsTexture()) then
                    self.Texture:SetTexture(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alpha)
                else
                    self:SetBackdropColor(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alpha)
                end
            end
        end)

        self:SetScript("OnMouseDown", function (s, b)
            self.IsPressed = true
            if (self:IsTexture()) then
                self.Texture:SetTexture(redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown, alpha)
            else
                self:SetBackdropColor(redColorOnMouseDown, greenColorOnMouseDown, blueColorOnMouseDown, alpha)
            end
            if (b == "LeftButton") then  
                if (functionOnMouseDown) then
                    functionOnMouseDown()
                    if (not self:IsShown()) then
                        self.IsPressed = false
                    end
                end
            end
            if (b == "RightButton") then
                if (functionOnMouseDownRight) then
                    functionOnMouseDownRight()
                    if (not self:IsShown()) then
                        self.IsPressed = false
                    end
                end
            end
        end)

        self:SetScript("OnMouseUp", function (s, b)
            self.IsPressed = false
            if (self:IsMouseOver()) then
                self.Texture:SetTexture(redColorOnMouseUp, greenColorOnMouseUp, blueColorOnMouseUp, alpha)
            else
                self.Texture:SetTexture(redColorOnLeave, greenColorOnLeave, blueColorOnLeave, alpha)
            end
            if (b == "LeftButton") then if (functionOnMouseUp) then functionOnMouseUp() end end
            if (b == "RightButton") then if (functionOnMouseUpRight) then functionOnMouseUpRight() end end
        end)
    end

    function uiFrame:InitNewInput(  fontSize, maxLetterx,
                                    redFontColor, greenFontColor, blueFontColor, alphaFontColor,
                                    functionOnTextChanged, functionOnEnterPressed)

        self.EditBox = CreateFrame("EditBox", nil, self)
        self.EditBox:SetPoint("CENTER", 0, 0)
        self.EditBox:SetWidth(self:GetWidth() - 16)
        self.EditBox:SetHeight(self:GetHeight() - 2)
        self.EditBox:SetFont("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\fonts\\verdana_normal.ttf", fontSize)
        self.EditBox:SetTextColor(redFontColor, greenFontColor, blueFontColor, alphaFontColor)
        self.EditBox:SetJustifyH("LEFT")
        self.EditBox:EnableMouse(true)
        self.EditBox:SetAutoFocus(false)
        self.EditBox:SetMaxLetters(maxLetterx)
        self.EditBox:SetScript("OnEscapePressed", function ()
            self.EditBox:ClearFocus()
        end)
        self.EditBox:SetScript("OnTextChanged", function ()
            if (functionOnTextChanged) then functionOnTextChanged() end
        end)
        self.EditBox:SetScript("OnEnterPressed", function()
            if (functionOnEnterPressed) then functionOnEnterPressed() end
        end)
    end

    function uiFrame:SetTextToFrame(point, pointParent, pointTo, pointX, pointY,
                                    isTextBold, textSize,
                                    text)
        self.Text = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        self.Text:SetPoint(point, pointParent, pointTo, pointX, pointY)
        self.Text:SetText(text)

        if (isTextBold) then
            self.Text:SetFont("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\fonts\\verdana_bold.ttf", textSize)
        else
            self.Text:SetFont("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\fonts\\verdana_normal.ttf", textSize)
        end
    end

    function uiFrame:InitNewCheckButton(size, setChecked, text, boldText, textSize, functionOnClick)
        self.CheckButton = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        self.CheckButton:SetSize(size, size)
        self.CheckButton:SetPoint("LEFT", self, "LEFT", -3, 0)
        self.CheckButton:SetChecked(setChecked)
        
        if (text) then
            self:SetTextToFrame("LEFT", self, "LEFT", 24, 2, boldText, textSize, text)
            self.Text:SetJustifyH("LEFT")
        end
    
        self.CheckButton:SetScript("OnClick", function()
            if (functionOnClick) then functionOnClick() end
        end)
    end

    function uiFrame:InitNewDropDownList(red, green, blue, alpha, sideToOpen, elementsType, dropDownButtonText, arrayWithElementsText, arrayWithElementsFuncs,
                                            addArrayElementsFuncs, dropDownButtonRightClickFunc, multiplyWidthDropDownList)
        sideToOpen = strlower(sideToOpen)
        multiplyWidthDropDownList = multiplyWidthDropDownList or 1
        if (arrayWithElementsFuncs == nil) then
            arrayWithElementsFuncs = {}
            for i = 1, #arrayWithElementsText do
                arrayWithElementsFuncs[i] = function()end
            end
        end
        if (#arrayWithElementsFuncs < #arrayWithElementsText) then
            for i = #arrayWithElementsFuncs+1, #arrayWithElementsText do
                arrayWithElementsFuncs[i] = function()end
            end
        end
        if (elementsType == "CheckButton") then
            if (addArrayElementsFuncs == nil) then
                addArrayElementsFuncs = {}
                for i = 1, #arrayWithElementsText do
                    addArrayElementsFuncs[i] = false
                end
            end
            if (#arrayWithElementsFuncs < #arrayWithElementsText) then
                for i = #arrayWithElementsFuncs+1, #arrayWithElementsText do
                    addArrayElementsFuncs[i] = false
                end
            end
        end
        self.DropDownButton = Engine[1]:CreateNewFrame(self)
        dropdownlists[#dropdownlists+1] = self
        self.DropDownButton.Arrow = Engine[1]:CreateNewFrame(self.DropDownButton)
        self.DropDownList = Engine[1]:CreateNewFrame(self)
        self.DropDownList.Elements = {}
        self.DropDownList.SideToOpen = sideToOpen
        self.DropDownList.Elements.DisplayOrders = {}



        -- dd funcs
        self.DropDownList.Open = function()
            self.DropDownList:Show()
            
            --------------------
            -- open animation -- 
            if (#self.DropDownList.Elements.DisplayOrders > 0) then
                self.DropDownList.Texture:SetTexture(0,0,0,0)
                self.DropDownButton:EnableMouse(false)
                for i = 1, #self.DropDownList.Elements do
                    self.DropDownList.Elements[i]:EnableMouse(false)
                    self.DropDownList.Elements[i]:SetAlpha(0)
                end

                local animSpeed
                local alpha = 0
                local indexEl = 1
                self:SetScript("OnUpdate", function()
                    self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[indexEl]]:SetAlpha(alpha)
                    if (GetFramerate() < 30) then
                        animSpeed = 3
                    elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                        animSpeed = 1.5
                    else
                        animSpeed = 0.75
                    end
                    -- animation acceleration
                    local animAccel = animSpeed / 100 * #self.DropDownList.Elements.DisplayOrders
                    alpha = alpha + (animSpeed + animAccel)
                    if (alpha >= 1) then
                        self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[indexEl]]:SetAlpha(1)
                        alpha = 0
                        indexEl = indexEl + 1
                        if (indexEl > #self.DropDownList.Elements.DisplayOrders) then
                            self:SetScript("OnUpdate", nil)
                            self.DropDownList.Texture:SetTexture(0,0,0,1)
                            self.DropDownButton:EnableMouse(true)
                            for i = 1, #self.DropDownList.Elements.DisplayOrders do
                                self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:EnableMouse(true)
                            end
                        end
                    end
                end)
            end
            -- open animation --
            --------------------


            if (self.DropDownList.SideToOpen == "up") then
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\movedown.tga")
            elseif (self.DropDownList.SideToOpen == "down") then
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\moveup.tga")
            end
            for i = 1, #dropdownlists do
                if (self ~= dropdownlists[i]) then
                    dropdownlists[i].DropDownList:Hide()
                    dropdownlists[i].DropDownList.Close()
                end
            end
        end
        self.DropDownList.Close = function ()
             ---------------------
            -- close animation -- 
            if (#self.DropDownList.Elements.DisplayOrders > 0) then
                self.DropDownButton:EnableMouse(false)
                self.DropDownList.Texture:SetTexture(0,0,0,0)
                for i = 1, #self.DropDownList.Elements do
                    self.DropDownList.Elements[i]:EnableMouse(false)
                end

                local animSpeed
                local alpha = 1
                local indexEl = #self.DropDownList.Elements.DisplayOrders
                self:SetScript("OnUpdate", function()
                    self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[indexEl]]:SetAlpha(alpha)
                    if (GetFramerate() < 30) then
                        animSpeed = 3
                    elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                        animSpeed = 1.5
                    else
                        animSpeed = 0.75
                    end
                    -- animation acceleration
                    local animAccel = animSpeed / 100 * #self.DropDownList.Elements.DisplayOrders
                    alpha = alpha - (animSpeed + animAccel)
                    if (alpha <= 0) then
                        self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[indexEl]]:SetAlpha(0)
                        alpha = 1
                        indexEl = indexEl - 1
                        if (indexEl < 1) then
                            self:SetScript("OnUpdate", nil)
                            self.DropDownList:Hide()
                            self.DropDownButton:EnableMouse(true)
                            for i = 1, #self.DropDownList.Elements.DisplayOrders do
                                self.DropDownList.Elements[i]:EnableMouse(true)
                            end
                        end
                    end
                end)
            end
            -- close animation --
            ---------------------
            if (self.DropDownList.SideToOpen == "up") then
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\moveup.tga")
            elseif (self.DropDownList.SideToOpen == "down") then
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\movedown.tga")
            end
        end
        self.DropDownList.AddElement = function(s, textElement, funcElement)
            local l = #self.DropDownList.Elements + 1
            self.DropDownList.Elements.DisplayOrders[#self.DropDownList.Elements.DisplayOrders+1] = l
            self.DropDownList.Close()
            self.DropDownList.Elements[l] = Engine[1]:CreateNewFrame(self.DropDownList)
            if (self.DropDownList.SideToOpen == "up") then
                self.DropDownList.Elements[l]:InitNewFrame(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #self.DropDownList.Elements.DisplayOrders,
                                                        "BOTTOM", self.DropDownList, "BOTTOM", 0,2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            elseif (self.DropDownList.SideToOpen == "down") then
                self.DropDownList.Elements[l]:InitNewFrame(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #self.DropDownList.Elements.DisplayOrders,
                                                        "TOP", self.DropDownList, "TOP", 0,-2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            end
            self.DropDownList.Elements[l]:SetTextToFrame("CENTER", self.DropDownList.Elements[l], "CENTER", 0, 0,
            true, self.DropDownButton:GetHeight() / 2.2, textElement)
            self.DropDownList:ChangeSideToOpen(self.DropDownList:GetSideToOpen())

            self.DropDownList.Elements[l]:InitNewButton2(red, green, blue, alpha,
                                                        nil, funcElement)
        end
        self.DropDownList.AddElementByOrder = function(s, indexOrder, textElement, funcElement)
            local l = #self.DropDownList.Elements + 1
            self.DropDownList.Close()
            self.DropDownList.Elements[l] = Engine[1]:CreateNewFrame(self.DropDownList)
            if (self.DropDownList.SideToOpen == "up") then
                self.DropDownList.Elements[l]:InitNewFrame(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #self.DropDownList.Elements.DisplayOrders+1,
                                                        "BOTTOM", self.DropDownList, "BOTTOM", 0,2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            elseif (self.DropDownList.SideToOpen == "down") then
                self.DropDownList.Elements[l]:InitNewFrame(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #self.DropDownList.Elements.DisplayOrders+1,
                                                        "TOP", self.DropDownList, "TOP", 0,-2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            end
            self.DropDownList.Elements[l]:SetTextToFrame("CENTER", self.DropDownList.Elements[l], "CENTER", 0, 0,
            true, self.DropDownButton:GetHeight() / 2.2, textElement)

            if (indexOrder <= #self.DropDownList.Elements.DisplayOrders) then
                local x = #self.DropDownList.Elements.DisplayOrders+1
                while (x > indexOrder) do
                    self.DropDownList.Elements.DisplayOrders[x] = self.DropDownList.Elements.DisplayOrders[x-1]
                    x = x - 1
                end
            end
            self.DropDownList.Elements.DisplayOrders[indexOrder] = l

            self.DropDownList:ChangeSideToOpen(self.DropDownList:GetSideToOpen())

            self.DropDownList.Elements[l]:InitNewButton2(red, green, blue, alpha,
                                                        nil, funcElement)
        end
        self.DropDownList.RemoveElementByText = function(s, textElement)
            textElement = tostring(textElement)
            for i = 1, #self.DropDownList.Elements.DisplayOrders do
                if (self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]].Text:GetText() == textElement) then
                    self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:Hide()
                    self.DropDownList.Elements.DisplayOrders[i] = nil
                end
            end
            self.DropDownList.Elements.DisplayOrders = Engine[1]:ClearNils(self.DropDownList.Elements.DisplayOrders)
            self.DropDownList:ChangeSideToOpen(self.DropDownList:GetSideToOpen())
        end
        self.DropDownList.RemoveElementByIndex = function(s, indexElement)
            if (self.DropDownList.Elements.DisplayOrders[indexElement]) then
                self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[indexElement]]:Hide()
                self.DropDownList.Elements.DisplayOrders[indexElement] = nil
            end
            self.DropDownList.Elements.DisplayOrders = Engine[1]:ClearNils(self.DropDownList.Elements.DisplayOrders)
            self.DropDownList:ChangeSideToOpen(self.DropDownList:GetSideToOpen())
        end
        self.DropDownList.ChangeSideToOpen = function(s, side)
            self.DropDownList:Hide()
            local newMultilpyHeight = #self.DropDownList.Elements.DisplayOrders
            self.DropDownList:SetHeight(self.DropDownButton:GetHeight()*newMultilpyHeight)
            self.DropDownList.SideToOpen = side
            self.DropDownList:ClearAllPoints()
            if (side == "up") then
                self.DropDownList:SetPoint("BOTTOM", self.DropDownButton, "TOP", 0,0)
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\moveup.tga")
            elseif (side == "down") then
                self.DropDownList:SetPoint("TOP", self.DropDownButton, "BOTTOM", 0,0)
                self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\movedown.tga")
            end
            for i = 1, #self.DropDownList.Elements.DisplayOrders do
                self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:SetHeight(self.DropDownList:GetHeight() / newMultilpyHeight)
            end
            self.DropDownList:RefreshByOrder()
        end
        self.DropDownList.GetSideToOpen = function()
            return self.DropDownList.SideToOpen
        end
        self.DropDownList.RefreshByOrder = function()
            for i = 1, #self.DropDownList.Elements.DisplayOrders do
                self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:ClearAllPoints()
                if (self.DropDownList:GetSideToOpen() == "up") then
                    if (i == 1) then
                        self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:SetPoint("BOTTOM", self.DropDownList, "BOTTOM", 0,0)
                    elseif (i > 1) then
                        self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:SetPoint("BOTTOM", self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i-1]], "TOP", 0, 0)
                    end
                elseif (self.DropDownList:GetSideToOpen() == "down") then
                    self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:SetPoint("TOP", self.DropDownList, "TOP", 0,0)
                    if (i > 1) then
                        self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i]]:SetPoint("TOP", self.DropDownList.Elements[self.DropDownList.Elements.DisplayOrders[i-1]], "BOTTOM", 0, 0)
                    end
                end
            end
        end
        -- dd funcs



        self.DropDownButton:InitNewFrame2(self:GetWidth(), self:GetHeight(),
                                            "LEFT", self, "LEFT", 0,0,
                                            red, green, blue, alpha,
                                            true, false)
        self.DropDownButton:InitNewButton2(red, green, blue, alpha, nil,
                function()
                    if (self.DropDownList:IsShown()) then
                        self.DropDownList.Close()
                    else
                        self.DropDownList.Open()
                    end
                end, nil, dropDownButtonRightClickFunc)
        self.DropDownButton:SetTextToFrame("CENTER", self.DropDownButton, "CENTER", 0,0, true, self.DropDownButton:GetHeight() / 2.1, dropDownButtonText)
        self.DropDownButton.Arrow:InitNewFrame(self.DropDownButton:GetHeight()/1.5, self.DropDownButton:GetHeight()/1.5,
                                                "RIGHT", self.DropDownButton, "RIGHT", -(self.DropDownButton:GetHeight()*0.1), 0,
                                                0,0,0,0,
                                                false, false, nil)
        if (sideToOpen == "up") then
            self.DropDownList:InitNewFrame2(self:GetWidth() * multiplyWidthDropDownList, self:GetHeight() * #arrayWithElementsText + 4,
                                            "BOTTOM", self.DropDownButton, "TOP", 0,0,
                                            0,0,0, 1,
                                            true, false)
            self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\moveup.tga")
        elseif (sideToOpen == "down") then
            self.DropDownList:InitNewFrame2(self:GetWidth() * multiplyWidthDropDownList, self:GetHeight() * #arrayWithElementsText + 4,
                                            "TOP", self.DropDownButton, "BOTTOM", 0,0,
                                            0,0,0, 1,
                                            true, false)
            self.DropDownButton.Arrow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\movedown.tga")
        end
        
        self.DropDownList:Hide()



        for i = 1, #arrayWithElementsText do
            self.DropDownList.Elements[i] = Engine[1]:CreateNewFrame(self.DropDownList)
            self.DropDownList.Elements[i].DisplayOrder = i
            self.DropDownList.Elements.DisplayOrders[i] = i

            if (self.DropDownList.SideToOpen == "up") then
                self.DropDownList.Elements[i]:InitNewFrame2(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #arrayWithElementsText,
                                                        "BOTTOM", self.DropDownList, "BOTTOM", 0,2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            elseif (self.DropDownList.SideToOpen == "down") then
                self.DropDownList.Elements[i]:InitNewFrame2(self.DropDownList:GetWidth()-2, self.DropDownList:GetHeight() / #arrayWithElementsText,
                                                        "TOP", self.DropDownList, "TOP", 0,-2,
                                                        red, green, blue, alpha,
                                                        true, false, nil)
            end

            if (i > 1) then
                if (self.DropDownList.SideToOpen == "up") then
                    self.DropDownList.Elements[i]:SetPoint("BOTTOM", self.DropDownList.Elements[i-1], "TOP", 0, 0)
                elseif (self.DropDownList.SideToOpen == "down") then
                    self.DropDownList.Elements[i]:SetPoint("TOP", self.DropDownList.Elements[i-1], "BOTTOM", 0, 0)
                end
            end

            if (elementsType == "Button") then
                self.DropDownList.Elements[i]:SetTextToFrame("CENTER", self.DropDownList.Elements[i], "CENTER", 0, 0,
                                                            true, self.DropDownButton:GetHeight() / 2.2, arrayWithElementsText[i])
                self.DropDownList.Elements[i]:InitNewButton2(red, green, blue, alpha,
                                                        nil, arrayWithElementsFuncs[i])
            end

            if (elementsType == "CheckButton") then
                self.DropDownList.Elements[i]:InitNewCheckButton(self:GetHeight()*1.1, addArrayElementsFuncs[i], arrayWithElementsText[i], true, self.DropDownButton:GetHeight() / 2.2, arrayWithElementsFuncs[i])
            end
        end
    end

    function uiFrame:WipeDropDownList()
        for i = 1, #dropdownlists do
            if (self == dropdownlists[i]) then
                dropdownlists[i]:Hide()
                wipe(dropdownlists[i])
                dropdownlists[i] = nil
            end
        end
    end

    function uiFrame:AddScrollToFrame()
        self:EnableMouseWheel(true)
    
        self.ScrollFrame = CreateFrame("ScrollFrame", nil, self)
        self.ScrollChild = CreateFrame("Frame")
        self.ScrollBar = CreateFrame("Slider", nil, self.ScrollFrame, "MinimalScrollBarTemplate")
        
        self.ScrollBar:SetPoint("RIGHT", self, "RIGHT", -5, 0)
        self.ScrollBar:SetSize(10, self:GetHeight() - 40)
        self.ScrollBar:SetMinMaxValues(0, 10)
        self.ScrollBar:SetValue(0)
        self.ScrollBar:SetValueStep(1)
        self.ScrollBar:SetOrientation('VERTICAL')
        self.ScrollBar:SetFrameLevel(self.ScrollBar:GetFrameLevel()+20)

        self.ScrollFrame:SetScrollChild(self.ScrollChild)

        self.ScrollFrame:SetAllPoints(self)
    
        self.ScrollChild:SetWidth(self.ScrollFrame:GetWidth()-10)
        self.ScrollChild:SetHeight(self.ScrollFrame:GetHeight())
        
    
        self:SetScript("OnMouseWheel", function (s, delta)
            self.ScrollBar:SetValue(self.ScrollBar:GetValue() - delta * 20)
            self.ScrollBar:SetMinMaxValues(0, self.ScrollFrame:GetVerticalScrollRange())
        end)

        self.ScrollBar:SetScript("OnMouseDown", function (s, mouseButtonClick)
            self.ScrollBar:SetMinMaxValues(0, self.ScrollFrame:GetVerticalScrollRange())
        end)
    end

    function uiFrame:TextureToBackdrop(addBorders, bordersSize, insets, borderColorRed, borderColorGreen, borderColorBlue, borderColorAlpha,
                                        backdropColorRed, backdropColorGreen, backdropColorBlue, backdropColorAlpha)
        self.Texture:ClearAllPoints()
        self.Texture = nil

        if (addBorders) then
            self:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = bordersSize,
                insets = {left = insets, right = insets, top = insets, bottom = insets},
            });
            self:SetBackdropColor(backdropColorRed,backdropColorGreen,backdropColorBlue,backdropColorAlpha);
            self:SetBackdropBorderColor(borderColorRed, borderColorGreen, borderColorBlue, borderColorAlpha);
        else
            self:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            })
            self:SetBackdropColor(backdropColorRed,backdropColorGreen,backdropColorBlue,backdropColorAlpha);
        end
    end

    function uiFrame:BackdropToTexture(redColorBg, greenColorBg, blueColorBg, alphaColorBg)
        self:SetBackdropColor(0,0,0,0)
        self:SetBackdropBorderColor(0,0,0,0)
        self:SetBackdrop({
            bgFile = nil,
            edgeFile = nil,
            edgeSize = nil,
            insets = nil,
        })

        self.Texture = self:CreateTexture()
        self.Texture:SetAllPoints()
        self.Texture:SetTexture(redColorBg, greenColorBg, blueColorBg, alphaColorBg) -- 0.735 alpha = 1 tooltip alpha
    end

    function uiFrame:IsTexture()
        if (self.Texture) then
            return true
        else
            return false
        end
    end

    return uiFrame
end

Engine[1].DelayAction = function(s, time, func, cancelSameFunc)
    local startTime = GetTime()
    local endTime = startTime + time

    if (#streams > 0) then
        if (cancelSameFunc) then
            for i = 1, #streams do
                if (streams[i]) then
                    if (streams[i].fn == func) then
                        streams[i].f:SetScript("OnUpdate", nil)
                        streams[i] = nil
                    end
                end
            end
        end
    end

    streams[#streams+1] = { f = CreateFrame("Frame"), t = startTime, fn = func}

    for i = 1, #streams do
        if (streams[i]) then
            if (streams[i].t == startTime) then
                streams[i].f:SetScript("OnUpdate", function()
                    if (GetTime() >= endTime) then
                        streams[i].f:SetScript("OnUpdate", nil)
                        table.wipe(streams[i].f)
                        streams[i].f = nil
                        streams[i].t = nil
                        table.wipe(streams[i])
                        streams[i] = nil
                        func()
                        return 1
                    end
                end)
            end
        end
    end
end

Engine[1].IndexOf = function(s, table, item)
    for key, value in ipairs(table) do
        if (value == item) then
            return key
        end
    end
    return nil
end

Engine[1].ClearNils = function(s, table)
    local t = {}
    for _,v in pairs(table) do
        t[#t+1] = v
    end
    return t
end

Engine[1].FindingDiffInTwoArray = function(s, table1, table2)
    local t = {}
    local mainTable
    local secondTable
    if (#table1 > #table2) then mainTable = table1 secondTable = table2 else mainTable = table2 secondTable = table1 end

    for _, value in ipairs(mainTable) do
        if (Engine[1]:IndexOf(secondTable, value) == nil) then
            t[#t+1] = value
        end
    end
    return t
end

Engine[1].RGBToWowColors = function(s, color)
    local colorButton
    if (color > 255) then
        colorButton = 1
    else
        colorButton = color/255 - 0.1
        if (colorButton < 0) then colorButton = 0 end
    end
    print(colorButton)
    return colorButton
end





Engine[1].InitAddon = function(s, fileName, name, version)
    Engine[2].Info = {}
    Engine[2].Info.FileName = fileName
    Engine[2].Info.Name = name
    Engine[2].Info.Version = version

    Engine[2].ChatPrefix = {}
    Engine[2].ChatPrefix.Color = "2499ed"
    Engine[2].ChatPrefix.Prefix = "|cff"..Engine[2].ChatPrefix.Color.."["..Engine[2].Info.Name.."]|r"

    ----------
    -- Chat --
    Engine[2].SetChatPrefixColor = function(self, hex)
        self.ChatPrefix.Color = hex
        self.ChatPrefix.Prefix = "|cff"..self.ChatPrefix.Color.."["..Engine[2].Info.Name.."]|r"
    end

    Engine[2].GetChatPrefixColor = function(self)
        return self.ChatPrefix.Color
    end

    Engine[2].PrintMsg = function(self, msg, msgColor)
        if (msgColor) then
            print(self.ChatPrefix.Prefix.." |cff"..msgColor..msg.."|r")
        else
            print(self.ChatPrefix.Prefix.." "..msg)
        end
    end
    -- Chat --
    ----------
    
    --------------------
    -- Addon Revision --
    Engine[2].SetRevision = function(self, year, month, day, major, minor, maintenance)
        self.Info.Revision = year..month..day..major..minor..maintenance
    end
    -- Addon Revision --
    --------------------

    --------------------------------
    -- Check Actual Addon Version --
    
        -- когда нибудь я сюда вернусь и перестану удалять код...

    -- Check Actual Addon Version --
    --------------------------------

    ------------------
    -- Addon Loaded --
    Engine[2].LoadedFunction = function(self, func)
        print("")
        Engine[2]:PrintMsg("Аддон загружен: v"..Engine[2].Info.Version, "a9ffa6")
        Engine[2].LoadedFunc = func
        Engine[2].LoadedFunc()
    end
    Engine[2].LoadedFunc = nil
    -- Engine[2].Loaded = CreateFrame("Frame")
    -- Engine[2].Loaded:RegisterEvent("PLAYER_LOGIN")
    -- Engine[2].Loaded:SetScript("OnEvent", function(s, event, addOnName)
        -- if (addOnName == Engine[2].Info.FileName) then
        --     print("")
        --     Engine[2]:PrintMsg("Аддон загружен: v"..Engine[2].Info.Version, "a9ffa6")
        --     if (Engine[2].LoadedFunction) then Engine[2].LoadedFunc() end
        -- end
    -- end)
    -- Addon Loaded --
    ------------------



    ------------------
    -- Notification --
    local notifWidth = 350
    local notifHeight = 140
    Engine[2].Notification = Engine[1]:CreateNewFrame(UIParent)
    Engine[2].Notification:InitNewFrame(notifWidth, notifHeight,
                                    "BOTTOMRIGHT", nil, "BOTTOMRIGHT", -20, 20,
                                    0, 0, 0, 0.788,
                                    true, false, nil)
    Engine[2].Notification:Hide()
    Engine[2].Notification:SetFrameStrata("TOOLTIP")
    Engine[2].Notification.Header = Engine[1]:CreateNewFrame(Engine[2].Notification)
    Engine[2].Notification.Header:InitNewFrame(Engine[2].Notification:GetWidth(), Engine[2].Notification:GetHeight() * 0.15,
                                            "TOP", Engine[2].Notification, "TOP", 0, 0,
                                            0,0,0,1,
                                            true, false, nil)
    Engine[2].Notification.Content = Engine[1]:CreateNewFrame(Engine[2].Notification)
    Engine[2].Notification.Content:InitNewFrame(notifWidth * 0.95, (notifHeight - Engine[2].Notification.Header:GetHeight()) * 0.80,
                                                "TOP", Engine[2].Notification, "TOP", 0, -(Engine[2].Notification.Header:GetHeight()) - 7,
                                                0,0,0,0,
                                                false, false, nil)
    Engine[2].Notification.Content:SetTextToFrame("TOPLEFT", Engine[2].Notification.Content, "TOPLEFT", 0,0, true, 11, "")
    Engine[2].Notification.Content.Text:SetWidth(Engine[2].Notification.Content:GetWidth())
    Engine[2].Notification.Content.Text:SetJustifyH("LEFT")
    Engine[2].Notification.Header.Title = Engine[1]:CreateNewFrame(Engine[2].Notification.Header)
    Engine[2].Notification.Header.Title:SetTextToFrame("LEFT", Engine[2].Notification.Header, "LEFT", 5, 0, true, 12, Engine[2].ChatPrefix.Prefix.." Уведомление!")
    Engine[2].Notification.Header.CloseButton = Engine[1]:CreateNewFrame(Engine[2].Notification.Header)
    Engine[2].Notification.Header.CloseButton:InitNewFrame(Engine[2].Notification.Header:GetHeight(), Engine[2].Notification.Header:GetHeight(),
                                                        "RIGHT", Engine[2].Notification.Header, "RIGHT", 0, 0,
                                                        .05, .05, .05, 1,
                                                        true, false, nil)
    Engine[2].Notification.Header.CloseButton:SetTextToFrame("CENTER", Engine[2].Notification.Header.CloseButton, "CENTER", 0, 0, true, 11, "x")
    local notifAnimF = CreateFrame("Frame")
    local function notificationHide()
        notifAnimF:SetScript("OnUpdate", nil)
        Engine[2].Notification:SetHeight(notifHeight)
        Engine[2].Notification.Header.CloseButton.Texture:SetTexture(.05, .05, .05, 1)
        Engine[2].Notification:ClearAllPoints()
        Engine[2].Notification:SetPoint("BOTTOMRIGHT", nil, "BOTTOMRIGHT", notifWidth, 20)
        Engine[2].Notification:Hide()
    end
    local notifAnimCloseF = CreateFrame("Frame")
    local function notificationClose()
        Engine[2].Notification.Content:Hide()
        Engine[2].Notification.Content.AcceptButton:Hide()
        Engine[2].Notification.Content.DeclineButton:Hide()
        local h = Engine[2].Notification:GetHeight()
        notifAnimCloseF:SetScript("OnUpdate", function()
            if (GetFramerate() < 30) then
                h = h - 15
            elseif (GetFramerate() >= 30 and GetFramerate() < 60) then
                h = h - 10
            elseif (GetFramerate() >= 60) then
                h = h - 5
            end
            Engine[2].Notification:SetHeight(h)
            if (Engine[2].Notification:GetHeight() <= Engine[2].Notification.Header:GetHeight()) then
                notifAnimCloseF:SetScript("OnUpdate", nil)
                notificationHide()
            end
        end)
    end
    Engine[2].Notification.Header.CloseButton:InitNewButton(.1, .1, .1, 1,
                                                        .05, .05, .05, 1,
                                                        .1, .1, .1, 1,
                                                        .1, .1, .1, 1,
                                                        notificationClose, nil)

    Engine[2].Notification.Content.AcceptButton = Engine[1]:CreateNewFrame(Engine[2].Notification.Content)
    Engine[2].Notification.Content.AcceptButton:InitNewFrame(75, 23,
                                                        "BOTTOM", Engine[2].Notification, "BOTTOM", -60, 0,
                                                        .25,1,.38,1, true, false, nil)
    Engine[2].Notification.Content.AcceptButton:SetTextToFrame("CENTER", Engine[2].Notification.Content.AcceptButton, "CENTER", 0,0, true, 12, "Принять")
    Engine[2].Notification.Content.AcceptButton:InitNewButton(.35,1,.48,1,
                                                            .25,1,.38,1,
                                                            .15,.85,.28,1,
                                                            .35,1,.48,1,
                                                            nil, nil)
    Engine[2].Notification.Content.DeclineButton = Engine[1]:CreateNewFrame(Engine[2].Notification.Content)
    Engine[2].Notification.Content.DeclineButton:InitNewFrame(75, 23,
                                                        "BOTTOM", Engine[2].Notification, "BOTTOM", 60, 0,
                                                        .9,.2,.2,1, true, false, nil)
    Engine[2].Notification.Content.DeclineButton:SetTextToFrame("CENTER", Engine[2].Notification.Content.DeclineButton, "CENTER", 0,0, true, 12, "Отклонить")
    Engine[2].Notification.Content.DeclineButton:InitNewButton(.9,.3,.3,1,
                                                            .9,.2,.2,1,
                                                            .8,.2,.2,1,
                                                            .9,.3,.3,1,
                                                            nil, nil)
    Engine[2].Notification.Content.AcceptButton:Hide()
    Engine[2].Notification.Content.DeclineButton:Hide()
    local function notificationShow()
        notificationHide()
        Engine[2].Notification:Show()
        Engine[2].Notification.Content.Text:Show()
        Engine[2].Notification.Content:Show()
        local x = Engine[2].Notification:GetWidth()
        notifAnimF:SetScript("OnUpdate", function()
            if (GetFramerate() < 30) then
                x = x - 40
            elseif (GetFramerate() >= 30 and GetFramerate() < 60) then
                x = x - 30
            elseif (GetFramerate() >= 60) then
                x = x - 20
            end
            Engine[2].Notification:ClearAllPoints()
            Engine[2].Notification:SetPoint("BOTTOMRIGHT", nil, "BOTTOMRIGHT", x, 20)
            if (x <= -20) then
                notifAnimF:SetScript("OnUpdate", nil)
                Engine[2].Notification:SetPoint("BOTTOMRIGHT", nil, "BOTTOMRIGHT", -20, 20)
            end
        end)
    end

    Engine[2].Notify = function(self, text, isChooser, acceptFunc, declineFunc)
        self.Notification.Content.Text:SetText(text)
        if (isChooser) then
            Engine[2].Notification.Content.AcceptButton:Show()
            Engine[2].Notification.Content.AcceptButton:SetScript("OnMouseDown", function()
                if (acceptFunc) then acceptFunc() end
                acceptFunc()
            end)
            Engine[2].Notification.Content.DeclineButton:Show()
            Engine[2].Notification.Content.DeclineButton:SetScript("OnMouseDown", function()
                if (declineFunc) then declineFunc() end
            end)
        end
        notificationShow()
        Engine[1]:DelayAction(10, notificationClose, true)
    end

    Engine[2].NotifyForceClose = function(self)
        notificationClose()
    end
    -- Notification --
    ------------------

    ------------------
    -- Data Storage --
    Engine[2].SetDataStorage = function(self, DB)
        Engine[2].DBCopy = DB
    end

    --------------
    -- Settings --
    Engine[2].SettingsWindow = Engine[1]:CreateNewFrame(UIParent)
    Engine[2].SettingsWindow.Width = 800
    Engine[2].SettingsWindow.Height = 570
    Engine[2].SettingsWindow.IsFirstOpen = true
    Engine[2].SettingsWindow:SetFrameStrata("HIGH")
    Engine[2].SettingsWindow.WindowStylesInRGB =
    {
        ["red"] = {
            red = 112, green = 4, blue = 4
        },
        ["green"] = {
            red = 4, green = 112, blue = 39
        },
        ["blue"] = {
            red = 26, green = 8, blue = 117
        },
        ["black"] = {
            red = 13, green = 13, blue = 13
        },
        ["white"] = {
            red = 230, green = 230, blue = 230
        },
        ["gold"] = {
            red = 225, green = 190, blue = 1
        },
        ["violet"] = {
            red = 121, green = 0, blue = 181
        }
    }
    Engine[2].SettingsWindow.WindowStyle = "violet"
    Engine[2].SettingsWindow.GetStyle = function()
        return Engine[2].SettingsWindow.WindowStyle
    end
    Engine[2].SettingsWindow.AddStyle = function(s, styleName, red, green, blue)
        if (Engine[2].SettingsWindow.WindowStylesInRGB[styleName]) then return end
        Engine[2].SettingsWindow.WindowStylesInRGB[styleName] = {
            red = red, green = green, blue = blue
        }
    end
    Engine[2].SettingsWindow.ChangeStyle = function(s, style)
        Engine[2].SettingsWindow.WindowStyle = style
    end
    Engine[2].SettingsWindow:InitNewFrame(Engine[2].SettingsWindow.Width, Engine[2].SettingsWindow.Height,
                                        "CENTER", nil, "CENTER", 0, 0,
                                        0, 0, 0, .735,
                                        true, true)
    Engine[2].SettingsWindow.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\settings_bg.blp")

    Engine[2].SettingsWindow.Header = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow)
    Engine[2].SettingsWindow.Header:InitNewFrame2(Engine[2].SettingsWindow:GetWidth(), Engine[2].SettingsWindow:GetHeight() * 0.042,
                                                "TOP", Engine[2].SettingsWindow, "TOP", 0, 0,
                                                Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red,
                                                Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green,
                                                Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue,
                                                1)
    Engine[2].SettingsWindow.Header.Title = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.Header)
    Engine[2].SettingsWindow.Header.Title:SetTextToFrame("CENTER", Engine[2].SettingsWindow.Header, "CENTER", 0, -1, true, 12, Engine[2].Info.Name)
    if (Engine[2].SettingsWindow:GetStyle() == "white") then
        Engine[2].SettingsWindow.Header.Title.Text:SetTextColor(0,0,0)
    end
    Engine[2].SettingsWindow.Header.CloseButton = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.Header)
    Engine[2].SettingsWindow.Header.CloseButton:InitNewFrame(Engine[2].SettingsWindow.Header:GetHeight(), Engine[2].SettingsWindow.Header:GetHeight(),
                                                            "RIGHT", Engine[2].SettingsWindow.Header, "RIGHT", 0, 0,
                                                            0, 0, 0, 0,
                                                            true)
    Engine[2].SettingsWindow.Header.CloseButton:SetTextToFrame("CENTER", Engine[2].SettingsWindow.Header.CloseButton, "CENTER", 0, 1, true, 15, "x")
    Engine[2].SettingsWindow.Header.CloseButton:InitNewButton2(0,0,0,0,
                                                            function()
                                                                -- Engine[2].SettingsWindow:Hide()
                                                                Engine[2].SettingsWindow:Close()
                                                            end)
        -- menu bar
    Engine[2].SettingsWindow.MenuBar = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow)
    Engine[2].SettingsWindow.MenuBar:InitNewFrame2(Engine[2].SettingsWindow:GetWidth()*0.23, Engine[2].SettingsWindow:GetHeight()-Engine[2].SettingsWindow.Header:GetHeight()-10,
                                                    "LEFT", Engine[2].SettingsWindow, "LEFT", 10, -8,
                                                    9,9,9,1, true)
    Engine[2].SettingsWindow.MenuBar:SetFrameLevel(Engine[2].SettingsWindow.MenuBar:GetFrameLevel()-1)
    -- Engine[2].SettingsWindow.MenuBar.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\textures\\settings_bg.blp")
    -- Engine[2].SettingsWindow.MenuBar.Texture:SetVertexColor(.1,.1,.1,1)

        -- main panel
    Engine[2].SettingsWindow.MainPanel = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow)
    Engine[2].SettingsWindow.MainPanel:InitNewFrame(Engine[2].SettingsWindow:GetWidth()*0.731, Engine[2].SettingsWindow:GetHeight()-Engine[2].SettingsWindow.Header:GetHeight()-10,
                                                    "RIGHT", Engine[2].SettingsWindow, "RIGHT", -10, -8,
                                                    .035,.035,.035,1, true)
    Engine[2].SettingsWindow.MainPanel:SetFrameLevel(Engine[2].SettingsWindow.MainPanel:GetFrameLevel()-1)
    Engine[2].SettingsWindow.MainPanel:Hide()
    -- LoutenLib Animation 
    Engine[2].SettingsWindow.MainPanel.Animation = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.MainPanel)
    Engine[2].SettingsWindow.MainPanel.Animation:InitNewFrame(Engine[2].SettingsWindow.MainPanel:GetWidth(), Engine[2].SettingsWindow.MainPanel:GetHeight(),
                                                                "CENTER", Engine[2].SettingsWindow.MainPanel, "CENTER", 0,0,
                                                                1,1,1,1)
    Engine[2].SettingsWindow.MainPanel.Animation.Time = GetTime()
    Engine[2].SettingsWindow.MainPanel.Animation.Frame = 0
    Engine[2].SettingsWindow.MainPanel.Animation.Interval = 0
    Engine[2].SettingsWindow.MainPanel.Animation:SetScript("OnUpdate", function ()
        if (GetTime() >= Engine[2].SettingsWindow.MainPanel.Animation.Time + Engine[2].SettingsWindow.MainPanel.Animation.Interval) then
            Engine[2].SettingsWindow.MainPanel.Animation.Texture:SetTexture("Interface\\AddOns\\"..Engine[2].Info.FileName.."\\libs\\LoutenLib\\Animations\\Settings\\Frames\\"..Engine[2].SettingsWindow.MainPanel.Animation.Frame..".blp")
            Engine[2].SettingsWindow.MainPanel.Animation.Frame = Engine[2].SettingsWindow.MainPanel.Animation.Frame + 1
            if (Engine[2].SettingsWindow.MainPanel.Animation.Frame == 88) then
                Engine[2].SettingsWindow.MainPanel.Animation.Frame = 0
            end
            if (Engine[2].SettingsWindow.MainPanel.Animation.Frame == 62) then
                Engine[2].SettingsWindow.MainPanel.Animation.Interval = 7
            else
                Engine[2].SettingsWindow.MainPanel.Animation.Interval = 0.024
            end
            Engine[2].SettingsWindow.MainPanel.Animation.Time = GetTime()
        end
    end)



        -- functions
    Engine[2].SettingsWindow.MenuBar.ButtonsWidth = Engine[2].SettingsWindow.MenuBar:GetWidth()
    Engine[2].SettingsWindow.MenuBar.ButtonsHeight = 30
    Engine[2].SettingsWindow.MenuBar.ButtonFontHeight = 11
    Engine[2].SettingsWindow.MenuBar.AddNewBarButton = function(s, buttonText, addScroll)
        Engine[2].SettingsWindow.MenuBar.Buttons = Engine[2].SettingsWindow.MenuBar.Buttons or {}
        local i = #Engine[2].SettingsWindow.MenuBar.Buttons + 1

        Engine[2].SettingsWindow.MenuBar.Buttons[i] = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.MenuBar)
        if (i == 1) then
            Engine[2].SettingsWindow.MenuBar.Buttons[i]:InitNewFrame2(Engine[2].SettingsWindow.MenuBar.ButtonsWidth, Engine[2].SettingsWindow.MenuBar.ButtonsHeight,
                                                                        "TOP", Engine[2].SettingsWindow.MenuBar, "TOP", 0, -10,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue,
                                                                        1, true)
        else
            Engine[2].SettingsWindow.MenuBar.Buttons[i]:InitNewFrame2(Engine[2].SettingsWindow.MenuBar:GetWidth(), 33,
                                                                        "TOP", Engine[2].SettingsWindow.MenuBar.Buttons[i-1], "BOTTOM", 0, -5,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green,
                                                                        Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue,
                                                                        1, true)
        end
        Engine[2].SettingsWindow.MenuBar.Buttons[i]:InitNewButton2(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red,
                                                                    Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green,
                                                                    Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue,
                                                                    1,
                                                                    function()
                                                                        for i = 1, #Engine[2].SettingsWindow.MainPanel.Windows do
                                                                            Engine[2].SettingsWindow.MainPanel.Windows[i]:Hide()
                                                                        end
                                                                        Engine[2].SettingsWindow.MainPanel:Show()
                                                                        Engine[2].SettingsWindow.MainPanel.Windows[i]:Show()
                                                                        Engine[2].SettingsWindow.MainPanel.Animation:SetAlpha(.2)
                                                                    end)
        Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetTextToFrame("CENTER", Engine[2].SettingsWindow.MenuBar.Buttons[i], "CENTER", 0, 1, true, Engine[2].SettingsWindow.MenuBar.ButtonFontHeight, buttonText)
        if (Engine[2].SettingsWindow:GetStyle() == "white") then
            Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:SetTextColor(0,0,0)
        end


        Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnEnter", function()
            local function setupColor(color)
                local colorButton, colorOnEnter, colorOnLeave
                if (color > 255) then
                    colorButton = 1
                else
                    colorButton = color/255 - 0.1
                    if (colorButton < 0) then colorButton = 0 end
                end
    
                colorOnEnter = colorButton + 0.1
                if (colorOnEnter > 1) then colorOnEnter = 1 end
    
                return colorOnEnter
            end

            if (Engine[2].SettingsWindow.MenuBar.Buttons[i]:IsTexture()) then
                Engine[2].SettingsWindow.MenuBar.Buttons[i].Texture:SetTexture(
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red), 
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green), 
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue), 1)
            else
                Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetBackdropColor(
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red), 
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green), 
                    setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue), 1)
            end

            local fontName = Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:GetFont()
            local fontHeight = Engine[2].SettingsWindow.MenuBar.ButtonFontHeight
            local w, h = Engine[2].SettingsWindow.MenuBar.ButtonsWidth+15, Engine[2].SettingsWindow.MenuBar.ButtonsHeight+15
            local animSpeed = 0
            Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnUpdate", function()
                if (GetFramerate() < 10) then
                    animSpeed = 20
                elseif (GetFramerate() < 30 and GetFramerate() >= 10) then
                    animSpeed = 40
                elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                    animSpeed = 60
                else
                    animSpeed = 100
                end
                Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetWidth(Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetWidth() + (w / animSpeed))
                Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetHeight(Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetHeight() + (h / animSpeed)*6.60)
                if (Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetHeight() >= h) then
                    Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnUpdate", nil)
                    Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetSize(w, h)
                    Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:SetFont(fontName, fontHeight+1)
                end
            end)
        end)
        Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnLeave", function()
            local function setupColor(color)
                local colorButton, colorOnLeave
                if (color > 255) then
                    colorButton = 1
                else
                    colorButton = color/255 - 0.1
                    if (colorButton < 0) then colorButton = 0 end
                end

                colorOnLeave = colorButton
    
                return colorOnLeave
            end

            if (not Engine[2].SettingsWindow.MenuBar.Buttons[i].IsPressed) then
                if (Engine[2].SettingsWindow.MenuBar.Buttons[i]:IsTexture()) then
                    Engine[2].SettingsWindow.MenuBar.Buttons[i].Texture:SetTexture(
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red), 
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green), 
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue), 1)
                else
                    Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetBackdropColor(
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].red), 
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].green), 
                        setupColor(Engine[2].SettingsWindow.WindowStylesInRGB[Engine[2].SettingsWindow.WindowStyle].blue), 1)
                end
            end

            local fontName = Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:GetFont()
            local fontHeight = Engine[2].SettingsWindow.MenuBar.ButtonFontHeight
            local w, h = Engine[2].SettingsWindow.MenuBar.ButtonsWidth, Engine[2].SettingsWindow.MenuBar.ButtonsHeight
            local animSpeed = 0
            
            Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnUpdate", function()
                if (GetFramerate() < 10) then
                    animSpeed = 20
                elseif (GetFramerate() < 30 and GetFramerate() >= 10) then
                    animSpeed = 40
                elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                    animSpeed = 60
                else
                    animSpeed = 100
                end
                Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetWidth(Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetWidth() - (w / animSpeed))
                Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetHeight(Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetHeight() - (h / animSpeed)*6.66)
                if (Engine[2].SettingsWindow.MenuBar.Buttons[i]:GetHeight() <= h) then
                    Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetScript("OnUpdate", nil)
                    Engine[2].SettingsWindow.MenuBar.Buttons[i]:SetSize(w, h)
                    Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:SetFont(fontName, fontHeight)
                end
            end)
        end)
        Engine[2].SettingsWindow.MainPanel:AddNewPanelWindow(addScroll)
    end
    Engine[2].SettingsWindow.MainPanel.AddNewPanelWindow = function(s, addScroll)
        Engine[2].SettingsWindow.MainPanel.Windows = Engine[2].SettingsWindow.MainPanel.Windows or {}
        local i = #Engine[2].SettingsWindow.MainPanel.Windows + 1

        Engine[2].SettingsWindow.MainPanel.Windows[i] = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.MainPanel)
        Engine[2].SettingsWindow.MainPanel.Windows[i]:InitNewFrame(Engine[2].SettingsWindow.MainPanel:GetWidth()-5, Engine[2].SettingsWindow.MainPanel:GetHeight()-5,
                                                    "CENTER", Engine[2].SettingsWindow.MainPanel, "CENTER", 0,0,
                                                    0,0,0,0, true)
        Engine[2].SettingsWindow.MainPanel.Windows[i].Title = Engine[1]:CreateNewFrame(Engine[2].SettingsWindow.MainPanel.Windows[i])
        Engine[2].SettingsWindow.MainPanel.Windows[i].Title:InitNewFrame(200, 50,
                                                                        "TOP", Engine[2].SettingsWindow.MainPanel.Windows[i], "TOP", 0,0,
                                                                        0,0,0,0)
        Engine[2].SettingsWindow.MainPanel.Windows[i].Title:SetTextToFrame("CENTER", Engine[2].SettingsWindow.MainPanel.Windows[i].Title, "CENTER", 0,0, true, 16, Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:GetText())
        if (addScroll) then Engine[2].SettingsWindow.MainPanel.Windows[i]:AddScrollToFrame() end
        Engine[2].SettingsWindow.MainPanel.Windows[i]:Hide()
    end
    Engine[2].SettingsWindow.GetIndexByText = function(s, text)
        if (not Engine[2].SettingsWindow.MenuBar.Buttons) then return end
        for i = 1, #Engine[2].SettingsWindow.MenuBar.Buttons do
            if (Engine[2].SettingsWindow.MenuBar.Buttons[i].Text:GetText() == text) then
                return i
            end
        end
    end
    Engine[2].SettingsWindow.AnimF = CreateFrame("Frame")
    Engine[2].SettingsWindow.Close = function()
        Engine[2].SettingsWindow.Texture:SetVertexColor(0,0,0,.9)
        local children = {Engine[2].SettingsWindow:GetChildren()}
        for _, child in ipairs(children) do
            child:Hide()
        end

        local w, h = Engine[2].SettingsWindow:GetWidth(), Engine[2].SettingsWindow:GetHeight()
        local animSpeed = 0
        Engine[2].SettingsWindow.AnimF:SetScript("OnUpdate", function()
            if (GetFramerate() < 10) then
                animSpeed = 4
            elseif (GetFramerate() < 30 and GetFramerate() >= 10) then
                animSpeed = 6
            elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                animSpeed = 8
            else
                animSpeed = 20
            end
            Engine[2].SettingsWindow:SetWidth(Engine[2].SettingsWindow:GetWidth() - (w / animSpeed))
            Engine[2].SettingsWindow:SetHeight(Engine[2].SettingsWindow:GetHeight() - (h / animSpeed))
            if (Engine[2].SettingsWindow:GetHeight() <= 0) then
                Engine[2].SettingsWindow.AnimF:SetScript("OnUpdate", nil)
                Engine[2].SettingsWindow:Hide()
            end
        end)
    end
    Engine[2].SettingsWindow.Open = function()
        local children = {Engine[2].SettingsWindow:GetChildren()}
        for _, child in ipairs(children) do
            child:Hide()
        end
        Engine[2].SettingsWindow:SetSize(0,0)
        Engine[2].SettingsWindow:Show()
        local w, h = Engine[2].SettingsWindow.Width, Engine[2].SettingsWindow.Height
        local animSpeed = 0
        Engine[2].SettingsWindow.AnimF:SetScript("OnUpdate", function()
            if (GetFramerate() < 10) then
                animSpeed = 4
            elseif (GetFramerate() < 30 and GetFramerate() >= 10) then
                animSpeed = 6
            elseif (GetFramerate() >= 30 and GetFramerate() <= 60) then
                animSpeed = 8
            else
                animSpeed = 20
            end
            Engine[2].SettingsWindow:SetWidth(Engine[2].SettingsWindow:GetWidth() + (w / animSpeed))
            Engine[2].SettingsWindow:SetHeight(Engine[2].SettingsWindow:GetHeight() + (h / animSpeed))
            if (Engine[2].SettingsWindow:GetHeight() >= h) then
                Engine[2].SettingsWindow.AnimF:SetScript("OnUpdate", nil)
                Engine[2].SettingsWindow:SetSize(w,h)
                Engine[2].SettingsWindow:Show()
                local children = {Engine[2].SettingsWindow:GetChildren()}
                for _, child in ipairs(children) do
                    child:Show()
                    if (Engine[2].SettingsWindow.IsFirstOpen) then
                        Engine[2].SettingsWindow.MainPanel:Hide()
                        Engine[2].SettingsWindow.IsFirstOpen = false
                    end
                end
                Engine[2].SettingsWindow.Texture:SetVertexColor(0,0,0,.8)
            end
        end)
    end
    Engine[2].SettingsWindow:Hide()
    --------------
    -- Settings --

    return Engine[2]
end

Engine[1].InitDataStorage = function(s, DB)
    if (not Engine[2]) then return end

    if (not DB) then
        DB = {
            Profiles = {}
        }
    end

    function DB:ClearDataStorage()
        table.wipe(DB.Profiles)
        table.wipe(DB)
        DB.Profiles = {}
    end



    --------------
    -- Profiles --
    function DB:AddProfile(profileName)
        DB.Profiles[profileName] = DB.Profiles[profileName] or {}
    end

    function DB:RemoveProfile(profileName)
        if (not DB.Profiles[profileName]) then
            DB.Profiles[profileName] = nil
        end
    end

    if (not DB.Profiles[UnitName("player")]) then
        DB:AddProfile(UnitName("player"))
    end
    -- Profiles --
    --------------

    return DB
end