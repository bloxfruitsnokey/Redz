loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Core.luau"))()

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/ui.luau"))()
local Window = redzlib:MakeWindow({
    Title = "Redz Hub : Blox Fruit",
    SubTitle = "by @redz",
    SaveFolder = "oknaiget.json"
})
local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.LeftControl
})
local MobileButton = Minimizer:CreateMobileMinimizer({
  Image = "rbxassetid://132684424743910",
  BackgroundColor3 = Color3.fromRGB(25, 25, 25)
})
local Tabs = {
    Info = Window:MakeTab({ Title = "Tab Info And Status", Icon = "Info" }),
    Main = Window:MakeTab({ Title = "Tab Farming", Icon = "rbxassetid://7733960981" }),
    Settings = Window:MakeTab({ Title = "Tab Setting", Icon = "rbxassetid://7734053495" }),
    Fish = Window:MakeTab({ Title = "Tab Fishing", Icon = "rbxassetid://127664059821666" }),
    Quests = Window:MakeTab({ Title = "Tab Quest And Item", Icon = "rbxassetid://13075622619" }),
    SeaEvent = Window:MakeTab({ Title = "Tab Sea Event", Icon = "waves" }),
    Race = Window:MakeTab({ Title = "Tab Mirage And Race", Icon = "rbxassetid://11162889532" }),
    Prehistoric = Window:MakeTab({ Title = "Tab Volcano Event", Icon = "tent" }),
    Esp = Window:MakeTab({ Title = "Tab Stats And Esp", Icon = "rbxassetid://7040410130" }),
    Raids = Window:MakeTab({ Title = "Tab Fruit And Raid", Icon = "rbxassetid://11155986081" }),
    Combat = Window:MakeTab({ Title = "Tab Local Player", Icon = "rbxassetid://13075651575" }),
    Travel = Window:MakeTab({ Title = "Tab Teleport", Icon = "locate" }),
    Shop = Window:MakeTab({ Title = "Tab Shopping", Icon = "rbxassetid://6031265976" }),
    Misc = Window:MakeTab({ Title = "Tab Miscellaneous", Icon = "rbxassetid://10709783577" })
}
Tabs.Info:AddSection("Status Server")
local TimeZone = Tabs.Info:AddParagraph("Time Zone", "")
local GameTime = Tabs.Info:AddParagraph("Game Time", "")

function UpdateOS()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "AM" or "PM"
    local timezone = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)    
    
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local result, code    
    
    if not getgenv().countryRegionCode then
        result, code = pcall(function()
            return LocalizationService:GetCountryRegionForPlayerAsync(player)
        end)
        if result then
            getgenv().countryRegionCode = code
        else
            getgenv().countryRegionCode = "Unknown"
        end
    else
        code = getgenv().countryRegionCode
    end
    
    TimeZone:SetDesc(datetime.." - "..timezone.." [ " .. code .. " ]")
end

spawn(function()
    while true do
        UpdateOS()
        wait(1)
    end
end)

function UpdateGameTime()
    local GameTimeValue = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTimeValue / (60^2)) % 24
    local Minute = math.floor(GameTimeValue / (60^1)) % 60
    local Second = math.floor(GameTimeValue / (60^0)) % 60
    GameTime:SetDesc(Hour.." Hour (h) "..Minute.." Minute (m) "..Second.." Second (s)")
end

spawn(function()
    while true do
        UpdateGameTime()
        wait(1)
    end
end)

local MirageCheck = Tabs.Info:AddParagraph("Mirage Island", "Status: ")
local previousMirageStatus = ""
spawn(function()
    pcall(function()
        while true do
            wait(1)            
            local mirageIslandExists = game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') ~= nil
            local currentStatus = mirageIslandExists and '✅' or '❌'
            if currentStatus ~= previousMirageStatus then
                MirageCheck:SetDesc('Status: ' .. currentStatus)
                previousMirageStatus = currentStatus
            end
        end
    end)
end)
local KitsuneCheck = Tabs.Info:AddParagraph("Kitsune Island", "Status: ")
local previousKitsuneStatus = ""
spawn(function()
    while task.wait(1) do
        pcall(function()
        local currentStatus = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") and '✅' or '❌'
        if currentStatus ~= previousKitsuneStatus then
            KitsuneCheck:SetDesc('Status: ' .. currentStatus)
            previousKitsuneStatus = currentStatus
        end
        end)
    end
end)
local PrehistoricCheck = Tabs.Info:AddParagraph("Prehistoric Island", "Status: ")
local previousPrehistoricStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") and '✅' or '❌'
        if currentStatus ~= previousPrehistoricStatus then
            PrehistoricCheck:SetDesc("Status: " .. currentStatus)
            previousPrehistoricStatus = currentStatus
        end
        end)
    end
