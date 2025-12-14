local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local function tp(cframe)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Position = cframe
end

local Window = Rayfield:CreateWindow({
    Name = "BlindShot Roblox Menu",
    LoadingTitle = "Blindshot OP Menu",
    LoadingSubtitle = "by maz",
    ShowText = "Menu",
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Big Hub"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Blindshot Menu Key",
        Subtitle = "Key System",
        Note = "dev1",
        FileName = "bskey",
        SaveKey = true,
        Key = {"dev1"}
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local frozenRoot
local lasers = {}
local antiFallPart
local antiFallHeight = 10

-- =================== Skins Section ===================
Tab:CreateSection("Skins")

Tab:CreateButton({
    Name = "Get All Skins",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("WeaponShopRemote")
        for i = 1, 6 do
            remote:FireServer(
                "PurchaseSkin",
                {
                    image = "rbxassetid://123456789",
                    name = "Nil",
                    price = 0,
                    id = i,
                    currency = "Cash"
                }
            )
            task.wait(0.1)
        end
    end,
})

-- =================== Player Actions Section ===================
Tab:CreateSection("Player Actions")

Tab:CreateButton({
    Name = "Sit",
    Callback = function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
            end
        end
    end,
})

Tab:CreateButton({
    Name = "Jump",
    Callback = function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end,
})

Tab:CreateButton({
    Name = "Show All Hitboxes",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    end
                end
                local hb = char:FindFirstChild("hitbox")
                if hb and hb:IsA("BasePart") then
                    hb.Transparency = 0.75
                    hb.CanCollide = false
                end
            end
        end
    end,
})

-- =================== Toggles Section ===================
Tab:CreateSection("Toggles")

-- Float Toggle
Tab:CreateToggle({
    Name = "Float",
    CurrentValue = false,
    Flag = "FreezeTP",
    Callback = function(Value)
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if Value then
            frozenRoot = hrp
            hrp.CFrame = hrp.CFrame + Vector3.new(0,2,0)
            hrp.Anchored = true
        else
            if frozenRoot then
                frozenRoot.Anchored = false
                frozenRoot = nil
            end
        end
    end,
})

-- Forward Lasers Toggle
Tab:CreateToggle({
    Name = "Forward Lasers",
    CurrentValue = false,
    Flag = "ForwardLaser",
    Callback = function(Value)
        if Value then
            -- Create lasers for all current players
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and not lasers[plr] then
                    local char = plr.Character
                    if char then
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                        if torso then
                            local beam = Instance.new("Part")
                            beam.Anchored = true
                            beam.CanCollide = false
                            beam.Size = Vector3.new(0.2,0.2,50)
                            beam.BrickColor = BrickColor.new("Bright blue")
                            beam.Material = Enum.Material.Neon
                            beam.Parent = workspace
                            lasers[plr] = {beam=beam, torso=torso}
                        end
                    end
                end
            end

            -- Add lasers for new players
            Players.PlayerAdded:Connect(function(plr)
                task.wait(1)
                if Value and plr ~= player and not lasers[plr] then
                    local char = plr.Character
                    if char then
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                        if torso then
                            local beam = Instance.new("Part")
                            beam.Anchored = true
                            beam.CanCollide = false
                            beam.Size = Vector3.new(0.2,0.2,50)
                            beam.BrickColor = BrickColor.new("Bright blue")
                            beam.Material = Enum.Material.Neon
                            beam.Parent = workspace
                            lasers[plr] = {beam=beam, torso=torso}
                        end
                    end
                end
            end)

            -- Update laser positions every frame
            local connection
            connection = RunService.RenderStepped:Connect(function()
                for plr, data in pairs(lasers) do
                    local beam = data.beam
                    local torso = data.torso
                    if beam and torso then
                        local startPos = torso.Position
                        local lookVec = torso.CFrame.LookVector
                        local endPos = startPos + lookVec * 50
                        local dir = (endPos - startPos).Unit
                        local dist = (endPos - startPos).Magnitude
                        beam.Size = Vector3.new(0.2,0.2,dist)
                        beam.CFrame = CFrame.new(startPos + dir*dist/2, endPos)
                    end
                end
            end)
            lasers["_connection"] = connection
        else
            -- Remove lasers
            if lasers["_connection"] then
                lasers["_connection"]:Disconnect()
                lasers["_connection"] = nil
            end
            for plr, data in pairs(lasers) do
                if data.beam then data.beam:Destroy() end
            end
            lasers = {}
        end
    end,
})

-- =================== Anti-Fall Section ===================
Tab:CreateSection("Anti-Fall")

-- Anti-Fall Height Slider
Tab:CreateSlider({
    Name = "Anti-Fall Height",
    Range = {0,250},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = antiFallHeight,
    Flag = "AntiFallHeightSlider",
    Callback = function(Value)
        antiFallHeight = Value
        if antiFallPart then
            antiFallPart.Position = workspace.chao.Position + Vector3.new(0, antiFallHeight, 0)
        end
    end,
})

-- Anti-Fall Toggle
Tab:CreateToggle({
    Name = "Anti-Fall",
    CurrentValue = false,
    Flag = "AntiFallToggle",
    Callback = function(Value)
        if Value then
            local chao = workspace:FindFirstChild("chao")
            if not chao then return end

            antiFallPart = Instance.new("Part")
            antiFallPart.Size = Vector3.new(50,1,50)
            antiFallPart.Anchored = true
            antiFallPart.CanCollide = true
            antiFallPart.Transparency = 0
            antiFallPart.Position = chao.Position + Vector3.new(0, antiFallHeight, 0)
            antiFallPart.Parent = workspace

            antiFallPart.Touched:Connect(function(hit)
                local plr = Players:GetPlayerFromCharacter(hit.Parent)
                if plr == player then
                    tp(chao.Position)
                end
            end)
        else
            if antiFallPart then
                antiFallPart:Destroy()
                antiFallPart = nil
            end
        end
    end,
})
