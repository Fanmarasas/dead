-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fanmarasas/dead/refs/heads/main/luaa.lua"))()

-- Create a custom theme for better visual appearance
local CustomTheme = {
   	SchemeColor = Color3.fromRGB(85, 170, 255),  -- Brighter blue for better visibility
    Background = Color3.fromRGB(15, 15, 25),     -- Darker background for contrast
    Header = Color3.fromRGB(10, 10, 20),         -- Even darker header for hierarchy
    TextColor = Color3.fromRGB(255, 255, 255),   -- White text for readability
    ElementColor = Color3.fromRGB(25, 25, 40) 
}

-- Create main window with custom theme
local Window = Library.CreateLib("✨ Snowfarn code Premium ✨", CustomTheme)

-- Store all connections for easy cleanup
local Connections = {}

-- Store original game settings for restoration
local OriginalSettings = {
    Lighting = {
        Brightness = game:GetService("Lighting").Brightness,
        Ambient = game:GetService("Lighting").Ambient,
        OutdoorAmbient = game:GetService("Lighting").OutdoorAmbient
    },
    Atmosphere = {
        Density = (game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere") and 
                  game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere").Density or 0)
    },
    ColorCorrection = {
        Brightness = (game:GetService("Lighting"):FindFirstChildOfClass("ColorCorrectionEffect") and 
                     game:GetService("Lighting"):FindFirstChildOfClass("ColorCorrectionEffect").Brightness or 0)
    }
}

-- Function to disconnect all connections
local function DisconnectAll()
    for _, connection in pairs(Connections) do
        if typeof(connection) == "RBXScriptConnection" and connection.Connected then
            connection:Disconnect()
        end
    end
    Connections = {}
end

-- Function to remove all highlights
local HighlightEntities = {}
local function RemoveAllHighlights()
    for _, highlight in pairs(HighlightEntities) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    HighlightEntities = {}
end

-- Function to add highlight to entity with custom effects
local function AddHighlightToEntity(entity, fillColor, outlineColor, fillTransparency, outlineTransparency)
    if entity:IsA("Model") and not entity:FindFirstChild("Highlight") then
        local parentFolder = entity.Parent
        
        -- Skip safe zones
        if parentFolder and parentFolder.Name == "SafeZones" then
            return
        end
        
        local newHighlight = Instance.new("Highlight")
        newHighlight.Parent = entity
        newHighlight.Adornee = entity
        newHighlight.FillColor = fillColor or Color3.fromRGB(255, 255, 255)
        newHighlight.OutlineColor = outlineColor or Color3.fromRGB(255, 255, 255)
        newHighlight.FillTransparency = fillTransparency or 0.3
        newHighlight.OutlineTransparency = outlineTransparency or 0.6
        
        table.insert(HighlightEntities, newHighlight)
        return newHighlight
    end
    return nil
end

-- Create info tab
local InfoTab = Window:NewTab("ℹ️ Information")
local InfoSection = InfoTab:NewSection("Welcome to Snowfarn code Premium")

InfoSection:NewLabel("👋 ทำโดย: Snowfarn ")
InfoSection:NewLabel("🌟 เวอร์ชั่น: 1.0 ")
InfoSection:NewLabel("📅 อัพเดตล่าสุด: เดือน มี.ค ")

-- Button to copy Discord invite
InfoSection:NewButton("🔗 ลิ้ง discord ของทางเรา", "discord youtube invite to clipboard", function()
    setclipboard("https://discord.gg/5eUPMxveDr")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "discord Invite",
        Text = "Copied to clipboard!",
        Duration = 3
    })
end)

-- Main Features Tab
local MainTab = Window:NewTab("⚡ ฟิวเจอร์หลัก")
local MainSection = MainTab:NewSection("Game Enhancements")

