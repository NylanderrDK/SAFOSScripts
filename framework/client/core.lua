--[[
    TITLE: Revive
    DESCRIPTION: Deactivate automatic revive
]]
local isDead = false

AddEventHandler("onClientMapStart", function()
    exports.spawnmanager:spawnPlayer()
    Citizen.Wait(2500)
    exports.spawnmanager.setAutoSpawn(false)
end)

function revivePed(ped)
    local pedCoords = GetEntityCoords(ped)
    isDead = false
    NetworkResurrectLocalPlayer(pedCoords, true, false, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
end

--[[
    TITLE: Hood command
    DESCRIPTION: Toggle the hood when a command is executed
]]
RegisterNetEvent("cwgm:toggleHood")
AddEventHandler("cwgm:toggleHood", function()
    local ped = GetPlayerPed(-1)
    
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleDoorAngleRatio(vehicle, 4) > 0 then
                SetVehicleDoorShut(vehicle, 4, false)
            else
                SetVehicleDoorOpen(vehicle, 4, false, false)
            end
        end
    else
        local vehicle = GetVehicleInFront()
        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleDoorAngleRatio(vehicle, 4) > 0 then
                SetVehicleDoorShut(vehicle, 4, false)
            else
                SetVehicleDoorOpen(vehicle, 4, false, false)
            end
        end
    end
end)

--[[
    TITLE: Trunk command
    DESCRIPTION: Toggle the trunk when a command is executed
]]
RegisterNetEvent("cwgm:toggleTrunk")
AddEventHandler("cwgm:toggleTrunk", function()
    local ped = GetPlayerPed(-1)

    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                SetVehicleDoorShut(vehicle, 5, false)
            else
                SetVehicleDoorOpen(vehicle, 5, false, false)
            end
        end
    else
        local vehicle = GetVehicleInFront()
        if vehicle ~= nil and vehicle ~= 0 and vehicle ~= 1 then
            if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                SetVehicleDoorShut(vehicle, 5, false)
            else
                SetVehicleDoorOpen(vehicle, 5, false, false)
            end
        end
    end
end)

--[[
    TITLE: Toggle engine
    DESCRIPTION: Toggle the engine when a command is executed
]]
RegisterNetEvent("cwgm:toggleEngine")
AddEventHandler("cwgm:toggleEngine", function()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if vehicle ~= nil and vehicle ~= 0 and GetLastPedInVehicleSeat(vehicle, 0) then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end)

--[[
    TITLE: Delete vehicle
    DESCRIPTION: Delete a vehicle when a command is executed
]]
RegisterNetEvent("cwgm:deleteVeh")
AddEventHandler("cwgm:deleteVeh", function()
    local distanceToCheck = 5.0
    local numRetries = 5
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        local pos = GetEntityCoords(ped)
        if IsPedSittingInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                deleteVehicle(vehicle, numRetries)
            else
                exports.pNotify:SendNotification({
                    text = "Du skal være chauffør af køretøjet for at slette det!",
                    type = "error",
                    timeout = 3500
                })
            end
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, distanceToCheck, 0.0)
            local vehicle = GetVehicleInDirection(ped, pos, inFrontOfPlayer)
            if DoesEntityExist(vehicle) then
                deleteVehicle(vehicle, numRetries)
            else
                exports.pNotify:SendNotification({
                    text = "Du skal være i eller i nærheden af et køretøj for at slette det!", 
                    type = "error",
                    timeout = 3500
                })
            end
        end
    end
end)

--[[
    TITLE: Delete gun
    DESCRIPTION: Delete the prop/entity the player is shooting at when activated
]]
local delgunToggle = false
local ped = GetPlayerPed(-1)

RegisterNetEvent("cwgm:delgun")
AddEventHandler("cwgm:delgun", function()
    if delgunToggle == false then
		delgunToggle = true
		exports.pNotify:SendNotification({text = "Delete Gun er aktiveret!", type = "success", timeout = 5000})
	else
		delgunToggle = false
		exports.pNotify:SendNotification({text = "Delete Gun er deaktiveret!", type = "success", timeout = 5000})
	end
end)

--[[
	TITLE: IGNORE PLAYER
	DESCRIPTION: Everyone ignore player
--]]
local player = PlayerId()

SetPoliceIgnorePlayer(player, true)
SetEveryoneIgnorePlayer(player, true)
SetPlayerCanBeHassledByGangs(player, false)
SetIgnoreLowPriorityShockingEvents(player, true)

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsEntityDead(ped) and IsEntityAPed(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end

--[[
    TITLE: THREADS
    DESCRIPTION: To lower hardware use, we are connecting all functions that needs a thread to one
]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Delete gun
        if delgunToggle then
			local entity = getEntity(PlayerId())
			if GetEntityType(entity) == 2 or 3 then
				if IsPedShooting(ped) then
					SetEntityAsMissionEntity(entity, true, true)
					DeleteEntity(entity)
				end
			end
        end
        
        -- Revive
        ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
            isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Tryk på E for at blive genoplivet!")
            DrawNotification(true, false)
            if IsControlJustReleased(0, 38) and GetLastInputMethod(0) then
                revivePed(ped)
            end
        end

        -- Hide reticle
        weapon = GetSelectedPedWeapon(ped)
        ManageReticle()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
        DisplayAmmoThisFrame(false)
		
		-- Ignore player
        for key,pedNpc in pairs(GetAllPeds()) do
            SetBlockingOfNonTemporaryEvents(pedNpc,true)
            SetPedFleeAttributes(pedNpc, 0, 0)
            SetPedCombatAttributes(pedNpc, 17, 1)
            if(GetPedAlertness(pedNpc) ~= 0) then
                SetPedAlertness(pedNpc,0)
            end
        end

    end
end)