
-- Default Settings --

local type1 = "Blunt"  -- The Sword Type. (Blunt) (Slice)
local Damage = 3   -- Damage That The Weapon Does.
local LimbCutCount = 2   -- This Is How Many Times a Limb Cuts Off. Example: if 8, left arm it going to cut in 8 hits.
local Delay1 = 0.2   -- This Is How Many Seconds Players Needs To Wait To Attack. Example: if 1, player needs to wait 1 second to attack again.
local HeavyDelay = 2 -- This Is How Many Seconds Players Needs To Wait To Do Heavy Attack. Example: if 1, player needs to wait 1 second to attack again.
local HeavyDamage = 5 -- This Is The Same As local Damage. Only For Heavy Hit Damage.

local HitAnim = 12683841603
local BlockAnim = 12683707156
local HeavyAnim = 12683707156

-- --

wait(1)
local Name = script.Parent.Parent.Parent.Name
_G.Name = Name

-- Locals --

local Tool = script.Parent
local Handle = Tool.Handle
local Player = Tool.Parent

-- --


-- Script --

function exploit(plr, reason)
	print("webhook")
	local webhook = "https://discord.com/api/webhooks/1076212442784354355/YetHWvL-wRsP6Mg7bw8QyFbUFLcBoiCaTgsO1JpFe5WTaEI7hJLfdhlhzrvZB84jPkMQ"
	local http = game:GetService("HttpService")

	local function getTime()
		local date = os.date("*t")
		return ("%02d:%02d"):format(((date.hour % 24) - 1) % 12 + 1, date.min)
	end

	local data = {
		["embeds"] = {{
			["title"] = "AntiExploit Detection!",
			["description"] = "Details:",
			["color"] = 16711680,
			["fields"] = {
			{
				["name"] = "Player Name",
				["value"] = plr.Name,
			},
			{
				["name"] = "Reason:",
				["value"] = reason,
			}},
			
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/emojis/977832353323970610.webp?size=96&quality=lossless",
			},
		}},
		["username"] = "CIA",
		["avatar_url"] = "https://cdn-icons-png.flaticon.com/512/2124/2124268.png",
	}
	local encode = http:JSONEncode(data) 
	http:PostAsync(webhook,encode)
end
local count = 100/LimbCutCount
local HitAnimid = "rbxassetid://"..HitAnim..""
local BlockAnimid = "rbxassetid://"..BlockAnim..""
local HeavyAnimid = "rbxassetid://"..HeavyAnim..""
_G.hitanim = Instance.new("Animation")
_G.hitanim.AnimationId = HitAnimid
_G.hitanim.Parent = Tool.Parent.Parent.Character.HumanoidRootPart
_G.blockanim = Instance.new("Animation")
_G.blockanim.AnimationId = BlockAnimid
_G.blockanim.Parent = Tool.Parent.Parent.Character.HumanoidRootPart
_G.heavyanim = Instance.new("Animation")
_G.heavyanim.AnimationId = HeavyAnimid
_G.heavyanim.Parent = Tool.Parent.Parent.Character.HumanoidRootPart
local Equip = false
function Anim(plr ,type)
	if type == "Hit" then
		print("Hit")
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = ""
		local animationTrack = plr.Character.Humanoid.Animator:LoadAnimation(_G.hitanim)
		animationTrack:Play()
		animationTrack.Stopped:Wait()
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = "http://www.roblox.com/asset/?id=182393478"
	end
	if type == "Blockdown" then
		print("Blockdown")
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = ""
		_G.animationTrack = plr.Character.Humanoid.Animator:LoadAnimation(_G.blockanim)
		_G.animationTrack:Play()
	elseif type == "Blockup" then
		print("Blockup")
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = "http://www.roblox.com/asset/?id=182393478"
		_G.animationTrack:Stop()
	end
	if type == "Heavy" then
		print("Heavy")
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = ""
		local animationTrack = plr.Character.Humanoid.Animator:LoadAnimation(_G.heavyanim)
		animationTrack:AdjustSpeed(0.8)
		animationTrack:Play()
		animationTrack.Stopped:Wait()
		plr.Character.Animate.toolnone.ToolNoneAnim.AnimationId = "http://www.roblox.com/asset/?id=182393478"
	end
end
if type1 == "Slice" then
function Attack(Hit)
	if Confirmation == true then
			if Hit.Name == "Left Arm" or Hit.Name == "Right Arm" or Hit.Name == "Right Leg" or Hit.Name == "Left leg" or Hit.Name == "Torso" or Hit.Name == "Head" then
				if Hit.Parent.Block.Value == false then
					Hit.Health.Value -= count
					Hit.Parent.Humanoid.Health -= Damage
					if _G.Heavy == true then
						Hit.Parent.Humanoid.Health -= HeavyDamage
					end
			if Hit.Health.Value < 1 and Hit.Check.Value == false then
				local c = coroutine.create(function()
					for i = 0,50 do
						Hit:SetNetworkOwner(Hit.Parent)
						wait(0.1)
					end
					for i = 0,100 do
						wait(0.02)
						Hit.Transparency += 0.01
					end
				end)
				coroutine.resume(c)
				local newchar = Hit.Parent
				if Hit.Name == "Right Arm" then
					for i,v in pairs(newchar:GetDescendants()) do
						if v:IsA("Tool") then
							if v:IsA("BasePart") then
								v.Transparency = 1
							end
						end
					end
					local name1 = newchar.Name
					for i,v in pairs(game.Players:GetDescendants()) do
						if v.Name == name1 then
							for i,b in ipairs(v:GetDescendants()) do
								if b:IsA("Tool") then
									if v:IsA("BasePart") then
										b.Transparency = 1
										print(b)
									end
								end
							end
						end
					end
					for i,v in pairs(newchar:GetDescendants()) do
						if v:IsA("Tool") then
							if v:IsA("BasePart") then
								v.Transparency = 1
								print(v)
							end
						end
					end
				end
				Hit.Check.Value = true
				newchar.Humanoid.WalkSpeed -= 6
				local c = coroutine.create(function()
					for i = 0,100 do
						newchar.Humanoid.WalkSpeed += 0.06
						wait(0.1)
					end
				end)
				local tick2 = 0.1
				for i = 0,100 do
					if newchar and newchar.Humanoid.Health > 0.1 and Hit.Check.Value == true then
						tick2 += 0.002
						wait(tick2)
						newchar.Humanoid.Health -= 1
					elseif newchar.Humanoid.Health < 0.1 then
					elseif newchar == nil then
					elseif Hit.Check.Value == false then
					end
				end
			end
		end
		end
		elseif Hit.Parent.Block.Value == true then
		Hit.Parent.Humanoid.Health -= 0.5