-- X-ray toggle with improved functionality
local XrayStatus = false
local XrayToggle = MainSection:NewToggle("🔍 X-ray Items & Enemies", "มองทะลุของที่เก็บได้", function(state)
    XrayStatus = state
    
    if state then
        -- Function to determine color based on entity type
        local function getEntityColor(entity)
            local parentFolder = entity.Parent
            local entityName = entity.Name:lower()
            
            -- Items get gold color
            if parentFolder and parentFolder.Name == "RuntimeItems" then
                return Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255), 0.3, 0.6
            -- Enemies by type
            elseif entityName:find("RevolverOutlaw") or entityName:find("ShotgunOutlaw") or entityName:find("Wolf") then
                return Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Red for dangerous enemies
            elseif entityName:find("Runner") then
                return Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Blue for runners
            elseif entityName:find("runner") then
                return Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Blue for runners
            elseif entityName:find("walker") then
                return Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Green for walkers
            elseif entityName:find("Walker") then
                return Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Green for walkers
            elseif entityName:find("vampire") then
                return Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Purple for vampires
            elseif entityName:find("werewolf") then
                return Color3.fromRGB(169, 169, 169), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Gray for werewolves
            elseif entityName:find("Vampire") then
                return Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Purple for vampires
            elseif entityName:find("Werewolf") then
                return Color3.fromRGB(169, 169, 169), Color3.fromRGB(255, 255, 255), 0.3, 0.6  -- Gray for werewolves
            end
            return nil
        end

        -- Process existing entities
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local colors = {getEntityColor(obj)}
                if colors[1] then
                    AddHighlightToEntity(obj, colors[1], colors[2], colors[3], colors[4])
                end
            end
        end
        
        -- ตรวจจับเอนทิตีใหม่
        local connection = game.Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("Model") then
                local colors = {getEntityColor(obj)}
                if colors[1] then
                    AddHighlightToEntity(obj, colors[1], colors[2], colors[3], colors[4])
                end
            end
        end)
        table.insert(Connections, connection)
        
        -- อัปเดต UI
        XrayToggle:UpdateToggle("🔍 X-ray ไอเท็ม & ศัตรู: เปิด")
        
        -- การแจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "เปิดใช้งาน X-ray",
            Text = "โหมดมองทะลุไอเท็มถูกเปิดใช้งาน",
            Duration = 3
        })
    else
        -- ปิดใช้งาน X-ray
        for _, connection in pairs(Connections) do
            if connection == Connections[#Connections] then
                connection:Disconnect()
                table.remove(Connections, #Connections)
            end
        end
        
        RemoveAllHighlights()
        
        -- อัปเดต UI
        XrayToggle:UpdateToggle("🔍 X-ray ไอเท็ม & ศัตรู: ปิด")
        
        -- การแจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ปิดใช้งาน X-ray",
            Text = "โหมดมองทะลุไอเท็มถูกปิด",
            Duration = 3
        })
    end
end)

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local DropToggle = MainSection:NewToggle("📦 ออโต้ทิ้งไอเท็ม", "ทิ้งไอเท็มอัตโนมัติ", function(state)
    if state then
        print("เปิดใช้งาน: ออโต้ทิ้งไอเท็ม")
        local dropItemRemote = replicatedStorage:WaitForChild("Remotes"):WaitForChild("DropItem")

        _G.AutoDropConnection = runService.Heartbeat:Connect(function()
            dropItemRemote:FireServer()
        end)
    else
        print("ปิดใช้งาน: ออโต้ทิ้งไอเท็ม")
        if _G.AutoDropConnection then
            _G.AutoDropConnection:Disconnect()
            _G.AutoDropConnection = nil
        end
    end
end)

local players = game:GetService("Players")
local player = players.LocalPlayer
local CollectRange = 20  -- ระยะทางเริ่มต้นในการเก็บอัตโนมัติ
local CollectToggle
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

MainSection:NewSlider("📏 ระยะเก็บไอเท็ม", "ปรับระยะทางการเก็บอัตโนมัติ", 50, 5, function(value)
    CollectRange = value
    if _G.AutoCollectConnection then
        CollectToggle:UpdateToggle("🧲 การเก็บไอเท็มอัตโนมัติ: เปิด (" .. CollectRange .. "m)")
    end
end)

CollectToggle = MainSection:NewToggle("🧲 การเก็บไอเท็มอัตโนมัติ", "เก็บไอเท็มใกล้เคียงอัตโนมัติ", function(state)
    if state then
        print("เปิดใช้งาน: การเก็บไอเท็มอัตโนมัติ")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local storeItemRemote = replicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem")

        -- บันทึกการเชื่อมต่อเพื่อตัดการเชื่อมต่อในภายหลัง
        _G.AutoCollectConnection = runService.Heartbeat:Connect(function()
            local runtimeItems = workspace:FindFirstChild("RuntimeItems")
            if not runtimeItems then return end

            for _, item in ipairs(runtimeItems:GetChildren()) do
                if item:IsA("Model") or item:IsA("Part") then
                    local itemPosition
                    if item:IsA("Model") then
                        local primaryPart = item.PrimaryPart
                        if primaryPart then
                            itemPosition = primaryPart.Position
                        else
                            itemPosition = item:GetPivot().Position
                        end
                    else
                        itemPosition = item.Position
                    end
                    
                    local distance = (rootPart.Position - itemPosition).Magnitude

                    if distance <= CollectRange then
                        storeItemRemote:FireServer(item)
                    end
                end
            end
        end)
    else
        print("ปิดใช้งาน: การเก็บไอเท็มอัตโนมัติ")
        -- ตัดการเชื่อมต่อเหตุการณ์เพื่อหยุดการเก็บอัตโนมัติ
        if _G.AutoCollectConnection then
            _G.AutoCollectConnection:Disconnect()
            _G.AutoCollectConnection = nil
        end
        CollectToggle:UpdateToggle("🧲 การเก็บไอเท็มอัตโนมัติ: ปิด")
    end
end)

