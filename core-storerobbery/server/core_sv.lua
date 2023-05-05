local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback('core-storerobbery:server:getCops', function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

RegisterNetEvent('core-storerobbery:server:registerreward', function()
    local src = source
    local amount = math.random(100, 200)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', amount)
    if math.random(1, 100) < 10 then
        Player.Functions.AddItem("safecraker", 1)
    end
end)
RegisterNetEvent('core-storerobbery:server:saferreward', function()
    local src = source
    local amount = math.random(500, 700)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', amount)
    if math.random(1, 100) < 10 then
        Player.Functions.AddItem("housecard", 1)
    end
end)
RegisterNetEvent('core-storerobbery:server:removelock', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem("lockpick", 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['lockpick'], "remove")
end)
RegisterNetEvent('core-storerobbery:server:removeadva', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem("advancedlockpick", 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['advancedlockpick'], "remove")
end)
RegisterNetEvent('core-storerobbery:server:removesafecracker', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem("safecracker", 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['safecracker'], "remove")
end)
