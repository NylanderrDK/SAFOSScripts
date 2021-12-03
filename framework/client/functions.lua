--[[
    TITLE: LOAD ANIM DICT
    DESCRIPTION: Loads an anim dict
]]
function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

--[[
    TITLE: GET VEHICLE IN FRONT
    DESCRIPTION: Get the vehicle in front and return the result
]]
function GetVehicleInFront()
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 2.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, player, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end

--[[
    TITLE: DELETE VEHICLE
    DESCRIPTION: Delete vehicle in a number of retries
]]
function deleteVehicle(veh, timeoutMax)
    local timeout = 0
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
    if DoesEntityExist(veh) then
        exports.pNotify:SendNotification({
            text = "Køretøjet kunne ikke slettes, prøver igen..", 
            type = "error",
            timeout = 3500
        })
        while DoesEntityExist(veh) and timeout < timeoutMax do
            DeleteVehicle(veh)
            if not DoesEntityExist(veh) then
                exports.pNotify:SendNotification({
                    text = "Køretøjet blev slettet!",
                    type = "success",
                    timeout = 3500
                })
            end
            timeout = timeout + 1
            Citizen.Wait(500)
            if DoesEntityExist(veh) and timeout == timeoutMax - 1 then
				exports.pNotify:SendNotification({
                    text = "Køretøjet kunne ikke slettes, prøve igen!",
                    type = "error",
                    timeout = 3500
                })
            end
        end
    else
        exports.pNotify:SendNotification({
            text = "Køretøjet blev slettet!",
            type = "success",
            timeout = 3500
        })
    end
end

--[[
    TITLE: GET VEHICLE IN DIRECTION
    DESCRIPTION: Get vehicle in direction, and return it
]]
function GetVehicleInDirection(entFrom, coordFrom, coordTo)
    local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    if IsEntityAVehicle(vehicle) then
        return vehicle
    end
end

--[[
    TITLE: GET ENTITY
    DESCRIPTION: Get the entity the player is looking at, and return it
]]
function getEntity(player)
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

--[[
    TITLE: STRING SPLIT
    DESCRIPTION: Split a string
]]
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

--[[
    TITLE: 3DME
    DESCRIPTION: Display me in 3D
]]
defaultScale = 0.5
color = { r = 230, g = 230, b = 230, a = 255 }
font = 0
displayTime = 5000
distToDraw = 250
pedDisplaying = {}

function DrawText3D(coords, text)
    camCoords = GetGameplayCamCoord()
    dist = #(coords - camCoords)
    scale = 200 / (GetGameplayCamFov() * dist)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextScale(0.0, defaultScale * scale)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextDropShadow()
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetDrawOrigin(coords, 0)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()
end

function Display(ped, text)
    playerPed = PlayerPedId()
    playerCoords = GetEntityCoords(playerPed)
    pedCoords = GetEntityCoords(ped)
    dist = #(playerCoords - pedCoords)
    if dist <= distToDraw then
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        display = true
        Citizen.CreateThread(function()
            Wait(displayTime)
            display = false
        end)
        offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        ped = GetPlayerPed(player)
        Display(ped, text)
    end
end)

--[[
    TITLE: HASH IN TABLE
    DESCRIPTION: Check if a hash is in a table
]]
function HashInTable(hash)
    for k, v in pairs(scopedWeapons) do
        if hash == v then
            return true
        end
    end

    return false
end

--[[
    TITLE: MANAGE RETICLE
    DESCRIPTION: Manage the reticle
]]
scopedWeapons = {
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    -952879014, -- WEAPON_MARKSMANRIFLE
	177293209,  -- WEAPON_HEAVYSNIPER MKII
	1785463520  -- WEAPON_MARKSMANRIFLE_MK2
}

function ManageReticle()
    local ped = GetPlayerPed(-1)
    local _, hash = GetCurrentPedWeapon(ped, true)
    if not HashInTable(hash) then
        HideHudComponentThisFrame(14)
    end
end

function Notify(text, type, timeout)
    exports.pNotify:SendNotification({
        text = text,
        type = type,
        timeout = timeout
    })
end

function IsVehicleACopVehicle()
    local ped = GetPlayerPed(-1)
    
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleClass(vehicle) == 18 then -- Emergency
                return true
            else
                return false
            end
        end
    
    else
        local vehicle = GetVehicleInFront()

        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleClass(vehicle) == 18 then -- Emergency
                return true
            else
                return false
            end
        end
    end
end