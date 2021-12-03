-- Function to enable the radio
function EnableRadio(enable)
    SetNuiFocus(true, true)
    radioMenu = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

-- Command to open the radio
RegisterCommand("radio", function()
    EnableRadio(true)
end, false)

-- Set the players current channel
RegisterNUICallback("joinRadio", function(data, cb)
    local currentChannel = exports.saltychat:GetRadioChannel(true)

    if tonumber(data.channel) ~= tonumber(currentChannel) then
        TriggerServerEvent("sf:ConnectToRadio", data.channel)
        exports.pNotify:SendNotification({
            type = "success",
            text = "Du er tilsluttet frekvens " .. data.channel .. ".00 MHz!",
            timeout = 7500
        })
    else
        exports.pNotify:SendNotification({
            type = "error",
            text = "Du er allerede tilsluttet frekvens " .. data.channel .. ".00 MHz!",
            timeout = 5000
        })
    end

    cb("ok")
end)

-- Leave the current channel
RegisterNUICallback("leaveRadio", function(data, cb)
    local currentChannel = exports.saltychat:GetRadioChannel(true)

    if currentChannel == nil then
        exports.pNotify:SendNotification({
            type = "error",
            text = "Du er ikke tilsluttet nogen frekvens!",
            timeout = 5000
        })
    else
        TriggerServerEvent("sf:DisconnectRadio", currentChannel)
        exports.pNotify:SendNotification({
            type = "success",
            text = "Du har afbrudt forbindelsen til frekvens " .. currentChannel .. ".00 MHz!",
            timeout = 7500
        })
    end

    cb("ok")
end)

-- Close UI when Escape is pressed
RegisterNUICallback("close", function(data, cb)
    EnableRadio(false)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Disable controls while UI is opened
Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, true) -- Look Left Right
            DisableControlAction(0, 2, true) -- Look Up Down
            DisableControlAction(0, 142, true) -- Melee Attack Alternate
            DisableControlAction(0, 106, true) -- Vehicle Mouse Control Override

            if IsDisabledControlJustReleased(0, 142) then -- Melee Attack Alternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)