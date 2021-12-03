RegisterServerEvent("sf:setRadio")
AddEventHandler("sf:setRadio", function(name)
    exports.saltychat:SetPlayerRadioChannel(source, name, false)
    print("Set " .. GetPlayerName(source) .. "'s radio to: " .. name)
end)

RegisterServerEvent("sf:removeRadio")
AddEventHandler("sf:removeRadio", function(name)
    exports.saltychat:RemovePlayerRadioChannel(source, name)
    print("Removed " .. GetPlayerName(source) .. " from radio: " .. name)
end)

RegisterServerEvent("Drag")
AddEventHandler("Drag", function(Target)
	local Source = source
	TriggerClientEvent("Drag", Target, Source)
end)