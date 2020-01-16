Function Get-ChecktaskUnreg {
    Get-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1
    if ($?) {
    Write-Host '*** Unregistering scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Unregister-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1}
    if (!$?) {
    Write-Host "*** Scheduled Task does not exist ****" -ForegroundColor Yellow -BackgroundColor Black}
}


Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    if ($?) {
    Write-Host '*** disabling scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Disable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}
    if (!$?) {
    Write-Host "*** Scheduled Task does not exist ****" -ForegroundColor Yellow -BackgroundColor Black}
}

Function Get-ChecktaskEnable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    if ($?) {
    Write-Host '*** Enabling scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Enable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}
    if (!$?) {
    write-host "*** Scheduled Task does not exist ****" -ForegroundColor Yellow -BackgroundColor Black}
}
Function New-BackupFolder {
    $path = "$global:currentdir\backups" 
    If(Test-Path $path) { 
    Write-Host '***  Backup folder exists! ***' -ForegroundColor Yellow -BackgroundColor Black} 
    Else {  
    Write-Host '*** Creating backup folder *****' -ForegroundColor Magenta -BackgroundColor Black
    New-Item -Path "$global:currentdir\" -Name "backups" -ItemType "directory"}
}

Function New-BackupServer {
    $BackupDate = get-date -Format yyyyMMdd
    Get-StopServer
    New-BackupFolder
    Write-Host '*** Server Backup Started! *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* > backup.log
    Write-Host '*** Server Backup is Done! *****' -ForegroundColor Yellow -BackgroundColor Black
    write-host "*** Checking for alternate Save location (appData) ****" -ForegroundColor Yellow -BackgroundColor Black
    Get-savelocation
    Get-ChecktaskEnable
    .\backup.log
    Set-Location $global:currentdir
}

Function Get-SevenZip {
    $path = "$global:currentdir\7za920\"
    $patha = "$global:currentdir\7za920\7za.exe"
    $pathb = "$global:currentdir\7za920.zip"
    Write-Host '*** Checking for 7ZIP *****' -ForegroundColor Yellow -BackgroundColor Black   
    If((Test-Path $path) -and (Test-Path $patha) -and (Test-Path $pathb)) { 
    Write-Host '*** 7Zip already downloaded! ****' -ForegroundColor Yellow -BackgroundColor Black}
    else {
    write-host "*** 7Zip not found!  ****" -ForegroundColor Yellow -BackgroundColor Black
    add-sevenzip}  
}


Function add-sevenzip {
    $start_time = Get-Date
    Write-Host '*** Downloading 7ZIP *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sevenzip -OutFile $global:currentdir\7za920.zip
    if (!$?) {write-host "*** 7Zip Download Failed ****" -ForegroundColor Yellow -BackgroundColor Black 
    New-Tryagain}
    if ($?) {write-host "*** 7Zip  Download succeeded ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '***  Extracting 7ZIP *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
    if (!$?) {write-host "*** 7Zip files did not Extract  ****" -ForegroundColor Yellow -BackgroundColor Black
    New-Tryagain}
    if ($?) {write-host "*** 7Zip Extract succeeded ****" -ForegroundColor Yellow -BackgroundColor Black}
}

Function New-Tryagain {
    $title    = 'Try again?'
    $question = 'Download and Extract 7Zip?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    add-sevenzip} 
    else {
    Write-Host 'Entered N'
    exit}
}

Function New-backupAppdata {
    $BackupDate = get-date -Format yyyyMMdd
    Write-Host '*** Server App Data Backup Started! *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\backups\AppDataBackup_$global:server-$BackupDate.zip $env:APPDATA\$global:saves\* > AppDatabackup.log
    Write-Host '*** Server App Data Backup is Done! *****' -ForegroundColor Yellow -BackgroundColor Black
    .\AppDatabackup.log
}

Function Get-savelocation {
    if("" -eq $global:saves){
    Write-Host "*** No saves located in App Data ***" -ForegroundColor Yellow -BackgroundColor Black 
    }else{
    New-AppDataSave}
}

Function New-AppDataSave {
    $title    = 'Game has Saves located in AppData'
    $question = 'Backup Appdata for server?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    New-backupAppdata} 
    else {
    Write-Host 'Entered N'
    exit}
}