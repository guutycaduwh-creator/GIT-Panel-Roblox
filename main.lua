--[[
    PAINEL GIT V5 - SISTEMA DE AUTO-LOADER & KEY
    Design: Preto & Azul Premium
    Status: AUTO-ATUALIZÁVEL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- CONFIGURAÇÕES DE DESIGN ---
local BLUE = Color3.fromRGB(0, 160, 255)
local BLACK = Color3.fromRGB(12, 12, 12)
local DARK_GREY = Color3.fromRGB(22, 22, 22)
local GREEN = Color3.fromRGB(0, 255, 120)
local RED = Color3.fromRGB(255, 60, 60)

-- --- SISTEMA DE KEY ---
local CorrectKey = "GIT-2026" 
local KeyVerified = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GIT_V5"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- --- FUNÇÕES DE ESTILO ---
local function AddCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function AddStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

-- --- SISTEMA DE NOTIFICAÇÕES ---
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Size = UDim2.new(0, 250, 1, 0); NotifContainer.Position = UDim2.new(1, -260, 0, 10); NotifContainer.BackgroundTransparency = 1
local NotifList = Instance.new("UIListLayout", NotifContainer); NotifList.VerticalAlignment = Enum.VerticalAlignment.Top; NotifList.Padding = UDim.new(0, 5)

local ShowNotifs = true
local function Notify(text, success)
    if not ShowNotifs then return end
    local n = Instance.new("Frame", NotifContainer)
    n.Size = UDim2.new(1, 0, 0, 40); n.BackgroundColor3 = BLACK; AddCorner(n, 8); AddStroke(n, success and BLUE or RED, 2)
    local t = Instance.new("TextLabel", n)
    t.Size = UDim2.new(1, -10, 1, 0); t.Position = UDim2.new(0, 5, 0, 0); t.BackgroundTransparency = 1; t.Text = text; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 14
    game:GetService("Debris"):AddItem(n, 3)
end

-- --- UI DE KEY ---
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75); KeyFrame.BackgroundColor3 = BLACK
AddCorner(KeyFrame, 10); AddStroke(KeyFrame, BLUE, 3)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40); KeyTitle.Text = "SISTEMA DE KEY"; KeyTitle.TextColor3 = BLUE; KeyTitle.Font = Enum.Font.SourceSansBold; KeyTitle.BackgroundTransparency = 1; KeyTitle.TextSize = 18

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 30); KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0); KeyInput.PlaceholderText = "Digite sua Key..."; KeyInput.BackgroundColor3 = DARK_GREY; KeyInput.TextColor3 = Color3.new(1,1,1)
AddCorner(KeyInput, 5)

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0.5, 0, 0, 30); KeyBtn.Position = UDim2.new(0.25, 0, 0.65, 0); KeyBtn.BackgroundColor3 = BLUE; KeyBtn.Text = "Verificar"; KeyBtn.TextColor3 = BLACK; KeyBtn.Font = Enum.Font.SourceSansBold
AddCorner(KeyBtn, 5)

-- --- INTERFACE PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "Main"; MainFrame.BackgroundColor3 = BLACK; MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200); MainFrame.Size = UDim2.new(0, 550, 0, 400); MainFrame.Visible = false
AddCorner(MainFrame, 15); AddStroke(MainFrame, BLUE, 4)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, -20, 0, 60); Header.Position = UDim2.new(0, 10, 0, 10); Header.BackgroundColor3 = DARK_GREY; AddCorner(Header, 10)

local ProfileImg = Instance.new("ImageLabel", Header)
ProfileImg.Size = UDim2.new(0, 50, 0, 50); ProfileImg.Position = UDim2.new(0, 5, 0, 5); ProfileImg.BackgroundColor3 = BLACK
ProfileImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"; AddCorner(ProfileImg, 25); AddStroke(ProfileImg, BLUE, 2)

local Welcome = Instance.new("TextLabel", Header)
Welcome.Size = UDim2.new(0, 200, 0, 25); Welcome.Position = UDim2.new(0, 65, 0, 10); Welcome.BackgroundTransparency = 1; Welcome.Text = "Olá, " .. LocalPlayer.DisplayName; Welcome.TextColor3 = Color3.new(1,1,1); Welcome.Font = Enum.Font.SourceSansBold; Welcome.TextSize = 18; Welcome.TextXAlignment = Enum.TextXAlignment.Left

local DateLabel = Instance.new("TextLabel", Header)
DateLabel.Size = UDim2.new(0, 200, 0, 20); DateLabel.Position = UDim2.new(0, 65, 0, 30); DateLabel.BackgroundTransparency = 1; DateLabel.Text = "Acesso: " .. os.date("%d/%m/%Y"); DateLabel.TextColor3 = BLUE; DateLabel.Font = Enum.Font.SourceSans; DateLabel.TextSize = 14; DateLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Lógica de Verificação
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyVerified = true
        KeyFrame.Visible = false
        MainFrame.Visible = true
        Notify("Acesso Concedido!", true)
    else
        KeyInput.Text = ""; KeyInput.PlaceholderText = "KEY INCORRETA!"
        Notify("Key Inválida!", false)
    end
