RegisterNetEvent("safos-police:OpenActionsMenu", function()
    TriggerEvent("safos-menu:SendMenu", {
        {
            id = 1,
            header = "< Tilbage",
            txt = "Gå tilbage til hovedmenuen",
            params = {
                event = "safos-police:OpenMainMenu"
            }
        },
        {
            id = 2,
            header = "Udsend information",
            txt = "",
            params = {
                event = "safos-police:PublishAlert"
            }
        },
        {
            id = 3,
            header = "Sæt nærmeste i håndjern",
            txt = "",
            params = {
                event = "safos-police:CuffNearest"
            }
        },
        {
            id = 4,
            header = "Tag fat i nærmeste",
            txt = "",
            params = {
                event = "safos-police:DragNearest"
            }
        },
        {
            id = 5,
            header = "Sæt nærmeste ind i køretøj",
            txt = "",
            params = {
                event = "safos-police:SeatNearest"
            }
        },
        {
            id = 6,
            header = "Tag nærmeste ud af køretøj",
            txt = "",
            params = {
                event = "safos-police:UnseatNearest"
            }
        },
        {
            id = 7,
            header = "Gennemsøg nærmeste",
            txt = "",
            params = {
                event = "safos-police:SearchNearest"
            }
        },
        {
            id = 8,
            header = "Gennemsøg nærmeste køretøj",
            txt = "",
            params = {
                event = "safos-police:SearchNearestVehicle"
            }
        }
    })
end)