-- แท็บการตั้งค่าภาพของโลก
local VisualTab = Window:NewTab("🌍 เอฟเฟกต์ภาพ")
local VisualSection = VisualTab:NewSection("การตั้งค่าสภาพแวดล้อม")

-- ความสว่างพร้อมแถบเลื่อน
local BrightnessValue = 0.2
local BrightnessStatus = false
local BrightnessToggle

VisualSection:NewSlider("💡 ระดับความสว่าง", "ปรับระดับความสว่างของสภาพแวดล้อม", 1, 0.1, function(value)
    BrightnessValue = value
    
    if BrightnessStatus then
        -- ใช้ค่าความสว่างทันทีหากเปิดใช้งานอยู่
        game:GetService("Lighting").Brightness = BrightnessValue
        
        -- อัปเดตข้อความของปุ่ม
        BrightnessToggle:UpdateToggle("💡 ความสว่างที่เพิ่มขึ้น: เปิด (ระดับ " .. BrightnessValue .. ")")
    end
end)

BrightnessToggle = VisualSection:NewToggle("💡 เพิ่มความสว่าง", "ปรับปรุงการมองเห็นด้วยการเพิ่มความสว่าง", function(state)
    BrightnessStatus = state
    local Lighting = game:GetService("Lighting")
    
    if state then
        print("เปิดใช้งาน: เพิ่มความสว่าง")
        local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")

        if ColorCorrection then
            -- บันทึกค่าตั้งต้น
            if not _G.OriginalColorCorrection then
                _G.OriginalColorCorrection = {
                    Brightness = ColorCorrection.Brightness
                }
            end
            
            -- ปรับระดับความสว่าง
            ColorCorrection.Brightness = BrightnessValue
            print("ปรับความสว่างเรียบร้อยแล้ว!")
        else
            print("ไม่พบ ColorCorrectionEffect ใน Lighting")
        end

        -- ปรับการตั้งค่าแสงทั่วไป
        Lighting.Brightness = 4
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        print("ปิดใช้งาน: คืนค่าความสว่างเริ่มต้น")
        -- คืนค่าการตั้งค่าความสว่างเดิม
        Lighting.Brightness = OriginalSettings.Lighting.Brightness
        Lighting.Ambient = OriginalSettings.Lighting.Ambient
        Lighting.OutdoorAmbient = OriginalSettings.Lighting.OutdoorAmbient

        -- คืนค่าการแก้ไขสีหากมีอยู่
        local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if ColorCorrection and _G.OriginalColorCorrection then
            ColorCorrection.Brightness = _G.OriginalColorCorrection.Brightness
        end
    end
end)

-- การลบหมอกพร้อมแถบเลื่อนปรับแต่ง
local FogStatus = false
local FogDensity = 0
local FogToggle

VisualSection:NewSlider("🌫️ ความหนาแน่นของหมอก", "ปรับความหนาแน่นของหมอก (0 = ไม่มีหมอก)", 1, 0, function(value)
    FogDensity = value
    
    if FogStatus then
        -- ใช้ค่าความหนาแน่นของหมอกทันทีหากเปิดใช้งานอยู่
        local Atmosphere = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
        if Atmosphere then
            Atmosphere.Density = FogDensity
        end
        
        -- อัปเดตข้อความของปุ่ม
        FogToggle:UpdateToggle("🌫️ ควบคุมหมอก: เปิด (ความหนาแน่น " .. FogDensity .. ")")
    end
end)

