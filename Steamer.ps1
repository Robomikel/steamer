# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
$global:currentdir=Get-Location
$global:serverdir="$global:currentdir\$global:server"
${global:EXTIP}=(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
${global:IP}=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
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
$global:steamerurl="https://github.com/Robomikel/steamer/archive/master.zip"
.$global:currentdir\functions\fn_Actions.ps1
.$global:currentdir\functions\fn_Ark.ps1
.$global:currentdir\functions\fn_BackupServer.ps1
.$global:currentdir\functions\fn_Commands.ps1
.$global:currentdir\functions\fn_CreateDiscord.ps1
.$global:currentdir\functions\fn_CreateLaunchScript.ps1
.$global:currentdir\functions\fn_CreateMonitor.ps1
.$global:currentdir\functions\fn_CreateMonitorJob.ps1
.$global:currentdir\functions\fn_CreateServerFolder.ps1
.$global:currentdir\functions\fn_CreateVariables.ps1
.$global:currentdir\functions\fn_InstallNodejs.ps1
.$global:currentdir\functions\fn_InstallServer.ps1
.$global:currentdir\functions\fn_InstallSteam.ps1
.$global:currentdir\functions\fn_Insurgency.ps1
.$global:currentdir\functions\fn_LaunchServer.ps1
.$global:currentdir\functions\fn_Miscreated.ps1
.$global:currentdir\functions\fn_Rust.ps1
.$global:currentdir\functions\fn_Read_AppID.ps1
.$global:currentdir\functions\fn_Sandstorm.ps1
.$global:currentdir\functions\fn_SetConsole.ps1
.$global:currentdir\functions\fn_SteamInfo.ps1
.$global:currentdir\functions\fn_UpdateSteamer.ps1
$global:command=$($args[0])
$global:server=$($args[1])     
Set-Console  >$null 2>&1

Function Set-Steamer {
If ($null -eq $global:command){
Select-Steamer 
} else {
Select-Steamer $global:command $global:server
}
}
Set-Steamer
##########################################################################