end)

-- Arrastar
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Botão Abrir
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 35); OpenBtn.Position = UDim2.new(0, 10, 0, 10); OpenBtn.BackgroundColor3 = BLACK; OpenBtn.Text = "GIT"; OpenBtn.TextColor3 = BLUE; OpenBtn.Font = Enum.Font.SourceSansBold; AddCorner(OpenBtn, 10); AddStroke(OpenBtn, BLUE, 2)
OpenBtn.MouseButton1Click:Connect(function() if KeyVerified then MainFrame.Visible = not MainFrame.Visible end end)

-- Sidebar e Conteúdo
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 130, 1, -90); Sidebar.Position = UDim2.new(0, 10, 0, 80); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -160, 1, -90); Container.Position = UDim2.new(0, 150, 0, 80); Container.BackgroundColor3 = DARK_GREY; AddCorner(Container, 10); AddStroke(Container, BLUE, 1)

local Pages = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = BLACK; btn.Text = name; btn.TextColor3 = BLUE; btn.Font = Enum.Font.SourceSansBold; AddCorner(btn, 5); AddStroke(btn, BLUE, 1)
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.new(1, -10, 1, -10); page.Position = UDim2.new(0, 5, 0, 5); page.BackgroundTransparency = 1; page.Visible = false; page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end page.Visible = true end)
    Pages[name] = page; return page
end

local function CreateToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 30); btn.BackgroundColor3 = BLACK; btn.Text = text .. ": OFF"; btn.TextColor3 = RED; btn.Font = Enum.Font.SourceSansBold; AddCorner(btn, 5); AddStroke(btn, BLUE, 1)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and GREEN or RED
        local ok, err = pcall(function() callback(state) end)
        Notify(text .. (state and " ativado" or " desativado") .. (ok and " com sucesso" or " sem sucesso"), ok)
    end)
end

-- --- ABAS ---
local pMain = CreateTab("PRINCIPAL")
CreateToggle(pMain, "Anti-Kick", function(v)
    if v then
        local mt = getrawmetatable(game); local old = mt.__namecall; setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...) if getnamecallmethod() == "Kick" then return nil end return old(self, ...) end)
    end
end)
local function CreateTeam(c, n) local b = Instance.new("TextButton", pMain); b.Size = UDim2.new(0.95,0,0,30); b.BackgroundColor3 = c; b.Text = n; b.TextColor3 = Color3.new(1,1,1); AddCorner(b, 5) end
CreateTeam(Color3.new(0,0,1), "AZUL"); CreateTeam(Color3.new(0,1,0), "VERDE"); CreateTeam(Color3.new(1,0,0), "VERMELHO")

-- --- HITBOX CORRIGIDA ---
local pAim = CreateTab("AIMBOT")
local hVal = 1
local slider = Instance.new("TextBox", pAim); slider.Size = UDim2.new(0.95,0,0,30); slider.PlaceholderText = "Hitbox (1-89)"; slider.BackgroundColor3 = BLACK; slider.TextColor3 = BLUE; AddCorner(slider, 5); AddStroke(slider, BLUE, 1)
slider.FocusLost:Connect(function() hVal = math.clamp(tonumber(slider.Text) or 1, 1, 89) end)
CreateToggle(pAim, "Ativar Hitbox", function(s)
    _G.Hitbox = s
    spawn(function()
        while _G.Hitbox do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(hVal, hVal, hVal); p.Character.Head.Transparency = 0.5; p.Character.Head.CanCollide = false
                end
            end
            task.wait(0.1)
        end
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Size = Vector3.new(1.2,1.2,1.2); p.Character.Head.Transparency = 0; p.Character.Head.CanCollide = true end end
    end)
end)

-- --- ESP ESQUELETO REAL ---
local pESP = CreateTab("ESP")
_G.ESP_Config = { Vida = false, Linhas = false, Nomes = false, Distancia = false, Esqueleto = false, Caixa = false }
for k, _ in pairs(_G.ESP_Config) do CreateToggle(pESP, "ESP " .. k, function(v) _G.ESP_Config[k] = v end) end

