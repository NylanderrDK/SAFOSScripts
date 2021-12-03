fx_version "cerulean"
game "gta5"

client_scripts {
    "@safos-framework/cl-functions.lua",

    "client.lua"
}

server_scripts {
    "@safos-framework/sv-functions.lua",
    
    "server.lua"
}

ui_page "nui/index.html"
files {
    "nui/index.html",
    "nui/index.css",
    "nui/index.js"
}