cinst neko --version 2.3.0 -y
:: cinst haxe --version 4.1.5 -y
cinst haxe -y
pause
mkdir C:\projects\haxelib
haxelib setup C:\projects\haxelib
pause 
haxelib install lime 7.9.0
haxelib run lime setup
haxelib install openfl
haxelib install flixel
lime setup flixel
lime setup
haxelib install flixel-tools
:: The line below isn't necessary but can still be run if ya want
:: haxelib run flixel-tools setup -y
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install hxcpp-debug-server
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
haxelib install hxCodec
haxelib install flixel-addons
haxelib git faxe https://github.com/uhrobots/faxe
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit.git
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib git extension-webm https://github.com/KadeDev/extension-webm
haxelib run lime rebuild extension-webm windows
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools windows
haxelib install actuate
haxelib list
haxelib --global update haxelib
pause
RefreshEnv