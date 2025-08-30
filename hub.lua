-- Load OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Universal Script GUI", HidePremium = false, IntroText = "Universal Hub", SaveConfig = true, ConfigFolder = "UniversalHub"})

---------------------------------------------------------------------
-- ESP TAB
local EspTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

EspTab:AddToggle({
    Name = "ESP Boxes",
    Default = getgenv().EspSettings.Boxes.Enabled,
    Callback = function(Value)
        getgenv().EspSettings.Boxes.Enabled = Value
    end
})

EspTab:AddToggle({
    Name = "ESP Tracers",
    Default = getgenv().EspSettings.Tracers.Enabled,
    Callback = function(Value)
        getgenv().EspSettings.Tracers.Enabled = Value
    end
})

EspTab:AddToggle({
    Name = "ESP Skeletons",
    Default = getgenv().EspSettings.Skeletons.Enabled,
    Callback = function(Value)
        getgenv().EspSettings.Skeletons.Enabled = Value
    end
})

EspTab:AddToggle({
    Name = "ESP Names",
    Default = getgenv().EspSettings.Names.Enabled,
    Callback = function(Value)
        getgenv().EspSettings.Names.Enabled = Value
    end
})

EspTab:AddSlider({
    Name = "ESP Max Distance",
    Min = 100,
    Max = 2000,
    Default = getgenv().EspSettings.MaximumDistance,
    Increment = 50,
    Callback = function(Value)
        getgenv().EspSettings.MaximumDistance = Value
    end
})

---------------------------------------------------------------------
-- AIMBOT TAB
local AimbotTab = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = getgenv().AimbotSettings.Enabled,
    Callback = function(Value)
        getgenv().AimbotSettings.Enabled = Value
    end
})

AimbotTab:AddToggle({
    Name = "Team Check",
    Default = getgenv().AimbotSettings.TeamCheck,
    Callback = function(Value)
        getgenv().AimbotSettings.TeamCheck = Value
    end
})

AimbotTab:AddSlider({
    Name = "Aimbot Smoothness",
    Min = 0,
    Max = 1,
    Default = getgenv().AimbotSettings.Smoothness,
    Increment = 0.05,
    Callback = function(Value)
        getgenv().AimbotSettings.Smoothness = Value
    end
})

AimbotTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 10,
    Max = 500,
    Default = getgenv().AimbotSettings.FOV,
    Increment = 10,
    Callback = function(Value)
        getgenv().AimbotSettings.FOV = Value
    end
})

AimbotTab:AddDropdown({
    Name = "Aim Part",
    Default = getgenv().AimbotSettings.AimPart,
    Options = {"Head", "HumanoidRootPart", "Torso"},
    Callback = function(Value)
        getgenv().AimbotSettings.AimPart = Value
    end
})

---------------------------------------------------------------------
-- MISC TAB (ONE HIT KILL)
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddButton({
    Name = "Enable One Hit Kill",
    Callback = function()
        for i, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v,"FireRate") then
                v.FireRate = 5000
                v.Range = Vector2.new(99999999, 99999999)
                v.MagnetStrength = 1000
                v.AmmoCapacity = math.huge
                v.Damage = 999999
            end
        end
    end
})

---------------------------------------------------------------------
OrionLib:Init()