FogToggle = VisualSection:NewToggle("🌫️ ควบคุมหมอก", "ลบหรือปรับความหนาแน่นของหมอกเพื่อการมองเห็นที่ดีขึ้น", function(state)
    FogStatus = state
    local Lighting = game:GetService("Lighting")
    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    
    if state then
        if Atmosphere then
            -- บันทึกค่าความหนาแน่นเดิม
            if not _G.OriginalAtmosphere then
                _G.OriginalAtmosphere = {
                    Density = Atmosphere.Density
                }
            end
            
            -- ลบหมอกโดยตั้งค่าความหนาแน่นเป็น 0
            Atmosphere.Density = FogDensity
            print("ปรับค่าหมอกเรียบร้อย!")
        else
            print("ไม่พบ Atmosphere ใน Lighting")
        end
    else
        print("ปิดใช้งาน: คืนค่าหมอกเป็นค่าเริ่มต้น")
        -- คืนค่าความหนาแน่นของหมอกเดิม
        local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if Atmosphere and _G.OriginalAtmosphere then
            Atmosphere.Density = _G.OriginalAtmosphere.Density
        end
    end
end)

-- การควบคุมเวลาในเกม
VisualSection:NewButton("🌞 บังคับให้เป็นเวลากลางวัน", "ตั้งเวลาเป็นช่วงกลางวัน", function()
    game:GetService("Lighting").ClockTime = 12
    
    -- การแจ้งเตือน
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "เปลี่ยนเวลาแล้ว",
        Text = "ตั้งเวลาเป็นตอนเที่ยงวัน",
        Duration = 3
    })
end)

VisualSection:NewButton("🌜 บังคับให้เป็นเวลากลางคืน", "ตั้งเวลาเป็นช่วงกลางคืน", function()
    game:GetService("Lighting").ClockTime = 0
    
    -- การแจ้งเตือน
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "เปลี่ยนเวลาแล้ว",
        Text = "ตั้งเวลาเป็นตอนเที่ยงคืน",
        Duration = 3
    })
end)

-- แท็บการตั้งค่าพร้อมตัวเลือกที่ได้รับการปรับปรุง
local SettingsTab = Window:NewTab("⚙️ การตั้งค่า")
local SettingsSection = SettingsTab:NewSection("การตั้งค่า UI")

SettingsSection:NewKeybind("🔑 ปุ่มลัดเปิด/ปิด UI", "ซ่อน/แสดงอินเทอร์เฟซ", Enum.KeyCode.H, function()
    Library:ToggleUI()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "เปิด/ปิด UI",
        Text = "เปลี่ยนการแสดงผลของอินเทอร์เฟซ",
        Duration = 2
    })
end)

local ThemeSection = SettingsTab:NewSection("การปรับแต่งธีม")

-- ตัวเลือกธีม
local themes = {
    ["เริ่มต้น"] = CustomTheme,
    ["มหาสมุทร"] = {
        SchemeColor = Color3.fromRGB(35, 170, 255),
        Background = Color3.fromRGB(10, 30, 45),
        Header = Color3.fromRGB(5, 20, 35),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 40, 60)
    },
    ["เที่ยงคืน"] = {
        SchemeColor = Color3.fromRGB(100, 50, 255),
        Background = Color3.fromRGB(5, 5, 15),
        Header = Color3.fromRGB(10, 10, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 30)
    },
    ["เลือดหมู"] = {
        SchemeColor = Color3.fromRGB(220, 40, 40),
        Background = Color3.fromRGB(25, 5, 5),
        Header = Color3.fromRGB(35, 10, 10),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(45, 20, 20)
    },
    ["ป่า"] = {
        SchemeColor = Color3.fromRGB(40, 180, 60),
        Background = Color3.fromRGB(10, 25, 15),
        Header = Color3.fromRGB(5, 20, 10),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 45, 25)
    },
    ["ทอง"] = {
        SchemeColor = Color3.fromRGB(255, 200, 0),
        Background = Color3.fromRGB(20, 15, 5),
        Header = Color3.fromRGB(25, 20, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(40, 30, 10)
    }
}

ThemeSection:NewDropdown("🎨 ธีมสี", "เปลี่ยนลักษณะของ UI", {"เริ่มต้น", "มหาสมุทร", "เที่ยงคืน", "เลือดหมู", "ป่า", "ทอง"}, function(selected)
    if themes[selected] then
        for property, color in pairs(themes[selected]) do
            Library:ChangeColor(property, color)
        end
        
        -- แจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "เปลี่ยนธีมแล้ว",
            Text = "ใช้ธีม " .. selected .. " แล้ว",
            Duration = 3
        })
    end
end)

-- ปุ่มรีเซ็ต
local ResetSection = SettingsTab:NewSection("ตัวเลือกการรีเซ็ต")

