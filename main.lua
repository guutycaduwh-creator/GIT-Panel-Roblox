--[[
    HUBCUBOS V6 - PREMIUM ICE EDITION
    Design: Tema de Gelo, Animação de Neve, Seletor de Cores
    Status: AUTO-ATUALIZADO
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- CONFIGURAÇÕES DE DESIGN ---
local CurrentThemeColor = Color3.fromRGB(0, 200, 255) -- Azul Gelo Padrão
local BLACK = Color3.fromRGB(5, 5, 10)
local DARK_GREY = Color3.fromRGB(15, 15, 25)
local GREEN = Color3.fromRGB(0, 255, 150)
local RED = Color3.fromRGB(255, 50, 50)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Hubcubos_V6"
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

-- --- ANIMAÇÃO DE NEVE/GELO NO FUNDO ---
local function CreateSnowflake(parent)
    local snow = Instance.new("TextLabel", parent)
    snow.BackgroundTransparency = 1
    snow.Text = math.random(1, 2) == 1 and "❄" or "🧊"
    snow.TextColor3 = Color3.new(1, 1, 1)
    snow.TextSize = math.random(10, 20)
    snow.Position = UDim2.new(math.random(), 0, -0.1, 0)
    
    spawn(function()
        local speed = math.random(2, 5)
        local drift = (math.random() - 0.5) * 0.1
        while snow.Parent and snow.Position.Y.Scale < 1.1 do
            snow.Position = snow.Position + UDim2.new(drift, 0, 0.01 * speed, 0)
            task.wait(0.05)
        end
        snow:Destroy()
    end)
end

-- --- INTERFACE PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "Main"; MainFrame.BackgroundColor3 = BLACK; MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200); MainFrame.Size = UDim2.new(0, 550, 0, 400); MainFrame.Visible = false
AddCorner(MainFrame, 20); local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = CurrentThemeColor; MainStroke.Thickness = 5

-- Background Animado
local AnimFrame = Instance.new("Frame", MainFrame)
AnimFrame.Size = UDim2.new(1, 0, 1, 0); AnimFrame.BackgroundTransparency = 1; AnimFrame.ZIndex = 0; AnimFrame.ClipsDescendants = true
spawn(function() while task.wait(0.5) do if MainFrame.Visible then CreateSnowflake(AnimFrame) end end end)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, -20, 0, 70); Header.Position = UDim2.new(0, 10, 0, 10); Header.BackgroundColor3 = DARK_GREY; AddCorner(Header, 15); AddStroke(Header, CurrentThemeColor, 2)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0, 70, 0, 10); Title.Text = "HUBCUBOS V6"; Title.TextColor3 = CurrentThemeColor; Title.Font = Enum.Font.FredokaOne; Title.TextSize = 24; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

local ProfileImg = Instance.new("ImageLabel", Header)
ProfileImg.Size = UDim2.new(0, 50, 0, 50); ProfileImg.Position = UDim2.new(0, 10, 0, 10); ProfileImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"; AddCorner(ProfileImg, 25); AddStroke(ProfileImg, CurrentThemeColor, 2)

-- Botão Abrir
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 90, 0, 40); OpenBtn.Position = UDim2.new(0, 10, 0, 10); OpenBtn.BackgroundColor3 = BLACK; OpenBtn.Text = "HUBCUBOS"; OpenBtn.TextColor3 = CurrentThemeColor; OpenBtn.Font = Enum.Font.FredokaOne; AddCorner(OpenBtn, 12); AddStroke(OpenBtn, CurrentThemeColor, 3)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Sidebar e Conteúdo
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -100); Sidebar.Position = UDim2.new(0, 10, 0, 90); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 6)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -170, 1, -100); Container.Position = UDim2.new(0, 160, 0, 90); Container.BackgroundColor3 = DARK_GREY; AddCorner(Container, 15); AddStroke(Container, CurrentThemeColor, 1)

