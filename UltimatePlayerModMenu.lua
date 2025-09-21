local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateModMenu"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Ultimate Mod Menu"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = frame

-- Make frame draggable
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateDrag(input)
	end
end)

local buttonHeight = 40
local buttonSpacing = 10
local features = {
	{name = "Infinite Jump", key = "InfJump"},
	{name = "Noclip", key = "Noclip"},
	{name = "Trigger Bot", key = "TriggerBot"},
	{name = "Aim Bot", key = "AimBot"},
	{name = "Fly", key = "Fly"},
	{name = "Killaura", key = "Killaura"},
	{name = "Others", key = "Others"},
}
local buttons = {}
local bindButtons = {}
local binds = {} -- key: feature.key, value: Enum.KeyCode or nil

for i, feature in features do
	local btn = Instance.new("TextButton")
	btn.Name = feature.key .. "Btn"
	btn.Text = feature.name
	btn.Size = UDim2.new(0.7, -20, 0, buttonHeight)
	btn.Position = UDim2.new(0, 10, 0, 50 + (i-1)*(buttonHeight+buttonSpacing))
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 20
	btn.Parent = frame
	buttons[feature.key] = btn

	-- Bind button
	local bindBtn = Instance.new("TextButton")
	bindBtn.Name = feature.key .. "BindBtn"
	bindBtn.Text = "Bind"
	bindBtn.Size = UDim2.new(0.3, -10, 0, buttonHeight)
	bindBtn.Position = UDim2.new(0.7, 0, 0, 50 + (i-1)*(buttonHeight+buttonSpacing))
	bindBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	bindBtn.TextColor3 = Color3.fromRGB(255,255,0)
	bindBtn.Font = Enum.Font.Gotham
	bindBtn.TextSize = 18
	bindBtn.Parent = frame
	bindButtons[feature.key] = bindBtn
end

-- Add Speed button below all feature buttons
local speedBtn = Instance.new("TextButton")
speedBtn.Name = "SpeedBtn"
speedBtn.Text = "Speed"
speedBtn.Size = UDim2.new(1, -20, 0, buttonHeight)
speedBtn.Position = UDim2.new(0, 10, 0, 50 + (#features)*(buttonHeight+buttonSpacing))
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
speedBtn.TextColor3 = Color3.fromRGB(255,255,255)
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 22
speedBtn.Parent = frame

-- Make Speed button beautiful
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 16)
speedCorner.Parent = speedBtn

local speedGradient = Instance.new("UIGradient")
speedGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 180))
}
speedGradient.Rotation = 45
speedGradient.Parent = speedBtn

local shadow = Instance.new("ImageLabel")
shadow.Name = "SpeedBtnShadow"
shadow.Image = "rbxassetid://1316045217"
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, 4)
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ZIndex = speedBtn.ZIndex - 1
shadow.Parent = speedBtn

-- Hover effect for Speed button
speedBtn.MouseEnter:Connect(function()
	speedBtn.Size = UDim2.new(1, -10, 0, buttonHeight + 6)
	speedGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 160, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 220))
	}
end)
speedBtn.MouseLeave:Connect(function()
	speedBtn.Size = UDim2.new(1, -20, 0, buttonHeight)
	speedGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 120, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 180))
	}
end)

speedBtn.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 200
		StarterGui:SetCore("SendNotification", {
			Title = "Speed",
			Text = "WalkSpeed set to 200!",
			Duration = 2
		})
	end
end)

screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Feature toggles
local toggles = {
	InfJump = false,
	Noclip = false,
	TriggerBot = false,
	AimBot = false,
	Fly = false,
	Killaura = false,
}

-- Binding system
local waitingForBind = nil -- feature.key being bound

local function keyToString(keyCode)
	if keyCode == nil then return "None" end
	return tostring(keyCode):gsub("Enum.KeyCode.", "")
end

for k, feature in features do
	local bindBtn = bindButtons[feature.key]
	bindBtn.MouseButton1Click:Connect(function()
		if waitingForBind then return end
		waitingForBind = feature.key
		bindBtn.Text = "Press Key..."
		bindBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
	end)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if waitingForBind then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local key = input.KeyCode
			binds[waitingForBind] = key
			local bindBtn = bindButtons[waitingForBind]
			bindBtn.Text = "Bind: " .. keyToString(key)
			bindBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			waitingForBind = nil
		end
	else
		-- Check if any feature is bound to this key
		for k, feature in features do
			local boundKey = binds[feature.key]
			if boundKey and input.KeyCode == boundKey then
				-- Toggle feature directly (fix: do not use Activate)
				if feature.key == "InfJump" then
					toggles.InfJump = not toggles.InfJump
					buttons.InfJump.BackgroundColor3 = toggles.InfJump and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
				elseif feature.key == "Noclip" then
					toggles.Noclip = not toggles.Noclip
					buttons.Noclip.BackgroundColor3 = toggles.Noclip and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
				elseif feature.key == "TriggerBot" then
					toggles.TriggerBot = not toggles.TriggerBot
					buttons.TriggerBot.BackgroundColor3 = toggles.TriggerBot and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
				elseif feature.key == "AimBot" then
					toggles.AimBot = not toggles.AimBot
					buttons.AimBot.BackgroundColor3 = toggles.AimBot and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
				elseif feature.key == "Fly" then
					toggles.Fly = not toggles.Fly
					buttons.Fly.BackgroundColor3 = toggles.Fly and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
					local character = LocalPlayer.Character
					if toggles.Fly and character and character:FindFirstChild("HumanoidRootPart") then
						flying = true
						bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
						bodyVelocity.Velocity = Vector3.new()
						bodyVelocity.Parent = character.HumanoidRootPart
					else
						flying = false
						if character and character:FindFirstChild("HumanoidRootPart") and bodyVelocity then
							bodyVelocity:Destroy()
							bodyVelocity = nil
						end
					end
				elseif feature.key == "Killaura" then
					toggles.Killaura = not toggles.Killaura
					buttons.Killaura.BackgroundColor3 = toggles.Killaura and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
				elseif feature.key == "Others" then
					StarterGui:SetCore("SendNotification", {
						Title = "Others",
						Text = "More features coming soon!",
						Duration = 2
					})
				end
			end
		end
	end
