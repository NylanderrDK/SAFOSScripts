-- Set nui focus to false when a button is clicked, and run the event
RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent(data.event, data.args)
    cb("ok")
end)

-- Set nui focus to false when ESC is clicked
RegisterNUICallback("cancel", function()
    SetNuiFocus(false, false)
end)

-- Create a menu when 'safos-menu:SendMenu' is triggered
RegisterNetEvent("safos-menu:SendMenu", function(data)
    if not data then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMenu",
        data = data
    })
end)

-- EXAMPLE --
--[[RegisterCommand("testmenu", function()
    TriggerEvent("safos-menu:TestMenu")
end, false)

RegisterNetEvent("safos-menu:TestMenu", function()
    TriggerEvent("safos-menu:SendMenu", {
        {
            id = 1,
            header = "Titel",
            txt = ""
        },
        {
            id = 2,
            header = "Sub Menu",
            txt = "Gå til sub menu",
            params = {
                event = "safos-menu:TestSubMenu",
                args = {
                    number = 1,
                    id = 2
                }
            }
        }
    })
end)

RegisterNetEvent("safos-menu:TestSubMenu", function(data)
    local id = data.id
    local number = data.number
    TriggerEvent("safos-menu:SendMenu", {
        {
            id = 1,
            header = "< Tilbage",
            txt = "",
            params = {
                event = "safos-menu:TestMenu"
            }
        },
        {
            id = 2,
            header = "Nummer: " .. number,
            txt = "ID: " .. id
        }
    })
end)]]--