Function New-DiscordScript {
Write-Host '*** Creating Discord Script *****' -ForegroundColor Yellow -BackgroundColor Black 
New-Item $global:currentdir\$global:server\Discord-$global:server.ps1 -Force
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value "`$webHookUrl = '<WEBHOOK>'"
#Create embed array
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "[System.Collections.ArrayList]`$embedArray = @()"
#Store embed values
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$title       = '$global:HOSTNAME'"
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$description = 'Server not Running, Starting Server!'"
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$color       = '16711680'"
#Create embed object
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$embedObject = [PSCustomObject]@{"
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "    title       = `$title       "
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "   description = `$description  "
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "   color       = `$color        "
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "}                              "
#Add embed object to array
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$embedArray.Add(`$embedObject) | Out-Null"
#Create the payload
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "`$payload = [PSCustomObject]@{"
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "    embeds = `$embedArray       "
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "}                              "
#Send over payload, converting it to JSON
Add-Content -Path $global:currentdir\$global:server\Discord-$global:server.ps1 -Value  "Invoke-RestMethod -Uri `$webHookUrl -Body (`$payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'"
}