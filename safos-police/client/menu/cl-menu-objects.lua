-- Set some nil variables for later usage
propsList = {}
freezeEntities = false
freezeEntitiesTxt = "Fra"

-- Build the menu
RegisterNetEvent("safos-police:OpenObjectsMenu", function()
    TriggerEvent("safos-menu:SendMenu", {
        { id = 1, header = "< Tilbage", txt = "Gå tilbage til hovedmenuen", params = { event = "safos-police:OpenMainMenu" } },
        { id = 2, header = "Frys genstand", txt = "Status: " .. freezeEntitiesTxt, params = { event = "safos-police:ToggleFreezeEntities" } },
        { id = 3, header = "Slet nærmeste genstand", txt = "Slet genstanden som du står foran", params = { event = "safos-police:RemoveNearestObject" } },
        { id = 4, header = "Slet ALLE genstande placeret af dig", txt = "Slet alle genstande som du har placeret", params = { event = "safos-police:RemoveAllObjects" } },
    })
    count = 4
    for i, object in pairs(Config.Objects) do
        TriggerEvent("safos-menu:SendMenu", {
            {
                id = count + 1,
                header = object.header,
                txt = object.txt,
                params = {
                    event = "safos-police:PlaceObject",
                    args = {
                        model = object.model
                    }
                }
            },
        })
        count = count + 1
    end
end)

-- Event that is triggered when a client wants to place a object
RegisterNetEvent("safos-police:PlaceObject", function(data)
    model = data.model
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end
    local obj = CreateObject(GetHashKey(model), x, y, z, true, false)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
    FreezeEntityPosition(obj, freezeEntities)
    propsList[#propsList + 1] = ObjToNet(obj)
    TriggerEvent("safos-police:OpenObjectsMenu")
end)

-- Event that is triggered when a client wants to remove the nearest object
RegisterNetEvent("safos-police:RemoveNearestObject", function()
    local prop = 0
    local deelZ = 10
    local deelXY = 2

    for offsetY = -2,2 do
        for offsetX = -2,2 do
            for offsetZ = -8,8 do
                local posFrom = GetEntityCoords(PlayerPedId())
                local posTo = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
                local rayHandle = StartShapeTestRay(posFrom.x, posFrom.y, posFrom.z - (offsetZ / deelZ), posTo.x + (offsetX / deelXY), posTo.y + (offsetY / deelXY), posTo.z - (offsetZ / deelZ), 16, PlayerPedId(), 0)
                local _, _, _, _, object = GetShapeTestResult(rayHandle)
                if object ~= 0 then prop = object break end
            end
        end
    end
    if prop == 0 then
        ClFunction.DefaultNotification("Der kunne ikke findes en genstand.")
    else
        SetEntityAsMissionEntity(prop)
        DeleteObject(prop)
    end
    TriggerEvent("safos-police:OpenObjectsMenu")
end)

-- Event that is triggered when a client wants to toggle wheter places objects should be frozen or not
RegisterNetEvent("safos-police:ToggleFreezeEntities", function()
    freezeEntities = not freezeEntities
    if freezeEntities then
        freezeEntitiesTxt = "Til"
    else
        freezeEntitiesTxt = "Fra"
    end
    TriggerEvent("safos-police:OpenObjectsMenu")
end)

-- Event that is triggered when a client wants to remove all objects he places
RegisterNetEvent("safos-police:RemoveAllObjects", function()
    for i, prop in pairs(propsList) do
        DeleteObject(NetToObj(prop))
        propsList[i] = nil
    end
end)