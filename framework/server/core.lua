--[[
    TITLE: HIDE COMMANDS
    DESCRIPTION: Hide misspelled commands/non-existing commands
]]
AddEventHandler("chatMessage", function(source, name, msg)
    args = stringsplit(msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
	else
		TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, msg)
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr,  "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterNetEvent("cwgm:disconnectRadioPolice")
AddEventHandler("cwgm:disconnectRadioPolice", function()
    exports.saltychat:RemovePlayerRadioChannel(source, "police")
end)

AddEventHandler("playerConnecting", function()
    identifier = GetPlayerIdentifier(source, 0)
    TriggerEvent("livemap:internal_UpdatePlayerData", identifier, "Info", "Civil")
end)