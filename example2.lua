local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character
local camera = workspace.CurrentCamera
local cameraFolder = workspace.CutsceneCamera
local playerGui = player.PlayerGui
local dialogueGui = playerGui.DialogueGui
local healthGui = playerGui.HealthGui
local movesGui = playerGui.MovesGui
local animationLoop1 = character.Humanoid:LoadAnimation(game.ReplicatedFirst.Preload.Animations.TransformLoop1)
local animationBreak1 = character.Humanoid:LoadAnimation(game.ReplicatedFirst.Preload.Animations.TransformBreak1)
local cutsceneDebounce = false
local isActive = false
local function makemotor(parent, p0, p1, c0, c1)
	local wel = Instance.new("Motor6D")
	wel.Parent = parent
	wel.Part0 = p0
	wel.Part1 = p1
	wel.C0 = c0
	wel.Name = "Morph6D"
	if c1 ~= nil then
		wel.C1 = c1
	end
	return wel
end
local function Dialogue(name, text)
	dialogueGui.MainFrame.Visible = true
	dialogueGui.MainFrame.NameFrame.TextLabel.TextTransparency = 1
	dialogueGui.MainFrame.DialogueFrame.TextLabel.TextTransparency = 1
	dialogueGui.MainFrame.Frame.BackgroundTransparency = 1
	dialogueGui.MainFrame.NameFrame.TextLabel.Text = name
	dialogueGui.MainFrame.DialogueFrame.TextLabel.Text = text
	dialogueGui.MainFrame.Position = UDim2.new(0.5, 50, 1, 0)
	TweenService:Create(dialogueGui.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 1, 0)}):Play()
	TweenService:Create(dialogueGui.MainFrame.NameFrame.TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	TweenService:Create(dialogueGui.MainFrame.DialogueFrame.TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	TweenService:Create(dialogueGui.MainFrame.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
end
local function DialogueHide()
	dialogueGui.MainFrame.Visible = false
	dialogueGui.MainFrame.NameFrame.TextLabel.Text = ""
	dialogueGui.MainFrame.DialogueFrame.TextLabel.Text = ""
	dialogueGui.MainFrame.Position = UDim2.new(0.5, 0, 1, 0)
end
local function GuiEnable(boolean)
	movesGui.Enabled = false
	healthGui.Enabled = boolean
end
local function Shine()
	task.spawn(function()
		local colorCorrection = game.Lighting.ColorCorrection
		TweenService:Create(colorCorrection, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Brightness = 1}):Play()
		task.wait(0.5)
		TweenService:Create(colorCorrection, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Brightness = 0}):Play()
	end)
end
local function TeaseSuperSaiyan()
	task.spawn(function()
		local hair = character.Hair
		local highlight = character.Highlight
		TweenService:Create(hair, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Color = Color3.fromRGB(250, 210, 140)}):Play()
		TweenService:Create(highlight, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), {OutlineColor = Color3.fromRGB(250, 230, 100)}):Play()
		task.wait(0.5)
		TweenService:Create(hair, TweenInfo.new(0.75, Enum.EasingStyle.Exponential), {Color = Color3.fromRGB(25, 25, 25)}):Play()
		TweenService:Create(highlight, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {OutlineColor = Color3.fromRGB(0, 0, 0)}):Play()
	end)
end
local function SuperSaiyan()
	local highlight = character.Highlight
	TweenService:Create(highlight, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {OutlineColor = Color3.fromRGB(250, 230, 100)}):Play()
	local superSaiyanHair = game.ReplicatedStorage.Assets.Morphs["Super Saiyan"].SuperHair:Clone()
	superSaiyanHair.Parent = character
	makemotor(superSaiyanHair, character.Head, superSaiyanHair, CFrame.new(0.015, 0.948, 0.171))
	TweenService:Create(superSaiyanHair, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	local normalHair = character.Hair
	TweenService:Create(normalHair, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Color = Color3.fromRGB(250, 210, 140)}):Play()
	task.delay(0.25, function()
		TweenService:Create(normalHair, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		game.Debris:AddItem(normalHair, 0.25)
	end)
	local pointLight = game.ReplicatedStorage.Assets.Morphs["Super Saiyan"].PointLight:Clone()
	pointLight.Parent = character.Torso
	TweenService:Create(pointLight, TweenInfo.new(2.5, Enum.EasingStyle.Exponential), {Brightness = 2.5}):Play()
	for i, v in pairs(character:GetChildren()) do
		if v:IsA("Clothing") then
			v:Destroy()
		end
	end
	local shirt, pants = game.ReplicatedStorage.Assets.Morphs["Super Saiyan"].Shirt:Clone(), game.ReplicatedStorage.Assets.Morphs["Super Saiyan"].Pants:Clone()
	shirt.Parent = character
	pants.Parent = character
end
local function Sphere()
	local vfx = game.ReplicatedStorage.Assets.Sphere:Clone()
	vfx.Parent = workspace
	vfx.CFrame = CFrame.new(0, 10.1, 0)
	TweenService:Create(vfx, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = Vector3.new(200, 200, 200), Transparency = 1}):Play()
	game.Debris:AddItem(vfx, 10)
