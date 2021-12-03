Radio = {
    Visible = false,
    Volume = 0.5,
    Speaker = false,
    PrimaryChannel = "",
    SecondaryChannel = "",
    Prop = nil,
    Model = "prop_cs_hand_radio",
    AnimDict = "cellphone@",
    AnimName = "cellphone_text_read_base",
}

Radio.Toggle = function()
    Radio.Visible = not Radio.Visible
    SetNuiFocus(Radio.Visible, Radio.Visible)
    SendNUIMessage({
        show = Radio.Visible
    })
    Radio.Animation()
end

Radio.Animation = function()
    local ped = PlayerPedId()
    if Radio.Visible then
        RequestAnimDict(Radio.AnimDict)
        while not HasAnimDictLoaded(Radio.AnimDict) do Citizen.Wait(0) end
        prop = CreateObject(GetHashKey(Radio.Model), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
        TaskPlayAnim(ped, Radio.AnimDict, Radio.AnimName, 8.0, -8.0, -1, 50, 0, 0, 0, 0)
    else
        StopAnimTask(ped, Radio.AnimDict, Radio.AnimName, 8.0, -8.0, -1, 50, 0, 0, 0, 0)
        RemoveAnimDict(Radio.AnimDict)
        DeleteEntity(prop)
    end
end

RegisterCommand("radio", function()
    Radio.Toggle()
end, false)
RegisterKeyMapping("radio", "Indstil din radio", "keyboard", "")

RegisterNUICallback("close", function(data, cb)
    Radio.Toggle()
    cb(true)
end)

RegisterNUICallback("turnOn", function(data, cb)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true)
end)

RegisterNUICallback("freqPrimary", function(data, cb)
    Radio.PrimaryChannel = tostring(data.channel)
    TriggerServerEvent("cg-radio:SetPlayerRadioChannel", Radio.PrimaryChannel, true)
    cb(true)
end)

RegisterNUICallback("freqSecondary", function(data, cb)
    Radio.SecondaryChannel = tostring(data.channel)
    TriggerServerEvent("cg-radio:SetPlayerRadioChannel", Radio.SecondaryChannel, false)
    cb(true)
end)

RegisterNUICallback("leave", function(data, cb)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    TriggerServerEvent("cg-radio:RemovePlayerRadioChannel", Radio.PrimaryChannel)
    TriggerServerEvent("cg-radio:RemovePlayerRadioChannel", Radio.SecondaryChannel)
    Radio.PrimaryChannel = ""
    Radio.SecondaryChannel = ""
    cb(true)
end)

RegisterNUICallback("volUp", function(data, cb)
    if Radio.Volume < 1.0 then
        Radio.Volume = Radio.Volume + 0.1
        exports["saltychat"]:SetRadioVolume(Radio.Volume)
        PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
    cb(true)
end)

RegisterNUICallback("volDown", function(data, cb)
    if Radio.Volume > 1.0 then
        Radio.Volume = Radio.Volume - 0.1
        exports["saltychat"]:SetRadioVolume(Radio.Volume)
        PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
    cb(true)
end)

RegisterNUICallback("speaker", function(data, cb)
    Radio.Speaker = not Radio.Speaker
    TriggerServerEvent("cg-radio:SetPlayerRadioSpeaker", Radio.Speaker)
end)