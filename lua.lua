-- This is a shift to run code made by Ice & Fire.

-- // Services \ --
-- Get the UserInputService from the game service
local userInputService = game:GetService("UserInputService")

-- // Object Variables \ --
-- Get the character and humanoid from the script's parent
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
-- Get the Animate script from the character
local animateScript = character:WaitForChild("Animate")

-- // Animation Tracks \ --
-- Load the run and walk animations from the script's child objects
local runAnimation = humanoid.Animator:LoadAnimation(script.RunAnimation)
local walkAnimation = humanoid.Animator:LoadAnimation(script.WalkAnimation)

-- // Private Functions \ --

-- Function to check if the LeftShift key is pressed
local function checkShiftInput()
return userInputService:IsKeyDown(Enum.KeyCode.LeftShift)
end

-- Function to handle when a key is pressed
local function inputBegan(key, gameProccessed)
-- Check if LeftShift key is pressed and the game is not processing the input
if checkShiftInput() and not gameProccessed then
-- Check if the run animation is not playing
if not runAnimation.IsPlaying then
-- Stop and destroy any currently playing animations
for _, animation in pairs(humanoid:GetPlayingAnimationTracks()) do
animation:Stop()
animation:Destroy()
end
        -- Play the run animation
        runAnimation:Play()

        -- Set the animation IDs for the run and walk animations
        animateScript.run.RunAnim.AnimationId = script.RunAnimation.AnimationId
        animateScript.walk.WalkAnim.AnimationId = "rbxassetid://0"

        -- Increase the humanoid's walk speed and print a message
        humanoid.WalkSpeed = 30
        print("Holding Shift!")
    end
end
end

-- Function to handle when a key is released
local function inputEnded(key, gameProccessed)
-- Check if the LeftShift key is released and the game is not processing the input
if key.KeyCode == Enum.KeyCode.LeftShift and not gameProccessed then
-- Set the animation IDs for the run and walk animations
animateScript.run.RunAnim.AnimationId = "rbxassetid://0"
animateScript.walk.WalkAnim.AnimationId = script.WalkAnimation.AnimationId

    -- Reset the humanoid's walk speed
    humanoid.WalkSpeed = 16

    -- Stop and destroy any currently playing animations and print a message
    for _, animation in pairs(humanoid:GetPlayingAnimationTracks()) do
        animation:Stop()
        animation:Destroy()
    end

    print("Shift ended!")
end
end

-- // Initialize \ --

-- Set the animation IDs for the run and walk animations
animateScript.run.RunAnim.AnimationId = "rbxassetid://0"
animateScript.walk.WalkAnim.AnimationId = script.WalkAnimation.AnimationId

-- Connect a function to the MoveDirection property of the humanoid
-- The function will stop the run animation when the MoveDirection is zero and the run animation is playing
humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
if humanoid.MoveDirection.X == 0 and humanoid.MoveDirection.Z == 0 and runAnimation.IsPlaying then
runAnimation:Stop()
end
end)

-- Connect the inputBegan and inputEnded functions to the UserInputService
userInputService.InputBegan:Connect(inputBegan)
userInputService.InputEnded:Connect(inputEnded)
