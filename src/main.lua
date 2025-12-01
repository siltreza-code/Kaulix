local spawn = task.spawn
local delay = task.delay

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

local CG:Instance = Services.CoreGui
local P:Players = Services.Players
local UIS:UserInputService = Services.UserInputService
local TS:TweenService = Services.TweenService
local RS:RunService = Services.RunService

local Module = {}

local function RandStr(min, Max)
	local L = math.random(min, Max)
	local AR = {}
	for i = 1, L do
		local n
		if math.random() < 0.5 then
			n = math.random(48, 57)
		else
			n = math.random(65, 90)
			if math.random() < 0.5 then n = n + 32 end
		end
		AR[i] = string.char(n)
	end
	return table.concat(AR)
end

local function Create(className: string, parent: Instance?, properties: {[string]: any})
	local inst = Instance.new(className)
	for prop, value in pairs(properties or {}) do
		pcall(function()
			inst[prop] = value
		end)
	end
	
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function GetTime()
	return os.date("*t", os.time())
end

function Module.Create(Name:string)
	local P = get_hidden_gui or gethui or Create("ScreenGui", CG, {IgnoreGuiInset=true,ResetOnSpawn=false,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Name=RandStr(15,30)})
	local Overlay = Create("CanvasGroup",P,{Name=RandStr(15, 30),Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(55,55,55),
		BackgroundTransparency = 1, GroupTransparency = 1})
	
	-- Widget
	local Widget1 = Create("Frame",Overlay,{AnchorPoint=Vector2.new(.5,0),BackgroundColor3=Color3.new(0.4, 0.4, 0.4),
		Position=UDim2.fromScale(.5,.05),Size=UDim2.fromScale(.35,.2),Name=RandStr(15,30)})
	Create("UIStroke", Widget1, {LineJoinMode=Enum.LineJoinMode.Miter,Thickness=4})
	
	local TimePart = Create("TextLabel", Widget1, {Name = RandStr(15, 30),BackgroundTransparency=1,
		Position=UDim2.fromScale(.04,.15),Size=UDim2.fromScale(.4,.3), TextColor3=Color3.new(1,1,1),TextScaled=true})
	Create("UIStroke",TimePart,{Thickness=1.5})
	
	spawn(function()
		while task.wait(1) do
			local T = GetTime()
			TimePart.Text = string.format("Time: %d-%d-%d %02d:%02d", T.year, T.month, T.day, T.hour, T.sec)
		end
	end)
	
	local Info = TweenInfo.new(2,Enum.EasingStyle.Sine)
	local Show = TS:Create(Overlay,Info,{BackgroundTransparency=0.5, GroupTransparency = 0})
	local Hide = TS:Create(Overlay,Info,{BackgroundTransparency=1, GroupTransparency = 1})
	local shown = true
	UIS.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then return end
		if input.KeyCode == Enum.KeyCode.Delete then
			if shown then
				Hide:Play()
			else
				Show:Play()
			end
		end
	end)
	Show:Play()
end

return Module
