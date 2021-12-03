RegisterServerEvent("cg-radio:SetPlayerRadioSpeaker")
AddEventHandler("cg-radio:SetPlayerRadioSpeaker", function(status)
    local source = source
    exports["saltychat"]:SetPlayerRadioSpeaker(source, status)
end)

RegisterServerEvent("cg-radio:SetPlayerRadioChannel")
AddEventHandler("cg-radio:SetPlayerRadioChannel", function(channel, isPrimary)
    local source = source
    exports["saltychat"]:SetPlayerRadioChannel(source, channel, isPrimary)
    if isPrimary then
        print(GetPlayerName(source) .. "'s primary radio channel has been set to " .. channel)
    else
        print(GetPlayerName(source) .. "'s secondary radio channel has been set to " .. channel)
    end
end)

RegisterServerEvent("cg-radio:RemovePlayerRadioChannel")
AddEventHandler("cg-radio:RemovePlayerRadioChannel", function(channel)
    local source = source
    exports["saltychat"]:RemovePlayerRadioChannel(source, channel)
    print(GetPlayerName(source) .. " has disconnected from channel " .. channel)
end)