end)
local FrozenCheck = Tabs.Info:AddParagraph("Frozen Dimension", "Status: ")
local previousFrozenStatus = ""
spawn(function()
    while wait(1) do
        pcall(function()
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') and '✅' or '❌'
        if currentStatus ~= previousFrozenStatus then
            FrozenCheck:SetDesc('Status: ' .. currentStatus)
            previousFrozenStatus = currentStatus
        end
        end)
    end
end)
local CakePrinceStatus = Tabs.Info:AddParagraph("Cake Prince", "")
spawn(function()
    while wait(1) do
        -- the server answers with the boss MODEL (not a string) once he has spawned; string.len on it threw and
        -- killed this loop permanently
        local okCP, cakePrince = pcall(function() return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner") end)
        local killStatus = "Cake Prince: ✅"
        if okCP and type(cakePrince) == "string" and string.len(cakePrince) >= 86 then
            local killCount = string.sub(cakePrince, 39, 41)
            killStatus = "Killed: " .. killCount
        end
        CakePrinceStatus:SetDesc(killStatus)
    end
end)
local RipIndraCheck = Tabs.Info:AddParagraph("Rip Indra", "Status: ")
local previousRipStatus = ""
spawn(function()
    while wait(1) do
        pcall(function()
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and '✅' or '❌'
        if currentStatus ~= previousRipStatus then
            RipIndraCheck:SetDesc("Status: " .. currentStatus)
            previousRipStatus = currentStatus
        end
        end)
    end
end)
local DoughKingCheck = Tabs.Info:AddParagraph("Dough King", "Status: ")
local previousDoughStatus = ""
spawn(function()
    while wait(1) do
        pcall(function()
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and '✅' or '❌'
        if currentStatus ~= previousDoughStatus then
            DoughKingCheck:SetDesc("Status: " .. currentStatus)
            previousDoughStatus = currentStatus
        end
        end)
    end
end)
local FullMoonCheck = Tabs.Info:AddParagraph("Full Moon", "")
task.spawn(function()
    while task.wait(1) do
        pcall(function()
        local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
        local moonStatus = "Moon: 0/5"
        
        if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
            moonStatus = "Moon: 5/5 (Full Moon) ✅"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
            moonStatus = "Moon: 4/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
            moonStatus = "Moon: 3/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
            moonStatus = "Moon: 2/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
            moonStatus = "Moon: 1/5"
        end
        
        FullMoonCheck:SetDesc(moonStatus)
        end)
    end
end)
local LegendarySwordCheck = Tabs.Info:AddParagraph("Legendary Sword", "Status: ")
spawn(function()
    -- Status only READS what you own. It used to call LegendarySwordDealer "1"/"2"/"3" every second, which are the
    -- purchase calls ("1" asks which sword is on offer, "2" buys it; the "Buy Legendary Sword" button uses them): standing near the dealer with enough
    -- beli, this label could silently buy swords.
    while wait(5) do
        pcall(function()
            local owned = {}
            for _, name in ipairs({"Shizu", "Saishi", "Oroshi"}) do -- renamed in game from Shisui/Wando/Saddi
                if GetWP(name) then table.insert(owned, name .. " ✅") end
            end
            LegendarySwordCheck:SetDesc(#owned > 0 and table.concat(owned, ", ") or "Not Found")
        end)
    end
end)
local BoneCount = Tabs.Info:AddParagraph("Bone", "")
spawn(function()
    while wait(1) do
        pcall(function()
        local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
        BoneCount:SetDesc("You Have: " .. tostring(bones) .. " Bones")
        end)
    end
end)
local RFSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"]
WeaponDropdown = Tabs.Main:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee","Sword","Blox Fruit","Gun"},
    Default = "Melee",
    Callback = function(Value)
    _G.ChooseWP = Value
end})
Tabs.Main:AddDropdown({
    Name = "UI Scale",
    Options = {"Small", "Normal", "Big"},
    Default = "Normal",
    Callback = function(Value)
        local scales = {Small = 0.8, Normal = 1.0, Big = 1.2}
        Window:SetUIScale(scales[Value])
    end
})
Tabs.Main:AddSection("Farming")
FarmLevel = Tabs.Main:AddToggle({
    Name = "Auto Farm Level",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Level = Value
        if not Value then
            alreadyTeleported = false
            teleporting = false
        end
    end
})
local alreadyTeleported = false
local teleporting = false
ClosetMons = Tabs.Main:AddToggle({
Name = "Auto Farm Nearest",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoFarmNear = Value
end})
FactoryRaids = Tabs.Main:AddToggle({
Name = "Auto Factory Raid",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoFactory = Value
end})
CastleRaids = Tabs.Main:AddToggle({
Name = "Auto Pirate Raid",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoRaidCastle = Value
end})
Ecto = Tabs.Main:AddToggle({
Name = "Auto Farm Ectoplasm",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoEctoplasm = Value
end})
Tabs.Main:AddSection("Chest")
ChestTW = Tabs.Main:AddToggle({
Name = "Auto Farm Chest",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoFarmChest = Value
end})
ChestBP = Tabs.Main:AddToggle({
    Name = "Auto Chest Bypass",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoChestBP = Value

        if Value then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local IsFarming = false
            local UncheckedChests = {}
            local FirstRun = true

            local function getCharacter()
                if not LocalPlayer.Character then
                    LocalPlayer.CharacterAdded:Wait()
                end
                LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                return LocalPlayer.Character
            end

            local function getChestsSorted()
                if FirstRun then
                    FirstRun = false
                    for _, Object in pairs(game:GetDescendants()) do
                        if Object.Name:find("Chest") and Object.ClassName == "Part" then
                            table.insert(UncheckedChests, Object)
                        end
                    end
                end

                local Chests = {}
                for _, Chest in pairs(UncheckedChests) do
                    if Chest:FindFirstChild("TouchInterest") then
                        table.insert(Chests, Chest)
                    end
                end

                local RootPart = getCharacter().LowerTorso
                table.sort(Chests, function(a, b)
                    return (RootPart.Position - a.Position).Magnitude < (RootPart.Position - b.Position).Magnitude
                end)
                return Chests
            end

            local function runChestLoop()
                if IsFarming then return end
                IsFarming = true

                task.spawn(function()
                    while _G.AutoChestBP and LocalPlayer.Character and LocalPlayer.Character.Parent do
                        local Chests = getChestsSorted()
                        if #Chests > 0 then
                            local RootPart = getCharacter().HumanoidRootPart
                            RootPart.CFrame = Chests[1].CFrame
                        end
                        task.wait(0.1)
                    end
                    IsFarming = false
                end)
            end

            LocalPlayer.CharacterAdded:Connect(function()
                getCharacter()
                task.wait(0.5)
                if _G.AutoChestBP then
                    runChestLoop()
                end
            end)

            runChestLoop()
        end
    end
})
StopI = Tabs.Main:AddToggle({
Name = "Stop Items",
Description = "",
Default = true,
Callback = function(Value)
    _G.StopWhenChalice = Value
end})
Tabs.Main:AddSection("Collect Berry")
Berry = Tabs.Main:AddToggle({
Name = "Auto Farm Berry",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoBerry = Value
end})
BerryH = Tabs.Main:AddToggle({
Name = "Auto Farm Berry + Hop",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoBerryH = Value
end})
Tabs.Main:AddSection("Farm Mob")
if World1 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = Bandit,
        Options = {
            "Bandit", "Monkey", "Gorilla", "Pirate", "Brute",
            "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman",
            "Chief Petty Officer", "Sky Bandit", "Dark Master", "Toga Warrior",
            "Gladiator", "Military Soldier", "Military Spy",
            "Fishman Warrior", "Fishman Commando",
            "God's Guard", "Shanda", "Royal Squad", "Royal Soldier",
            "Galley Pirate", "Galley Captain",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
if World2 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = Raider,
        Options = {
            "Raider", "Mercenary", "Swan Pirate", "Factory Staff",
            "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire",
            "Snow Trooper", "Winter Warrior", "Lab Subordinate",
            "Horned Warrior", "Magma Ninja", "Lava Pirate",
            "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
            "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
if World3 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Options = {
            "Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer",
            "Female Islander", "Giant Islander", "Marine Commodore",
            "Marine Rear Admiral", "Fishman Raider", "Fishman Captain",
            "Forest Pirate", "Mythological Pirate", "Jungle Pirate",
            "Musketeer Pirate", "Reborn Skeleton", "Living Zombie",
            "Demonic Soul", "Posessed Mummy", "Peanut Scout",
            "Peanut President", "Ice Cream Chef", "Ice Cream Commander",
            "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker",
            "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief",
            "Candy Rebel", "Candy Pirate", "Snow Demon", "Isle Outlaw",
            "Island Boy", "Sun-kissed Warrior", "Isle Champion",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
Tabs.Main:AddToggle({
    Name = "Auto Kill Mob",
    Default = false,
    Callback = function(Value)
        _G.AutoKillMob = Value
    end
})
Tabs.Main:AddSection("Farm All Island")
Tabs.Main:AddDropdown({
    Name = "Select Island",
    Options = (function()
        local list = {}
        for k in pairs(Core.Island or {}) do table.insert(list, k) end
        table.sort(list)
        return list
    end)(),
    Callback = function(Value)
        _G.SelectIsland = Value
    end
})
local IslandData = Core.Island
Tabs.Main:AddToggle({
    Name = "Auto Farm All Island",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmIsland = Value
    end
})
Tabs.Main:AddSection("Farm Elite Hunter")
local Process = Tabs.Main:AddParagraph("Elites Process", "")
spawn(function()
    while wait(Sec) do
        pcall(function()    
            local prog = replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
            Process:SetDesc("Elite Progress : " .. tostring(prog or 0))
        end)
    end
end)
local EliteHunter = Tabs.Main:AddParagraph("Elite Spawn", "Status: ")
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '✅' or '❌'
        local ok, progress = pcall(function()
            return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
        end)
        local progressStr = tostring((ok and progress) or 0)
        if currentStatus ~= previousStatus then
            EliteHunter:SetDesc("Status: " .. currentStatus .. " | Killed: " .. progressStr)
            previousStatus = currentStatus
        end
    end
end)
EliteQ = Tabs.Main:AddToggle({
    Name = "Auto Farm Elite",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.FarmEliteHunt = Value
end})
EliteH = Tabs.Main:AddToggle({
	Name = "Auto Farm Elite + Hop",
	Description = "",
	Default = false,
	Callback = function(Value)
	_G.FarmEliteH = Value
end})
Tabs.Main:AddSection("Farm Rip Indra")
Tabs.Main:AddToggle({
Name = "Auto Attack Rip Indra",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoRipIngay = Value
end})
Tabs.Main:AddToggle({
Name = "Auto Unlocked Haki",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoUnHaki = Value
end})
Tabs.Main:AddSection("Farming Cake")
local MobKilled = Tabs.Main:AddParagraph("Cake Princes", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            local Killed = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")
            if Killed then
                MobKilled:SetDesc("Killed : " .. (500 - tonumber(Killed) or 0))
            end
        end)
    end
end)
Cake = Tabs.Main:AddToggle({
    Name = "Auto Farm Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.Auto_Cake_Prince = Value
end
})
CakeQ = Tabs.Main:AddToggle({
Name = "Accept Quests",
Description = "",
Default = false,
Callback = function(Value)
  _G.AcceptQuestC = Value
end
})
CakeSM = Tabs.Main:AddToggle({
    Name = "Auto Summon Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoSpawnCP = Value
end})
Tabs.Main:AddToggle({
    Name = "Auto Dough King [Fully]",
    Default = false,
    Callback = function(Value)
        _G.AutoDoughKing = Value
    end
})
Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King",
    Default = false,
    Callback = function(Value)
        _G.AutoAttackDoughKing = Value
    end
})
Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King + Hop",
    Default = false,
    Callback = function(Value)
        _G.AutoHop_Dough = Value
    end
})
Tabs.Main:AddSection("Farming Bone")
local CheckingBone = Tabs.Main:AddParagraph("Bones", "")
spawn(function()
    while wait(1) do
        pcall(function()
            local bonesCount = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
            CheckingBone:SetDesc("Bones : " .. tostring(bonesCount))
        end)
    end
end)
Tabs.Main:AddToggle({
    Name = "Auto Farm Bone",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm_Bone = Value
    end
})
BoneQ = Tabs.Main:AddToggle({
Name = "Accept Quests",
Description = "",
Default = false,
Callback = function(Value)
  _G.AcceptQuestB = Value
end
})
Tabs.Main:AddToggle({
Name = "Auto Soul Reaper",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoHytHallow = Value
end})
RanBone = Tabs.Main:AddToggle({
Name = "Auto Random Bones",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Random_Bone = Value
end})
Lucky = Tabs.Main:AddToggle({
Name = "Auto Try Luck Gravestone",
Description = "",
Default = false,
Callback = function(Value)
  _G.TryLucky = Value
end})
Pray = Tabs.Main:AddToggle({
Name = "Auto Pray Gravestone",
Description = "",
Default = false,
Callback = function(Value)
  _G.Praying = Value
end})
Tabs.Main:AddSection("Tyrant of the Skies")
local TyrantStatus = Tabs.Main:AddParagraph("Boss Spawn", "")
spawn(function()
    pcall(function()
        while wait(1) do
            if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
                TyrantStatus:SetDesc("✅")
            else
                TyrantStatus:SetDesc("❌")
            end
        end
    end)
end)
local EyeStatus = Tabs.Main:AddParagraph("Check Status Eyes", "")
task.spawn(function()
    local alerted = false
    while task.wait(1) do
        -- Tiki Outpost is streamed out when you are far away; the unprotected call threw and killed this thread for good
        local okEye, current, full = pcall(Check_Eye)
        if okEye then
            EyeStatus:SetDesc("Eyes: " .. current .. "/4")

            if full and not alerted then
                alerted = true
            elseif not full then
                alerted = false
            end
        end
    end
end)
FarmTyrant = Tabs.Main:AddToggle({
Name = "Auto Farm Boss TOTS",
Description = "",
Default = false,
Callback = function(Value) 
    _G.FarmTyrant = Value 
end})
FarmPhaBinh = Tabs.Main:AddToggle({
Name = "Auto Summon Boss",
Description = "",
Default = false,
Callback = function(Value)
    _G.FarmPhaBinh = Value
end})
Tabs.Main:AddSection("Farm Material")
Test = Tabs.Main:AddDropdown({
Name = "Choose Material",
		Description = "",
		Options = MaterialList,
		Callback = function(Value)
			getgenv().SelectMaterial = Value
		end
		})
Toggle = Tabs.Main:AddToggle({
Name = "Auto Farm Materials",
Description = "",
Default = false,
Callback = function(Value)
    getgenv().AutoMaterial = Value
end})
Tabs.Main:AddSection("Farm Boss")
		BossDropdown = Tabs.Main:AddDropdown({
		Name = "Select Boss",
		Description = "",
		Options = BossList,
		Callback = function(value)
			_G.FindBoss = value
		end
		})
FarmBoss = Tabs.Main:AddToggle({
    Name = "Auto Farm Boss",
    Description = "",
    Default = false,
    Callback = function(value)
        _G.FarmBoss = value
    end
})
BossQ = Tabs.Main:AddToggle({
    Name = "Accept Quests",
    Description = "",
    Default = true,
    Callback = function(Value)
        _G.AcceptQuestBoss = Value
    end
})
FarmAllBoss = Tabs.Main:AddToggle({
   Name = "Auto Farm All Boss",
    Default = false,
Callback = function(Value)
    _G.AutoFarmAllBoss = Value
end})
Tabs.Main:AddSection("Farming Mastery")
local posMastery = {"Cake","Bone"}
local Mastery_Config = Tabs.Main:AddDropdown({
Name = "Choose Island",
		Description = "",
		Options = posMastery,
		Default = Bone,
		Callback = function(Value)
  SelectIsland = Value
end})
Tabs.Main:AddSlider({
	Title = "NPC Health % Switch to Weapon",
	Description = "Switches to mastery weapon moves when NPC HP drops below this percent",
	Min = 10,
	Max = 95,
	Default = 70,
	Callback = function(Y)
		_G.MasteryHealthPct = Y;
	end,
});
Tabs.Main:AddDropdown({
    Name = "Select Skills to Use",
    Description = "Select which skills to spam (locked skills are auto-skipped)",
    Options = {"Z", "X", "C", "V", "F", "Y"},
    Default = {"Z", "X", "C", "V", "F"},
    MultiSelect = true,
    Callback = function(Value)
        _G.SelectedMasterySkills = Value
    end
})
local MasteryFruits = Tabs.Main:AddToggle({
Name = "Auto Mastery Fruits",
Description = "",
Default = false,
Callback = function(Value)
  _G.FarmMastery_Dev = Value
end})
local MasteryGun = Tabs.Main:AddToggle({
Name = "Auto Mastery Gun",
Description = "",
Default = false,
Callback = function(Value)
  _G.FarmMastery_G = Value
end})
local MasterySword = Tabs.Main:AddToggle({
Name = "Auto Mastery All Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.FarmMastery_S = Value
end})
local MagnetEvent = require(game.ReplicatedStorage.EventConfig.MagnetEvent26)
Tabs.Main:AddSection("Update 30 / Magnet Token")
local magnetStatus = Tabs.Main:AddParagraph("Magnet Event Status", "Loading...")
local magnetPatrolStatus = Tabs.Main:AddParagraph("Status", "Status : Idle")

