---------
-- COP --
---------
RegisterCommand("cop", function(source, args)
    callsign = args[1]
    department = args[2]

    if callsign ~= nil and department ~= nil then
        TriggerEvent("cwgm:DutyCop", callsign, department)
    else
        Notify("Du skal skrive dit callsign samt department!", "error", 3500)
    end
end, false)

RegisterCommand("offduty", function()
    if IsPlayerActiveAsCop() then TriggerEvent("cwgm:OffDutyCop") end
    if IsPlayerActiveAsEMS() then TriggerEvent("cwgm:OffDutyEMS") end
	TriggerServerEvent("safos_dispatch_offDuty")
end, false)

---------
-- EMS --
---------
RegisterCommand("ems", function(source, args)
    callsign = args[1]

    if callsign ~= nil then
        TriggerEvent("cwgm:DutyEMS", callsign)
    else
        Notify("Du skal skrive dit callsign!", "error", 3500)
    end
end)

--------------
-- CIVILIAN --
--------------
RegisterCommand("civ", function()
    TriggerEvent("cwgm:toggleCiv")
end)

RegisterCommand("k", function()
    TriggerEvent("cwgm:kneel")
end)

RegisterCommand("hu", function()
    TriggerEvent("sf:handsup")
end)

RegisterCommand("sekradio", function(source, args)
    currentSecondaryRadio = args[1]
    TriggerServerEvent("sf:setRadio", args[1])
    exports.pNotify:SendNotification({
        type = "success",
        text = "Du er nu tilsluttet frekvens " .. currentSecondaryRadio .. ".00 MHz på din sekundære kanal!",
        timeout = 5000
    })
end)

RegisterCommand("sluksek", function(source)
    TriggerServerEvent("sf:removeRadio", currentSecondaryRadio)
    exports.pNotify:SendNotification({
        type = "success",
        text = "Du har afbrudt forbindelsen til frekvens " .. currentSecondaryRadio .. ".00 MHz på din sekundære radio!",
        timeout = 5000
    })
    currentSecondaryRadio = nil
end)

-------------
-- VEHICLE --
-------------
RegisterCommand("trunk", function()
    TriggerEvent("cwgm:toggleTrunk")
end)

RegisterCommand("hood", function()
    TriggerEvent("cwgm:toggleHood")
end)

RegisterCommand("eng", function()
    TriggerEvent("cwgm:toggleEngine")
end)

RegisterCommand("dv", function()
    TriggerEvent("cwgm:deleteVeh")
end)

----------
-- CORE --
----------
RegisterCommand("delgun", function()
    TriggerEvent("cwgm:delgun")
end)

RegisterCommand("carbine", function()
    TriggerEvent("sf:ToggleWeapon", "weapon_carbinerifle_mk2")
end, false)

RegisterCommand("smg", function()
    TriggerEvent("sf:ToggleWeapon", "WEAPON_SMG")
end, false)

RegisterCommand("shotgun", function()
    TriggerEvent("sf:ToggleWeapon", "weapon_pumpshotgun_mk2")
end, false)

RegisterCommand("fireex", function()
    TriggerEvent("sf:ToggleWeapon", "WEAPON_FIREEXTINGUISHER")
end, false)

RegisterCommand("jerrycan", function()
    TriggerEvent("sf:ToggleWeapon", "WEAPON_PETROLCAN")
end, false)

-----------
-- STAFF --
-----------
RegisterCommand("info", function(source, args)
    TriggerServerEvent("cwgm:announce", table.concat(args, " "))
end)

TriggerEvent("chat:addSuggestion", "/cop", "Gå på arbejde som betjent", { { name = "Callsign", help = "Skriv dit callsign" }, { name = "Department", help = "Skriv dit department" } })
TriggerEvent("chat:addSuggestion", "/ems", "Gå på arbejde som EMS", { { name = "Callsign", help = "Skriv dit callsign" } })