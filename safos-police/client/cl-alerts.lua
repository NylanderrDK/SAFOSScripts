-- Just for development purposes!!!
--RegisterCommand("testalert", function()
    --local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    --TriggerServerEvent("safos-police:AlertCops", x, y, "Dette er en test!")
--end, false)

-- Event that is triggered when the cops needs to be alerted
RegisterNetEvent("safos-police:AlertCops")
AddEventHandler("safos-police:AlertCops", function(x, y, text)
    if exports["safos-framework"]:CheckCop() then
        ClFunction.PictureNotification("CHAR_CALL911", "Dispatch", "SACD", text)
        SetNewWaypoint(x, y)
    end
end)

-- Event that is triggered when the cops needs to be alerted
RegisterNetEvent("safos-police:AlertAll")
AddEventHandler("safos-police:AlertALl", function(text)
    ClFunction.CustomPictureNotification("SAST", "Information", "SAST", text)
end)