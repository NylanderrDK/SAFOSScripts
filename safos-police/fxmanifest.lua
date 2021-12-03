fx_version "cerulean"
game "gta5"

shared_script "config.lua"

client_scripts {
    "cl-functions.lua",

    "client/cl-main.lua",
    "client/cl-armouries.lua",
    "client/cl-alerts.lua",
    "client/menu/*.lua"
}

server_scripts {
    "sv-functions.lua",
    
    "server/sv-main.lua",
    "server/sv-alerts.lua"
}