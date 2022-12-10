fx_version 'bodacious'
game 'gta5'

author "xariesnull"
github "https://github.com/xariesnull"
description "Greenzone script"
version '1.1'
lua54 "yes"

client_scripts {
    'client.lua',
    'config.lua'
}

escrow_ignore {
    'config.lua',
}

server_script 'server.lua'
