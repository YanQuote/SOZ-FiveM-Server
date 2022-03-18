local VehicleNitrous = {}

QBCore.Functions.CreateCallback("nos:GetNosLoadedVehs", function(source, cb)
    cb(VehicleNitrous)
end)

QBCore.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    local src = source
    TriggerClientEvent("hud:client:DrawNotification", src, "ID: " .. src)
end)

RegisterNetEvent("qb-carwash:server:washCar", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney("money", Config.DefaultPrice, "car-washed") then
        TriggerClientEvent("qb-carwash:client:washCar", src)
    else
        TriggerClientEvent("hud:client:DrawNotification", src, "~r~You dont have enough money..")
    end
end)

QBCore.Functions.CreateCallback("smallresources:server:GetCurrentPlayers", function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

AddEventHandler("chatMessage", function(playerId, playerName, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
        CancelEvent()
    end
end)
