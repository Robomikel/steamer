

#----------      Install server as Anon     ----------------------
Function Install-Anonserver
    {
        New-Item $global:currentdir\$global:server\Update-$global:server.ps1 -Force
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "@echo off"
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "$host.ui.RawUi.WindowTitle = 'SteamServerInstall'"
        Add-Content -Path $global:currentdir\$global:server\Update-$global:server.ps1 -Value "$global:currentdir\SteamCMD\steamcmd +runscript $global:server.txt"
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "exit"
        New-Item $global:currentdir\SteamCMD\$global:server.txt -Force
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "login anonymous"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "app_update $global:AppID $global:Branch"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "exit"
        & "$global:currentdir\$global:server\Update-*.ps1"
   

}
#--------- Install server as User  -----------------
Function Install-Server
    {
        $global:username = Read-host -Prompt 'Enter Username for Steam install, Steam.exe will prompt for Password and Steam Gaurd'
        New-Item $global:currentdir\$global:server\Update-$global:server.ps1 -Force
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "@echo off"
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "$host.ui.RawUi.WindowTitle = 'SteamServerInstall'"
        Add-Content -Path $global:currentdir\$global:server\Update-$global:server.ps1 -Value "$global:currentdir\SteamCMD\steamcmd +runscript $global:server.txt"
        #Add-Content -Path $global:currentdir\$global:server\UpdateServer-$global:server.ps1 -Value "exit"
        New-Item $global:currentdir\SteamCMD\$global:server.txt -Force
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        #Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "login $global:username"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\$global:server.txt -Value "app_update $global:AppID $global:Branch"
        & "$global:currentdir\$global:server\Update-*.ps1"
       
      
}