local QBCore = exports['qb-core']:GetCoreObject()
local collectmoney = false
local robbedLocations = {}
local safelocations = {}
CreateThread(function()
    for k, _ in pairs(Config.Safes) do
        exports['qb-target']:AddCircleZone(Config.Safes[k], vector3(Config.Safes[k][1].xyz), 1.0, {
            name = Config.Safes[k],
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = "core-storerobbery:client:safes",
                    icon = "fas fa-lock",
                    label = "Break Open Safe",
                },
                {
                    type = "client",
                    event = "core-storerobbery:client:collectsafe",
                    icon = "fas fa-lock",
                    label = "Grab Goods",
                },
            },
            distance = 0.85
        })
    end
end)

RegisterNetEvent('core-storerobbery:client:collectsafe', function()
    if collectmoney then
        TriggerServerEvent('core-storerobbery:server:saferreward')
        collectmoney = false
    else
        QBCore.Functions.Notify('did u rob  it  first', 'error', 7500)
    end
end)
RegisterNetEvent('core-storerobbery:client:startrob', function()
    local playerPed1 = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed1)
    local advanced = QBCore.Functions.HasItem('advancedlockpick')
    local lockpick = QBCore.Functions.HasItem('lockpick')
    local playerPed = PlayerPedId()
    -- Check if the current location has already been robbed
    for _, robbedLocation in ipairs(robbedLocations) do
        if #(playerCoords - robbedLocation) < 1.85 then
            QBCore.Functions.Notify('You cannot rob this register again', 'error', 7500)
            return
        end
    end
    QBCore.Functions.TriggerCallback('core-storerobbery:server:getCops', function(CoreCops)
        if CoreCops >= Config.cops then
            if advanced then
                if math.random(1, 10) == 10 then
                    TriggerServerEvent('core-storerobbery:server:removeadva')
                end
                local seconds = math.random(8, 12)
                local circles = math.random(4, 5)
                local success1 = exports['qb-lock']:StartLockPickCircle(circles, seconds, success1)
                if success1 then
                    QBCore.Functions.Progressbar('name', 'Emptying the register..', 3000, false, true,
                        {
                            -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "veh@break_in@0h@p_m_one@",
                            anim = "low_force_entry_ds",
                            flags = 16,
                        }, {}, {}, function() -- Play When Done
                            exports['qb-dispatch']:StoreRobbery(camId)
                            table.insert(robbedLocations, playerCoords)
                            ClearPedTasks(playerPed)
                            TriggerServerEvent('core-storerobbery:server:registerreward')
                        end, function() -- Play When Cancel
                            ClearPedTasks(playerPed)
                        end)
                end
            elseif lockpick then
                if math.random(1, 10) == 10 then
                    TriggerServerEvent('core-storerobbery:server:removelock')
                end
                QBCore.Functions.Notify('because youre using a weak equipement the robbery will be hard  for you',
                    'primary',
                    7500)
                local seconds = math.random(2, 5)
                local circles = math.random(7, 10)
                local success = exports['qb-lock']:StartLockPickCircle(circles, seconds, success)
                if success then
                    QBCore.Functions.Progressbar('name', 'Emptying the register..', 60000, false, true,
                        {
                            -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "veh@break_in@0h@p_m_one@",
                            anim = "low_force_entry_ds",
                            flags = 16,
                        }, {}, {}, function() -- Play When Done
                            exports['qb-dispatch']:StoreRobbery(camId)
                            table.insert(robbedLocations, playerCoords)

                            ClearPedTasks(playerPed)
                            TriggerServerEvent('core-storerobbery:server:registerreward')
                        end, function() -- Play When Cancel
                            ClearPedTasks(playerPed)
                        end)
                end
            else
                QBCore.Functions.Notify('Youre missing something', 'error', 7500)
            end
            Citizen.SetTimeout(600000, function()
                robbedLocations = {}
            end)
        else
            QBCore.Functions.Notify("Not Enough Police (" .. Config.cops .. " Required)", 'error', 7500)
        end
    end)
end)
RegisterNetEvent('core-storerobbery:client:safes', function()
    local hasitem = QBCore.Functions.HasItem('safecracker')
    local playerPed1 = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed1)
    for _, safelocation in ipairs(safelocations) do
        if #(playerCoords - safelocation) < 1.85 then
            QBCore.Functions.Notify('this safe is already robbed', 'error', 7500)
            return
        end
    end
    if hasitem then
        exports["memorygame_2"]:thermiteminigame(10, 3, 3, 10,
            function() -- success
                TriggerServerEvent('core-storerobbery:server:removesafecracker')
                QBCore.Functions.Notify('Give it some  Time', 'success', 7500)
                Wait(10000)
                QBCore.Functions.Notify('you can now collect it', 'success', 7500)
                collectmoney = true
                table.insert(safelocations, playerCoords)
            end,
            function() -- failure
                QBCore.Functions.Notify('You failed try again', 'error', 7500)
            end)
    else
        QBCore.Functions.Notify('youre missing something', 'error', 7500)
    end
    Citizen.SetTimeout(600000, function()
        safelocations = {}
    end)
end)
store = {
    `prop_till_01`,
    -- "prop_till_01_dam"
}

exports['qb-target']:AddTargetModel(store, {
    options = {
        {
            type = "client",
            event = "core-storerobbery:client:startrob",
            icon = "fas fa-dollar-sign",
            label = "Collect Money",
            job = "all"
        },

    },
    distance = 0.85,
})
