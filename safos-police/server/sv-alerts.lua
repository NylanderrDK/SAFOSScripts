-- Event that is triggered when all cops needs to be alerted
RegisterServerEvent("safos-police:AlertCops")
AddEventHandler("safos-police:AlertCops", function(x, y, text)
    TriggerClientEvent("safos-police:AlertCops", -1, x, y, text)
end)

-- Event that is triggered when all clients needs to be alerted by the police
RegisterServerEvent("safos-police:AlertAll")
AddEventHandler("safos-police:AlertAll", function(text)
    TriggerClientEvent("safos-police:AlertAll", -1, text)
end)