local Pages = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = BLACK; btn.Text = name; btn.TextColor3 = CurrentThemeColor; btn.Font = Enum.Font.SourceSansBold; AddCorner(btn, 8); AddStroke(btn, CurrentThemeColor, 1)
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.new(1, -10, 1, -10); page.Position = UDim2.new(0, 5, 0, 5); page.BackgroundTransparency = 1; page.Visible = false; page.CanvasSize = UDim2.new(0, 0, 3, 0)
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end page.Visible = true end)
    Pages[name] = page; return page
end

local function CreateToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = BLACK; btn.Text = text .. ": OFF"; btn.TextColor3 = RED; btn.Font = Enum.Font.SourceSansBold; AddCorner(btn, 8); AddStroke(btn, CurrentThemeColor, 1)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and GREEN or RED
        pcall(function() callback(state) end)
    end)
end

-- --- ABAS ---
local pMain = CreateTab("PRINCIPAL")
CreateToggle(pMain, "Anti-Kick", function(v) end)
local pESP = CreateTab("ESP")
_G.ESP_Config = { Vida = false, Linhas = false, Nomes = false, Distancia = false, Esqueleto = false, Caixa = false }
for k, _ in pairs(_G.ESP_Config) do CreateToggle(pESP, "ESP " .. k, function(v) _G.ESP_Config[k] = v end) end

