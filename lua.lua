wait(2)
-- Settings --


-- NPC Settings --

local WalkSpeed = 10  -- Walkspeed.
local Health = 100  -- Health.
local Damage = 1  -- Damage.
local DamageDelay = 1  -- Delay Between Each hit.
local DamageDistance = 1  -- Distance Between The Player To Damage.
local StopBetweenHit = true  -- If True, NPC Will Stop Moving Each Time It Hits To a Player.
local StopDistance = 1  -- Indicates How Close The NPC Gets To Stop.
local HitAnim = 12640023680  -- The Hit Animation ID.
local ViewDistance = 8  -- The ViewDistance Of The NPC. 1 To inf. Example: if 15, the NPC can see and chase people who are far away.
local WalkAroundRandomly = true  -- If True NPC Will Walk Around The Area Randomly.

local RespawnDelay = 20  -- The Delay On Respawning.

-- Abilities --

local ADelay = 30  -- Delay Between Each Ability Attack.
local Abilities = {
	
	ability1 = {
		work = true,  -- If False, This Ability Will Not Work.
		-- Default Settings --
		
		Damage = 100,  -- Damage.
		DamageDistance = 10,  -- Distance Between The Player To Damage. 1 to inf.
		AttackStartLenght = 2,  -- Indicates How Long Will Take Before The Attack Starts. Example: if 2, attack will start after 2 seconds while playing the start animation.
		AttackLenght = 2,  -- Indicates How Long An Attack Will Last. (Seconds.)
		AttackDelay = 5,  -- How Much Second Needed For The NPC To Make THIS Ability Attack Again.
		AttackEndLenght = 2, -- Indicates How Long Will Take In An Attack Ending. Example: if 2, attack will end after 2 seconds while playing the end animation.
		
			-- Animations --

		StartAttackAnimId = 12640023680, -- The Anim Will Be Played Before An Ability Attack.
		AttackAnimId = 12640023680,  -- The Anim Will Be Played On An Ability Attack.
		EndAttackAnimId = 12640023680,  -- The Anim Will Be Played After An Ability Attack.

			-- End --

		-- End --
		
	},
	ability2 = {
		work = false,
		Damage = 15,
		AttackStartLenght = 2,
		AttackLenght = 2,
		AttackDelay = 20,
		AttackEndLenght = 2,

		StartAttackAnimId = 313131,
		AttackAnimId = 313131,
		EndAttackAnimId = 31313,
		
	},
	ability3 = {
		work = false,
		Damage = 15,
		AttackStartLenght = 2,
		AttackLenght = 2,
		AttackDelay = 20,
		AttackEndLenght = 2,

		StartAttackAnimId = 313131,
		AttackAnimId = 313131,
		EndAttackAnimId = 31313,

	},
	ability4 = {
		work = false,
		Damage = 15,
		AttackStartLenght = 2,
		AttackLenght = 2,
		AttackDelay = 20,
		AttackEndLenght = 2,

		StartAttackAnimId = 313131,
		AttackAnimId = 313131,
		EndAttackAnimId = 31313,

	},
	ability5 = {
		work = false,
		Damage = 15,
		AttackStartLenght = 2,
		AttackLenght = 2,
		AttackDelay = 20,
		AttackEndLenght = 2,

		StartAttackAnimId = 313131,
		AttackAnimId = 313131,
		EndAttackAnimId = 31313,

	},


}

-- End --

-- End --


-- End --


-- Script --

local NPC = script.Parent
local Humanoid = NPC.Humanoid
local HumanoidRootPart = NPC.HumanoidRootPart
local Players = game:GetService("Players")
local dist = ViewDistance*8
local stopdist = StopDistance*8
local damagedist = DamageDistance*8
local plrhit = false
local pathfinding = game:GetService("PathfindingService")
local work = true
local outofrange = false
local hitting = false
local usingability = false

Humanoid.Health = Health
Humanoid.WalkSpeed = WalkSpeed

