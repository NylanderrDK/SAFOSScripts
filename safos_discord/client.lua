Citizen.CreateThread(function()
    while true do
        SetDiscordAppId()

        SetDiscordRichPresenceAsset("safoslogo")
        SetDiscordRichPresenceAssetText("SAFOS ~ En del af Coward Gaming")

        SetDiscordRichPresenceAssetSmall("fivemlogo")
        SetDiscordRichPresenceAssetSmallText("FiveM")

        SetDiscordRichPresenceAction(0, "Tilslut", "fivem://safos.cowardgaming.dk")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/Kb48nwK")

        Citizen.Wait(120000)
    end
end)