fx_version "cerulean"
games {"gta5"}
lua54 "yes"

shared_script "config.lua"

client_scripts {"@menuv/menuv.lua", "client/main.lua", "client/noclip.lua", "client/tpm.lua"}

server_scripts {"server/main.lua"}

ui_page "html/index.html"
files {"html/index.html", "html/index.js"}

dependencies {"qb-core", "menuv"}
