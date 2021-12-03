--[[
    TITLE: COMMANDS
    DESCRIPTION: Several commands that needs to be executed on the serverside
]]
RegisterCommand("ooc", function(source, args)
    local message = table.concat(args, " ")
    TriggerClientEvent("chatMessage", -1, "^6[OOC] | " .. GetPlayerName(source) .. "^0", {255, 255, 255}, message)
end)

RegisterCommand("me", function(source, args)
    local text = "*" .. table.concat(args, " ") .. "*"
    TriggerClientEvent("3dme:shareDisplay", -1, text, source)
end)

RegisterCommand("do", function(source, args)
    local message = table.concat(args, " ")
    TriggerClientEvent("chatMessage", -1, "^3[Do] | " .. GetPlayerName(source) .. "^0", {255, 255, 255}, message)
end)

RegisterCommand("twt", function(source, args)
    local message = table.concat(args, " ")
    TriggerClientEvent("chatMessage", -1, "^5[Twitter] | @" .. GetPlayerName(source) .. "^0", {255, 255, 255}, message)
end)

RegisterCommand("911", function(source, args)
    local message = table.concat(args, " ")
    TriggerClientEvent("chatMessage", -1, "^8[911] | " .. GetPlayerName(source) .. "^0", {255, 255, 255}, message)
end)

RegisterCommand("k", function()
	TriggerClientEvent("cwgm:kneel", source)
end)

RegisterCommand("hu", function()
	TriggerClientEvent("cwgm:handsup", source)
end)