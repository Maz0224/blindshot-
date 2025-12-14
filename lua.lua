local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

Tab:CreateSection("Game")

Tab:CreateButton({
   Name = "Show All Hitboxes",
   Callback = function()
      for _, player in ipairs(game.Players:GetPlayers()) do
         local character = player.Character
         if character then
            for _, part in ipairs(character:GetChildren()) do
               if part:IsA("BasePart") then
                  part.Transparency = 0
               end
            end
            local hb = character:FindFirstChild("hitbox")
            if hb and hb:IsA("BasePart") then
               hb.Transparency = 0.75
               hb.CanCollide = false
            end
         end
      end
   end,
})

Tab:CreateButton({
   Name = "Sit",
   Callback = function()
      local player = game.Players.LocalPlayer
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
      local player = game.Players.LocalPlayer
      local character = player.Character
      if character then
         local humanoid = character:FindFirstChildOfClass("Humanoid")
         if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end
   end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local frozenRoot
local beams = {}

Tab:CreateToggle({
   Name = "Float",
   CurrentValue = false,
   Flag = "FreezeTP",
   Callback = function(Value)
      local character = player.Character
      if not character then return end
      local hrp = character:FindFirstChild("HumanoidRootPart")
      if not hrp then return end
      if Value then
         frozenRoot = hrp
         hrp.CFrame = hrp.CFrame + Vector3.new(0, 2, 0)
         hrp.Anchored = true
      else
         if frozenRoot then
            frozenRoot.Anchored = false
            frozenRoot = nil
         end
      end
   end,
})

Tab:CreateToggle({
    Name = "Show Lasers",
    CurrentValue = false,
    Flag = "RedBeamESP",
    Callback = function(Value)
        if Value then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    local char = plr.Character
                    if char then
                        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                        if rightHand and rightHand:IsA("BasePart") then
                            local beam = Instance.new("Part")
                            beam.Anchored = true
                            beam.CanCollide = false
                            beam.Size = Vector3.new(0.2, 0.2, 50)
                            beam.BrickColor = BrickColor.new("Bright red")
                            beam.Material = Enum.Material.Neon
                            beam.Parent = workspace
                            beams[plr] = beam
                        end
                    end
                end
            end

            local connection
            connection = RunService.RenderStepped:Connect(function()
                for plr, beam in pairs(beams) do
                    local char = plr.Character
                    if char then
                        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                        if rightHand then
                            local lookVec = rightHand.CFrame.LookVector
                            local center = rightHand.Position + lookVec * 25
                            beam.CFrame = CFrame.new(center, rightHand.Position + lookVec * 50)
                            beam.CFrame = beam.CFrame * CFrame.Angles(math.rad(90),0,0)
                        end
                    end
                end
            end)
            beams["_connection"] = connection
        else
            if beams["_connection"] then
                beams["_connection"]:Disconnect()
                beams["_connection"] = nil
            end
            for plr, beam in pairs(beams) do
                if beam and beam:IsA("Part") then
                    beam:Destroy()
                end
            end
            beams = {}
        end
    end,
})
