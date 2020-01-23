# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
$global:command=$($args[0])
$global:server=$($args[1])
$global:currentdir=Get-Location
$global:serverdir="$global:currentdir\$global:server"
${global:EXTIP}=(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
${global:IP}=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
# Game-Server-configs
$global:githuburl="https://raw.githubusercontent.com/GameServerManagers/Game-Server-Configs/master"

#NodeJs Version
$global:nodeversion="12.13.1"
$global:nodejsurl="https://nodejs.org/dist/v$global:nodeversion/node-v$global:nodeversion-win-x64.zip"

# Oxide
$global:oxiderustlatestlink="https://umod.org/games/rust/download"

# Metamod
$global:metamodmversion="1.10"
$global:mmWebResponse=Invoke-WebRequest "https://mms.alliedmods.net/mmsdrop/$global:metamodmversion/mmsource-latest-windows"
$global:mmWebResponse=$global:mmWebResponse.content
$global:metamodurl="https://mms.alliedmods.net/mmsdrop/$global:metamodmversion/$global:mmWebResponse"
# Sourcemod
$global:sourcemodmversion="1.10"
$smWebResponse=Invoke-WebRequest "https://sm.alliedmods.net/smdrop/$global:sourcemodmversion/sourcemod-latest-windows"
$smWebResponse=$smWebResponse.content
$global:sourcemodurl="https://sm.alliedmods.net/smdrop/$global:sourcemodmversion/$smWebResponse"
#7 Zip Portable
$global:sevenzip="https://www.7-zip.org/a/7za920.zip"
# Steam
$global:steamurl="https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
$global:steamoutput="steamcmd.zip"
# Steamer url
#$global:steamerurl="https://github.com/Robomikel/steamer/archive/master.zip"
#if (!$?) {$global:steamerurl="http://github.com/Robomikel/steamer/archive/master.zip"}
$global:steamerurl="https://github.com/Robomikel/steamer/archive/untested.zip"
# mcrcon
$global:mcrconurl="https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-windows-x86-32.zip"

$global:RANDOMPASSWORD = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 11 | ForEach-Object {[char]$_})

$global:SMILEY_WHITE = ([char]9786)
$global:SMILEY_BLACK = ([char]9787)
$global:GEAR = ([char]9788)
$global:HEART = ([char]9829)
$global:DIAMOND = ([char]9830)
$global:CLUB = ([char]9827)
$global:SPADE = ([char]9824)
$global:CIRCLE = ([char]8226)
$global:NOTE1 = ([char]9834)
$global:NOTE2 = ([char]9835)
$global:CHECKMARK = ([char]8730) 

.$global:currentdir\functions\fn_Actions.ps1
.$global:currentdir\functions\fn_Ark.ps1
.$global:currentdir\functions\fn_Commands.ps1
.$global:currentdir\functions\fn_CreateLaunchScript.ps1
.$global:currentdir\functions\fn_CSGO.ps1
.$global:currentdir\functions\fn_DOI.ps1
.$global:currentdir\functions\fn_Insurgency.ps1
.$global:currentdir\functions\fn_KF2Server.ps1
.$global:currentdir\functions\fn_Left4Dead2.ps1
.$global:currentdir\functions\fn_Miscreated.ps1
.$global:currentdir\functions\fn_Rust.ps1
.$global:currentdir\functions\fn_Sandstorm.ps1
.$global:currentdir\functions\fn_Settings.ps1
Set-SteamerSetting
Set-Console  >$null 2>&1

Function Set-Steamer {
If($null -eq $global:command){
Select-Steamer 
}else{
Select-Steamer $global:command $global:server}
}
Set-Steamer
##########################################################################