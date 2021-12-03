RegisterServerEvent("sf:startCall")
AddEventHandler("sf:startCall", function(partner)
    exports.saltychat:EstablishCall(source, partner)
    print(GetPlayerName(source) .. " established a call with " .. GetPlayerName(partner))
end)

RegisterServerEvent("sf:endCall")
AddEventHandler("sf:endCall", function(partner)
    exports.saltychat:EndCall(source, partner)
    print(GetPlayerName(source) .. " ended a call with " .. GetPlayerName(partner))
end)

--[[RegisterServerEvent("sf:NotifySpecificPlayer")
AddEventHandler("sf:NotifySpecificPlayer", function(clientNetId, text)
    TriggerClientEvent("pNotify:SendNotification", clientNetId, {
        type = "info",
        text = GetPlayerName(source) .. " vil gerne ringe til dig.<br>Skriv <code>/besvar</code> for at tage opkaldet.<br>Skriv <code>/lægpå</code> for at afvise opkaldet.",
        timeout = 15000
    })
end)--]]