local function DrawSkelLine(p1, p2, container)
    if not p1 or not p2 then return end
    local startPos, on1 = Camera:WorldToViewportPoint(p1.Position)
    local endPos, on2 = Camera:WorldToViewportPoint(p2.Position)
    if on1 and on2 then
        local line = container:FindFirstChild(p1.Name .. "_" .. p2.Name) or Instance.new("Frame", container)
        line.Name = p1.Name .. "_" .. p2.Name; line.BackgroundColor3 = BLUE; line.BorderSizePixel = 0; line.AnchorPoint = Vector2.new(0.5, 0.5)
        local dist = (Vector2.new(startPos.X, startPos.Y) - Vector2.new(endPos.X, endPos.Y)).Magnitude
        line.Size = UDim2.new(0, dist, 0, 1); line.Position = UDim2.new(0, (startPos.X + endPos.X)/2, 0, (startPos.Y + endPos.Y)/2)
        line.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)); line.Visible = true
    end
end

RunService.RenderStepped:Connect(function()
    if not KeyVerified then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character; local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local container = char:FindFirstChild("GIT_Visuals") or Instance.new("Folder", char); container.Name = "GIT_Visuals"

            if onScreen and _G.ESP_Config.Esqueleto then
                local h = char:FindFirstChild("Head"); local t = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if h and t then DrawSkelLine(h, t, container) end
            else
                for _, v in pairs(container:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
            end

            if onScreen and _G.ESP_Config.Caixa then
                local h = container:FindFirstChild("High") or Instance.new("Highlight", container)
                h.Name = "High"; h.OutlineColor = BLUE; h.FillTransparency = 1; h.Enabled = true
            elseif container:FindFirstChild("High") then container.High.Enabled = false end

            if onScreen and _G.ESP_Config.Linhas then
                local l = ScreenGui:FindFirstChild("L_" .. p.Name) or Instance.new("Frame", ScreenGui)
                l.Name = "L_" .. p.Name; l.BackgroundColor3 = BLUE; l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
                local start = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); local endP = Vector2.new(pos.X, pos.Y)
                l.Position = UDim2.new(0, (start.X + endP.X)/2, 0, (start.Y + endP.Y)/2); l.Size = UDim2.new(0, (start - endP).Magnitude, 0, 1)
                l.Rotation = math.deg(math.atan2(endP.Y - start.Y, endP.X - start.X)); l.Visible = true
            elseif ScreenGui:FindFirstChild("L_" .. p.Name) then ScreenGui["L_" .. p.Name].Visible = false end
        end
    end
end)

-- --- ABA: TELEPORTE ---
local pTP = CreateTab("TELEPORTE")
local selPlr = ""
local tpScroll = Instance.new("ScrollingFrame", pTP); tpScroll.Size = UDim2.new(0.95, 0, 0, 120); tpScroll.BackgroundColor3 = BLACK; AddCorner(tpScroll, 5)
Instance.new("UIListLayout", tpScroll)
local function UpdateList()
    for _, v in pairs(tpScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then
        local b = Instance.new("TextButton", tpScroll); b.Size = UDim2.new(1,0,0,25); b.Text = p.Name; b.BackgroundColor3 = DARK_GREY; b.TextColor3 = BLUE; AddCorner(b, 5)
        b.MouseButton1Click:Connect(function() selPlr = p.Name; pTP.Sel.Text = "Alvo: " .. p.Name end)
    end end
end
local selL = Instance.new("TextLabel", pTP); selL.Name = "Sel"; selL.Size = UDim2.new(1,0,0,25); selL.Text = "Alvo: Nenhum"; selL.TextColor3 = BLUE; selL.BackgroundTransparency = 1
local btnRef = Instance.new("TextButton", pTP); btnRef.Size = UDim2.new(0.95,0,0,30); btnRef.Text = "Atualizar Lista"; btnRef.BackgroundColor3 = BLACK; btnRef.TextColor3 = BLUE; AddCorner(btnRef, 5); btnRef.MouseButton1Click:Connect(UpdateList)
local btnTP = Instance.new("TextButton", pTP); btnTP.Size = UDim2.new(0.95,0,0,30); btnTP.Text = "Teleportar"; btnTP.BackgroundColor3 = BLACK; btnTP.TextColor3 = BLUE; AddCorner(btnTP, 5)
btnTP.MouseButton1Click:Connect(function() local t = Players:FindFirstChild(selPlr); if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end end)
CreateToggle(pTP, "Spectate", function(s) local t = Players:FindFirstChild(selPlr); if s and t and t.Character then Camera.CameraSubject = t.Character.Humanoid else Camera.CameraSubject = LocalPlayer.Character.Humanoid end end)

-- --- ABA: NOTÍCIAS ---
local pNews = CreateTab("NOTÍCIAS")
local newsText = Instance.new("TextLabel", pNews); newsText.Size = UDim2.new(1,0,0,100); newsText.Text = "VERSÃO V5 AUTO-ATUALIZÁVEL!\n- Esqueleto Real\n- Sistema de Key\n- Repositório GitHub Criado"; newsText.TextColor3 = BLUE; newsText.BackgroundTransparency = 1; newsText.TextWrapped = true

Pages["PRINCIPAL"].Visible = true
print("GIT V5 Carregado via Auto-Loader!")
