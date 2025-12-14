local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local frozenRoot
local lasers = {}
local antiFallPart
local antiFallHeight = 1020

-- Teleport helper
local function tp(cframe)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Position = cframe
    end
end

-- =================== Window ===================
local Window = Rayfield:CreateWindow({
    Name = "BlindShot Roblox Menu",
    LoadingTitle = "Blindshot OP Menu",
    LoadingSubtitle = "by maz",
    ShowText = "Menu",
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = false, FileName = "n" },
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

-- =================== Skins ===================
Tab:CreateSection("Skins")
Tab:CreateButton({
    Name = "Get All Skins",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("WeaponShopRemote")
        for i = 1, 6 do
            remote:FireServer("PurchaseSkin", {
                image = "rbxassetid://123456789",
                name = "Nil",
                price = 0,
                id = i,
                currency = "Cash"
            })
            task.wait(0.1)
        end
    end
})

-- =================== Player Actions ===================
Tab:CreateSection("Player Actions")
Tab:CreateButton({
    Name = "Sit",
    Callback = function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
            end
        end
    end
})
Tab:CreateButton({
    Name = "Jump",
    Callback = function()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
})
-- Show hitboxes toggle
local showHitboxes = false
local hitboxConnection
Tab:CreateToggle({
    Name = "Show All Hitboxes",
    CurrentValue = false,
    Flag = "ShowHitboxesToggle",
    Callback = function(Value)
        showHitboxes = Value
        if Value then
            hitboxConnection = RunService.RenderStepped:Connect(function()
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
            end)
        else
            if hitboxConnection then
                hitboxConnection:Disconnect()
                hitboxConnection = nil
            end
        end
    end
})

-- =================== Toggles ===================
Tab:CreateSection("Toggles")

-- Float
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
            hrp.CFrame = hrp.CFrame + Vector3.new(0,50,0)
            hrp.Anchored = true
        else
            if frozenRoot then
                frozenRoot.Anchored = false
                frozenRoot = nil
            end
        end
    end
})

-- Lasers
Tab:CreateToggle({
    Name = "Lasers (Turn off before shooting)",
    CurrentValue = false,
    Flag = "ForwardLaser",
    Callback = function(Value)
        if Value then
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
            if lasers["_connection"] then
                lasers["_connection"]:Disconnect()
                lasers["_connection"] = nil
            end
            for plr, data in pairs(lasers) do
                if data.beam then data.beam:Destroy() end
            end
            lasers = {}
        end
    end
})

Tab:CreateButton({
    Name = "Refresh Lasers",
    Callback = function()
        for plr, data in pairs(lasers) do
            if data.beam then data.beam:Destroy() end
        end
        lasers = {}
    end
})

-- =================== Anti-Fall ===================
Tab:CreateSection("Anti-Fall")

Tab:CreateSlider({
    Name = "Anti-Fall Height",
    Range = {1020,2500},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = antiFallHeight,
    Flag = "AntiFallHeightSlider",
    Callback = function(Value)
        antiFallHeight = Value
        if antiFallPart then
            antiFallPart.Position = workspace.chao.Position + Vector3.new(0, antiFallHeight, 0)
        end
    end
})

Tab:CreateToggle({
    Name = "Anti-Fall",
    CurrentValue = false,
    Flag = "AntiFallToggle",
    Callback = function(Value)
        if Value then
            local chao = workspace:FindFirstChild("chao")
            if not chao then return end
            antiFallPart = Instance.new("Part")
            antiFallPart.Size = Vector3.new(150,1,150)
            antiFallPart.Anchored = true
            antiFallPart.CanCollide = true
            antiFallPart.Transparency = 0.5
            antiFallPart.Position = chao.Position + Vector3.new(0, antiFallHeight, 0)
            antiFallPart.Parent = workspace

            antiFallPart.Touched:Connect(function(hit)
                local plr = Players:GetPlayerFromCharacter(hit.Parent)
                if plr == player then
                    tp(antiFallPart.Position + Vector3.new(0, 20, 0))
                end
            end)
        else
            if antiFallPart then
                antiFallPart:Destroy()
                antiFallPart = nil
            end
        end
    end
})

