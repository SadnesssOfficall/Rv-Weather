fx_version 'cerulean'
game 'gta5'

author 'Sadness'
description 'Mevsimsel Hava ve RP Sistemi'
version '2.0.0'

shared_script 'config.lua'
shared_script 'shared/utils.lua'

server_script '@oxmysql/lib/MySQL.lua'
server_script 'server/main.lua'

client_script 'client/main.lua'
