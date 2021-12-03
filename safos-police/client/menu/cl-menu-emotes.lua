-- Build the menu
RegisterNetEvent("safos-police:OpenEmotesMenu", function()
    TriggerEvent("safos-menu:SendMenu", {
        { id = 1, header = "< Tilbage", txt = "Gå tilbage til hovedmenuen", params = { event = "safos-police:OpenMainMenu" } },
        { id = 2, header = "Stop igangværende emote", txt = "", params = { event = "safos-police:StopEmote" } },
    })
    count = 2
    for i, emote in pairs(Config.Emotes) do
        TriggerEvent("safos-menu:SendMenu", {
            {
                id = count + 1,
                header = emote.header,
                txt = emote.txt,
                params = {
                    event = "safos-police:PlayEmote",
                    args = {
                        emote = emote.emote
                    }
                }
            }
        })
        count = count + 1
    end
end)

-- Event that is triggered when a client plays an emote
RegisterNetEvent("safos-police:PlayEmote", function(data)
    anim = data.emote
    ClFunction.StartEmote(anim)
    TriggerEvent("safos-police:OpenEmotesMenu")
end)

-- Event that is triggered when a client stops an emote
RegisterNetEvent("safos-police:StopEmote", function()
    ClFunction.StopEmote()
    TriggerEvent("safos-police:OpenEmotesMenu")
end)

-- Register a command to stop the playing emote
RegisterCommand("stope", function()
    ClFunction.StopEmote()
end, false)
-- Add a button in keybindings, so the client can set their own button
RegisterKeyMapping("stope", "Stop igangværende emote", "keyboard", "")