Function Set-CreateMonitorScript{
Write-Host '*** Creating Monitor Script *****' -ForegroundColor Yellow -BackgroundColor Black 
New-Item $global:currentdir\$global:server\Monitor-$global:server.ps1 -Force
#Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value " "
Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value "`$mprocesss = Get-Process `"$global:process`""
Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value "If (!(`$mprocesss)) {"
Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value "& `"$global:currentdir\$global:server\Launch-*.ps1`""
Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value "& `"$global:currentdir\$global:server\Discord-*.ps1`""
Add-Content -Path $global:currentdir\$global:server\Monitor-$global:server.ps1 -Value "}"
}