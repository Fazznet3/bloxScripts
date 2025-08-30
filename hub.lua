-- ESP SETTINGS
getgenv().EspSettings = {
    TeamCheck = false,
    ToggleKey = "RightAlt",
    RefreshRate = 10,
    MaximumDistance = 500,
    FaceCamera = false,
    AlignPoints = false,
    MouseVisibility = {
        Enabled = true,
        Radius = 60,
        Transparency = 0.3,
        Method = "Hover",
        HoverRadius = 50,
        Selected = {
            Boxes = true,
            Tracers = true,
            Names = true,
            Skeletons = true,
            HealthBars = true,
            HeadDots = true,
            LookTracers = true
        }
    },
    Highlights = {
        Enabled = false,
        Players = {},
        Transparency = 1,
        Color = Color3.fromRGB(255, 150, 0),
        AlwaysOnTop = true
    },
    NPC = {
        Color = Color3.fromRGB(150,150,150),
        Transparency = 1,
        RainbowColor = false,
        Overrides = {
            Boxes = true,
            Tracers = true,
            Names = true,
            Skeletons = true,
            HealthBars = true,
            HeadDots = true,
            LookTracers = true
        }
    },
    Boxes = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Thickness = 1
    },
    Tracers = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Origin = "Top",
        Thickness = 1
    },
    Names = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        Font = Drawing.Fonts.UI,
        Size = 18,
        ShowDistance = false,
        ShowHealth = true,
        UseDisplayName = false,
        DistanceDataType = "m",
        HealthDataType = "Percentage"
    },
    Skeletons = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Thickness = 1
    },
    HealthBars = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(0,255,0),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Origin = "None",
        OutlineBarOnly = true
    },
    HeadDots = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Thickness = 1,
        Filled = false,
        Scale = 1
    },
    LookTracers = {
        Enabled = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,255,255),
        UseTeamColor = true,
        RainbowColor = false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0,0,0),
        OutlineThickness = 1,
        Thickness = 1,
        Length = 5
    }
}

-- Load ESP
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dragon5819/Main/main/esp", "UniversalEsp"))()

---------------------------------------------------------------------
-- AIMBOT SETTINGS
getgenv().AimbotSettings = {
    Enabled = true,
    TeamCheck = true,
    AimPart = "Head",
    Smoothness = 0.2,
    FOV = 120,
    ToggleKey = "RightShift"
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotEnabled = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode[getgenv().AimbotSettings.ToggleKey] then
        aimbotEnabled = not aimbotEnabled
    end
end)

local function getClosestPlayer()
    local closestPlayer, shortestDistance = nil, getgenv().AimbotSettings.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and getgenv().AimbotSettings.Enabled then
        local target = getClosestPlayer()
        if target and target.Character:FindFirstChild(getgenv().AimbotSettings.AimPart) then
            local aimPart = target.Character[getgenv().AimbotSettings.AimPart]
            local targetPos = Camera:WorldToViewportPoint(aimPart.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local aimPos = Vector2.new(targetPos.X, targetPos.Y)
            local newPos = mousePos:Lerp(aimPos, getgenv().AimbotSettings.Smoothness)
            mousemoverel((newPos.X - mousePos.X), (newPos.Y - mousePos.Y))
        end
    end
end)

---------------------------------------------------------------------
-- ONE HIT KILL
for i, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v,"FireRate") then
        v.FireRate = 5000
        v.Range = Vector2.new(99999999, 99999999)
        v.MagnetStrength = 1000
        v.AmmoCapacity = math.huge
        v.Damage = 999999 -- ini bikin 1 hit kill
    end
end
