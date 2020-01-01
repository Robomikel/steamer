

#----------      Install server as Anon     ----------------------
Function Install-Anonserver{
        Write-Host '*** Creating SteamCMD Run txt *****' -ForegroundColor Magenta -BackgroundColor Black 
        New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login anonymous"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:AppID $global:Branch"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "exit"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login anonymous"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:AppID $global:Branch validate"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
        Get-UpdateServer
        Set-Location $global:currentdir
}
#--------- Install server as User  -----------------
Function Install-Server{
        $global:username = Read-host -Prompt 'Enter Username for Steam install, Steam.exe will prompt for Password and Steam Gaurd'
        Write-Host '*** Creating SteamCMD Run txt *****' -ForegroundColor Magenta -BackgroundColor Black 
        New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        #Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login $global:username"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:AppID $global:Branch"
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "exit"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
        #Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login $global:username"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:AppID $global:Branch validate"
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
        Get-UpdateServer
        Set-Location $global:currentdir     
}