local HitAnimId = Instance.new("Animation")
HitAnimId.Parent = script.Parent
HitAnimId.AnimationId = "rbxassetid://"..HitAnim
local HitAnimTrack = Humanoid:LoadAnimation(HitAnimId)

local StringDelay = Instance.new("StringValue")
StringDelay.Parent = HumanoidRootPart
StringDelay.Value = RespawnDelay
StringDelay.Name = "RespawnDelay"


function nearplr()
	local check = nil
	for i,v in pairs(Players:GetPlayers()) do
		if v then
			local char = v.Character
			if char and char.check.Value == false then
				local plrhum = char:FindFirstChildWhichIsA("Humanoid")
				local plrhrp = char:FindFirstChild("HumanoidRootPart")
				if plrhum.Health > 0 and plrhrp then
					local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
					if newdist < dist and newdist > stopdist and Humanoid.Health > 0 then
						outofrange = false
						check = plrhrp
					else
						outofrange = true
					end
					if newdist < damagedist and not plrhit and Humanoid.Health > 0 then
						char.Humanoid:TakeDamage(Damage)
						plrhit = true
						HitAnimTrack:Play()
						wait(DamageDelay)
						plrhit = false
					end
				end
			end
		end
	end
	return check, outofrange
end

local c = coroutine.create(function()
	while wait() do
		if WalkAroundRandomly == true and outofrange == false and Humanoid.Health > 0 and usingability == false then
			local dly = math.random(3,15)
			wait(dly)
			local movepart = Instance.new("Part")
			movepart.Anchored = true
			movepart.Parent = HumanoidRootPart
			movepart.Transparency = 1
			movepart.CanCollide = false
			local X = math.random(-20,20)
			local Z = math.random(-20,20)
			movepart.CFrame = HumanoidRootPart.CFrame * CFrame.new(X ,0 ,Z)
			Humanoid:MoveTo(movepart.Position)
			Humanoid.MoveToFinished:Wait()
			movepart:Destroy()
		end
	end
end)
coroutine.resume(c)
local c = coroutine.create(function()
	if Abilities.ability1.work == true then
		local startanim1 = Instance.new("Animation")
		startanim1.Parent = HumanoidRootPart
		startanim1.AnimationId = "rbxassetid://"..Abilities.ability1.StartAttackAnimId
		local startanimtrack1 = Humanoid:LoadAnimation(startanim1)
		_G.startanimtrack1 = startanimtrack1
		local attackanim1 = Instance.new("Animation")
		attackanim1.Parent = HumanoidRootPart
		attackanim1.AnimationId = "rbxassetid://"..Abilities.ability1.AttackAnimId
		local attackanimtrack1 = Humanoid:LoadAnimation(attackanim1)
		_G.attackanimtrack1 = attackanimtrack1
		local endanim1 = Instance.new("Animation")
		endanim1.Parent = HumanoidRootPart
		endanim1.AnimationId = "rbxassetid://"..Abilities.ability1.EndAttackAnimId
		local endanimtrack1 = Humanoid:LoadAnimation(endanim1)
		_G.endanimtrack1 = endanimtrack1
		_G.ability1delay = false
	end
	if Abilities.ability2.work == true then
		local startanim2 = Instance.new("Animation")
		startanim2.Parent = HumanoidRootPart
		startanim2.AnimationId = "rbxassetid://"..Abilities.ability2.StartAttackAnimId
		local startanimtrack2 = Humanoid:LoadAnimation(startanim2)
		_G.startanimtrack2 = startanimtrack2
		local attackanim2 = Instance.new("Animation")
		attackanim2.Parent = HumanoidRootPart
		attackanim2.AnimationId = "rbxassetid://"..Abilities.ability2.AttackAnimId
		local attackanimtrack2 = Humanoid:LoadAnimation(attackanim2)
		_G.attackanimtrack2 = attackanimtrack2
		local endanim2 = Instance.new("Animation")
		endanim2.Parent = HumanoidRootPart
		endanim2.AnimationId = "rbxassetid://"..Abilities.ability2.EndAttackAnimId
		local endanimtrack2 = Humanoid:LoadAnimation(endanim2)
		_G.endanimtrack2 = endanimtrack2
		_G.ability2delay = false
	end
	if Abilities.ability3.work == true then
		local startanim3 = Instance.new("Animation")
		startanim3.Parent = HumanoidRootPart
		startanim3.AnimationId = "rbxassetid://"..Abilities.ability3.StartAttackAnimId
		local startanimtrack3 = Humanoid:LoadAnimation(startanim3)
		_G.startanimtrack3 = startanimtrack3
		local attackanim3 = Instance.new("Animation")
		attackanim3.Parent = HumanoidRootPart
		attackanim3.AnimationId = "rbxassetid://"..Abilities.ability3.AttackAnimId
		local attackanimtrack3 = Humanoid:LoadAnimation(attackanim3)
		_G.attackanimtrack3 = attackanimtrack3
		local endanim3 = Instance.new("Animation")
		endanim3.Parent = HumanoidRootPart
		endanim3.AnimationId = "rbxassetid://"..Abilities.ability3.EndAttackAnimId
		local endanimtrack3 = Humanoid:LoadAnimation(endanim3)
		_G.endanimtrack3 = endanimtrack3
		_G.ability3delay = false
	end
	if Abilities.ability4.work == true then
		local startanim4 = Instance.new("Animation")
		startanim4.Parent = HumanoidRootPart
		startanim4.AnimationId = "rbxassetid://"..Abilities.ability4.StartAttackAnimId
		local startanimtrack4 = Humanoid:LoadAnimation(startanim4)
		_G.startanimtrack4 = startanimtrack4
		local attackanim4 = Instance.new("Animation")
		attackanim4.Parent = HumanoidRootPart
		attackanim4.AnimationId = "rbxassetid://"..Abilities.ability4.AttackAnimId
		local attackanimtrack4 = Humanoid:LoadAnimation(attackanim4)
		_G.attackanimtrack4 = attackanimtrack4
		local endanim4 = Instance.new("Animation")
		endanim4.Parent = HumanoidRootPart
		endanim4.AnimationId = "rbxassetid://"..Abilities.ability4.EndAttackAnimId
		local endanimtrack4 = Humanoid:LoadAnimation(endanim4)
		_G.endanimtrack4 = endanimtrack4
		_G.ability4delay = false
	end
	if Abilities.ability5.work == true then
		local startanim5 = Instance.new("Animation")
		startanim5.Parent = HumanoidRootPart
		startanim5.AnimationId = "rbxassetid://"..Abilities.ability5.StartAttackAnimId
		local startanimtrack5 = Humanoid:LoadAnimation(startanim5)
		_G.startanimtrack5 = startanimtrack5
		local attackanim5 = Instance.new("Animation")
		attackanim5.Parent = HumanoidRootPart
		attackanim5.AnimationId = "rbxassetid://"..Abilities.ability5.AttackAnimId
		local attackanimtrack5 = Humanoid:LoadAnimation(attackanim5)
		_G.attackanimtrack5 = attackanimtrack5
		local endanim5 = Instance.new("Animation")
		endanim5.Parent = HumanoidRootPart
		endanim5.AnimationId = "rbxassetid://"..Abilities.ability5.EndAttackAnimId
		local endanimtrack5 = Humanoid:LoadAnimation(endanim5)
		_G.endanimtrack5 = endanimtrack5
		_G.ability5delay = false
	end
	_G.countAbj35 = 0
	for i,v in pairs(Abilities) do
		_G.countAbj35 = _G.countAbj35+1
	end
	while wait(ADelay) do
		local randomisko = math.random(0,_G.countAbj35)
		if randomisko == 1 then
			local a = coroutine.create(function()
				for i,v in pairs(Players:GetPlayers()) do
					if v then
						local ability = Abilities.ability1
						local char = v.Character
						if char and char.check.Value == false then
							local plrhum = char:FindFirstChildWhichIsA("Humanoid")
							local plrhrp = char:FindFirstChild("HumanoidRootPart")
							if plrhum.Health > 0 and Humanoid.Health > 0 then
								local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
								if newdist < Abilities.ability1.DamageDistance*8 then
									usingability = true
									Humanoid.WalkSpeed = 0
									_G.startanimtrack1:Play()
									wait(Abilities.ability1.AttackStartLenght)
									_G.attackanimtrack1:Play()
									for i = 0,4 do
										if newdist < ability.DamageDistance*8 and char.check.Value == false and Humanoid.Health > 0 then
											char.Humanoid:TakeDamage(ability.Damage/4)
											wait(ability.AttackLenght/4)
										end
									end
									_G.endanimtrack1:Play()
									wait(Abilities.ability1.AttackEndLenght)
									Humanoid.WalkSpeed = WalkSpeed
								end
							end
						end
					end
				end
				usingability = false
			end)
			coroutine.resume(a)
		elseif randomisko == 2 then
			local ability = Abilities.ability2
			local a = coroutine.create(function()
			for i,v in pairs(Players:GetPlayers()) do
				if v then
					local char = v.Character
					if char and char.check.Value == false then
						local plrhum = char:FindFirstChildWhichIsA("Humanoid")
						local plrhrp = char:FindFirstChild("HumanoidRootPart")
							if plrhum.Health > 0 and Humanoid.Health > 0 then
							local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
								if newdist < ability.DamageDistance*8 and not plrhit then
								usingability = true
								Humanoid.WalkSpeed = 0
								_G.startanimtrack2:Play()
								wait(ability.AttackStartLenght)
								_G.attackanimtrack2:Play()
								for i = 0,4 do
										if newdist < ability.DamageDistance*8 and char.check.Value == false and Humanoid.Health > 0 then
											char.Humanoid:TakeDamage(ability.Damage/4)
											wait(ability.AttackLenght/4)
										end
								end
								_G.endanimtrack2:Play()
								wait(ability.AttackEndLenght)
								Humanoid.WalkSpeed = WalkSpeed
							end
						end
					end
				end
			end
			usingability = false
			end)
			coroutine.resume(a)
		elseif randomisko == 3 then
			local ability = Abilities.ability3
			local a = coroutine.create(function()
			for i,v in pairs(Players:GetPlayers()) do
				if v then
					local char = v.Character
						if char and char.check.Value == false and Humanoid.Health > 0 then
						local plrhum = char:FindFirstChildWhichIsA("Humanoid")
						local plrhrp = char:FindFirstChild("HumanoidRootPart")
						if plrhum.Health > 0 then
							local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
								if newdist < ability.DamageDistance*8 and not plrhit then
								usingability = true
								Humanoid.WalkSpeed = 0
								_G.startanimtrack3:Play()
								wait(ability.AttackStartLenght)
								_G.attackanimtrack3:Play()
								for i = 0,4 do
										if newdist < ability.DamageDistance*8 and char.check.Value == false and Humanoid.Health > 0 then
											char.Humanoid:TakeDamage(ability.Damage/4)
											wait(ability.AttackLenght/4)
										end
								end
								_G.endanimtrack3:Play()
								wait(ability.AttackEndLenght)
								Humanoid.WalkSpeed = WalkSpeed	
							end
						end
					end
				end
			end
			usingability = false
			end)
			coroutine.resume(a)
		elseif randomisko == 4 then
			local ability = Abilities.ability4
			local a = coroutine.create(function()
			for i,v in pairs(Players:GetPlayers()) do
				if v then
					local char = v.Character
					if char and char.check.Value == false then
						local plrhum = char:FindFirstChildWhichIsA("Humanoid")
						local plrhrp = char:FindFirstChild("HumanoidRootPart")
							if plrhum.Health > 0 and Humanoid.Health > 0 then
							local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
								if newdist < ability.DamageDistance*8 and not plrhit then
									usingability = true
									Humanoid.WalkSpeed = 0
									_G.startanimtrack4:Play()
									wait(ability.AttackStartLenght)
									_G.attackanimtrack4:Play()
									for i = 0,4 do
										if newdist < ability.DamageDistance*8 and char.check.Value == false and Humanoid.Health > 0 then
											char.Humanoid:TakeDamage(ability.Damage/4)
											wait(ability.AttackLenght/4)
										end
									end
									_G.endanimtrack4:Play()
									wait(ability.AttackEndLenght)
									Humanoid.WalkSpeed = WalkSpeed
							end
						end
					end
				end
			end
			usingability = false
			end)
			coroutine.resume(a)
		elseif randomisko == 5 then
			local ability = Abilities.ability5
			local a = coroutine.create(function()
				for i,v in pairs(Players:GetPlayers()) do
					if v then
						local char = v.Character
						if char and char.check.Value == false then
							local plrhum = char:FindFirstChildWhichIsA("Humanoid")
							local plrhrp = char:FindFirstChild("HumanoidRootPart")
							if plrhum.Health > 0 and Humanoid.Health > 0 then
								local newdist = (plrhrp.Position - HumanoidRootPart.Position).Magnitude
								if newdist < ability.DamageDistance*8 and not plrhit then
									usingability = true
									Humanoid.WalkSpeed = 0
									_G.startanimtrack5:Play()
									wait(ability.AttackStartLenght)
									_G.attackanimtrack5:Play()
									for i = 0,4 do
										if newdist < ability.DamageDistance*8 and char.check.Value == false and Humanoid.Health > 0 then
											char.Humanoid:TakeDamage(ability.Damage/4)
											wait(ability.AttackLenght/4)
										end
									end
									_G.endanimtrack5:Play()
									wait(ability.AttackEndLenght)
									Humanoid.WalkSpeed = WalkSpeed
								end
							end
						end
					end
				end
				usingability = true
			end)
			coroutine.resume(a)
		end
	end
end)
coroutine.resume(c)

