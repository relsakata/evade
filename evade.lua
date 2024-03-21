local library

local players = game.Players;
local plr = players.LocalPlayer;
local char = plr.Character

local Action = "Hide"

local Threads = {}
getgenv().Threads = function ()
    return Threads
end

local Platform = Instance.new("Part", workspace)
Platform.Name = "Platform"
Platform.Anchored = true
Platform.Transparency = 1
Platform.Size = Vector3.new(100, 5, 100)

plr.CharacterAdded:Connect(function(new)
    char = new
    char:WaitForChild("Humanoid").Died:Connect(function()
        for i,v in Threads do
            --v:Cancel()
        end
    end)
end)

getgenv().sakata_evade = {
    AutoHide = true;
    AutoRevive = true;
    AutoClover = true;
    AutoRespawn = true;
}

local script_flag = {
    NextBotNear = false;
    Hiding=false;
}

local GetDownedPlr = function()
    for i,v in pairs(workspace.Game.Players:GetChildren()) do
        if v:GetAttribute("Downed") then
            return v
        end
    end
end

Threads[#Threads+1] = task.spawn(function()
    while task.wait() do
        if getgenv().sakata_evade.AutoRespawn and (char and char:GetAttribute("Downed") or not char) then
            game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
       end
        Platform.CFrame = CFrame.new(char.HumanoidRootPart.CFrame * CFrame.new(0, -2.6, 0))
        if Action == "Hide" and not script_flag.Hiding then
            char:PivotTo(char.CFrame+CFrame.new(0,200,0)) -- Hide
            script_flag.Hiding=true
        end
        local DownedPlr = GetDownedPlr()
        if DownedPlr and getgenv().sakata_evade.AutoRevive then
            script_flag.Hiding = false
            Action = "Reviving"
            workspace.Game.Settings:SetAttribute("ReviveTime", 0.1)
            char:PivotTo(DownedPlr.HumanoidRootPart.CFrame+CFrame.new(0,-5,0))
            game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(DownedPlr.Name, true)
            Action = "Hide"
        end
        if getgenv().sakata_evade.AutoClover then
            -- collect clovers
            for i,v in pairs(game:GetService("Workspace").Game.Effects.Tickets:GetChildren()) do
                char:PivotTo(CFrame.new(v:WaitForChild('HumanoidRootPart').Position))
                task.wait(.2)
            end
        end
    end
end)
