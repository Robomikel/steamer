
Function New-ServerStatusScript{
    New-Item $global:currentdir\$global:server\Check-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Check-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Check-$global:server.ps1 -Value "Write-Host `"----NOT RUNNING----`" -ForegroundColor Red -BackgroundColor Black}else{Write-Host `"**** RUNNING ***`" -ForegroundColor Green -BackgroundColor Black ;; Get-Process `"$global:process`"}"

    
}