SetMagnetStatus = function(status)
    if magnetPatrolStatus and magnetPatrolStatus.SetDesc then
        pcall(function() magnetPatrolStatus:SetDesc("Status : " .. status) end)
    end
end
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local now = os.time()
            local t = os.date("*t", now)
            local minute = t.min
            local second = t.sec

            local isEventTime = (minute >= 0 and minute < 10)
            local hasEnemy = false
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:IsA("Model") and (mob:GetAttribute("MagnetEnemy") == true or string.find(string.lower(mob.Name), "magnetized")) then
                    hasEnemy = true
                    break
                end
            end

            local icon = "🔴"
            local text = ""

            if hasEnemy then
                icon = "🟢"
                local remaining = (10 - minute) * 60 - second
                if remaining < 0 then remaining = 0 end
                local mins = math.floor(remaining / 60)
                local secs = remaining % 60
                text = string.format("%s ACTIVE - Time Left: %02d:%02d (✅ Enemies Found)", icon, mins, secs)
            elseif isEventTime then
                icon = "🟢"
                local remaining = (10 - minute) * 60 - second
                if remaining < 0 then remaining = 0 end
                local mins = math.floor(remaining / 60)
                local secs = remaining % 60
                text = string.format("%s ACTIVE - Time Left: %02d:%02d", icon, mins, secs)
            else
                local secondsUntilNext = (60 - minute) * 60 - second
                if secondsUntilNext <= 0 then secondsUntilNext = 0 end
                local mins = math.floor(secondsUntilNext / 60)
                local secs = secondsUntilNext % 60
                text = string.format("%s INACTIVE - Next Event: %02d:%02d", icon, mins, secs)
            end

            magnetStatus:SetDesc(text)
        end)
    end
end)
_G.MagnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1
local MAGNET_BLACKLIST_ENEMYSPAWNS = {
}
Tabs.Main:AddToggle({
    Name = "Auto Farm Magnet Token",
    Default = false,
    Callback = function(v)
        _G.AutoMagnetToken = v
        SetMagnetStatus(v and "Starting..." or "Idle")
        if not v then
            _G.MagnetEventSpawnIndex = 1
        end
    end
})
Tabs.Settings:AddSection("Settings / Configure")
Initialize = Tabs.Settings:AddToggle({
Name = "Fast Attack",
Description = "",
Default = true,
Callback = function(Value)
  _G.Seriality = Value
end})
Bringmob = Tabs.Settings:AddToggle({
Name = "Bring Mobs",
Description = "",
Default = true,
Callback = function(Value)
  _B = Value
end})
Tabs.Settings:AddToggle({
    Name = "Auto Hop Server with time",
    Default = false,
    Callback = function(Value)
        _G.AutoHopServer = Value
        if not Value then
            _G.HopTimer = nil
        end
    end
})

