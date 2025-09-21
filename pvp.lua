-- PvP Script GUI (Executável via loadstring)
-- Feito para uso em testes ou jogos próprios

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PvP_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 240)
Frame.Position = UDim2.new(0, 10, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local function createButton(name, posY, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0, 230, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.MouseButton1Click:Connect(callback)
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	return btn
end

-- ESP Function
local function enableESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			if not plr.Character.Head:FindFirstChild("ESPTag") then
				local billboard = Instance.new("BillboardGui", plr.Character.Head)
				billboard.Name = "ESPTag"
				billboard.Size = UDim2.new(0, 100, 0, 40)
				billboard.AlwaysOnTop = true

				local nameLabel = Instance.new("TextLabel", billboard)
				nameLabel.Size = UDim2.new(1, 0, 1, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = plr.Name
				nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				nameLabel.TextScaled = true
			end
		end
	end
end

-- Aimbot
local aimbotEnabled = false
local function getClosestPlayer()
	local closest = nil
	local shortestDistance = math.huge
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local headPos = Camera:WorldToViewportPoint(plr.Character.Head.Position)
			local distance = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
			if distance < shortestDistance and headPos.Z > 0 then
				shortestDistance = distance
				closest = plr
			end
		end
	end
	return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
	if aimbotEnabled then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- Buttons
createButton("🔴 Ativar ESP", 10, enableESP)

createButton("🎯 Alternar Aimbot", 60, function()
	aimbotEnabled = not aimbotEnabled
	print("Aimbot:", aimbotEnabled and "Ativado" or "Desativado")
end)

createButton("❤️ Resetar Vida", 110, function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = 0
	end
end)

createButton("❌ Fechar Menu", 160, function()
	ScreenGui:Destroy()
end)

print("✅ PvP Script carregado com sucesso.")
