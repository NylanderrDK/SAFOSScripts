--[[
    TITLE: Toggle EMS duty
    DESCRIPTION: Toggle EMS duty, give permissions to radio channels and set a blip of the client
]]
activeEMS = false

RegisterNetEvent("cwgm:DutyEMS")
AddEventHandler("cwgm:DutyEMS", function()
        if not activeEMS then
            TriggerServerEvent("cwgm:addEMSBlip", callsign, 8)
            activeEMS = true
            Notify("Du er nu aktiv som EMS!<br>Callsign: <b>" .. callsign, "info", 3500)
			TriggerServerEvent("safos_dispatch_newOnDuty", callsign, department)
		else
            Notify("Du er allerede på vagt som EMS!", "info", 3500)
        end
end)

--[[
    TITLE: Perform CPR
    DESCRIPTION: Perform CPR animation when a command is executed
]]
RegisterNetEvent("cwgm:toggleCPR")
AddEventHandler("cwgm:toggleCPR", function()
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) and emsOnDuty then
        if not IsPauseMenuActive() then
            LoadAnimDict("mini@cpr@char_a@cpr_str")
            TaskPlayAnim(ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end
    end
end)

function IsPlayerActiveAsEMS()
    if activeEMS then
        return true
    else
        return false
    end
end

RegisterNetEvent("cwgm:OffDutyEMS")
AddEventHandler("cwgm:OffDutyEMS", function()
    if IsPlayerActiveAsEMS() then
        activeEMS = false
        TriggerServerEvent("cwgm:removeBlip")
        Notify("Du er nu ikke længere aktiv som EMS!", "info", 3500)
    else
        Notify("Du er ikke aktiv på noget job!", "info", 3500)
    end
end)