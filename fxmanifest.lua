fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'choda'
description 'ESX Shop - marker-based general store'
version '1.0.0'

dependencies {
    'es_extended'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@es_extended/imports.lua',
    'server.lua'
}
