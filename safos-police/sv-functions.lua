SvFunction = {}

-- SvFunction.SendToDiscord(name: string, message: string, color: ?)
-- Sends a webhook to Discord with the provided settings
SvFunction.SendToDiscord = function(name, message, color)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "SAFOS"
            }
        }
    }
    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = Config.DiscordWebhookName, embeds = embed, avatar_url = Config.DiscordImage}), { ['Content-Type'] = 'application/json' })
end

-- SvFunction.GetIdentifier(type: string, id: int)
-- Returns the client's identifier
SvFunction.GetIdentifier = function(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do table.insert(identifiers, GetPlayerIdentifier(id, a)) end
    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then return identifiers[b] end
    end
    return false
end

-- SvFunction.Print(text: string)
-- Prints the text to the server console
SvFunction.Print = function(text)
    print("^3[SAFOS FW] ^6>> ^7" .. text)
end