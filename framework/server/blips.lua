RegisterNetEvent("cwgm:addCopBlip")
AddEventHandler("cwgm:addCopBlip", function(csign, dep)
    identifier = GetPlayerIdentifier(source, 0)
    pName = GetPlayerName(source)
    callsign = csign
    department = dep
    TriggerEvent("eblips:add", {
        name = pName .. " [" .. department .. "] | " .. callsign,
        src = source,
        color = 3
    })
    TriggerEvent("livemap:internal_UpdatePlayerData", identifier, "Info", "[" .. department .. "] " .. callsign)
end)

RegisterNetEvent("cwgm:addEMSBlip")
AddEventHandler("cwgm:addEMSBlip", function(csign)
    pName = GetPlayerName(source)
    callsign = csign
    TriggerEvent("eblips:add", {
        name = pName .. " | " .. callsign,
        src = source,
        color = 1
    })
    TriggerEvent("livemap:internal_UpdatePlayerData", identifier, "Info", "[EMS] " .. callsign)
end)

RegisterNetEvent("cwgm:removeBlip")
AddEventHandler("cwgm:removeBlip", function()
    TriggerEvent("eblips:remove", source)
    TriggerEvent("livemap:internal_UpdatePlayerData", identifier, "Info", "Civil")
end)