-- Resource Metadata
fx_version "cerulean"
game "gta5"

author "Nylander"
description "SAFOS Framework"
version "0.0.1"

-- What to run
client_scripts {
    -- Cop
    "client/cop.lua",
    -- EMS
    "client/ems.lua",
    -- Civ
    "client/civ.lua",
    -- Commands
    "client/commands.lua",
    -- Core
    "client/core.lua",
    "client/functions.lua",

    "client/test.lua"
}

server_scripts {
    -- Staff
    "server/staff.lua",
    -- Core
    "server/core.lua",
    -- Commands
    "server/commands.lua",

    "server/blips.lua",

    "server/cop.lua",

    "server/civ.lua"
}

-- Dependencies
dependencies {
    "EmergencyBlips",
    "pNotify",
    "progressBars"
}

exports {
    "IsPlayerActiveAsCop"
}