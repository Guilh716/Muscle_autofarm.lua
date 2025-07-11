-- Muscle Legends AutoFarm Script (Delta Executor Compatible)
-- Versão segura e testada para uso com botão/menu externo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local muscleRemote = ReplicatedStorage:WaitForChild("GainMuscle")

local CONFIG = {
    TRAIN_DELAY = 0.1,
    ORB_RADIUS = 150,
    ORB_TAG = "Orb"
}

local runningTrain = false
local runningOrbs = false
local orbConn

-- Auto Train
local function startTraining()
    runningTrain = true
    task.spawn(function()
        while runningTrain do
            pcall(function()
                muscleRemote:FireServer()
            end)
            task.wait(CONFIG.TRAIN_DELAY)
        end
    end)
end

local function stopTraining()
    runningTrain = false
end

-- Auto Orbs
local function startCollecting()
    if runningOrbs then return end
    runningOrbs = true
    orbConn = RunService.Heartbeat:Connect(function()
        for _, orb in ipairs(CollectionService:GetTagged(CONFIG.ORB_TAG)) do
            if orb:IsA("BasePart") and (orb.Position - hrp.Position).Magnitude <= CONFIG.ORB_RADIUS then
                hrp.CFrame = orb.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.05)
            end
        end
    end)
end

local function stopCollecting()
    runningOrbs = false
    if orbConn then orbConn:Disconnect() end
end

-- Ativar automaticamente
startTraining()
startCollecting()
