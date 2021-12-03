--[[
    TITLE: Toggle cop duty
    DESCRIPTION: Toggle cop duty, give permissions to radio channels and set a blip of the client
]]
activeCop = false

RegisterNetEvent("cwgm:DutyCop")
AddEventHandler("cwgm:DutyCop", function()
        if not activeCop then
            TriggerServerEvent("cwgm:addCopBlip", callsign, department, 8)
            activeCop = true
            Notify("Du er nu aktiv som betjent!<br>Callsign: <b>" .. callsign .. "</b> | Department: <b>" .. department .. "</b>", "info", 3500)
			TriggerServerEvent("safos_dispatch_newOnDuty", callsign, department)
		else
            Notify("Du er allerede på vagt som betjent!", "info", 3500)
        end
end)

--[[
    TITLE: Hand on holster
    DESCRIPTION: Take hand on holster when ALT is held down
]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) and activeCop then
            DisableControlAction(0, 19, true) -- ALT
            if not IsPauseMenuActive() then
                LoadAnimDict("reaction@intimidation@cop@unarmed")
                if IsDisabledControlJustReleased(0, 19) then -- ALT
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                else
                    if IsDisabledControlJustPressed(0, 19) then -- ALT
                        SetEnableHandcuffs(ped, true)
                        TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
                    end
                end
            end
        end

        -- Drag
        if Drag.Dragging then
			local PlayerPed = PlayerPedId()

			Drag.Dragged = true
			AttachEntityToEntity(PlayerPed, GetPlayerPed(GetPlayerFromServerId(Drag.Dragger)), 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			if Drag.Dragged then
				local PlayerPed = PlayerPedId()

				if not IsPedInParachuteFreeFall(PlayerPed) then
					Drag.Dragged = false
					DetachEntity(PlayerPed, true, false)    
				end
			end
		end
    end
end)

--[[
    DRAG
]]
Drag = {
	Distance = 3,
	Dragging = false,
	Dragger = -1,
	Dragged = false,
}

function Drag:GetPlayers()
	local Players = {}
    
	for Index = 0, 255 do
		if NetworkIsPlayerActive(Index) then
			table.insert(Players, Index)
		end
	end

    return Players
end

function Drag:GetClosestPlayer()
    local Players = self:GetPlayers()
    local ClosestDistance = -1
    local ClosestPlayer = -1
    local PlayerPed = PlayerPedId()
    local PlayerPosition = GetEntityCoords(PlayerPed, false)
    
    for Index = 1, #Players do
    	local TargetPed = GetPlayerPed(Players[Index])
    	if PlayerPed ~= TargetPed then
    		local TargetCoords = GetEntityCoords(TargetPed, false)
    		local Distance = #(PlayerPosition - TargetCoords)

    		if ClosestDistance == -1 or ClosestDistance > Distance then
    			ClosestPlayer = Players[Index]
    			ClosestDistance = Distance
    		end
    	end
    end
    
    return ClosestPlayer, ClosestDistance
end

RegisterNetEvent("Drag")
AddEventHandler("Drag", function(Dragger)
	Drag.Dragging = not Drag.Dragging
	Drag.Dragger = Dragger
end)

RegisterCommand("drag", function(source, args, fullCommand)
	local Player, Distance = Drag:GetClosestPlayer()

	if Distance ~= -1 and Distance < Drag.Distance then
		TriggerServerEvent("Drag", GetPlayerServerId(Player))
	else
		TriggerEvent("chat:addMessage", {
			color = {255, 0, 0},
			multiline = true,
			args = {"Drag", "Du skal tættere på en person for at dragge!"},
		})
	end
end, false)

function IsPlayerActiveAsCop()
    if activeCop then
        return true
    else
        return false
    end
end

RegisterNetEvent("cwgm:OffDutyCop")
AddEventHandler("cwgm:OffDutyCop", function()
    if IsPlayerActiveAsCop() then
        activeCop = false
        TriggerServerEvent("cwgm:removeBlip")
        Notify("Du er nu ikke længere aktiv som betjent!", "info", 3500)
    else
        Notify("Du er ikke aktiv på noget job!", "info", 3500)
    end
end)

