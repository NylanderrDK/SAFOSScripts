--[[
    TITLE: ANNOUNCE
    DESCRIPTION: Announce to all players
]]
RegisterServerEvent("cwgm:announce")
AddEventHandler("cwgm:announce", function(param)
    if IsPlayerAceAllowed(source, "faxes.aopcmds") then
        print("^7[^1Information^7]^5:" .. param)
        TriggerClientEvent("chatMessage", -1, "^7[^1Information^7]^2", {0, 0, 0}, param)
    else
        print("No permission")
    end
end)