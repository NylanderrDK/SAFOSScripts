-- Register a command to open the police menu
RegisterCommand("polmenu", function()
    TriggerEvent("safos-police:OpenMainMenu")
end, false)
-- Add a button to keybindings so the menu can be toggled with a button press
RegisterKeyMapping("polmenu", "Åbn/luk politimenuen", "keyboard", "")

-- Build the menu
RegisterNetEvent("safos-police:OpenMainMenu", function()
    TriggerEvent("safos-menu:SendMenu", {
        {
            id = 1,
            header = "SAPD Menu",
            txt = ""
        },
        {
            id = 2,
            header = "> Genstande",
            txt = "",
            params = {
                event = "safos-police:OpenObjectsMenu"
            }
        },
        {
            id = 3,
            header = "> Emotes",
            txt = "",
            params = {
                event = "safos-police:OpenEmotesMenu"
            }
        }
    })
end)