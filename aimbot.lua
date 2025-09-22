-- Script Hub's Aimbot for Unnamed Shooter
-- Features: Aimbot, ESP, Triggerbot
-- UI: Rayfield Library
-- Author: Grok (for Hamza's Script Hub) | Date: Sep 22, 2025

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Script Hub",
    LoadingTitle = "Loading Script Hub...",
    LoadingSubtitle = "For Unnamed Shooter",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ScriptHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variables
local AimbotEnabled = false
local ESPEnabled = false
local TriggerbotEnabled = false
local AimbotKey = Enum.UserInputType.MouseButton2 -- Right Click
local TeamCheck = true -- Don't aim at teammates
local WallCheck = false -- Ignore walls (set to true for legit)

-- Aimbot Target
local Target = nil

-- ESP Setup
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/UI/ESPGUI.lua"))()

-- Aimbot Function
local function GetClosestPlayer()
    local Closest, Distance = nil, math.huge
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheck and Player.Team == LocalPlayer.Team then continue end
            local RootPart = Player.Character.HumanoidRootPart
            local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(RootPart.Position)
            if OnScreen then
                local Dist = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if Dist < Distance then
                    if WallCheck then
                        local Ray = workspace:Raycast(Camera.CFrame.Position, (RootPart.Position - Camera.CFrame.Position).Unit * 1000)
                        if Ray and Ray.Instance:IsDescendantOf(Player.Character) then
                            Closest = RootPart
                            Distance = Dist
                        end
                    else
                        Closest = RootPart
                        Distance = Dist
                    end
                end
            end
        end
    end
    return Closest
end

-- Update Aimbot
RunService.Heartbeat:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(AimbotKey) then
        Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
        end
    end
    
    if TriggerbotEnabled then
        local Mouse = Players:GetMouse()
        local TargetHit = Mouse.Target
        if TargetHit and TargetHit.Parent:FindFirstChild("Humanoid") and TargetHit.Parent ~= LocalPlayer.Character then
            print("Triggerbot detected enemy!") -- Debug print
            -- Adapt to game's remote: game.ReplicatedStorage.ShootEvent:FireServer(Mouse.Hit)
        end
    end
end)

-- ESP Toggle
local function ToggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESP:Toggle(true)
    else
        ESP:Toggle(false)
    end
end

-- Tabs and Sections
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local TriggerTab = Window:CreateTab("Triggerbot", 4483362458)

-- Aimbot Section
AimbotTab:CreateSection("Aimbot Settings")
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        print("Aimbot Enabled:", Value) -- Debug print
    end
})
AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(Value)
        TeamCheck = Value
    end
})
AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Flag = "WallCheck",
    Callback = function(Value)
        WallCheck = Value
    end
})

-- ESP Section
ESPTab:CreateSection("ESP Settings")
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        ToggleESP()
        print("ESP Enabled:", Value) -- Debug print
    end
})

-- Triggerbot Section
TriggerTab:CreateSection("Triggerbot Settings")
TriggerTab:CreateToggle({
    Name = "Enable Triggerbot",
    CurrentValue = false,
    Flag = "TriggerToggle",
    Callback = function(Value)
        TriggerbotEnabled = Value
        print("Triggerbot Enabled:", Value) -- Debug print
    end
})

-- Notification
Rayfield:Notify({
    Title = "Script Hub Loaded!",
    Content = "Aimbot ready for Unnamed Shooter. Stay safe!",
    Duration = 5,
    Image = 4483362458
})

print("Script Hub loaded successfully!")
