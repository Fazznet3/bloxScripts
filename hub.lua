--[[
    Skrip ini menggabungkan fungsionalitas ESP, Aimbot, dan Weapon Mod
    dengan antarmuka pengguna grafis (GUI) dari Rayfield.
    
    Cara Kerja:
    1. Pengaturan Awal: Semua pengaturan untuk ESP dan Aimbot didefinisikan terlebih dahulu.
    2. Pustaka GUI: Memuat pustaka Rayfield untuk membuat antarmuka.
    3. Logika Inti: Skrip ESP, Aimbot, dan One Hit Kill dari Anda disertakan.
    4. Elemen GUI:
        - Membuat jendela utama dengan tiga tab: ESP, Aimbot, dan Weapon.
        - Setiap tab diisi dengan elemen (toggle, slider, textbox, color picker) yang
          terhubung langsung ke tabel pengaturan (getgenv().EspSettings dan getgenv().AimbotSettings).
        - Setiap perubahan pada GUI akan langsung memperbarui pengaturan skrip secara real-time.
]]

--==================================================================================
--=[ BAGIAN 1: PENGATURAN & LOGIKA INTI (DARI SKRIP ANDA) ]=--
--==================================================================================

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
-- ONE HIT KILL FUNCTION
function ApplyOneHitKill()
    for i, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v,"FireRate") then
            v.FireRate = 5000
            v.Range = Vector2.new(99999999, 99999999)
            v.MagnetStrength = 1000
            v.AmmoCapacity = math.huge
            v.Damage = 999999 -- ini bikin 1 hit kill
        end
    end
end


--==================================================================================
--=[ BAGIAN 2: PEMBUATAN GUI ]=--
--==================================================================================

-- Memuat Pustaka Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Membuat Jendela Utama
local Window = Rayfield:CreateWindow({
    Name = "Universal Script GUI",
    LoadingTitle = "Loading Interface",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalScriptConfig",
        FileName = "Settings"
    }
})

-- TAB: AIMBOT
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = getgenv().AimbotSettings.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        getgenv().AimbotSettings.Enabled = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = getgenv().AimbotSettings.TeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        getgenv().AimbotSettings.TeamCheck = Value
    end,
})

AimbotTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
    CurrentOption = getgenv().AimbotSettings.AimPart,
    Flag = "AimPart",
    Callback = function(Option)
        getgenv().AimbotSettings.AimPart = Option
    end,
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = getgenv().AimbotSettings.Smoothness,
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        getgenv().AimbotSettings.Smoothness = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = getgenv().AimbotSettings.FOV,
    Flag = "AimbotFOV",
    Callback = function(Value)
        getgenv().AimbotSettings.FOV = Value
    end,
})

AimbotTab:CreateTextbox({
    Name = "Toggle Key",
    Content = getgenv().AimbotSettings.ToggleKey,
    Placeholder = "e.g., RightShift",
    Flag = "AimbotToggleKey",
    Callback = function(Text)
        getgenv().AimbotSettings.ToggleKey = Text
    end,
})

-- TAB: ESP
local EspTab = Window:CreateTab("ESP", 4483362458)

local EspSectionGeneral = EspTab:CreateSection("General Settings")

EspTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = getgenv().EspSettings.TeamCheck,
    Flag = "EspTeamCheck",
    Callback = function(Value)
        getgenv().EspSettings.TeamCheck = Value
    end,
})

EspTab:CreateSlider({
    Name = "Maximum Distance",
    Range = {100, 2000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = getgenv().EspSettings.MaximumDistance,
    Flag = "EspMaxDistance",
    Callback = function(Value)
        getgenv().EspSettings.MaximumDistance = Value
    end,
})

-- Bagian ESP lainnya di sini
local function CreateEspComponentSection(tab, componentName)
    local settings = getgenv().EspSettings[componentName]
    tab:CreateSection(componentName .. " ESP")

    tab:CreateToggle({
        Name = "Enable " .. componentName,
        CurrentValue = settings.Enabled,
        Flag = "Esp" .. componentName .. "Enabled",
        Callback = function(Value)
            settings.Enabled = Value
        end,
    })

    tab:CreateToggle({
        Name = "Use Team Color",
        CurrentValue = settings.UseTeamColor,
        Flag = "Esp" .. componentName .. "TeamColor",
        Callback = function(Value)
            settings.UseTeamColor = Value
        end,
    })
    
    tab:CreateToggle({
        Name = "Rainbow Color",
        CurrentValue = settings.RainbowColor,
        Flag = "Esp" .. componentName .. "Rainbow",
        Callback = function(Value)
            settings.RainbowColor = Value
        end,
    })

    tab:CreateColorpicker({
        Name = componentName .. " Color",
        Color = settings.Color,
        Flag = "Esp" .. componentName .. "Color",
        Callback = function(Value)
            settings.Color = Value
        end,
    })
    
    if settings.Thickness then
        tab:CreateSlider({
            Name = "Thickness",
            Range = {1, 10},
            Increment = 1,
            CurrentValue = settings.Thickness,
            Flag = "Esp" .. componentName .. "Thickness",
            Callback = function(Value)
                settings.Thickness = Value
            end,
        })
    end
end

-- Membuat bagian untuk setiap komponen ESP
CreateEspComponentSection(EspTab, "Boxes")
CreateEspComponentSection(EspTab, "Tracers")
CreateEspComponentSection(EspTab, "Skeletons")
CreateEspComponentSection(EspTab, "HeadDots")
-- Untuk Names dan HealthBars, kita tambahkan kustomisasi ekstra
local NameSettings = getgenv().EspSettings.Names
EspTab:CreateSection("Names ESP")
EspTab:CreateToggle({Name = "Enable Names", CurrentValue = NameSettings.Enabled, Callback = function(v) NameSettings.Enabled = v end})
EspTab:CreateToggle({Name = "Use Team Color", CurrentValue = NameSettings.UseTeamColor, Callback = function(v) NameSettings.UseTeamColor = v end})
EspTab:CreateToggle({Name = "Rainbow Color", CurrentValue = NameSettings.RainbowColor, Callback = function(v) NameSettings.RainbowColor = v end})
EspTab:CreateToggle({Name = "Show Distance", CurrentValue = NameSettings.ShowDistance, Callback = function(v) NameSettings.ShowDistance = v end})
EspTab:CreateToggle({Name = "Show Health", CurrentValue = NameSettings.ShowHealth, Callback = function(v) NameSettings.ShowHealth = v end})
EspTab:CreateSlider({Name = "Font Size", Range = {12, 30}, Increment = 1, CurrentValue = NameSettings.Size, Callback = function(v) NameSettings.Size = v end})
EspTab:CreateColorpicker({Name = "Name Color", Color = NameSettings.Color, Callback = function(v) NameSettings.Color = v end})


-- TAB: WEAPON
local WeaponTab = Window:CreateTab("Weapon", 4483362458)

WeaponTab:CreateLabel("Modifikasi senjata untuk damage tinggi.")
WeaponTab:CreateButton({
    Name = "Activate One Hit Kill",
    Callback = function()
        ApplyOneHitKill()
        Rayfield:Notify({
            Title = "Success",
            Content = "Weapon stats have been modified.",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "GUI is ready to use.",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        -- Tidak ada action
    },
})
