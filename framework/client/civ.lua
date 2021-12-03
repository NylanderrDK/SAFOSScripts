--[[
    TITLE: Toggle civ duty
    DESCRIPTION: Toggle civ duty
]]
local civOnDuty = false

RegisterNetEvent("cwgm:toggleCiv")
AddEventHandler("cwgm:toggleCiv", function()
    civOnDuty = not civOnDuty
    
    if civOnDuty then
        dutyTxt = "aktiv som civil"
    else
        dutyTxt = "ikke aktiv som civil"
    end
    exports.pNotify:SendNotification({
        text = "Du er nu " .. dutyTxt .. "!",
        type = "success",
        timeout = 3500,
        layout = "topRight"
    })
end)

--[[
    TITLE: Kneel
    DESCRIPTION: Kneel when command is executed
]]
local kneeling = false
local ped = GetPlayerPed(-1)

RegisterNetEvent("cwgm:kneel")
AddEventHandler("cwgm:kneel", function()
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        LoadAnimDict("random@arrests")
        LoadAnimDict("random@arrests@busted")
        if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
            isKneeling = false
            ClearPedTasksImmediately(ped)
            ClearPedTasks(ped)
            ClearPedSecondaryTask(ped)
            TaskPlayAnim(ped, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(3000)
            TaskPlayAnim(ped, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
            blockControls = false
        else
            blockControls = true
            isKneeling = true
            TaskPlayAnim(ped, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            SetPedDropsWeapon(ped)
            if isKneeling == false then
                return
            end
            Wait(5000)
            TaskPlayAnim(ped, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            if isKneeling == false then
                return
            end
            Wait(1000)
            TaskPlayAnim(ped, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
        end
    end
end)

--[[
    TITLE: Handsup
    DESCRIPTION: Handsup when command is executed
]]
local handsup = false
local ped = GetPlayerPed(-1)

RegisterNetEvent("sf:handsup")
AddEventHandler("sf:handsup", function()
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        LoadAnimDict("random@mugging3")

        if IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) then
            ClearPedTasksImmediately(ped)
            ClearPedTasks(ped)
            ClearPedSecondaryTask(ped)
        else
            TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
        end

    end
end)

--[[
    Phone Calls
]]
activePartner = nil

RegisterCommand("ring", function(source, args)
    activePartner = args[1]
    TriggerServerEvent("sf:startCall", activePartner)
end)

RegisterCommand("lægpå", function(source)
    TriggerServerEvent("sf:endCall", activePartner)
    activePartner = nil
end)

--[[isInCall = false
awaitingPartner = nil
activePartner = nil

awaitingCalls = {}

RegisterCommand("ring", function(source, args)
    partner = args[1]

    if awaitingPartner then
        awaitingPartner = nil
    end

    if isInCall then
        exports.pNotify:SendNotification({
            type = "error",
            text = "Du skal lægge på i det opkald som du er i gang med, før du kan starte et nyt!",
            timeout = 7500
        })
    end

    if partner == nil then
        exports.pNotify:SendNotification({
            type = "error",
            text = "Du skal skrive ID'et på den person du vil ringe til!",
            timeout = 5000
        })
    end

    TriggerServerEvent("sf:NotifySpecificPlayer", partner)
    awaitingPartner = partner
end)

RegisterCommand("check", function()
    print(awaitingCalls)
end)

RegisterCommand("besvar", function(source, args)
    TriggerServerEvent("sf:startCall", awaitingPartner)
    activePartner = awaitingPartner
    awaitingPartner = nil
end)--]]