game.Workspace.SafeAreaBox.Touched:Connect(function(hit)
	if hit.Name == "Head" then
		if hit.Parent:FindFirstChild("AI") and Humanoid.Health > 0 then
			print("Touch!")
			local movepart = Instance.new("Part")
			movepart.Anchored = true
			movepart.Parent = HumanoidRootPart
			movepart.Transparency = 1
			movepart.CanCollide = false
			local Z = math.random(100,300)
			movepart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0 ,0 ,Z)
			Humanoid:MoveTo(movepart.Position)
			Humanoid.MoveToFinished:Wait()
			movepart:Destroy()
		end
	end
end)

game["Run Service"].Stepped:Connect(function()
	local plrdetected = nearplr()
	if plrdetected and plrhit == false and Humanoid.Health > 0 then
		local function thing()
			local pathChanged = false
			local bindConnection
			local path = pathfinding:CreatePath()
			path:ComputeAsync(HumanoidRootPart.Position, plrdetected.Position)
			local waypoints = path:GetWaypoints()
			
			bindConnection = plrdetected:GetPropertyChangedSignal("Position"):Connect(function()
				bindConnection:Disconnect()
				pathChanged = true
				thing()
			end)
			
			for i, waypoint in pairs(waypoints) do
				if i > 3 and outofrange == false and usingability == false then
					Humanoid:MoveTo(waypoint.Position)
					Humanoid.MoveToFinished:Wait()
					if pathChanged or outofrange or plrhit and StopBetweenHit then
						break
					end
				end
			end
		end

		if plrdetected and not plrhit and not outofrange then
			thing()
		end
	end
end)

-- End --