Tabs.Settings:AddSlider({
    Name = "Hop Delay (Minutes)",
    Min = 5,
    Max = 120,
    Default = 30,
    Increment = 1,
    Callback = function(Value)
        _G.HopDelay = Value * 60
    end
})
Tabs.Settings:AddToggle({
    Name = "Auto Set Spawn Point",
    Default = false,
    Callback = function(Value)
        getgenv().Set = Value
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end)
        end
    end
})
BusuAura = Tabs.Settings:AddToggle({
Name = "Auto Turn on Buso",
Description = "",
Default = true,
Callback = function(Value)
  Boud = Value
end})
Tabs.Settings:AddToggle({
    Name = "Auto Haki Observation",
    Default = false,
    Callback = function(Value)
        getgenv().Observation = Value
    end
})
RaceV3Aura = Tabs.Settings:AddToggle({
Name = "Auto Turn on Race V3",
Description = "",
Default = false,
Flag = "AutoTurnonRaceV3",
Callback = function(Value)
  _G.RaceClickAutov3 = Value
end})
RaceV4Aura = Tabs.Settings:AddToggle({
Name = "Auto Turn on Race V4",
Description = "",
Default = false,
Callback = function(Value)
  _G.RaceClickAutov4 = Value
end})
RandomAround = Tabs.Settings:AddToggle({
Name = "Auto Turn on Spin  xyz",
Description = "",
Default = false,
Callback = function(Value)
  RandomCFrame = Value
end})
SafeModes = Tabs.Settings:AddToggle({
Name = "Safe Mode",
Description = "",
Default = false,
Callback = function(Value)
  _G.Safemode = Value
end})
DisableHitVFX = Tabs.Settings:AddToggle({
    Name = "Remove Hit VFX",
    Description = "Removes slash and sword visual effects for better visibility",
    Default = false,
    Callback = function(Value)
        _G.DestroyHit = Value
    end
})
local HitEffects = {"SlashHit", "CurvedRing", "SwordSlash", "SlashTail"}
RmvVFX = Tabs.Settings:AddToggle({
Name = "Remove Death & Respawned VFX",
Description = "",
Default = false,
Callback = function(Value)
  RDeath = Value
end})
DisblesNotify = Tabs.Settings:AddToggle({
Name = "Disable Notify",
Description = "",
Default = false,
Callback = function(Value)
  RemoveDamage = Value
end})
Tabs.Settings:AddToggle({
    Name = "Anti AFK",
    Default = true,
    Callback = function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            repeat wait() until game:IsLoaded()
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})
Tabs.Settings:AddToggle({
    Name = "Auto Anti - Admin Join Server",
    Description = "",
    Default = true,
    Callback = function(Value)
        getgenv().HopServerAdmin = Value
    end
})
Tabs.Settings:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value)
        getgenv().NoClip = Value
    end
})
Tabs.Esp:AddSection("Stats Upgrade")
StatusSelect = Tabs.Esp:AddSlider({
Name = "Stats Value",
Description = "",
Default = 10,
Min = 0,
Max = 1000,
Rounding = 1,
Callback = function(Value)
  pSats = Value
end})
StatsUpg = Tabs.Esp:AddToggle({
Name = "Auto Melee",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Melee = Value
end})
StatsUpg = Tabs.Esp:AddToggle({
Name = "Auto Swords",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Sword = Value
end})
StatsUpg = Tabs.Esp:AddToggle({
Name = "Auto Gun",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Gun = Value
end})
StatsUpg = Tabs.Esp:AddToggle({
Name = "Auto Blox Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_DevilFruit = Value
end})
StatsUpg = Tabs.Esp:AddToggle({
Name = "Auto Defense",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Defense = Value
end})
Tabs.Fish:AddSection("Fishing")
Tabs.Fish:AddDropdown({
    Name = "Select Fishing Rod",
    Description = "",
    Options = {"Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod"},
    Default = "Fishing Rod",
    Callback = function(Value)
        _G.SelectedRod = Value
    end
})
BaitDropdown = Tabs.Fish:AddDropdown({
    Name = "Select Bait",
    Description = "",
    Options = {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"},
    Default = "Basic Bait",
    Callback = function(Value)
        _G.SelectedBait = Value
        if _G.AutoBuyBait then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
})
BuyBaitToggle = Tabs.Fish:AddToggle({
    Name = "Auto Buy Bait",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyBait = Value
        if Value then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
})
FishingToggle = Tabs.Fish:AddToggle({
    Name = "Auto Fishing",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFishing = Value
    end
})
FishingQ = Tabs.Fish:AddToggle({
Name = "Auto Quest Fishing",
Description = "",
Default = false,
Callback = function(Value)
    _G.AutoFishingQuest = Value
end})
QuestToggle = Tabs.Fish:AddToggle({
    Name = "Auto Complete Quest",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoQuestComplete = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end
})
SellFishToggle = Tabs.Fish:AddToggle({
    Name = "Auto Sell Fish",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoSellFish = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end
})
SpamSkillZ = Tabs.Fish:AddToggle({
Name = "Auto Spam Skill Z",
Description = "",
Default = false,
Callback = function(Value)
    _G.AutoSkillZ = Value
end})
TravelDress = Tabs.Quests:AddToggle({
Name = "Auto Quest Sea 2",
Description = "",
Default = false,
Callback = function(Value)
  _G.TravelDres = Value
end})
Zou = Tabs.Quests:AddToggle({
Name = "Auto Quest Sea 3",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoZou = Value
end})
Tabs.Quests:AddSection("Tushita + Yama")
Q = Tabs.Quests:AddToggle({
Name = "Auto Tushita Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Tushita = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Yama Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Yama = Value
end})
Tabs.Quests:AddSection("Skull Guitars / Misc")
local CheckSoul = Tabs.Quests:AddParagraph("Skull Guitar Quests", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            if Quest1 == true then 
                CheckSoul:SetDesc("Quest Number : Quest1")
            elseif Quest2 == true then 
                CheckSoul:SetDesc("Quest Number : Quest2")
            elseif Quest3 == true then 
                CheckSoul:SetDesc("Quest Number : Quest3")
            elseif Quest4 == true then 
                CheckSoul:SetDesc("Quest Number : Quest4")
            elseif GetWP("Skull Guitar") then 
                CheckSoul:SetDesc("Quest Number : Collect!!")
            else 
                CheckSoul:SetDesc("Quest Number : No Quest!!")
            end
        end)
    end
end)
Tabs.Quests:AddToggle({
Name = "Auto Skull Guitar",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Soul_Guitar = Value
end})
Tabs.Quests:AddToggle({
Name = "Auto Farm Material Skull Guitar",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoMatSoul = Value
end})
Tabs.Quests:AddSection("Cursed Dual Katana")
local CheckCDK = Tabs.Quests:AddParagraph("Number Cursed dual katana quests", "Quest Numbers :")
spawn(function()  
    while wait(0.2) do 
        if QuestYama_1 == true then 
            CheckCDK:SetDesc("Quest Numbers : yama quest 1") 
        elseif QuestYama_2 == true then
            CheckCDK:SetDesc("Quest Numbers : yama quest 2") 
        elseif QuestYama_3 == true then
            CheckCDK:SetDesc("Quest Numbers : yama quest 3") 
        elseif QuestTushita_1 == true then
            CheckCDK:SetDesc("Quest Numbers : tushita quest 1") 
        elseif QuestTushita_2 == true then
            CheckCDK:SetDesc("Quest Numbers : tushita quest 2") 
        elseif GetWP("Cursed Dual Katana") then
            CheckCDK:SetDesc("Quest Numbers : CDK done!!")
        end 
    end
end)
Q = Tabs.Quests:AddToggle({
Name = "Auto Get CDK [ Last Quest ]",
Description = "",
Default = false,
Callback = function(Value)
  _G.CDK = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Yama CDK",
Description = "",
Default = false,
Callback = function(Value)
  _G.CDK_YM = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Tushita CDK",
Description = "",
Default = false,
Callback = function(Value)
  _G.CDK_TS = Value
end})
Tabs.Quests:AddSection("True Triple Katana Sword")
Tabs.Quests:AddButton({
Name = "Buy Legendary Sword",
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","1")
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","2")
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","3")
end})
Tabs.Quests:AddButton({
Name = "Buy True Triple Katana Sword",
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("MysteriousMan","2")
end})
Q = Tabs.Quests:AddToggle({
Name = "Tween to Legendary Sword Dealer",
Description = "",
Default = false,
Callback = function(Value)
  _G.Tp_LgS = Value
end})
Tabs.Quests:AddSection("Pole / God Enal's")
Q = Tabs.Quests:AddToggle({
Name = "Auto Pole V1",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoPole = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Pole V2 [Beta]",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoPoleV2 = Value
end})
Tabs.Quests:AddToggle({
Name = "Auto Saw Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoSaw = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Saber Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoSaber = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Cybrog",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoColShad = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Usoap's Hat",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoGetUsoap = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Bisento V2",
Description = "",
Default = false,
Callback = function(Value)
  _G.Greybeard = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Warden Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.WardenBoss = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Marine Coat",
Description = "",
Default = false,
Callback = function(Value)
  _G.MarinesCoat = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Swan Coat",
Description = "",
Default = false,
Callback = function(Value)
  _G.SwanCoat = Value
end})
Tabs.Quests:AddSection("Rengoku Sword")
Q = Tabs.Quests:AddToggle({
Name = "Auto Rengoku Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.IceBossRen = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Key Rengoku",
Description = "",
Default = false,
Callback = function(Value)
  _G.KeysRen = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Dragon Trident",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoTridentW2 = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Long Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.LongsWord = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Black Spikey",
Description = "",
Default = false,
Callback = function(Value)
  _G.BlackSpikey = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Dark Blade V3",
Description = "",
Default = false,
Callback = function(Value)
  _G.DarkBladev3 = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Midnight Blade",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoEcBoss = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Darkbeard",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Def_DarkCoat = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Unlocked DonSwan",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_DonAcces = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Swan Glasses",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_SwanGG = Value
end})
Tabs.Quests:AddSection("Cavender + Twin Hooks + Bigmom")
Q = Tabs.Quests:AddToggle({
Name = "Auto Bigmom",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoBigmom = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Canvendish Sword",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Cavender = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Twin Hooks",
Description = "",
Default = false,
Callback = function(Value)
  _G.TwinHook = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Serpent Bow",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoSerpentBow = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Lei Accessory",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoKilo = Value
end})
Tabs.Quests:AddSection("Buso/Aura Colours")
Q = Tabs.Quests:AddToggle({
Name = "Auto Teleport Barista Cousin",
Description = "",
Default = false,
Callback = function(Value)
  _G.Tp_MasterA = Value
end})
Tabs.Quests:AddButton({
Name = "Buy Buso Colors",
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("ColorsDealer","2")
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Rainbow Colors",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Rainbow_Haki = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Accept Rainbow Quest Faster",
Description = "",
Default = false,
Callback = function(Value)
  _G.GetQFast = Value
end})
Tabs.Quests:AddSection("Instinct / Observation")
Q = Tabs.Quests:AddToggle({
Name = "Auto Farm Observation",
Description = "",
Default = false,
Callback = function(Value)
  _G.obsFarm = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Observation V2",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoKenVTWO = Value
end})
Bartilo = Tabs.Quests:AddToggle({
Name = "Auto Done Bartilo Quest",
Description = "",
Default = false,
Callback = function(Value)
  _G.Bartilo_Quest = Value
end})
CitizenQ = Tabs.Quests:AddToggle({
Name = "Auto Done Citizen Quest",
Description = "",
Default = false,
Callback = function(Value)
  _G.CitizenQuest = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Training Dummy",
Description = "",
Default = false,
Callback = function(Value)
  _G.DummyMan = Value
end})
Tabs.Quests:AddSection("Fighting Melee Styles")
SuperHuman = Tabs.Quests:AddToggle({
Name = "Auto Superhuman",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_SuperHuman = Value
end})
DeathStep = Tabs.Quests:AddToggle({
Name = "Auto DeathStep",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoDeathStep = Value
end})
SharkManV2 = Tabs.Quests:AddToggle({
Name = "Auto Sharkman Karate",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_SharkMan_Karate = Value
end})
ElectricClaw = Tabs.Quests:AddToggle({
Name = "Auto ElectricClaw",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Electric_Claw = Value
end})
DragonTalon = Tabs.Quests:AddToggle({
Name = "Auto DragonTalon",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoDragonTalon = Value
end})
Godhuman = Tabs.Quests:AddToggle({
Name = "Auto Godhuman",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_God_Human = Value
end})
SanguineArt = Tabs.Quests:AddToggle({
Name = "Auto SanguineArt",
Description = "",
Default = false,
Callback = function(Value)
  _G.Snaguine = Value
end})
Tabs.Race:AddSection("Mystic Island / Full Moon")
local FullMOOn = Tabs.Race:AddParagraph("FullMoon Status", "")
local Ismirage = Tabs.Race:AddParagraph("Mirage Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("MysticIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
            Ismirage:SetDesc("Mirage Island : True")
        else
            Ismirage:SetDesc("Mirage Island : False")
        end
    end
end)
spawn(function()
    while wait(0.2) do
        pcall(function()
            local moon8 = "http://www.roblox.com/asset/?id=9709150401"
            local moon7 = "http://www.roblox.com/asset/?id=9709150086"
            local moon6 = "http://www.roblox.com/asset/?id=9709149680"
            local moon5 = "http://www.roblox.com/asset/?id=9709149431"
            local moon4 = "http://www.roblox.com/asset/?id=9709149052"
            local moon3 = "http://www.roblox.com/asset/?id=9709143733"
            local moon2 = "http://www.roblox.com/asset/?id=9709139597"
            local moon1 = "http://www.roblox.com/asset/?id=9709135895"
            local moon = Getmoon()
            
            if moon == moon1 then
                FullMOOn:SetDesc("Moon : 0 / 8")
            elseif moon == moon2 then
                FullMOOn:SetDesc("Moon : 1 / 8")
            elseif moon == moon3 then
                FullMOOn:SetDesc("Moon : 2 / 8")
            elseif moon == moon4 then
                FullMOOn:SetDesc("Moon : 3 / 8 [ Next Night ]")
            elseif moon == moon5 then
                FullMOOn:SetDesc("Moon : 4 / 8 [ Full Moon ]")
            elseif moon == moon6 then
                FullMOOn:SetDesc("Moon : 5 / 8 [ Last Night ]")
            elseif moon == moon7 then
                FullMOOn:SetDesc("Moon : 6 / 8")
            elseif moon == moon8 then
                FullMOOn:SetDesc("Moon : 7 / 8")
            end
        end)
    end
end)
Tabs.Race:AddToggle({
Name = "Auto Find Mirage Island",
Description = "",
Default = false,
Callback = function(Value)
  _G.FindMirage = Value
end})
Tabs.Race:AddToggle({
    Name = "Esp Mirage Island",
    Description = "",
    Value = false,
    Callback = function(Value)
        MirageIslandESP = Value
        if MirageIslandESP then
            task.spawn(function()
                while MirageIslandESP do
                    if UpdateIslandMirageESP then UpdateIslandMirageESP() end   -- never defined anywhere in this script
                    task.wait(1)
                end
            end)
        elseif UpdateIslandMirageESP then
            UpdateIslandMirageESP()
        end
    end
})
Tabs.Race:AddToggle({
    Name = "Auto Tween To Mirage Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoMysticIsland = Value
    end
})
Tabs.Race:AddToggle({
Name = "Auto Tween To Highest Point",
Description = "",
Default = false,
Callback = function(Value)
  _G.HighestMirage = Value
end})
Tabs.Race:AddToggle({
Name = "Auto Collect Gear",
Description = "",
Default = false,
Callback = function(Value)
  _G.TPGEAR = Value
end})
Tabs.Race:AddToggle({
Name = "Change Transparency can see",
Description = "",
Default = false,
Callback = function(Value)
  _G.can = Value
end})
Tabs.Race:AddToggle({
Name = "Auto Tween Advanced Fruit Dealer",
Description = "",
Default = false,
Callback = function(Value)
  _G.Addealer = Value
end})
Tabs.Race:AddToggle({
Name = "Auto Collect Mirage Chest",
Description = "",
Default = false,
Callback = function(Value)
  _G.FarmChestM = Value
end})
Tabs.Race:AddButton({
Name = "Talk With Stone",
Description = "",
Callback = function()
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Begin")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Check")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Teleport")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Continue")
end})
Tabs.Race:AddToggle({
Name = "Auto Look At Moon",
Description = "",
Default = false,
Callback = function(Value)
  LookM = Value
end})
Tabs.Race:AddToggle({
    Name = "Look Moon + Auto V3",
    Description = "",
    Default = false,
    Callback = function(Value)
        LookMV3 = Value
    end
})
Tabs.Race:AddSection("Upgrade Races V2 And V3")
RaceMink = Tabs.Race:AddToggle({
Name = "Auto Upgrade Mink",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Mink = Value
end})
RaceHuman = Tabs.Race:AddToggle({
Name = "Auto Upgrade Human",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Human = Value
end})
RaceSky = Tabs.Race:AddToggle({
Name = "Auto Upgrade Angel",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Skypiea = Value
end})
RaceFish = Tabs.Race:AddToggle({
Name = "Auto Upgrade FishMan",
Description = "",
Default = false,
Callback = function(Value)
  _G.Auto_Fish = Value
end})
Tabs.Race:AddSection("Trials Quest V4")
local CheckTier = Tabs.Race:AddParagraph("Tiers V4 Status", "")
spawn(function()
    pcall(function()
        while wait(0.2) do
            CheckTier:SetDesc("Tiers - V4 : " .. " " .. plr.Data.Race.C.Value)
        end
    end)
end)
PullLv = Tabs.Race:AddToggle({
Name = "Auto Pull Lever",
Description = "",
Default = false,
Callback = function(Value)
  _G.Lver = Value
end})
Train = Tabs.Race:AddToggle({
Name = "Auto Train V4",
Description = "",
Default = false,
Callback = function(Value)
  _G.AcientOne = Value
end})
Tabs.Race:AddButton({
    Name = "Teleport to Temple of Time",
    Description = "",
    Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end
})
Tabs.Race:AddButton({
Name = "Teleport to Ancient One",
Description = "",
Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
        
        task.wait(2)

        tween(CFrame.new(28981.552734375, 14888.4267578125, - 120.245849609375))
    end
})
Tabs.Race:AddButton({
Name = "Teleport to Ancient Clock",
Description = "",
Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        local pos1 = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        local pos2 = CFrame.new(29549, 15069, -88)

        if hrp then
            hrp.CFrame = pos1
        end

        task.delay(2, function()
            _tp(pos2)
        end)

        if not workspace.Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end
})
Doors = Tabs.Race:AddToggle({
Name = "Auto Teleport to Race Doors",
Description = "",
Default = false,
Callback = function(Value)
  _G.TPDoor = Value
end})
Trials = Tabs.Race:AddToggle({
Name = "Auto Complete Trial Race",
Description = "",
Default = false,
Callback = function(Value)
  _G.Complete_Trials = Value
end})
AutoKill = Tabs.Race:AddToggle({
Name = "Auto Kill Player After Trial",
Description = "",
Default = false,
Callback = function(Value)
  _G.Defeating = Value
end})
Tabs.Prehistoric:AddSection("Dojo Quest")
Tabs.Prehistoric:AddButton({
    Title = "Teleport To Dragon Dojo",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
    end
})
DojoQ = Tabs.Prehistoric:AddToggle({
Name = "Auto Dojo Trainer",
Description = "",
Default = false,
Callback = function(Value)
  _G.Dojoo = Value
end})
BlazeEM = Tabs.Prehistoric:AddToggle({
Name = "Auto Dragon Hunter",
Description = "",
Default = false,
Callback = function(Value)
  _G.FarmBlazeEM = Value
end})
Tabs.Prehistoric:AddSection("Drago Trial")
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Tween To Upgrade Droco Trial",
Description = "",
Default = false,
Callback = function(Value)
  _G.UPGDrago = Value
