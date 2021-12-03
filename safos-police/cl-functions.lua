ClFunction = {}
emoteActive = false

-- ClFunction.DefaultNotification(text: string)
-- Shows a notification
ClFunction.DefaultNotification = function(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true, true)
    ClFunction.PlayWarningSound()
end

-- ClFunction.PictureNotification(picture: string, title: string, subtitle: string, text: string)
-- Shows a notification with the specified parameters
ClFunction.PictureNotification = function(picture, title, subtitle, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(picture, picture, false, 0, title, subtitle)
    DrawNotification(true, false)
    ClFunction.PlayWarningSound()
end

-- ClFunction.CustomPictureNotification(picture: string, title: string, subtitle: string, text: string)
-- Shows a notification with the specified parameters (here you should use a custom one from the streamed 'char_floyd')
ClFunction.CustomPictureNotification = function(picture, title, subtitle, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage("CHAR_FLOYD", picture, false, 0, title, subtitle)
    DrawNotification(true, false)
    ClFunction.PlayWarningSound()
end

-- ClFunction.PlaySound(name: string, ref: string)
-- Plays the specified sound
ClFunction.PlaySound = function(name, ref)
    PlaySoundFrontend(-1, name, ref, 1)
end

-- ClFunction.PlayWarningSound()
-- Plays a kind of warning sound, or basically just a "bonk"
ClFunction.PlayWarningSound = function()
    ClFunction.PlaySound("BACK", "HUD_AMMO_SHOP_SOUNDSET")
end

-- ClFunction.UpdateProfileHUD(job: string, callsign: string, name: string, headshot: string)
-- Updates the whole profile HUD, with job, callsign, name and headshot
ClFunction.UpdateProfileHUD = function()
    if not GetCurrentCharacter() then
        name = "Intet"
    else
        local currentCharacter = GetCurrentCharacter()
        name = currentCharacter["fname"] .. " " .. currentCharacter["lname"]
        ClFunction.Print(name)
    end
    
    SendNUIMessage({
        type = "profile",
        show = true,
        job = GetJob(),
        callsign = GetCallsign(),
        name = name
    })
end

-- ClFunction.KeyboardInput(entry: string, placeholder: string, maxLength: int)
-- Shows a text input, and returns the input
ClFunction.KeyboardInput = function(entry, placeholder, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", entry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", placeholder, "", "", "", maxLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

-- ClFunction.StartEmote(anim: string)
-- Starts the specified emote
ClFunction.StartEmote = function(anim)
    if not emoteActive then
        TaskStartScenarioInPlace(PlayerPedId(), anim, 0, true)
        emoteActive = true
    end
end

-- ClFunction.StopEmote()
-- Stops the current playing animation
ClFunction.StopEmote = function()
    if emoteActive then
        ClearPedTasks(PlayerPedId())
        emoteActive = false
    end
end

-- ClFunction.IsCopCar(veh: vehicle)
-- Returns true if the specified vehicle is a cop car, else false
ClFunction.IsCopCar = function(veh)
    if GetVehicleClass(veh) == 18 then return true else return false end
end

-- ClFunction.GiveWeapon(hash: hash, ammo: int)
-- Gives the ped the specified weapon and ammo
ClFunction.GiveWeapon = function(hash, ammo)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(hash), ammo, false, false)
end

-- ClFunction.Print(text: string)
-- Prints the text to the client console (F8)
ClFunction.Print = function(text)
    print("^3[SAFOS FW] ^6>> ^7" .. text)
end

-- ClFunction.CountTableLength(table: table)
-- Counts how many entries there are in provided table, and returns it
ClFunction.CountTableLength = function(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

-- ClFunction.LoadAnimDict(dict: string)
-- Requests the dict and loads it (needs to be in a thread
ClFunction.LoadAnimDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
end

--[[ClFunction.GetPedInFront = function()
    local player = PlayerId()
    local playerPed = PlayerPedId()
    local playerPedPos = GetEntityCoords(playerPed)
    local playerOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(playerPedPos.x, playerPedPos.y, playerPedPos.z, playerOffset.x, playerOffset.y, playerOffset.z, 1.0, 12, playerPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

ClFunction.GetPlayerFromPed = function(ped)
    for a = 0, 64 do
        if GetPlayerPed(a) == ped then return a end
    end
    return -1
end]]--