end
local function TransformCutscene()
	isActive = true
	GuiEnable(false)
	cutsceneDebounce = true
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = 50
	character.HumanoidRootPart.CFrame = cameraFolder.Root.CFrame
	character.Humanoid.WalkSpeed = 0
	character.Humanoid.JumpPower = 0
	character.Humanoid.AutoRotate = false
	character.HumanoidRootPart.CFrame = workspace.CutsceneCamera.Root.CFrame
	animationLoop1:Play()
	camera.CFrame = cameraFolder["Camera 1"].CFrame
	task.wait(4)
	camera.CFrame = cameraFolder["Camera 2A"].CFrame
	game.TweenService:Create(camera, TweenInfo.new(5, Enum.EasingStyle.Exponential), {CFrame = cameraFolder["Camera 2B"].CFrame}):Play()
	task.wait(3)
	TeaseSuperSaiyan()
	task.wait(2)
	camera.CFrame = cameraFolder["Camera 3"].CFrame
	task.wait(1)
	TeaseSuperSaiyan()
	task.wait(2)
	Dialogue("Goku", "H-How...dare...you...")
	camera.CFrame = cameraFolder["Camera 4"].CFrame
	task.wait(1)
	TeaseSuperSaiyan()
	task.wait(2)
	DialogueHide()
	task.wait(1)
	Dialogue("Goku", "Y-You're... You're gonna pay for that...")
	task.wait(3)
	DialogueHide()
	animationLoop1:Stop()
	animationBreak1:Play()
	task.wait(1.15)
	Dialogue("Goku", "AAAAAGGGHHH!")
	task.wait(0.15)
	SuperSaiyan()
	task.wait(0.2)
	TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {FieldOfView = 100}):Play()
	Shine()
	task.wait(0.5)
	TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {FieldOfView = 50}):Play()
	playerGui.HealthGui.MainFrame.ProfilePicture.Character.Image = "rbxassetid://17034013622"
	playerGui.HealthGui.MainFrame.HealthFrame.Value.Text = "500000"
	playerGui.HealthGui.MainFrame.KiFrame.Value.Text = "5000"
	camera.CFrame = cameraFolder["Camera 5"].CFrame
	Sphere()
	DialogueHide()
	task.wait(3)
	camera.CFrame = cameraFolder["Camera 6A"].CFrame
	task.wait(2)
	game.TweenService:Create(camera, TweenInfo.new(7.5, Enum.EasingStyle.Cubic), {CFrame = cameraFolder["Camera 6B"].CFrame}):Play()
	task.wait(10)	
	character.Humanoid.WalkSpeed = 16
	character.Humanoid.JumpPower = 50
	character.Humanoid.AutoRotate = true
	camera.CameraType = Enum.CameraType.Custom
	camera.FieldOfView = 70
	GuiEnable(true)
	isActive = false
end
local function KiVFX()
	local vfx = game.ReplicatedStorage.Assets.KiSphere:Clone()
	vfx.Parent = workspace
	vfx.CFrame = character.HumanoidRootPart.CFrame
	TweenService:Create(vfx, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), {Size = Vector3.new(10, 10, 10), Transparency = 1}):Play()
	game.Debris:AddItem(vfx, 1)	
end
local function ChargeKi(boolean)
	if boolean then
		isActive = true
		animationLoop1:Play()
		character.Humanoid.WalkSpeed = 0
		character.Humanoid.JumpPower = 0
		character.Humanoid.AutoRotate = false
		repeat
			task.wait(0.5)
			KiVFX()
		until isActive == false
	else
		isActive = false
		animationLoop1:Stop()
		character.Humanoid.WalkSpeed = 16
		character.Humanoid.JumpPower = 50
		character.Humanoid.AutoRotate = true
	end
end
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if isActive then return end
	if input.KeyCode == Enum.KeyCode.G then
		if cutsceneDebounce == true then return end
		TransformCutscene()
	end
	if input.KeyCode == Enum.KeyCode.C then
		ChargeKi(true)
	end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.C then
		ChargeKi(false)
	end
end)