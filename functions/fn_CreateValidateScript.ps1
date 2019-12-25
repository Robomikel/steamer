
#:::::::::::     Create update Validate-Script          ::::::::::::::::::::::::
Function New-ValidateScriptPS
{
    New-Item $global:currentdir\$global:server\Validate-$global:server.ps1 -Force
    #Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "stop-process -Name $global:process -Force"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "Write-Host `"Not Running`" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name '$global:process' -Force}"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "$global:currentdir\SteamCMD\steamcmd +runscript Validate-$global:server.txt"
    New-Item $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login anonymous"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:AppID $global:Branch validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
}
#:::::::::::     Create update Validate-Script for Login  ::::::::::::::::::::::::
Function New-ValidateScriptlPS
{
    New-Item $global:currentdir\$global:server\Validate-$global:server.ps1 -Force
    #Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "stop-process -Name $global:process -Force"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "Write-Host `"Not Running`" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name '$global:process' -Force}"
    Add-Content -Path $global:currentdir\$global:server\Validate-$global:server.ps1 -Value "$global:currentdir\SteamCMD\steamcmd +runscript Validate-$global:server.txt"
    New-Item $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    #Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login $global:username"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:AppID $global:Branch Validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
}



