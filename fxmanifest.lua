fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MCore Development'
description 'SafeZone Script for ESX/QB'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua'
}

client_scripts {
    'config/config.lua',
    'client/client.lua'
}

dependencies {
    'ox_lib'
}