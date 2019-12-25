Function New-StopsScript {
    New-Item $global:currentdir\$global:server\Stops-$global:server.ps1 -Force
    #Add-Content -Path $global:currentdir\$global:server\Stops-$global:server.ps1 -Value "stop-process -Name '$global:process' -Force"
    Add-Content -Path $global:currentdir\$global:server\Stops-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Stops-$global:server.ps1 -Value "Write-Host `"Not Running`" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name '$global:process' -Force}"
}