end})
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Drago (V1)",
Description = "",
Default = false,
Callback = function(Value)
  _G.DragoV1 = Value
end})
fireflower = Tabs.Prehistoric:AddToggle({
Name = "Auto Drago (V2)",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoFireFlowers = Value
end})
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Drago (V3)",
Description = "",
Default = false,
Callback = function(Value)
  _G.DragoV3 = Value
end})
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Relic Drago Trial [Beta]",
Description = "",
Default = false,
Callback = function(Value)
  _G.Relic123 = Value
end})
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Train Drago v4",
Description = "",
Default = false,
Callback = function(Value)
  _G.TrainDrago = Value
end})
dragoTpVolcano = Tabs.Prehistoric:AddToggle({
Name = "Tween to Drago Trials",
Description = "",
Default = false,
Callback = function(Value)
  _G.TpDrago_Prehis = Value
end})
bdrago = Tabs.Prehistoric:AddToggle({
Name = "Swap Drago Race",
Description = "",
Default = false,
Callback = function(Value)
  _G.BuyDrago = Value
end})
UpTalon = Tabs.Prehistoric:AddToggle({
Name = "Upgrade Dragon Talon With Uzoth",
Description = "",
Default = false,
Callback = function(Value)
  _G.DT_Uzoth = Value
end})
Tabs.Prehistoric:AddSection("Volcanic Crafting")
Tabs.Prehistoric:AddButton({
Name = "Craft Dragonheart",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "Dragonheart"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Prehistoric:AddButton({
Name = "Craft Dragonstorm",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "Dragonstorm"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Prehistoric:AddButton({
    Name = "Craft Dino Hood",
    Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "DinoHood"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Prehistoric:AddButton({
    Name = "Craft T-Rex Skull",
    Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "TRexSkull"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.Prehistoric:AddSection("Prehistoric Island")
local Check_Volcano = Tabs.Prehistoric:AddParagraph("Prehistoric Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
            Check_Volcano:SetDesc("Prehistoric Island : True")
        else
            Check_Volcano:SetDesc("Prehistoric Island : False")
        end
    end
end)
Tabs.Prehistoric:AddButton({
    Name = "Craft Volcanic Magnet",
    Callback = function()
        local RF = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

        RF:InvokeServer(
            "PossibleHardcode",
            "Volcanic Magnet"
        )
    end
})
Tabs.Prehistoric:AddToggle({
    Name = "Craft Volcanic Magnet",
    Default = false,
    Callback = function(Value)
        getgenv().AutoCraftVolcanic = Value
    end
})
Tabs.Prehistoric:AddToggle({
    Name = "Auto Find Prehistoric Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Prehis_Find = Value; PrehisUser.Find = Value
    end
})
local targetDestination = nil
Tabs.Prehistoric:AddToggle({
    Name = "Auto Start Prehistoric Event",
    Default = false,
    Callback = function(Value)
        _G.AutoStartPrehistoric = Value
    end
})
Tabs.Prehistoric:AddToggle({
    Name = "Auto Patch Prehistoric Event",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Prehis_Skills = Value; PrehisUser.Skills = Value
    end
})
Kaura = Tabs.Prehistoric:AddToggle({
    Name = "Kill Aura",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.KillAuraFull = Value
end})
local Range = 500
local Delay = 2
Vocan = Tabs.Prehistoric:AddToggle({
Name = "Auto Collect Dino Bones",
Description = "",
Default = false,
Callback = function(Value)
  _G.Prehis_DB = Value
end})
Vocan = Tabs.Prehistoric:AddToggle({
Name = "Auto Collect Dragon Eggs",
Description = "",
Default = false,
Callback = function(Value)
  _G.Prehis_DE = Value; PrehisUser.DE = Value
end})
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Reset When Complete Volcano",
Description = "",
Default = false,
Callback = function(Value)
  _G.ResetPH = Value
end})
Tabs.SeaEvent:AddSection("Sea Event / Setting Sail")
Tabs.SeaEvent:AddButton({
    Name = "Remove Lighting Effect",
    Callback = function()
        game:GetService("Lighting").BaseAtmosphere:Destroy()
    end
})
Tabs.SeaEvent:AddToggle({
    Name = "Ship Speed Modifier",
    Default = false,
    Callback = function(Value)
        getgenv().SpeedBoat = Value
    end
})
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().SpeedBoat then
        local plr = game:GetService("Players").LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Sit then
                for _, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                    local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
                    if seat then
                        seat.MaxSpeed = SetSpeedBoat
                    end
                end
            end
        end
    end
end)
Tabs.SeaEvent:AddSlider({
    Name = "Ship Speed",
    Min = 0,
    Max = 1000,
    Increment = 1,
    Default = 300,
    Callback = function(Value)
        SetSpeedBoat = Value
    end
})
Tabs.SeaEvent:AddToggle({
    Name = "Auto Press W",
    Default = false,
    Callback = function(Value)
        getgenv().AutoPressW = Value
    end
})
Tabs.SeaEvent:AddToggle({
    Name = "No Clip Ship",
    Default = false,
    Callback = function(Value)
        getgenv().NoClipShip = Value
    end
})
Tabs.SeaEvent:AddSection("Crafting Items")
Tabs.SeaEvent:AddButton({
Name = "Craft SharkTooth",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "SharkTooth"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft TerrorJaw",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "TerrorJaw"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft SharkAnchor",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "SharkAnchor"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft LeviathanCrown",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanCrown"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft LeviathanShield",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanShield"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft LeviathanBoat",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanBoat"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft LegendaryScroll",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LegendaryScroll"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddButton({
Name = "Craft MythicalScroll",
Description = "",
Callback = function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "MythicalScroll"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
})
Tabs.SeaEvent:AddSection("Choose Sea Event")
Q = Tabs.SeaEvent:AddDropdown({
    Name = "Select Boats",
	Options = ListSeaBoat,
	Callback = function(Value)
        _G.SelectedBoat = Value
    end
})
Tabs.SeaEvent:AddButton({
Name = "Buy Boats",
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyBoat",_G.SelectedBoat)
end})
Q = Tabs.SeaEvent:AddDropdown({
Name = "Select Sea Level",
Options = ListSeaZone,
Callback = function(Value)
  _G.DangerSc = Value
end})
Q = Tabs.SeaEvent:AddToggle({
Name = "Auto Sail Boat",
Description = "",
Default = false,
Callback = function(Value)
  _G.SailBoats = Value
end})
Tabs.SeaEvent:AddSection("Entity Sea Event")
Tabs.SeaEvent:AddToggle({
Name = "Auto Shark",
Description = "",
Default = false,
Callback = function(Value)
  _G.Shark = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Piranha",
Description = "",
Default = false,
Callback = function(Value)
  _G.Piranha = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Terror Shark",
Description = "",
Default = false,
Callback = function(Value)
  _G.TerrorShark = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Fish Crew Member",
Description = "",
Default = false,
Callback = function(Value)
  _G.MobCrew = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Haunted Crew Member",
Description = "",
Default = false,
Callback = function(Value)
  _G.HCM = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Attack PirateGrandBrigade",
Description = "",
Default = false,
Callback = function(Value)
  _G.PGB = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Attack Fish Boat",
Description = "",
Default = false,
Callback = function(Value)
  _G.FishBoat = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Attack Sea Beast",
Description = "",
Default = false,
Callback = function(Value)
  _G.SeaBeast1 = Value
end})
Tabs.SeaEvent:AddSection("Kitsune Island / Event")
local Check_Kitsu = Tabs.SeaEvent:AddParagraph("Kitsune Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("KitsuneIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
            Check_Kitsu:SetDesc("Kitsune Island : True")
        else
            Check_Kitsu:SetDesc("Kitsune Island : False")
        end
    end
end)
Tabs.SeaEvent:AddToggle({
Name = "Auto Find Kitsune Island",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutofindKitIs = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Teleport to Shrine Actived",
Description = "",
Default = false,
Callback = function(Value)
  _G.tweenShrine = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Collect Azure Ember",
Description = "",
Default = false,
Callback = function(Value)
  _G.Collect_Ember = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Trade Azure Ember",
Description = "",
Default = false,
Callback = function(Value)
  _G.Trade_Ember = Value
end})
Tabs.SeaEvent:AddButton({
Name = "Trade Items Azure",
Description = "",
Callback = function()
  replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
end})
Tabs.SeaEvent:AddButton({
Name = "Talk with kitsune statue",
Description = "",
Callback = function()
  replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
end})
Tabs.SeaEvent:AddSection("Frozen Dimension Event")
local FloD = Tabs.SeaEvent:AddParagraph("FrozenDimension Status", "")
spawn(function()
    pcall(function()
        while wait(0.2) do
            if workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') then
                FloD:SetDesc('Frozen Dimension : True')
            else
                FloD:SetDesc('Frozen Dimension : False')
            end
        end
    end)
end)
local SPYING = Tabs.SeaEvent:AddParagraph("Spy Status", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            local spycheck = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "1"), "%d+")
            if spycheck then 
                SPYING:SetDesc("Spy Leviathan : " .. tostring(spycheck))
                if tonumber(spycheck) == 5 then
                    SPYING:SetDesc("Spy Leviathan : Already Done!!")
                end
            end
        end)
    end
end)
Tabs.SeaEvent:AddButton({
    Name = "Buy Spy",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
    end
})
Tabs.SeaEvent:AddToggle({
Name = "Auto Teleport Frozen Dimension",
Description = "",
Default = false,
Callback = function(Value)
  _G.FrozenTP = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Drive To Hydra Island",
Description = "",
Default = false,
Callback = function(Value)
  _G.SailBoat_Hydra = Value
end})
Tabs.SeaEvent:AddToggle({
Name = "Auto Attack Leviathan",
Description = "",
Default = false,
Callback = function(Value)
  _G.Leviathan1 = Value
end})
Tabs.Esp:AddSection("Esp")
Tabs.Esp:AddToggle({
    Name = "Esp Berry",
    Description = "",
    Default = false,
    Callback = function(Value)
        BerryEsp = Value
        if not Value then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                    v:Destroy()
                end
            end
        else
            task.spawn(function()
                while BerryEsp do
                    berriesEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Player",
    Description = "",
    Default = false,
    Callback = function(Value)
        PlayerEsp = Value
        if not Value then
            for _,v in next, game.Players:GetChildren() do
                pcall(function()
                    if not isnil(v.Character) and not isnil(v.Character.Head) then
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                        end
                    end
                end)
            end
        else
            task.spawn(function()
                while PlayerEsp do
                    EspPly()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Chest",
    Description = "",
    Default = false,
    Callback = function(Value)
        ChestESP = Value
        if not Value then
            for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
                if espAttachment then
                    espAttachment:Destroy()
                end
            end
        else
            task.spawn(function()
                while ChestESP do
                    ChestEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Fruit",
    Description = "",
    Default = false,
    Callback = function(Value)
        DevilFruitESP = Value
        if not Value then
            for i,v in next, workspace:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
                        v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while DevilFruitESP do
                    DevEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        IslandESP = Value
        if not Value then
            for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('NameEsp') then
                        v:FindFirstChild('NameEsp'):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while IslandESP do
                    LocationEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Flower",
    Description = "",
    Default = false,
    Callback = function(Value)
        FlowerESP = Value
        if not Value then
            for i,v in pairs(workspace:GetChildren()) do
                pcall(function()
                    if (v.Name == "Flower2" or v.Name == "Flower1") and v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while FlowerESP do
                    flowerEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Legendary Sword",
    Description = "",
    Default = false,
    Callback = function(Value)
        LegenS = Value
        if not Value then
            if workspace:FindFirstChild("Lgd") then
                workspace:FindFirstChild("Lgd"):Destroy()
            end
        else
            task.spawn(function()
                while LegenS do
                    LegenSword()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Haki Color",
    Description = "",
    Default = false,
    Callback = function(Value)
        ColorEsp = Value
        if not Value then
            if workspace:FindFirstChild("Gay") then
                workspace:FindFirstChild("Gay"):Destroy()
            end
        else
            task.spawn(function()
                while ColorEsp do
                    HakiClorEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Gear",
    Description = "",
    Default = false,
    Callback = function(Value)
        ESPGear = Value
        if not Value then
            local mystic = workspace.Map:FindFirstChild("MysticIsland")   -- nil until the island spawns; the UI calls this once at creation
            for _,v in pairs(mystic and mystic:GetDescendants() or {}) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while ESPGear do
                    gearEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp SeaEvent Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        EspEventIsland = Value
        if not Value then
            for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while EspEventIsland do
                    EventIslandEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Esp:AddToggle({
    Name = "Esp Advanced Dealer",
    Description = "",
    Default = false,
    Callback = function(Value)
        advanEsp = Value
        if not Value then
            if workspace:FindFirstChild("Adv") then
                workspace:FindFirstChild("Adv"):Destroy()
            end
        else
            task.spawn(function()
                while advanEsp do
                    AdvanFruitEsp()
                    task.wait()
                end
            end)
        end
    end
})
Tabs.Raids:AddSection("Fruits Options")
local stockParagraph = Tabs.Raids:AddParagraph("Stock Fruit", "Loading...")
task.spawn(function()
    while task.wait(60) do
        pcall(function()
            stockParagraph:SetDesc(getFruitStock())
        end)
    end
end)
pcall(function()
    stockParagraph:SetDesc(getFruitStock())
end)
RandomFF = Tabs.Raids:AddToggle({
Name = "Auto Random Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.Random_Auto = Value
  _G.RandomFruitCooldown = nil
end})
local RandomFruitCooldown = nil
DropF = Tabs.Raids:AddToggle({
Name = "Auto Drop Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.DropFruit = Value
end})
StoredF = Tabs.Raids:AddToggle({
Name = "Auto Store Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.StoreF = Value
end})
TwF = Tabs.Raids:AddToggle({
Name = "Auto Tween to Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.TwFruits = Value
end})
BringF = Tabs.Raids:AddToggle({
Name = "Auto Collect Fruit",
Description = "",
Default = false,
Callback = function(Value)
  _G.InstanceF = Value
end})
Tabs.Raids:AddDropdown({
    Name = "Select Fruit Shop",
    Options = {
        "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
        "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame",
        "Ice-Ice", "Sand-Sand", "Dark-Dark", "Eagle-Eagle",
        "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Ghost-Ghost",
        "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
        "Creation-Creation", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix",
        "Portal-Portal", "Lightning-Lightning", "Pain-Pain", "Blizzard-Blizzard",
        "Gravity-Gravity", "T-Rex-T-Rex", "Mammoth-Mammoth", "Dough-Dough",
        "Shadow-Shadow", "Venom-Venom", "Gas-Gas", "Control-Control",
        "Spirit-Spirit", "Leopard-Leopard", "Yeti-Yeti", "Kitsune-Kitsune",
        "Dragon-Dragon"
    },
    Callback = function(Value)
        getgenv().SelectFruit = Value
    end
})
Tabs.Raids:AddToggle({
    Name = "Auto Buy Fruit Shop",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuyFruitSniper = Value
    end
})
Tabs.Raids:AddSection("Dungeon Event / Raiding")
DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
Q = Tabs.Raids:AddDropdown({
Name = "Select Chip",
Description = "",
Options = DungeonTables,
Callback = function(Value)
  _G.SelectChip = Value
end})
Q = Tabs.Raids:AddToggle({
Name = "Auto Select Dungeon Chip",
Description = "",
Default = false,
Callback = function(Value)
  _G.AutoSelectDungeon = Value
end})
Tabs.Raids:AddToggle({
    Name = "Get Fruit In Inventory Below 1M",
    Default = false,
    Callback = function(Value)
        getgenv().AutoGetFruit = Value
    end
})
Tabs.Raids:AddButton({
Name = "Buy Dungeon Chips [Beli]",
Description = "",
Callback = function()
  if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip) end
end})
Tabs.Raids:AddButton({
Name = "Buy Dungeon Chips [Devil Fruit]",
Description = "",
Callback = function()
  if GetBP("Special Microchip") then return end
  local FruitPrice = {}
  local FruitStore = {}
  for i,v in next,replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
    if v.Price <= 490000 then table.insert(FruitPrice,v.Name) end 
  end    
  for _,y in pairs(FruitPrice) do    
    for i,v in pairs(DungeonTables) do 
      if not GetBP("Special Microchip") then     
        replicated.Remotes.CommF_:InvokeServer("LoadFruit",tostring(y))	      
	    replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)	
	  end            
    end    
  end
end})
AutoChipBeli = Tabs.Raids:AddToggle({
    Name = "Auto Buy Chip [Beli]",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoChipBeli = Value
end
})
AutoChipFruit = Tabs.Raids:AddToggle({
    Name = "Auto Buy Chip [Devil Fruit]",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoChipFruit = Value
end
})
StartR = Tabs.Raids:AddToggle({
    Name = "Auto Start Raid",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Auto_StartRaid = Value
    end
})
Raiding = Tabs.Raids:AddToggle({
    Name = "Auto Raid + Next Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Raiding = Value
    end
})
KillAuraRaid = Tabs.Raids:AddToggle({
    Name = "Kill Aura (Island 4 & 5)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.KillAuraRaid = Value
    end
})

Tabs.Raids:AddToggle({
Name = "Auto Awakening",
Description = "",
Default = false,
Callback = function(Value)

  _G.Auto_Awakener = Value

end})
Tabs.Raids:AddToggle({
    Name = "Auto Teleport To Lab",
    Default = false,
    Callback = function(Value)

        _G.TpLab = Value

        while _G.TpLab do
            wait()
            if _G.TpLab then
                if World2 and _G.TpLab then
                  _tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                elseif World3 and _G.TpLab then
                  _tp(CFrame.new(-5046, 314, -2960));
                end
            end
        end

    end
})
Tabs.Raids:AddSection("Items Law/Order Sword")
Tabs.Raids:AddButton({
Name = "Buy Microchip Law",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")

end})
Tabs.Raids:AddButton({
Name = "Start Law Raids",
Description = "",
Callback = function()

  fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)

end})
Tabs.Raids:AddToggle({
    Name = "Auto Buy Microchip Law",
    Description = "",
    Default = false,
    Callback = function(Value)

        getgenv().AutoBuyMicrochipLaw = Value

    end
})
Tabs.Raids:AddToggle({
    Name = "Auto Start Law Raids",
    Description = "",
    Default = false,
    Callback = function(Value)

        getgenv().AutoStartLawRaids = Value

    end
})
Tabs.Raids:AddToggle({
Name = "Auto Kill Law",
Description = "",
Default = false,
Callback = function(Value)

  _G.AutoLawKak = Value

end})
Tabs.Raids:AddSection("Raids Dungeons")
Tabs.Raids:AddToggle({
    Name = "Auto Farm Dungeon",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AutoFarmDungeon = Value

    end
})
local FARM_RANGE = 5000
Tabs.Raids:AddToggle({
    Name = "TP Exit (1)",
    Default = false,
    Callback = function(v)

        _G.TPFloor1 = v

    end
})
local tp1Done = false
Tabs.Raids:AddToggle({
    Name = "TP Exit (2)",
    Default = false,
    Callback = function(v)

        _G.TPFloor2 = v

    end
})
local tp2Done = false
Tabs.Raids:AddToggle({
    Name = "TP Exit (3)",
    Default = false,
    Callback = function(v)

        _G.TPFloor3 = v

    end
})
local tp3Done = false
Tabs.Raids:AddToggle({
    Name = "TP Exit (4)",
    Default = false,
    Callback = function(v)

        _G.TPFloor4 = v

    end
})
local tp4Done = false
Tabs.Combat:AddSection("Combat / AimBot")
local __indexPlayer = Tabs.Combat:AddParagraph("All Players On Server", "")
spawn(function()

    while wait(Sec) do
        pcall(function()
            local playerCount = #game:GetService("Players"):GetPlayers()
            if playerCount == 12 then
                __indexPlayer:SetDesc("All Players : " .. playerCount .. " / 12 [Max]")
            else
                __indexPlayer:SetDesc("All Players : " .. playerCount .. " / 12")
            end
        end)
    end

end)
local __AimBotTurn = Tabs.Combat:AddParagraph("Aimbot Status", "")
Checking_AimStatus = function()

    if _G.AimCam then
        return "Aimbot Camera"
    elseif _G.AimbotGun then
        return "Aimbot Guns"
    else
        return ""
    end

end
spawn(function()

    while wait(0.2) do
        pcall(function()
            if _G.AimMethod then
                if (_G.AimCam or _G.AimbotGun) then
                    __AimBotTurn:SetDesc("Aimbot - " .. Checking_AimStatus() .. " : True")
                else
                    __AimBotTurn:SetDesc("Aimbot - Skills : True")
                end
            else
                __AimBotTurn:SetDesc("Aimbot - Skills : False")
            end
        end)
    end
end)

Tabs.Combat:AddDropdown({
    Name = "Select Players",
    Description = "",
    Options = PlrList,
    Callback = function(Value)

        _G.PlayersList = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Teleport To Select Players",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.TpPly = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Spectate Select Players",
    Description = "",
    Default = false,
    Callback = function(Value)

        SpectatePlys = Value

    end
})
Tabs.Combat:AddDropdown({
    Name = "Select Aim Method",
    Description = "",
    Options = {"Aim Player","Nearest Aim"},
    Callback = function(Value)

        ABmethod = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Aimbot Method Skills",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AimMethod = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Aimbot Camera Closet Players",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AimCam = Value

    end
})
Tabs.Combat:AddSection("Quests Players")
Tabs.Combat:AddButton({
    Name = "Get player quests",
    Description = "",
    Callback = function()

        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
        end)

    end
})
Tabs.Combat:AddToggle({
    Name = "Auto Get PlayerQuest",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AutoReceivePlayerQuest = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Auto Kill Player Quest",
    Default = false,
    Callback = function(Value)

        _G.AutoPlayerHunter = Value

        if not Value then Useskill = false end

    end
})
Tabs.Combat:AddToggle({
    Name = "Auto Enable PvP",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AutoPvP = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Auto Safe Mode",
    Default = false,
    Callback = function(Value)

        _G.SafeMode = Value

    end
})
Tabs.Combat:AddSection("LocalPlayer Settings")

Tabs.Combat:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(Value)
        toggleFly(Value)
    end
})
Tabs.Combat:AddSlider({
    Name = "Speed Fly Mode",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        updateFlySpeed(Value)
    end
})
Tabs.Combat:AddToggle({
    Name = "Dash No Cooldown",
    Default = false,
    Callback = function(Value)

        getgenv().DodgeNoCD = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Instance Mink V3 [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)

        InfAblities = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Instance Energy [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)

        infEnergy = Value

        if Value then
            getInfinity_Ability("Energy", infEnergy)
        end

    end
})
Tabs.Combat:AddToggle({
    Name = "Instance Soru [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.InfSoru = Value

        if Value then
            getInfinity_Ability("Soru", _G.InfSoru)
        end

    end
})
Tabs.Combat:AddToggle({
    Name = "Instance Observation Range [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.InfiniteObRange = Value

        if Value then
            getInfinity_Ability("Observation", _G.InfiniteObRange)
        end

    end
})
Tabs.Combat:AddToggle({
    Name = "Ignore Same Teams",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.NoAimTeam = Value

    end
})
Tabs.Combat:AddToggle({
    Name = "Accept Allies",
    Description = "",
    Default = false,
    Callback = function(Value)

        _G.AcceptAlly = Value

    end
})
Tabs.Travel:AddSection("Travel - Worlds")
Tabs.Travel:AddButton({
Name = "Travel East Blue (World 1)",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelMain")

end})
Tabs.Travel:AddButton({
Name = "Travel Dressrosa (World 2)",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")

end})
Tabs.Travel:AddButton({
Name = "Travel Zou (World 3)",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelZou")

end})
Tabs.Travel:AddSection("Travel - Island")
Location = {}
for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  

  table.insert(Location ,v.Name)

end
Travelllll = Tabs.Travel:AddDropdown({
Name = "Select Travelling",
Description = "",
Options = Location,
Callback = function(Value)

  _G.Island = Value

end})
GoIsland = Tabs.Travel:AddToggle({
Name = "Auto Travel",
Description = "",
Default = false,
Callback = function(Value)

  _G.Teleport = Value

  if Value then
    for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
      if v.Name == _G.Island then
        repeat wait()
	     _tp(v.CFrame * CFrame.new(0, 30, 0)) 
        until not _G.Teleport or Root.CFrame == v.CFrame
      end
    end
  end

end
})
Tabs.Travel:AddSection("Travel - Portal")
if World1 then

  Location_Portal = {

    "Sky",

    "UnderWater"

  }

elseif World2 then

  Location_Portal = {

    "SwanRoom",

    "Cursed Ship"

  }

elseif World3 then

  Location_Portal = {

    "Castle On The Sea",

    "Mansion Cafe",

    "Hydra Teleport",

    "Canvendish Room",

    "Temple of Time"

  }

end
PortalTP = Tabs.Travel:AddDropdown({
Name = "Select Portal",
Options = Location_Portal,
Callback = function(Value)

  _G.Island_PT = Value

end})
Tabs.Travel:AddButton({
Name = "requestEntrance",
Description = "",
Callback = function()

  if _G.Island_PT == "Sky" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894, 5547, -380))
  elseif _G.Island_PT == "UnderWater" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
  elseif _G.Island_PT == "SwanRoom" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2285, 15, 905))
  elseif _G.Island_PT == "Cursed Ship" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
  elseif _G.Island_PT == "Castle On The Sea" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
  elseif _G.Island_PT == "Mansion Cafe" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
  elseif _G.Island_PT == "Hydra Teleport" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
  elseif _G.Island_PT == "Canvendish Room" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
  elseif _G.Island_PT == "Temple of Time" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28310.0234, 14895.1123, 109.456741, -0.469690144, -2.85620132e-08, -0.882831335, -3.23509219e-08, 1, -1.51411736e-08, 0.882831335, 2.14487486e-08, -0.469690144))
  end

end})
Tabs.Travel:AddSection("Travel - NPCs")
for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name)end
NPCsPos = Tabs.Travel:AddDropdown({
Name = "Select NPCs",
Options = NPCList,
Callback = function(Value)

  NPClist = Value

end})
GoNPCs = Tabs.Travel:AddToggle({
Name = "Auto Tween to NPC",
Description = "",
Default = false,
Callback = function(Value)

  _G.TPNpc = Value

end})
Tabs.Shop:AddSection("Shop Options")
Tabs.Shop:AddButton({
Name = "Buy Buso",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Buso")

end})
Tabs.Shop:AddButton({
Name = "Buy Geppo",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")

end})
Tabs.Shop:AddButton({
Name = "Buy Soru",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Soru")

end})
Tabs.Shop:AddButton({
Name = "Buy Ken",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("KenTalk","Buy")

end})
Tabs.Shop:AddSection("Fighting - Style")
Tabs.Shop:AddButton({
Name = "Buy Black Leg",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")

end})
Tabs.Shop:AddButton({
Name = "Buy Electro",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyElectro")

end})
Tabs.Shop:AddButton({
Name = "Buy Fishman Karate",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")

end})
Tabs.Shop:AddButton({
Name = "Buy DragonClaw",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")

end})
Tabs.Shop:AddButton({
Name = "Buy Superhuman",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")

end})
Tabs.Shop:AddButton({
Name = "Buy Death Step",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")

end})
Tabs.Shop:AddButton({
Name = "Buy Sharkman Karate",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")

end})
Tabs.Shop:AddButton({
Name = "Buy ElectricClaw",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")

end})
Tabs.Shop:AddButton({
Name = "Buy DragonTalon",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")

end})
Tabs.Shop:AddButton({
Name = "Buy Godhuman",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")

end})
Tabs.Shop:AddButton({
Name = "Buy SanguineArt",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")

end})
Tabs.Shop:AddSection("Accessory")
Tabs.Shop:AddButton({
Name = "Buy Tomoe Ring",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring")

end})
Tabs.Shop:AddButton({
Name = "Buy Black Cape",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Black Cape")

end})
Tabs.Shop:AddButton({
Name = "Buy Swordsman Hat",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")

end})
Tabs.Shop:AddButton({
Name = "Buy Bizarre Rifle",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 1)

end})
Tabs.Shop:AddButton({
Name = "Buy Ghoul Mask",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 2)

end})
Tabs.Shop:AddSection("Weapon World1")
Tabs.Shop:AddButton({
Name = "Buy Cutlass",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cutlass")

end})
Tabs.Shop:AddButton({
Name = "Buy Katana",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Katana")

end})
Tabs.Shop:AddButton({
Name = "Buy Iron Mace",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")

end})
Tabs.Shop:AddButton({
Name = "Buy Duel Katana",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")

end})
Tabs.Shop:AddButton({
Name = "Buy Triple Katana",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")

end})
Tabs.Shop:AddButton({
Name = "Buy Pipe",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Pipe")

end})
Tabs.Shop:AddButton({
Name = "Buy Dual-Headed Blade",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")

end})
Tabs.Shop:AddButton({
Name = "Buy Bisento",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")

end})
Tabs.Shop:AddButton({
Name = "Buy Soul Cane",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")

end})
Tabs.Shop:AddButton({
Name = "Buy Slingshot",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Slingshot")

end})
Tabs.Shop:AddButton({
Name = "Buy Musket",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Musket")

end})
Tabs.Shop:AddButton({
Name = "Buy Dual Flintlock",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")

end})
Tabs.Shop:AddButton({
Name = "Buy Flintlock",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Flintlock")

end})
Tabs.Shop:AddButton({
Name = "Buy Refined Flintlock",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")

end})
Tabs.Shop:AddButton({
Name = "Buy Cannon",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cannon")

end})
Tabs.Shop:AddButton({
Name = "Buy Kabucha",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")

end})
Tabs.Shop:AddSection("Fragments shop")
Tabs.Shop:AddButton({
Name = "Buy Refund Stats",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")

end})
Tabs.Shop:AddButton({
Name = "Buy Reroll Race",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")

end})
Tabs.Shop:AddButton({
Name = "Buy Ghoul Race",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm"," Change", 4)

end})
Tabs.Shop:AddButton({
Name = "Buy Cyborg Race (2.5k)",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CyborgTrainer"," Buy")

end})
Tabs.Shop:AddButton({
    Name = "Buy Draco Race",
    Callback = function()

        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))

        local targetPosition = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)

        local character = player.Character or player.CharacterAdded:Wait()

        repeat wait()
        until (character.HumanoidRootPart.Position - targetPosition).Magnitude < 1

        local args = {
          [1] = {
                ["NPC"] = "Dragon Wizard",
                ["Command"] = "DragonRace"
            }

        }

        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))

    end
})
Tabs.Misc:AddSection("Server - Function")
Tabs.Misc:AddButton({
  Name = "Redeem All Codes",
  Description = "",
  Callback = function()
      local codes = {
          "LIGHTNINGABUSE","1LOSTADMIN","ADMINFIGHT","GIFTING_HOURS","NOMOREHACK",
          "BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS",
          "SUB2GAMERROBOT_RESET1","KITT_RESET","Bignews","CHANDLER","Fudd10",
          "fudd10_v2","Sub2UncleKizaru","FIGHT4FRUIT","kittgaming","TRIPLEABUSE",
          "Sub2CaptainMaui","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK",
          "Starcodeheo","Bluxxy","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123",
          "Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie",
          "TheGreatAce","JULYUPDATE_RESET","ADMINHACKED","SEATROLLING","24NOADMIN",
          "ADMIN_TROLL","NEWTROLL","SECRET_ADMIN","staffbattle","NOEXPLOIT",
          "NOOB2ADMIN","CODESLIDE","fruitconcepts","krazydares"
      }

      local ReplicatedStorage = game:GetService("ReplicatedStorage")
      local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
      local RedeemRemote = RemotesFolder:FindFirstChild("Redeem")

      if not RedeemRemote then
          return
      end

      for _, code in ipairs(codes) do
          task.wait(0)
          pcall(function()
              if RedeemRemote.InvokeServer then
                  RedeemRemote:InvokeServer(code)
              else
                  RedeemRemote:FireServer(code)
              end
          end)
      end
  end
})
Tabs.Misc:AddButton({
Name = "Rejoin Server",
Description = "",
Callback = function()

  game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)

end})
Tabs.Misc:AddButton({
    Name = "Hop Server",
    Description = "",
    Callback = function()
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local PlaceId = game.PlaceId
            local Players = game:GetService("Players")

            local success, servers = pcall(function()
                local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local response = game:HttpGet(url)
                return HttpService:JSONDecode(response).data
            end)

            if success and servers then
                local targetServer
                for _, s in pairs(servers) do
                    if s.playing < s.maxPlayers then
                        targetServer = s.id
                    end
                end

                if targetServer then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
                    end)
                end
            end
        end)
    end
})
Tabs.Misc:AddButton({
Name = "Hop to Lowest Players",
Description = "",
Callback = function()

  local Http = game:GetService("HttpService")

  local TPS = game:GetService("TeleportService")

  local Api = "https://games.roblox.com/v1/games/"

  local _place = game.PlaceId

  local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"

   local Server, Next; repeat
   local Servers = ListServers(Next)
   Server = Servers.data[1]
   Next = Servers.nextPageCursor
  until Server

  TPS:TeleportToPlaceInstance(_place,Server.id,plr)

end})
Tabs.Misc:AddButton({
Name = "Hop to Lowest Pings Server",
Description = "",
Callback = function()

local HTTPService = game:GetService("HttpService")

local TeleportService = game:GetService("TeleportService")

local StatsService = game:GetService("Stats")

  local placeId = game.PlaceId

  local serverLimit = 100

  local servers = fetchServersData(placeId, serverLimit)

  if not servers then return end

  local lowestPingServer = servers[1]

  for _, server in pairs(servers) do
    if server["ping"] < lowestPingServer["ping"] and server.maxPlayers > server.playing then
      lowestPingServer = server
    end
  end

  local commonLoadTime = 0.5

  task.wait(commonLoadTime)

  local pingThreshold = 100

  local serverStats = StatsService.Network.ServerStatsItem

  local dataPing = serverStats["Data Ping"]:GetValueString()

  local pingValue = tonumber(dataPing:match("(%d+)"))

  if pingValue >= pingThreshold then
    TeleportService:TeleportToPlaceInstance(placeId, lowestPingServer.id)
  else
  end

end})
Tabs.Misc:AddTextBox({
    Name = "Input Job Id",
    Placeholder = "Job ID",
    ClearOnFocus = true,
    Callback = function(Value)

        getgenv().Job = Value

    end
})
Tabs.Misc:AddButton({
    Name = "Teleport [Job ID]",
    Callback = function()

        if getgenv().Job and getgenv().Job ~= "" then
            game:GetService("TeleportService")
                :TeleportToPlaceInstance(
                    game.PlaceId,
                    getgenv().Job,
                    game.Players.LocalPlayer
                )
        end

    end
})
Tabs.Misc:AddButton({
Name = "Copy JobID",
Description = "",
Callback = function()

  setclipboard(tostring(game.JobId))

end})
Tabs.Misc:AddSection("Player Gui / Others")
Tabs.Misc:AddButton({
Name = "Open Awakenings Expert",
Description = "",
Callback = function()

  plr.PlayerGui.Main.AwakeningToggler.Visible = true

end})
Tabs.Misc:AddButton({
Name = "Open Title Selection",
Description = "",
Callback = function()

  replicated.Remotes.CommF_:InvokeServer("getTitles",true)

  plr.PlayerGui.Main.Titles.Visible = true

end})
DisbleChat = Tabs.Misc:AddToggle({
Name = "Disable Chat GUI",
Description = "",
Default = false,
Callback = function(Value)

  _G.Rechat = Value

  if  _G.Rechat == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)    
  elseif _G.chat == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)    
  end