-- Toggle Carbine
RegisterNetEvent("sf:ToggleWeapon")
AddEventHandler("sf:ToggleWeapon", function(weapon)
    local ped = GetPlayerPed(-1)
    local hash = GetHashKey(weapon)

    if IsVehicleACopVehicle() then
        if weapon == "weapon_carbinerifle_mk2" then
            if not HasPedGotWeapon(ped, hash, false) then
                GiveWeaponToPed(ped, hash, 200, 0, true) -- Give weapon
                GiveWeaponComponentToPed(ped, hash, 0x7BC4CDDC) -- Flashlight
                GiveWeaponComponentToPed(ped, hash, 0xC66B6542) -- Large Scope
                GiveWeaponComponentToPed(ped, hash, 0x8B3C480B) -- Heavy Barrel
                GiveWeaponComponentToPed(ped, hash, 0x255D5D57) -- Armor Piercing
                GiveWeaponComponentToPed(ped, hash, 0x2E7957A) -- Heavy Duty Muzzle Brake
                SetPedAmmo(ped, hash, 0) -- Reset ammo count
                AddAmmoToPed(ped, hash, 120) -- Give ammo
                Notify("Du har taget din Carbine Rifle!", "info", 3500)
            else
                RemoveWeaponFromPed(ped, hash)
                SetPedAmmo(ped, hash, 0)
                Notify("Du har lagt din Carbine Rifle tilbage!", "info", 3500)
            end
        elseif weapon == "WEAPON_SMG" then
            if not HasPedGotWeapon(ped, hash, false) then
                GiveWeaponToPed(ped, hash, 200, 0, true) -- Give weapon
                GiveWeaponComponentToPed(ped, hash, 0x7BC4CDDC) -- Flashlight
                GiveWeaponComponentToPed(ped, hash, 0x3CC6BA57) -- Scope
                GiveWeaponComponentToPed(ped, hash, 0x350966FB) -- Extended Clip
                SetPedAmmo(ped, hash, 0) -- Reset ammo count
                AddAmmoToPed(ped, hash, 180) -- Give ammo
                Notify("Du har taget din SMG!", "info", 3500)
            else
                RemoveWeaponFromPed(ped, hash)
                SetPedAmmo(ped, hash, 0)
                Notify("Du har lagt din SMG tilbage!", "info", 3500)
            end
        elseif weapon == "weapon_pumpshotgun_mk2" then
            if not HasPedGotWeapon(ped, hash, false) then
                GiveWeaponToPed(ped, hash, 250, 0, true) -- Give weapon
                GiveWeaponComponentToPed(ped, hash, 0x7BC4CDDC) -- Flashlight
                GiveWeaponComponentToPed(ped, hash, 0x4E65B425) -- Steel Buckshot Shells
                GiveWeaponComponentToPed(ped, hash, 0x420FD713) -- Holographic Sight
                SetPedAmmo(ped, hash, 0) -- Reset ammo count
                AddAmmoToPed(ped, hash, 75) -- Give ammo
                Notify("Du har taget din Pump Shotgun!", "info", 3500)
            else
                RemoveWeaponFromPed(ped, hash)
                SetPedAmmo(ped, hash, 0)
                Notify("Du har lagt din Pump Shotgun tilbage!", "info", 3500)
            end
        elseif weapon == "WEAPON_FIREEXTINGUISHER" then
            if not HasPedGotWeapon(ped, hash, false) then
                GiveWeaponToPed(ped, hash, 1000, 0, true)
                SetPedInfiniteAmmo(ped, true, hash)
                Notify("Du har taget din Fire Extenguisher!", "info", 3500)
            else
                RemoveWeaponFromPed(ped, hash)
                SetPedAmmo(ped, hash, 0)
                SetPedInfiniteAmmo(ped, false, hash)
                Notify("Du har lagt din Fire Extenguisher tilbage", "info", 3500)
            end
        elseif weapon == "WEAPON_PETROLCAN" then
            if not HasPedGotWeapon(ped, hash, false) then
                GiveWeaponToPed(ped, hash, 1000, 0, true)
                Notify("Du har taget din Jerry Can!", "info", 3500)
            else
                RemoveWeaponFromPed(ped, hash)
                SetPedAmmo(ped, hash, 0)
                Notify("Du har lagt din Jerry Can tilbage!", "info", 3500)
            end
        end
    else
        Notify("Det kan du ikke når du ikke er i eller foran et politikøretøj!", "error", 3500)
    end
end)