local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BlindShot Roblox Menu",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Blindshot OP Menu",
   LoadingSubtitle = "by maz",
   ShowText = "Menu", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Blindshot Menu Key",
      Subtitle = "Key System",
      Note = "dev1", -- Use this to tell the user how to get a key
      FileName = "bskey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"dev1"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Skins")

local Button = Tab:CreateButton({
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
end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})

local Section = Tab:CreateSection("Game")

local Button = Tab:CreateButton({
   Name = "Show All Hitboxes",
   Callback = function()
      for _, player in ipairs(game.Players:GetPlayers()) do
         local character = player.Character
         if character then
            -- Make all body parts visible
            for _, part in ipairs(character:GetChildren()) do
               if part:IsA("BasePart") then
                  part.Transparency = 0
               end
            end

            -- Show hitbox if it exists
            local hb = character:FindFirstChild("hitbox")
            if hb and hb:IsA("BasePart") then
               hb.Transparency = 0.75
               hb.CanCollide = false
            end
         end
      end
   end,
})
