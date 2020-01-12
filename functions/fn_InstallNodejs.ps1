




Function Get-NodeJS
    {
        $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
        $patha = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64\node.exe"
        $pathb = "node-v$global:nodeversion-win-x64.zip"
        write-host "*** Checking for Nodejs ****" -ForegroundColor Magenta -BackgroundColor Black     
        If((Test-Path $path) -and (Test-Path $pathb) -and (Test-Path $patha)){ 
  
        Write-Host 'NodeJS already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
        }else {
        write-host "NodeJS not found" -ForegroundColor Yellow -BackgroundColor Black
        add-nodejs
        }
}

Function add-nodejs {
    $start_time = Get-Date
Write-Host '*** Downloading  Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black  
#(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64.zip")
#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Invoke-WebRequest -Uri $global:nodejsurl -OutFile $global:currentdir\node-v$global:nodeversion-win-x64.zip
if (!$?) {write-host "Downloading  Nodejs Failed" -ForegroundColor Red -BackgroundColor Black 
New-TryagainN}
if ($?) {write-host "Downloading  Nodejs succeeded" -ForegroundColor Yellow -BackgroundColor Black}
Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
Write-Host '***  Extracting Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
if (!$?) {write-host "Extracting Nodejs Failed" -ForegroundColor Yellow -BackgroundColor Black 
New-TryagainN}
if ($?) {write-host "Extracting Nodejs succeeded" -ForegroundColor Yellow -BackgroundColor Black}
Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
Write-Host '*** Installing gamedig in Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
Write-Host '*** Do not stop or cancel! Will need to delete nodejs files and start over! *****' -ForegroundColor Yellow -BackgroundColor Black  
.\npm install gamedig
.\npm install gamedig -g
Set-Location $global:currentdir
}

Function New-TryagainN {
    $title    = 'Try again?'
    $question = 'Download and Extract NodeJS?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        Write-Host 'Entered Y'
        add-nodejs} 
    else {
        Write-Host 'Entered N'
        exit}
}