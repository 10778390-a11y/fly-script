-- Fly GUI V3 Movable - REBIRT052AI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGuiV3_REBIRT052AI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "REBIRT052AI"  -- <- Nombre personalizado
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Buttons
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Position = UDim2.new(0, 10, 0, 30)
flyBtn.Size = UDim2.new(0, 80, 0, 30)
flyBtn.Text = "FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 255)
flyBtn.TextColor3 = Color3.new(1,1,1)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 100, 0, 30)
speedLabel.Size = UDim2.new(0, 80, 0, 30)
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)

local plusBtn = Instance.new("TextButton", frame)
plusBtn.Position = UDim2.new(0, 190, 0, 30)
plusBtn.Size = UDim2.new(0, 30, 0, 30)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
plusBtn.TextColor3 = Color3.new(1,1,1)

local minusBtn = Instance.new("TextButton", frame)
minusBtn.Position = UDim2.new(0, 230, 0, 30)
minusBtn.Size = UDim2.new(0, 30, 0, 30)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
minusBtn.TextColor3 = Color3.new(1,1,1)

local upBtn = Instance.new("TextButton", frame)
upBtn.Position = UDim2.new(0, 10, 0, 70)
upBtn.Size = UDim2.new(0, 80, 0, 20)
upBtn.Text = "UP"
upBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
upBtn.TextColor3 = Color3.new(1,1,1)

local downBtn = Instance.new("TextButton", frame)
downBtn.Position = UDim2.new(0, 100, 0, 70)
downBtn.Size = UDim2.new(0, 80, 0, 20)
downBtn.Text = "DOWN"
downBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
downBtn.TextColor3 = Color3.new(1,1,1)

-- Vars
local flying = false
local speed = 50
local bodyGyro, bodyVelocity

local function updateSpeed()
	speedLabel.Text = "Speed: " .. speed
end
updateSpeed()

-- Fly functions
local function startFly()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyVelocity = Instance.new("BodyVelocity", hrp)

	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	flying = true
end

local function stopFly()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

-- Button events
flyBtn.MouseButton1Click:Connect(function()
	if not flying then
		startFly()
		flyBtn.Text = "STOP"
	else
		stopFly()
		flyBtn.Text = "FLY"
	end
end)

plusBtn.MouseButton1Click:Connect(function()
	speed = speed + 10
	updateSpeed()
end)

minusBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	updateSpeed()
end)

upBtn.MouseButton1Click:Connect(function()
	if flying then
		bodyVelocity.Velocity = Vector3.new(0, speed, 0)
	end
end)

downBtn.MouseButton1Click:Connect(function()
	if flying then
		bodyVelocity.Velocity = Vector3.new(0, -speed, 0)
	end
end)

-- Fly control loop
game:GetService("RunService").RenderStepped:Connect(function()
	if flying and bodyGyro and bodyVelocity then
		local cam = workspace.CurrentCamera
		bodyGyro.CFrame = cam.CFrame
		bodyVelocity.Velocity = cam.CFrame.LookVector * speed
	end
end)

-- DRAGGABLE GUI
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
