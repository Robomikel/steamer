###                        ~[STEAMER]~                             ###           
######################################################################
###---------- Steam Server Install Current Folder -------------######
######################################################################
#----------   Determine script current location ---------------------
$global:currentdir = Get-Location
.$global:currentdir\functions\fn_BackupServer.ps1
.$global:currentdir\functions\fn_CheckServer.ps1
.$global:currentdir\functions\fn_Commands.ps1
.$global:currentdir\functions\fn_CreateCheckServer.ps1
.$global:currentdir\functions\fn_CreateDiscord.ps1
.$global:currentdir\functions\fn_CreateGameDig.ps1
.$global:currentdir\functions\fn_CreateGameDigFull.ps1
.$global:currentdir\functions\fn_CreateLaunchScript.ps1
.$global:currentdir\functions\fn_CreateMonitor.ps1
.$global:currentdir\functions\fn_CreateServerFolder.ps1
.$global:currentdir\functions\fn_CreateStopsScript.ps1
.$global:currentdir\functions\fn_CreateValidateScript.ps1
.$global:currentdir\functions\fn_GameDig.ps1
.$global:currentdir\functions\fn_GameDigFull.ps1
.$global:currentdir\functions\fn_InstallNodejs.ps1
.$global:currentdir\functions\fn_InstallServer.ps1
.$global:currentdir\functions\fn_InstallSteam.ps1
.$global:currentdir\functions\fn_LaunchServer.ps1
.$global:currentdir\functions\fn_Miscreated.ps1
.$global:currentdir\functions\fn_Read_AppID.ps1
.$global:currentdir\functions\fn_RestartServer.ps1
.$global:currentdir\functions\fn_SetConsole.ps1
.$global:currentdir\functions\fn_SteamInfo.ps1
.$global:currentdir\functions\fn_StopsServer.ps1
.$global:currentdir\functions\fn_UpdateServer.ps1
.$global:currentdir\functions\fn_ValidateServer.ps1




$global:command=$($args[0])
$global:server=$($args[1])     
Set-Console

#Select-Steamer $global:command
Function Set-Steamer {
If ($null -eq $global:command){
Select-Steamer 
} else {
Select-Steamer $global:command $global:server
}
}
Set-Steamer
##########################################################################