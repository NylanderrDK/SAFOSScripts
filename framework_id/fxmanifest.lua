fx_version "cerulean"
game "gta5"

author "Nylander"
description "Addon to SAFOS Framework which adds a ID card."
version "1.0.0"

client_script "SAFOSIdClient.net.dll"
server_script "SAFOSIdServer.net.dll"

files {
    "ui/index.html",
    "ui/index.js",
    "ui/vendor/mdb.min.css",
    "ui/vendor/mdb.min.js",
    "./Newtonsoft.Json.dll"
}

ui_page "ui/index.html"