local pPlayer = CreateTab("PLAYER")
CreateToggle(pPlayer, "Speed (100)", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
CreateToggle(pPlayer, "Pulo Infinito", function(v) _G.InfJump = v end)
UserInputService.JumpRequest:Connect(function() if _G.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

-- Invisibilidade
local function ToggleInvis(v)
    local char = LocalPlayer.Character
    if v and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    elseif char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end
CreateToggle(pPlayer, "Invisível (H)", function(v) _G.Invis = v; ToggleInvis(v) end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.H then
        _G.Invis = not _G.Invis
        ToggleInvis(_G.Invis)
        Notify("Invisibilidade: " .. (_G.Invis and "ON" or "OFF"), true)
    end
end)

-- Carregar Jogador (GTA VM Style)
CreateToggle(pPlayer, "Carregar Jogador", function(v)
    local target = Players:FindFirstChild(selPlr)
    if v and target and target.Character then
        _G.Carrying = true
        spawn(function()
            while _G.Carrying and target.Character do
                target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                task.wait()
            end
        end)
    else
        _G.Carrying = false
    end
end)

local pWorld = CreateTab("MUNDO") -- NOVA ABA
CreateToggle(pWorld, "Remover Neblina", function(v) game.Lighting.FogEnd = v and 100000 or 1000 end)
CreateToggle(pWorld, "Fullbright", function(v) game.Lighting.Brightness = v and 2 or 1 end)

local pCars = CreateTab("CARROS") -- RECUPERADA
local cScroll = Instance.new("ScrollingFrame", pCars); cScroll.Size = UDim2.new(0.95, 0, 0, 150); cScroll.BackgroundColor3 = BLACK; AddCorner(cScroll, 8)
Instance.new("UIListLayout", cScroll)
local function RefreshCars()
    for _, v in pairs(cScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("VehicleSeat") then
        local b = Instance.new("TextButton", cScroll); b.Size = UDim2.new(1,0,0,30); b.Text = v.Parent.Name; b.BackgroundColor3 = DARK_GREY; b.TextColor3 = CurrentThemeColor; AddCorner(b, 5)
        b.MouseButton1Click:Connect(function() LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.PrimaryPart.CFrame + Vector3.new(0,5,0) end)
    end end
end
local btnRefC = Instance.new("TextButton", pCars); btnRefC.Size = UDim2.new(0.95,0,0,35); btnRefC.Text = "Atualizar Carros"; btnRefC.BackgroundColor3 = BLACK; btnRefC.TextColor3 = CurrentThemeColor; AddCorner(btnRefC, 8); btnRefC.MouseButton1Click:Connect(RefreshCars)

local pSettings = CreateTab("AJUSTES") -- SELETOR DE CORES
local colors = {["Azul"] = Color3.fromRGB(0, 200, 255), ["Verde"] = Color3.fromRGB(0, 255, 100), ["Vermelho"] = Color3.fromRGB(255, 50, 50), ["Amarelo"] = Color3.fromRGB(255, 255, 0)}
for name, color in pairs(colors) do
    local b = Instance.new("TextButton", pSettings); b.Size = UDim2.new(0.95,0,0,35); b.BackgroundColor3 = color; b.Text = "Tema " .. name; b.TextColor3 = BLACK; AddCorner(b, 8)
    b.MouseButton1Click:Connect(function()
        CurrentThemeColor = color
        MainStroke.Color = color; OpenBtn.TextColor3 = color; OpenBtn.UIStroke.Color = color
        -- Atualizar todos os strokes e textos
    end)
end

-- --- LÓGICA ESP CORRIGIDA ---
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character; local hrp = char.HumanoidRootPart; local hum = char:FindFirstChild("Humanoid")
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local container = char:FindFirstChild("GIT_Visuals") or Instance.new("Folder", char); container.Name = "GIT_Visuals"

            -- Nomes Grandes
            local bg = container:FindFirstChild("Info") or Instance.new("BillboardGui", container)
            bg.Name = "Info"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 200, 0, 50); bg.Adornee = hrp; bg.ExtentsOffset = Vector3.new(0, 4, 0)
            local label = bg:FindFirstChild("Label") or Instance.new("TextLabel", bg)
            label.Name = "Label"; label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = CurrentThemeColor; label.Font = Enum.Font.FredokaOne; label.TextSize = 20 -- AUMENTADO
            label.Text = (_G.ESP_Config.Nomes and p.Name or "") .. (_G.ESP_Config.Distancia and "\n" .. math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m" or "")
            label.Visible = _G.ESP_Config.Nomes or _G.ESP_Config.Distancia

            -- Vida Real
            if onScreen and _G.ESP_Config.Vida and hum then
                local hb = container:FindFirstChild("Health") or Instance.new("BillboardGui", container)
                hb.Name = "Health"; hb.AlwaysOnTop = true; hb.Size = UDim2.new(0, 8, 0, 60); hb.Adornee = hrp; hb.StudsOffset = Vector3.new(-3, 0, 0)
                local f = hb:FindFirstChild("F") or Instance.new("Frame", hb); f.Name = "F"; f.Size = UDim2.new(1,0,hum.Health/hum.MaxHealth,0); f.Position = UDim2.new(0,0,1-(hum.Health/hum.MaxHealth),0); f.BackgroundColor3 = GREEN; hb.Enabled = true
            elseif container:FindFirstChild("Health") then container.Health.Enabled = false end

            -- Linhas Alinhadas
            if onScreen and _G.ESP_Config.Linhas then
                local l = ScreenGui:FindFirstChild("L_" .. p.Name) or Instance.new("Frame", ScreenGui)
                l.Name = "L_" .. p.Name; l.BackgroundColor3 = CurrentThemeColor; l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
                local start = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); local endP = Vector2.new(pos.X, pos.Y)
                l.Position = UDim2.new(0, (start.X + endP.X)/2, 0, (start.Y + endP.Y)/2); l.Size = UDim2.new(0, (start - endP).Magnitude, 0, 2)
                l.Rotation = math.deg(math.atan2(endP.Y - start.Y, endP.X - start.X)); l.Visible = true
            elseif ScreenGui:FindFirstChild("L_" .. p.Name) then ScreenGui["L_" .. p.Name].Visible = false end
        end
    end
end)

Pages["PRINCIPAL"].Visible = true
print("HUBCUBOS V6 CARREGADO!")
