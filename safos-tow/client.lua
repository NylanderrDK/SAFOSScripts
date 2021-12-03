RegisterNetEvent("safos-tow:BoatTrailer")
AddEventHandler("safos-tow:BoatTrailer", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil then
        if IsVehicleModel(veh, GetHashKey("code3boat")) then
            print("is in boat")
            local below = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
            local boatPos = GetEntityCoords(veh)
            local trailer = GetVehicleInDirection(boatPos, below)

            if IsVehicleModel(trailer, GetHashKey("code3trailer")) then
                print("below is trailer")
                if IsEntityAttached(veh) then
                    DetachEntity(veh, false, true)
                else
                    AttachEntityToEntity(veh, trailer, 20, 0.0, 0.0, 0.0, 0.06, 0.0, 0.0, false, false, true, false, 20, true)
                end
            end
        else
            print("not in boat")
        end
    end
end)

RegisterCommand("trailerboat", function()
    TriggerEvent("safos-tow:BoatTrailer")
end, false)

RegisterNetEvent("safos-tow:GatorTrailer")
AddEventHandler("safos-tow:GatorTrailer", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, true)
    local trailer = GetHashKey("code3trailer2")

    if IsVehicleModel(veh, trailer) then
        local pedPos = GetEntityCoords(ped)
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
        local targetVeh = GetVehicleInDirection(pedPos, offset)

        if targetVeh ~= 0 then
            if not IsPedInAnyVehicle(ped, true) then
                if veh ~= targetVeh then
                    if IsEntityAttached(targetVeh) then
                        DetachEntity(targetVeh, false, true)
                    else
                        AttachEntityToEntity(targetVeh, veh, 20, 0.0, 0.75, -0.025, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
                    end
                else
                    print("You can't tow your own trailer.")
                end
            end
        else
            print("There's no vehicle.")
        end
    end
end)

RegisterCommand("trailergator", function()
    TriggerEvent("safos-tow:GatorTrailer")
end, false)

RegisterCommand("trailerguide", function()
    TriggerEvent("chatMessage", "[SAFOS Trailer]", { 255, 255, 0 }, "GATOR: Sæt dig i traileren (tryk F når du står ved siden af), gå ud og kig på Gator'en og skriv herefter /trailergator.\nBÅD: Kør en trailer ned i vandkanten, sejl båden på traileren og skriv herefter /trailerboat.")
end, false)

function GetVehicleInDirection(from, to)
    local rayHandle = CastRayPointToPoint(from.x, from.y, from.z, to.x, to.y, to.z, 10, PlayerPedId(), 0)
    local _, _, _, _, veh = GetRaycastResult(rayHandle)
    return veh
end