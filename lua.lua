-- Made by Ice & Fire

-- // Services \\ --

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local marketPlaceService = game:GetService("MarketplaceService")
local tweenService = game:GetService("TweenService")
local starterGui = game:GetService("StarterGui")

-- // Object Variables \\ --

local camera = workspace.CurrentCamera

local player = players.LocalPlayer
local playerGui = player.PlayerGui

local mouseDown = false
local lastPosition

local mouse = player:GetMouse()

local teleportPart = workspace:WaitForChild("TeleportPart")

local wardrobeGui = playerGui:WaitForChild("Wardrobe")
local mainFrame = wardrobeGui:WaitForChild("MainFrame")
local assetPlacement = mainFrame:WaitForChild("AssetFolder")

local selectFrame = mainFrame:WaitForChild("SelectFrame")
local visual2D = selectFrame:WaitForChild("2DVisuals")
local visual3D = selectFrame:WaitForChild("3DVisuals")

local faceFrame = assetPlacement:WaitForChild("Faces")

local clothingRepository = replicatedStorage:WaitForChild("ClothingRepository")

local assetFolder = replicatedStorage:WaitForChild("Assets")
local remoteEventsFolder = replicatedStorage:WaitForChild("RemoteEvents")
local remoteFunctionsFolder = replicatedStorage:WaitForChild("RemoteFunctions")

-- // Private Variables \\ --

local opened = false
local oldOpened = "None"

local connections = {}

local equippedClothing = {
	["NotUsed"] = true,
	["Hat"] = false,
	["Face"] = false,
	["Hair"] = false,
	["Shirt"] = false,
	["Pant"] = false,
	["Shoe"] = false,
}

local buttonConnections = {}
local cameraConnection

-- // Private Functions \\ --

-- Function to rotate the player's character

local function rotateCharacter()
	-- Check if the mouse button is pressed
	
	if mouseDown then  
		-- Calculate the rotation angle based on the mouse movement
		
		local rotateRadian = math.rad((mouse.X - lastPosition) / 4)
		
		-- Get the player's character and its humanoid root part
		
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		-- Lock the humanoid root part in place
		
		humanoidRootPart.Anchored = true
		
		-- Apply the rotation to the humanoid root part
		
		humanoidRootPart.CFrame *= CFrame.Angles(0, rotateRadian, 0)
	end
end

-- Function to set up the camera