ResetSection:NewButton("🔄 รีเซ็ตการตั้งค่าทั้งหมด", "คืนค่าการตั้งค่ากลับเป็นค่าเริ่มต้น", function()

    -- Reset X-ray
    if XrayStatus then
        XrayStatus = false
        RemoveAllHighlights()
        XrayToggle:UpdateToggle("🔍 X-ray ไอเท็มและศัตรู: ปิด")
    end

    -- รีเซ็ตการเก็บไอเท็มอัตโนมัติ
    if _G.AutoCollectConnection then
        _G.AutoCollectConnection:Disconnect()
        _G.AutoCollectConnection = nil
        CollectToggle:UpdateToggle("🧲 การเก็บไอเท็มอัตโนมัติ: ปิด")
    end
    
    -- Reset Auto Drop
    if _G.AutoDropConnection then
        _G.AutoDropConnection:Disconnect()
        _G.AutoDropConnection = nil
        DropToggle:UpdateToggle("📦 การทิ้งไอเท็มอัตโนมัติ: ปิด")
    end
    
    -- Reset Brightness
    if BrightnessStatus then
        BrightnessStatus = false
        local Lighting = game:GetService("Lighting")
        
        Lighting.Brightness = OriginalSettings.Lighting.Brightness
        Lighting.Ambient = OriginalSettings.Lighting.Ambient
        Lighting.OutdoorAmbient = OriginalSettings.Lighting.OutdoorAmbient
        
        local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if ColorCorrection and _G.OriginalColorCorrection then
            ColorCorrection.Brightness = _G.OriginalColorCorrection.Brightness
        end
        
        BrightnessToggle:UpdateToggle("💡 ความสว่างที่เพิ่มขึ้น: ปิด")
    end
    
    
    -- Reset Fog
    if FogStatus then
        FogStatus = false
        local Atmosphere = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
        
        if Atmosphere and _G.OriginalAtmosphere then
            Atmosphere.Density = _G.OriginalAtmosphere.Density
        end
        
        FogToggle:UpdateToggle("🌫️ การควบคุมหมอก: ปิด")
    end
    
    -- ตัดการเชื่อมต่อทั้งหมด
    DisconnectAll()
    
    -- แจ้งเตือน
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reset Complete",
        Text = "การตั้งค่าทั้งหมดถูกคืนค่าเป็นค่าเริ่มต้น",
        Duration = 3
    })
    end)
    

-- Credits tab
local CreditsTab = Window:NewTab("👑 เครดิต")
local CreditsSection = CreditsTab:NewSection("Special Thanks")

CreditsSection:NewLabel("🌟 ทำโดย: Snowfarn")
CreditsSection:NewLabel("🛠️ UI ทำโดย : Snowfarn")
CreditsSection:NewLabel("🔧 เวอร์ชั่น : ทดสอบ")

-- Create Mobile UI Toggle Button
-- This will create a floating button for mobile users
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "Snowfarn code MobileToggle"

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "MobileToggle"
ToggleButton.Parent = ScreenGui
ToggleButton.AnchorPoint = Vector2.new(1, 0) -- Anchor to top right
ToggleButton.Position = UDim2.new(0.98, 0, 0.1, 0) -- Position in top right area
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255) -- Match theme blue
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "📱"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = true

-- Make the button rounded
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Fully rounded (circle)
UICorner.Parent = ToggleButton

-- Add shadow for better visibility
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Transparency = 0.5
UIStroke.Thickness = 2
UIStroke.Parent = ToggleButton

-- Add a small gradient for style
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 220))
})
UIGradient.Parent = ToggleButton

-- Add touch effect
local TouchRipple = Instance.new("Frame")
TouchRipple.Name = "TouchRipple"
TouchRipple.Parent = ToggleButton
TouchRipple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TouchRipple.BackgroundTransparency = 0.8
TouchRipple.BorderSizePixel = 0
TouchRipple.Size = UDim2.new(1, 0, 1, 0)
TouchRipple.Visible = false
TouchRipple.ZIndex = 2

local RippleCorner = Instance.new("UICorner")
RippleCorner.CornerRadius = UDim.new(1, 0)
RippleCorner.Parent = TouchRipple

-- Make the button draggable for better user experience
local isDragging = false
local dragInput
local dragStart
local startPos

local function updatePosition(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then

        TouchRipple.Visible = true
        

        if not isDragging then
            Library:ToggleUI()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "UI Toggled",
                Text = "เปลี่ยนการมองเห็นของเมนู",
                Duration = 2
            })
        end
        
        -- Handle dragging
        isDragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        -- Hide ripple effect after a short delay
        spawn(function()
            wait(0.3)
            TouchRipple.Visible = false
        end)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
        if isDragging then
            updatePosition(input)
        end
    end
end)

-- Opening notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✨ Snowfarn code Premium ✨",
    Text = "ดาวโหลดปุ่มมือถือสำเร็จแล้ว",
    Duration = 5
})
