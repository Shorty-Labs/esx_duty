fx_version 'cerulean'
lua54 'yes'
game 'gta5'
author 'S-Labs <https://shorty-labs.tebex.io/>'
description 'Slabs-Duty - ESX Duty System'
version '1.0.0'

shared_scripts {
	'@es_extended/locale.lua',
	'shared/*.lua',
	'locales/*.lua'
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
	'ox_target'
}

escrow_ignore {
	'*'
}

provide 'slabs-duty'