end
})
DisbleLeaderB = Tabs.Misc:AddToggle({
Name = "Disable Leader Board GUI",
Description = "",
Default = false,
Callback = function(Value)

  ReLeader = Value

  if ReLeader == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)   
  elseif ReLeader == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)   
  end

end
})
Tabs.Misc:AddButton({
Name = "Set Pirate Team",
Description = "",
Callback = function()

  Pirates()

end})
Tabs.Misc:AddButton({
Name = "Set Marine Team",
Description = "",
Callback = function()

  Marines()

end})
UnPortal = Tabs.Misc:AddToggle({
Name = "Unlock All Portals",
Description = "",
Default = false,
Callback = function(Value)

  _G.PortalUnLock = Value

end})
Tabs.Misc:AddSection("Graphics / Haki Stats")
HakiSt = {"State 0","State 1","State 2","State 3","State 4","State 5"}
HakiStat = Tabs.Misc:AddDropdown({
Name = "Select Haki States",
Options = HakiSt,
Callback = function(Value)

  _G.SelectStateHaki = Value

end})
Tabs.Misc:AddButton({
Name = "ChangeBusoStage",
Description = "",
Callback = function()

  if _G.SelectStateHaki == "State 0" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",0)
  elseif _G.SelectStateHaki == "State 1" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",1)
  elseif _G.SelectStateHaki == "State 2" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",2)
  elseif _G.SelectStateHaki == "State 3" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",3)
  elseif _G.SelectStateHaki == "State 4" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",4)
  elseif _G.SelectStateHaki == "State 5" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",5)
  end

end})
rtxM = Tabs.Misc:AddToggle({
Name = "Turn on RTX Mode",
Description = "",
Default = false,
Callback = function(Value)

  _G.RTXMode = Value

  local a = game.Lighting

  local c = Instance.new("ColorCorrectionEffect", a)

  local e = Instance.new("ColorCorrectionEffect", a)

  OldAmbient = a.Ambient

  OldBrightness = a.Brightness

  OldColorShift_Top = a.ColorShift_Top

  OldBrightnessc = c.Brightness

  OldContrastc = c.Contrast

  OldTintColorc = c.TintColor

  OldTintColore = e.TintColor    

  if not _G.RTXMode then return end

  while _G.RTXMode do wait()
    a.Ambient = Color3.fromRGB(33, 33, 33)
    a.Brightness = 0.3
    c.Brightness = 0.176
    c.Contrast = 0.39
    c.TintColor = Color3.fromRGB(217, 145, 57)
    game.Lighting.FogEnd = 999
    if not plr.Character.HumanoidRootPart:FindFirstChild("PointLight") then
      local a2 = Instance.new("PointLight")
      a2.Parent = plr.Character.HumanoidRootPart
      a2.Range = 15
      a2.Color = Color3.fromRGB(217, 145, 57)
    end
    if not _G.RTXMode then
      a.Ambient = OldAmbient
      a.Brightness = OldBrightness
      a.ColorShift_Top = OldColorShift_Top
      c.Contrast = OldContrastc
      c.Brightness = OldBrightnessc
      c.TintColor = OldTintColorc
      e.TintColor = OldTintColore
      game.Lighting.FogEnd = 2500
      plr.Character.HumanoidRootPart:FindFirstChild("PointLight"):Destroy()
    end
  end

end
})
Tabs.Misc:AddButton({
Name = "Turn on Fast Mode",
Description = "",
Callback = function()

  for _,zx in next, workspace:GetDescendants() do
  if table.find(Past, zx.ClassName) then  zx.Material = "Plastic" end
  end

end})
Tabs.Misc:AddButton({
Name = "Turn on Low CPU",
Description = "",
Callback = function()

  LowCpu()

end})
Tabs.Misc:AddButton({
Name = "Turn on increase Boats",
Description = "",
Callback = function()

  for _, v in pairs(workspace.Boats:GetDescendants()) do
    if table.find(ListSeaBoat, v.Name) and tostring(v.Owner.Value) == tostring(plr.Name) then              
      v.VehicleSeat.MaxSpeed = 350
      v.VehicleSeat.Torque = 0.2
      v.VehicleSeat.TurnSpeed = 5
      v.VehicleSeat.HeadsUpDisplay = true
    end
  end

end})
Tabs.Misc:AddButton({
Name = "Remove Sky Fog",
Description = "",
Callback = function()

  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end

  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end

  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end

end})
Tabs.Misc:AddSection("Configure - God")
Tabs.Misc:AddButton({
Name = "Rain Fruits (Client)",
Description = "",
Callback = function()

  for i, v in pairs(game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()) do
    v.Parent = game.Workspace.Map
    v:MoveTo(plr.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))
    if v.Fruit:FindFirstChild("AnimationController") then
      v.Fruit:FindFirstChild("AnimationController"):LoadAnimation(v.Fruit:FindFirstChild("Idle")):Play()
    end
    v.Handle.Touched:Connect(function(otherPart)
      if otherPart.Parent == plr.Character then
        v.Parent = plr.Backpack
        plr.Character.Humanoid:EquipTool(v)
      end
    end)
  end

end})
briggt1 = Tabs.Misc:AddToggle({
Name = "Turn on Full Bright",
Description = "",
Default = false,
Callback = function(Value)

  bright = Value

  if Value == true then
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
  else
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
  end  

end
})
DayN = Tabs.Misc:AddDropdown({
Name = "Select Time",
Description = "",
Options = {"Day", "Night"},
Default = Day,
Callback = function(Value)

  _G.SelectDN = Value

end})
dayornight = Tabs.Misc:AddToggle({
Name = "Turn on Time",
Description = "",
Default = false,
Callback = function(Value)

  _G.daylightN = Value

end})
walkWater = Tabs.Misc:AddToggle({
Name = "Turn on Walk on Water",
Description = "",
Default = true,
Callback = function(Value)

  _G.WalkWater_Part = Value

  if _G.WalkWater_Part then
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
  else
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
  end

end
})
iceWalk = Tabs.Misc:AddToggle({
Name = "Turn on Ice Walk",
Description = "",
Default = false,
Callback = function(Value)

  _G.WalkWater = Value

end})
Window:Notify({
  Title = "Redz Hub",
  Content = "Redz Hub comeback",
  Image = "rbxassetid://132684424743910",
  Duration = 5
})