-- =================== Lock-On ===================
Tab:CreateSection("Lock-On")
local lockRange = 20
local lockOn = false
local rangeSphere

Tab:CreateSlider({
    Name = "Lock-On Range",
    Range = {1,100},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = lockRange,
    Flag = "LockOnRange",
    Callback = function(Value)
        lockRange = Value
        if rangeSphere then
            rangeSphere.Size = Vector3.new(lockRange*2, lockRange*2, lockRange*2)
        end
    end
})

Tab:CreateToggle({
    Name = "Lock-On Target",
    CurrentValue = false,
    Flag = "LockOnToggle",
    Callback = function(Value)
        lockOn = Value
        local char = player.Character
        if lockOn and char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                rangeSphere = Instance.new("Part")
                rangeSphere.Shape = Enum.PartType.Ball
                rangeSphere.Anchored = true
                rangeSphere.CanCollide = false
                rangeSphere.Transparency = 0.5
                rangeSphere.Color = Color3.fromRGB(0,0,255)
                rangeSphere.Size = Vector3.new(lockRange*2, lockRange*2, lockRange*2)
                rangeSphere.Position = hrp.Position
                rangeSphere.Parent = workspace
            end
        elseif not lockOn and rangeSphere then
            rangeSphere:Destroy()
            rangeSphere = nil
        end
    end
})

-- Smooth lock-on
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if rangeSphere then rangeSphere.Position = hrp.Position end

        if lockOn then
            local nearest
            local nearestDist = math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    local tChar = plr.Character
                    if tChar and tChar:FindFirstChild("HumanoidRootPart") then
                        local targetPos = tChar.HumanoidRootPart.Position
                        local dist = (targetPos - hrp.Position).Magnitude
                        if dist <= lockRange and dist < nearestDist then
                            nearest = tChar.HumanoidRootPart
                            nearestDist = dist
                        end
                    end
                end
            end

            if nearest then
                local targetPos = nearest.Position + Vector3.new(0,7,0)
                local desiredCFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                hrp.CFrame = hrp.CFrame:lerp(desiredCFrame, 0.15)
            end
        end
    end
end)

-- =================== Super Punch ===================
Tab:CreateSection("Combat")
local superPunchConnection
Tab:CreateToggle({
    Name = "Super Punch",
    CurrentValue = false,
    Flag = "SuperPunchToggle",
    Callback = function(Value)
        if superPunchConnection then
            superPunchConnection:Disconnect()
            superPunchConnection = nil
        end

        if Value then
            superPunchConnection = RunService.RenderStepped:Connect(function()
                local char = player.Character
                if not char then return end
                local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") or char:FindFirstChild("RightUpperArm")
                if not rightArm then return end

                local fistsFolder = workspace:FindFirstChild(player.Name)
                if not fistsFolder then return end

                local fists = fistsFolder:FindFirstChild("Fists", true)
                if not fists then return end

                local fistRemote = fists:FindFirstChild("fistremote", true)
                if not fistRemote then return end

                local args = {
                    [1] = "part",
                    [2] = rightArm,
                    [3] = Vector3.new(0,0,0),
                    [4] = Vector3.new(250,250,250)
                }
                fistRemote:FireServer(unpack(args))
            end)
        end
    end
})

-- =================== Selected Player Lock-On ===================
Tab:CreateSection("Target Lock")
local selectedPlayerName = nil
local selectedLockOn = false
local dropdown
local function updateDropdown()
    local options = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(options, plr.Name)
        end
    end
    dropdown:Refresh(options)
end

dropdown = Tab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "SelectedPlayerDropdown",
    Callback = function(Options)
        selectedPlayerName = Options[1]
    end
})

Tab:CreateToggle({
    Name = "Lock-On Selected",
    CurrentValue = false,
    Flag = "SelectedPlayerLock",
    Callback = function(Value)
        selectedLockOn = Value
    end
})

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)
updateDropdown() -- initial
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char or not selectedLockOn or not selectedPlayerName then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPlr = Players:FindFirstChild(selectedPlayerName)
    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlr.Character.HumanoidRootPart.Position + Vector3.new(0,7,0)
        local desiredCFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        hrp.CFrame = hrp.CFrame:lerp(desiredCFrame, 0.15)
    end
end)