local function setupCamera()
	-- Set the camera type to scriptable
	
	camera.CameraType = Enum.CameraType.Scriptable

	-- Create a part to act as the camera's reference point
	
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	
	-- Set the part's position to be behind the player's character
	
	part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -7)
	
	-- Make the part look at the player's character
	
	part.CFrame = CFrame.lookAt(part.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
	part.Transparency = 1

	-- Connect the mouse movement to the rotateCharacter function
	
	cameraConnection = mouse.Move:Connect(rotateCharacter)

	-- Set the camera's position to the reference part's position
	
	camera.CFrame = part.CFrame
end

-- The function changeData is defined with three parameters: data, value, and showcaseFrame.

local function changeData(data, value, showcaseFrame)
	-- The value of the data parameter is assigned to the equippedClothing table with the data key.
	
	equippedClothing[data] = value
	
	-- The character variable is assigned the player's character or waits for the character to be added if it is not yet loaded.
	
	local character = player.Character or player.CharacterAdded:Wait()
	
	-- The head variable is assigned the "Head" instance of the character and waits for it to exist if it doesn't already.
	
	local head = character:WaitForChild("Head")
	
	-- The face variable is assigned the "face" instance of the head and waits for it to exist if it doesn't already.
	
	local face = head:WaitForChild("face")
	
	-- If the data parameter is equal to "Face", then the texture of the "face" instance is set to the value parameter and the "Image" property of the "dataImage" child of the showcaseFrame is set to the value parameter.
	
	if data == "Face" then
		face.Texture = value
		showcaseFrame:FindFirstChild(data .. "Image").Image = value
		
		-- If the data parameter is equal to "Hat", then a variable named "accessory" is assigned to the "CustomAccessory" instance of the character, if it exists.
		-- If "accessory" exists, it is destroyed.
		-- The value parameter is then cloned and assigned to "accessory", and "accessory" is parented to the character.
	elseif data == "Hat" or data == "Hair" then
		-- If the accessory to be changed is a hat or hair, find the humanoid object in the character
		local humanoid = character:FindFirstChild("Humanoid")

		-- Send a request to the server to change the accessory using the PlaceAccessory remote event
		remoteEventsFolder:WaitForChild("PlaceAccessory"):FireServer(data, value)

	elseif data == "Shirt" then
		-- If the accessory to be changed is a shirt, find the shirt object in the character
		local shirt = character:FindFirstChildOfClass("Shirt")

		-- Update the shirt image in the UI to show the new shirt design
		showcaseFrame:FindFirstChild(data .. "Image").Image = value

		-- If the character is wearing a shirt, change its ShirtTemplate property to the new design
		if shirt then
			shirt.ShirtTemplate = value
		end

	elseif data == "Pant" then
		-- If the accessory to be changed is pants, find the pants object in the character
		local pant = character:FindFirstChildOfClass("Pants")

		-- Update the pants image in the UI to show the new pants design
		showcaseFrame:FindFirstChild(data .. "Image").Image = value

		-- If the character is wearing pants, change its PantsTemplate property to the new design
		if pant then
			pant.PantsTemplate = value
		end

	elseif data == "Shoe" then
		-- If the accessory to be changed is shoes, loop through each shoe object in the value parameter
		for index, shoe in pairs(value:GetChildren()) do
			-- Send a request to the server to change each shoe accessory using the PlaceAccessory remote event
			remoteEventsFolder:WaitForChild("PlaceAccessory"):FireServer(data .. index, shoe)

			-- Wait for a short time to prevent server overload
			task.wait(0.35)
		end
	end
end

local function hasProperty(object, property)
	local property = object[property] 
end

-- This function lists 2D images of a given type in a given frame
-- It takes the dataType (e.g. "ShirtData") and the showcaseFrame as parameters

local function list2D(dataType, showcaseFrame)
	-- Get the data repository for the given data type
	
	local dataRepository = clothingRepository:WaitForChild(dataType)

	-- Disconnect any previous button connections
	
	for _, connection in pairs(buttonConnections) do
		connection:Disconnect()
	end

	-- Destroy any previous image buttons in the 2D visual frame
	
	for _, object in pairs(visual2D:GetChildren()) do
		if object:IsA("ImageButton") then
			object:Destroy()
		end
	end

	-- Loop through each data item in the data repository
	
	for _, data in pairs(dataRepository:GetChildren()) do
		-- Clone the 2D image button asset from the asset folder
		local button = assetFolder:WaitForChild("2DImage"):Clone()

		local texture

		-- Check if the data object has a "Texture" property, and if so, set the texture variable to its value
		local success, fail = pcall(function()
			hasProperty(data, "Texture")
		end)

		if success then
			texture = data.Texture
			-- If the "Texture" property is not found, check for a "ShirtTemplate" property instead
		elseif fail then
			local success, fail = pcall(function()
				hasProperty(data, "ShirtTemplate")
			end)

			if success then
				texture = data.ShirtTemplate
				-- If neither "Texture" nor "ShirtTemplate" are found, check for a "PantsTemplate" property instead
			else
				local success, fail = pcall(function()
					hasProperty(data, "PantsTemplate")
				end)

				if success then
					texture = data.PantsTemplate
				end
			end
		end

		
		-- Set the button's image and color based on the data
		
		button.Image = texture
		button.Parent = visual2D -- Set the button's parent to the 2D visual frame

		-- Set up a button click event to change the data in the showcase frame
		
		button.MouseButton1Click:Connect(function()
			-- Get the ID of the data item from the texture string
			
			local dataID = string.split(texture, "=")
			
			-- Get the pure name of the data type (e.g. "Shirt" instead of "ShirtData")
			
			local dataPureName = string.sub(dataType, 1, string.len(dataType) - 1)
			local asset

			-- Try to get the product info from the data ID using the marketplace service
			
			local success, fail = pcall(function()
				asset = marketPlaceService:GetProductInfo(tonumber(dataID[2]))
			end)

			-- If successful, set the showcase frame's selected text to the asset name
			
			if success then
				showcaseFrame:FindFirstChild("Selected" .. dataPureName .. "Text").Text = asset.Name
			else
				-- If the first attempt fails, try getting the product info from a different texture string format
				
				local newDataID = string.split(texture, "://")

				local success, fail = pcall(function()
					asset = marketPlaceService:GetProductInfo(tonumber(newDataID[2]))
				end)

				-- If successful, set the showcase frame's selected text to the asset name
				
				if success then
					showcaseFrame:FindFirstChild("Selected" .. dataPureName .. "Text").Text = asset.Name
				else
					-- If both attempts fail, log the error to the console
					
					warn(fail)
				end
			end

			-- Change the data in the showcase frame to the selected data item
			
			changeData(dataPureName, texture, showcaseFrame)
		end)
	end
end

-- This function lists 3D data for a specific data type in the showcase frame
-- The data type is passed as a parameter
-- The showcase frame is passed as a parameter as well
local function list3D(dataType, showcaseFrame)
	-- Find the data repository for the specified data type
	local dataRepository = clothingRepository:WaitForChild(dataType)

	-- Disconnect all button connections for the 3D data
	for _, connection in pairs(buttonConnections) do
		connection:Disconnect()
	end

	-- Destroy any existing 3D viewport frames
	for _, object in pairs(visual3D:GetChildren()) do
		if object:IsA("ViewportFrame") then
			object:Destroy()
		end
	end

	-- Iterate over each child in the data repository and create a button for it
	for _, data in pairs(dataRepository:GetChildren()) do
		-- Clone the 3D image button asset from the asset folder
		local button = assetFolder:WaitForChild("3DImage"):Clone()
		button.Parent = visual3D

		-- Clone the data and parent it to the button
		local clonedAsset = data:Clone()
		clonedAsset.Parent = button

		-- Set the position of the asset in the 3D viewport
		for _, part in pairs(clonedAsset:GetDescendants()) do
			if part.Name == "Handle" then
				part.CFrame = CFrame.new(39.11, 0.794, 1.649)

				break
			end
		end

		-- Connect a mouse click event to the button to change the displayed data in the showcase frame
		button.TextButton.MouseButton1Click:Connect(function()
			-- Get the pure name of the data type
			local dataPureName = string.sub(dataType, 1, string.len(dataType) - 1)
			-- Find the image frame in the showcase frame for the data type and remove any existing accessory
			local showingFrame = showcaseFrame:FindFirstChild(dataPureName .. "Image")
			local accessory = showingFrame:FindFirstChildOfClass("Accessory")
			if accessory then
				accessory:Destroy()
			end
			-- Clone the data and parent it to the image frame
			local clonedAsset = data:Clone()
			clonedAsset.Parent = showingFrame
			-- Set the position of the asset in the image frame
			for _, part in pairs(clonedAsset:GetDescendants()) do
				if part.Name == "Handle" then
					part.CFrame = CFrame.new(39.11, 0.794, 1.649)
					break
				end
			end
			-- Set the selected data text in the showcase frame
			showcaseFrame:FindFirstChild("Selected" .. dataPureName .. "Text").Text = clonedAsset.Name
			-- Change the data in the character
			changeData(dataPureName, data, showcaseFrame)
		end)
	end
end

-- This function is named "openGui" and takes in two parameters, "gui" and "showcaseFrame"
local function openGui(gui, showcaseFrame)
	
	-- The name of the "gui" parameter is assigned to a new variable called "dataName"
	local dataName = gui.Name

	-- The following lines of code check if the "dataName" is equal to either "Faces", "Shirts", or "Pants". 
	-- If it is, then the selectFrame and the 2DVisuals are made visible and the list2D function is called with the "dataName" and "showcaseFrame" parameters.
	if dataName == "Faces" or dataName == "Shirts" or dataName == "Pants" then
		selectFrame.Visible = true
		selectFrame:FindFirstChild("2DVisuals").Visible = true
		list2D(dataName, showcaseFrame)

		-- If the "dataName" is equal to either "Hats", "Hairs", or "Shoes", then the selectFrame and the 3DVisuals are made visible 
		-- and the list3D function is called with the "dataName" and "showcaseFrame" parameters.
	elseif dataName == "Hats" or dataName == "Hairs" or dataName == "Shoes" then
		selectFrame.Visible = true
		selectFrame:FindFirstChild("3DVisuals").Visible = true
		list3D(dataName, showcaseFrame)
	end
end

-- The purpose of the function is to open the appropriate menu when a button is clicked in the main menu.
-- If the button is related to 2D clothing items (Faces, Shirts, Pants), the 2D visual list is displayed.
-- If the button is related to 3D accessories (Hats, Hairs, Shoes), the 3D visual list is displayed.

-- // Initialize \\ --

-- Wait for 3 seconds
task.wait(3)

-- Invoke the remote function to get data
local data = remoteFunctionsFolder.GetData:InvokeServer()

-- Print the value of "NotUsed" in the "equippedClothing" table of the retrieved data
print(data["equippedClothing"]["NotUsed"])

-- If the "NotUsed" key in the "equippedClothing" table is true, execute the following code block
if data["equippedClothing"]["NotUsed"] then
	
	-- Try to set the ResetButtonCallback to false using pcall
	local success = pcall(function() 
		starterGui:SetCore("ResetButtonCallback", false) 
	end)

	-- Set the position of the player's character to the position of the teleport part
	player.Character.HumanoidRootPart.CFrame = teleportPart.CFrame

	-- Wait for 0.2 seconds
	task.wait(0.2)

	-- Enable the wardrobe GUI
	wardrobeGui.Enabled = true

	-- Loop through each frame in the assetPlacement folder
	for _, frame in pairs(assetPlacement:GetChildren()) do
		local button = frame:FindFirstChildOfClass("TextButton")

		-- When a button is clicked, execute the following code block
		button.MouseButton1Click:Connect(function()
			if not opened then
				-- Set opened to true and store the name of the currently opened button
				opened = true
				oldOpened = button.Name

				-- Change the button text and animate the selectFrame and camera
				button.Text = ">"
				tweenService:Create(selectFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0.948, 0, 0.771, 0)}):Play()
				tweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {CFrame = camera.CFrame * CFrame.new(3, 0, 0)}):Play()

				-- Call the openGui function and pass the button and frame as arguments
				openGui(button, frame)
			elseif oldOpened == button.Name then
				-- If the currently opened button is clicked again, set opened to false and animate the selectFrame and camera in reverse
				opened = false
				visual2D.Visible = false
				visual3D.Visible = false
				button.Text = "<"
				tweenService:Create(selectFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
				tweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {CFrame = camera.CFrame * CFrame.new(-3, 0, 0)}):Play()
			end
		end)
	end

	-- Destroy any accessories currently on the player's character
	for _, accessory in pairs(player.Character:GetChildren()) do
		if accessory:IsA("Accessory") then
			accessory:Destroy()
		end
	end

	-- Set up mouse events for rotating the camera
	connections["Down"] = mouse.Button1Down:Connect(function()
		mouseDown = true
		lastPosition = mouse.X
	end)

	connections["Up"] = mouse.Button1Up:Connect(function()
		mouseDown = false
	end)

	-- Set up the camera
	setupCamera()

	-- When the Apply button is clicked, execute the following code block
	connections["Apply"] = mainFrame.Apply.MouseButton1Click:Connect(function()
		camera.CameraType = Enum.CameraType.Custom

		remoteEventsFolder.SetClothingData:FireServer(equippedClothing)
		wardrobeGui.Enabled = false
		
		if cameraConnection then
			cameraConnection:Disconnect()
		end
		
		for _, connection in pairs(connections) do
			connection:Disconnect()
		end
		
		local success = pcall(function() 
			starterGui:SetCore("ResetButtonCallback", true) 
		end)
	end)
end