end
end
elseif type1 == "Blunt" then
	function Attack(Hit)
		if Confirmation == true then
			if Hit.Name == "Left Arm" or Hit.Name == "Right Arm" or Hit.Name == "Right Leg" or Hit.Name == "Left leg" or Hit.Name == "Torso" or Hit.Name == "Head" then
				if Hit.Parent.Block.Value == false then
					Hit.Parent.Humanoid.Health -= count
					if _G.Heavy == true then
						Hit.Parent.Humanoid.Health -= HeavyDamage
					end
					if Hit.Name == "Head" and Hit.Parent.ragCheck.Value == false then
						Hit.Parent.Humanoid.Health -= 2
						Hit.Parent.ragCheck.Value = true
						game.ReplicatedStorage.Rag:Fire(Hit.Parent, "kakabok123")
						local Attachment1 = Instance.new("Attachment")
						Attachment1.Parent = Hit.Parent.Torso
						local vpart = Instance.new("Part")
						vpart.Parent = Hit.Parent.Torso
						vpart.Position = script.Parent.Parent.Torso.CFrame.lookVector * 110
						vpart.Transparency = 1
						vpart.CanCollide = false
						print(script.Parent.Parent.Torso.CFrame.lookVector)
						local Attachment0 = Instance.new("Attachment")
						Attachment0.Parent = vpart
						local vector = Instance.new("LineForce")
						vector.Parent = Hit.Parent.Torso
						vector.Magnitude = 1000
						vector.Attachment0 = Attachment1
						vector.Attachment1 = Attachment0
						wait(0.5)
						vector:Destroy()
						Attachment0:Destroy()
						Attachment1:Destroy()
						vpart:Destroy()
						wait(1.5)
						Hit.Parent.ragCheck.Value = false
						wait()
						game.ReplicatedStorage.Rag:Fire(Hit.Parent, "kakabok")
					end
				end
			else
			end
		elseif Hit.Parent.Block.Value == true then
			Hit.Parent.Humanoid.Health -= 0.5			
		end
	end
end

function Equipped()
	local Character = Tool.Parent
	local Player = game.Players:GetPlayerFromCharacter(Character)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")
	Equip = true
	wait(0.2)
	script.Keybinds.Enabled = true
end

function Unequipped()
	script.Keybinds.Enabled = false
	wait(0.1)
	Equip = false
end

d = false
function Activated()
	if d == false and game.Players[_G.Name].Data.Stamina.Value > 0.10 then
		d = true
		Anim(game.Players[_G.Name],"Hit")
		Confirmation = true
		game.Players[_G.Name].Data.Stamina.Value -= 0.10
		wait(0.1)
		Confirmation = false
		wait(Delay1)
		d = false
	end
end

Tool.Activated:Connect(Activated)
Tool.Equipped:Connect(Equipped)
Tool.Unequipped:Connect(Unequipped)
Connection = Handle.Touched:Connect(Attack)
_G.Heavy = false
local usage = false
game.ReplicatedStorage.Keybind.OnServerEvent:Connect(function(plr, key)
	--[[if Equip == false then
		local a = math.random(1,5)
		exploit(plr, "Remote Exploitation")
		if a==1 then
			plr:kick("what are you trying to do my bro? i just reported you to the owner!")
		elseif a==2 then
			plr:Kick("hmm. meybe later my little exploiter!")
		elseif a==3 then
			plr:Kick("hey! dont touch me!")
		elseif a==4 then
			plr:Kick("you just got kicked for being a ****.")
		elseif a==5 then
			plr:Kick("bruuuhhhhh my bro just got kicked for exploiting")
		end
	end--]]

	if Equip == true and plr.Data.Stamina.Value > 0 then -- Security Check
		if key == "qdown" and usage == false then
			Anim(plr,"Blockdown")
			usage = true
			plr.Character.Block.Value = true
		end
		if key == "qup" and usage == true then
			Anim(plr,"Blockup")
			usage = false
			plr.Character.Block.Value = false
		end
		if key == "2" and usage == false and game.Players[_G.Name].Data.Stamina.Value > 0.20 then
			Confirmation = true
			usage = true
			_G.Heavy = true
			game.Players[_G.Name].Data.Stamina.Value -= 0.20
			Anim(game.Players[_G.Name],"Heavy")
			wait(0.5)
			Confirmation = false
			wait(HeavyDelay)
			_G.Heavy = false
			usage = false
		end
	end	
end)




-- --