end)

-- Infinite Jump
buttons.InfJump.MouseButton1Click:Connect(function()
	toggles.InfJump = not toggles.InfJump
	buttons.InfJump.BackgroundColor3 = toggles.InfJump and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
end)

UserInputService.JumpRequest:Connect(function()
	if toggles.InfJump then
		local character = LocalPlayer.Character
		if character and character:FindFirstChildOfClass("Humanoid") then
			character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Noclip
buttons.Noclip.MouseButton1Click:Connect(function()
	toggles.Noclip = not toggles.Noclip
	buttons.Noclip.BackgroundColor3 = toggles.Noclip and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
end)

RunService.RenderStepped:Connect(function()
	if toggles.Noclip then
		local character = LocalPlayer.Character
		if character then
			for k, v in character:GetChildren() do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)

-- Fly
local flySpeed = 50
local flying = false
local flyDirection = Vector3.new()
local bodyVelocity = nil

buttons.Fly.MouseButton1Click:Connect(function()
	toggles.Fly = not toggles.Fly
	buttons.Fly.BackgroundColor3 = toggles.Fly and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
	local character = LocalPlayer.Character
	if toggles.Fly and character and character:FindFirstChild("HumanoidRootPart") then
		flying = true
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Velocity = Vector3.new()
		bodyVelocity.Parent = character.HumanoidRootPart
	else
		flying = false
		if character and character:FindFirstChild("HumanoidRootPart") and bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if not flying then return end
	if input.KeyCode == Enum.KeyCode.W then
		flyDirection = Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then
		flyDirection = Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then
		flyDirection = Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then
		flyDirection = Vector3.new(1,0,0)
	elseif input.KeyCode == Enum.KeyCode.Space then
		flyDirection = Vector3.new(0,1,0)
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		flyDirection = Vector3.new(0,-1,0)
	end
end)

UserInputService.InputEnded:Connect(function(input, processed)
	if not flying then return end
	flyDirection = Vector3.new()
end)

RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity then
		local camera = workspace.CurrentCamera
		bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(flyDirection) * flySpeed
	end
end)

-- Trigger Bot (fires at player under mouse)
buttons.TriggerBot.MouseButton1Click:Connect(function()
	toggles.TriggerBot = not toggles.TriggerBot
	buttons.TriggerBot.BackgroundColor3 = toggles.TriggerBot and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
end)

local function getPlayerFromPart(part)
	if not part then return nil end
	local model = part:FindFirstAncestorOfClass("Model")
	if model and Players:GetPlayerFromCharacter(model) and model ~= LocalPlayer.Character then
		return Players:GetPlayerFromCharacter(model)
	end
	return nil
end

UserInputService.InputBegan:Connect(function(input, processed)
	if toggles.TriggerBot and input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = LocalPlayer:GetMouse()
		local target = mouse.Target
		local player = getPlayerFromPart(target)
		if player then
			-- Simulate "trigger" (for demonstration, print to output)
			print("TriggerBot: Fired at", player.Name)
		end
	end
end)

-- Aim Bot (aims at nearest player)
buttons.AimBot.MouseButton1Click:Connect(function()
	toggles.AimBot = not toggles.AimBot
	buttons.AimBot.BackgroundColor3 = toggles.AimBot and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
end)

RunService.RenderStepped:Connect(function()
	if toggles.AimBot then
		local character = LocalPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local myPos = character.HumanoidRootPart.Position
			local nearestPlayer = nil
			local nearestDist = math.huge
			for k, player in Players:GetPlayers() do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
					if dist < nearestDist then
						nearestDist = dist
						nearestPlayer = player
					end
				end
			end
			if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local camera = workspace.CurrentCamera
				camera.CFrame = CFrame.new(camera.CFrame.Position, nearestPlayer.Character.HumanoidRootPart.Position)
			end
		end
	end
end)

-- Killaura (attack nearby players)
buttons.Killaura.MouseButton1Click:Connect(function()
	toggles.Killaura = not toggles.Killaura
	buttons.Killaura.BackgroundColor3 = toggles.Killaura and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
end)

local killauraRadius = 10 -- studs

RunService.RenderStepped:Connect(function()
	if toggles.Killaura then
		local character = LocalPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local myPos = character.HumanoidRootPart.Position
			for k, player in Players:GetPlayers() do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
					local targetPos = player.Character.HumanoidRootPart.Position
					local dist = (targetPos - myPos).Magnitude
					if dist <= killauraRadius then
						-- Simulate attack (for demonstration, print to output)
						print("Killaura: Attacked", player.Name)
						-- If you want to actually damage, you need a RemoteEvent to the server
						-- player.Character:FindFirstChildOfClass("Humanoid").Health = 0 -- Only works on server
					end
				end
			end
		end
	end
end)

-- Others (placeholder)
buttons.Others.MouseButton1Click:Connect(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Others",
		Text = "More features coming soon!",
		Duration = 2
	})
end)

